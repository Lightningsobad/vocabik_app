import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:formz/formz.dart';
import 'package:stream_transform/stream_transform.dart';

import 'register_event.dart';
import 'register_state.dart';
import '../models/email_input.dart';
import '../models/password_input.dart';
import '../models/display_name_input.dart';
import '../models/password_strength.dart';
import '../../domain/use_cases/register_use_case.dart';
import '../../domain/use_cases/login_with_google_use_case.dart';
import '../../../../core/services/social_auth_service.dart';
import 'auth_bloc.dart';

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

@injectable
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase _registerUseCase;
  final LoginWithGoogleUseCase _loginWithGoogleUseCase;
  final SocialAuthService _socialAuthService;
  final AuthBloc _authBloc;

  RegisterBloc(
    this._registerUseCase,
    this._loginWithGoogleUseCase,
    this._socialAuthService,
    this._authBloc,
  ) : super(const RegisterState()) {
    on<RegisterDisplayNameChanged>(
      _onDisplayNameChanged,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
    on<RegisterEmailChanged>(
      _onEmailChanged,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
    on<RegisterPasswordChanged>(
      _onPasswordChanged,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
    on<RegisterSubmitted>(_onSubmitted);
    on<RegisterWithGoogleSubmitted>(_onGoogleSubmitted);
  }

  PasswordStrength _evaluatePasswordStrength(String password) {
    if (password.length < 6) return PasswordStrength.none;
    if (password.length < 8) return PasswordStrength.weak;
    if (password.length <= 10) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  void _onDisplayNameChanged(
    RegisterDisplayNameChanged event,
    Emitter<RegisterState> emit,
  ) {
    final displayName = DisplayNameInput.dirty(event.displayName);
    emit(
      state.copyWith(
        displayName: displayName,
        formStatus: Formz.validate([displayName, state.email, state.password])
            ? FormzSubmissionStatus.success
            : FormzSubmissionStatus.initial,
      ),
    );
  }

  void _onEmailChanged(
    RegisterEmailChanged event,
    Emitter<RegisterState> emit,
  ) {
    final email = EmailInput.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        formStatus: Formz.validate([state.displayName, email, state.password])
            ? FormzSubmissionStatus.success
            : FormzSubmissionStatus.initial,
      ),
    );
  }

  void _onPasswordChanged(
    RegisterPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    final password = PasswordInput.dirty(event.password);
    final strength = _evaluatePasswordStrength(event.password);
    emit(
      state.copyWith(
        password: password,
        passwordStrength: strength,
        formStatus: Formz.validate([state.displayName, state.email, password])
            ? FormzSubmissionStatus.success
            : FormzSubmissionStatus.initial,
      ),
    );
  }

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    final displayName = DisplayNameInput.dirty(state.displayName.value);
    final email = EmailInput.dirty(state.email.value);
    final password = PasswordInput.dirty(state.password.value);

    final isValid = Formz.validate([displayName, email, password]);
    emit(
      state.copyWith(
        displayName: displayName,
        email: email,
        password: password,
        formStatus: isValid
            ? FormzSubmissionStatus.success
            : FormzSubmissionStatus.initial,
        status: isValid ? RegisterStatus.loading : RegisterStatus.initial,
      ),
    );

    if (!isValid) return;

    final result = await _registerUseCase(
      RegisterParams(
        email: state.email.value,
        password: state.password.value,
        displayName: state.displayName.value,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RegisterStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: RegisterStatus.success)),
    );
  }

  Future<void> _onGoogleSubmitted(
    RegisterWithGoogleSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: RegisterStatus.loading));

    try {
      if (kDebugMode) {
        debugPrint('[RegisterBloc] Triggering RegisterWithGoogleSubmitted...');
      }
      final idToken = await _socialAuthService.getGoogleIdToken();
      if (idToken == null || idToken.isEmpty) {
        if (kDebugMode) {
          debugPrint('[RegisterBloc] Google Sign-Up cancelled by user.');
        }
        emit(state.copyWith(status: RegisterStatus.initial));
        return;
      }

      if (kDebugMode) {
        debugPrint('[RegisterBloc] Sending Google idToken to Backend API...');
      }
      final result = await _loginWithGoogleUseCase(idToken: idToken);

      result.fold(
        (failure) {
          if (kDebugMode) {
            debugPrint('[RegisterBloc] Backend Google Sign-Up failed: ${failure.message}');
          }
          emit(state.copyWith(
            status: RegisterStatus.failure,
            errorMessage: failure.message,
          ));
        },
        (user) {
          if (kDebugMode) {
            debugPrint('[RegisterBloc] Backend Google Sign-Up succeeded');
          }
          _authBloc.add(UserAuthenticated(user));
          emit(state.copyWith(status: RegisterStatus.socialSuccess));
        },
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('[RegisterBloc] Google Sign-Up/Sign-In error: $e\n$stackTrace');
      }
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: errorMsg.isNotEmpty
            ? errorMsg
            : 'Đăng ký với Google không thành công. Vui lòng thử lại.',
      ));
    }
  }
}
