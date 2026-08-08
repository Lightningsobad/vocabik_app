import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:formz/formz.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';

import 'register_event.dart';
import 'register_state.dart';
import '../models/email_input.dart';
import '../models/password_input.dart';
import '../models/display_name_input.dart';
import '../widgets/password_strength_indicator.dart';
import '../../domain/use_cases/register_use_case.dart';

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

@injectable
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterBloc(this._registerUseCase) : super(const RegisterState()) {
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
  }

  PasswordStrength _evaluatePasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.none;
    if (password.length < 8) return PasswordStrength.weak;

    final hasLetters = password.contains(RegExp(r'[a-zA-Z]'));
    final hasNumbers = password.contains(RegExp(r'[0-9]'));
    final hasSpecialCharacters = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (hasLetters && hasNumbers && hasSpecialCharacters) {
      return PasswordStrength.strong;
    } else if (hasLetters && hasNumbers) {
      return PasswordStrength.medium;
    } else {
      return PasswordStrength.weak;
    }
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
    if (state.formStatus != FormzSubmissionStatus.success &&
        Formz.validate([state.displayName, state.email, state.password])) {
      return;
    }

    emit(state.copyWith(status: RegisterStatus.loading));

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
}
