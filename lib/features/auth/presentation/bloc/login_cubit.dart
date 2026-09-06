import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';

import '../models/email_input.dart';
import '../models/password_input.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../../domain/use_cases/login_with_google_use_case.dart';
import '../../../../core/services/social_auth_service.dart';
import 'auth_bloc.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;
  final LoginWithGoogleUseCase _loginWithGoogleUseCase;
  final SocialAuthService _socialAuthService;
  final AuthBloc _authBloc;

  LoginCubit(
    this._loginUseCase,
    this._loginWithGoogleUseCase,
    this._socialAuthService,
    this._authBloc,
  ) : super(const LoginState());

  void emailChanged(String value) {
    final email = EmailInput.dirty(value);
    emit(
      state.copyWith(
        email: email,
        status: LoginStatus.initial,
      ),
    );
  }

  void passwordChanged(String value) {
    final password = PasswordInput.dirty(value);
    emit(
      state.copyWith(
        password: password,
        status: LoginStatus.initial,
      ),
    );
  }

  Future<void> submit() async {
    final email = EmailInput.dirty(state.email.value);
    final password = PasswordInput.dirty(state.password.value);

    final isValid = Formz.validate([email, password]);
    if (!isValid) {
      emit(state.copyWith(
        email: email,
        password: password,
        status: LoginStatus.initial,
      ));
      return;
    }

    emit(state.copyWith(
      email: email,
      password: password,
      status: LoginStatus.loading,
    ));

    final result = await _loginUseCase(
      email: email.value,
      password: password.value,
    );

    result.fold(
      (failure) {
        if (failure is NotVerifiedFailure) {
          emit(state.copyWith(
            status: LoginStatus.unverified,
            errorMessage: failure.message,
          ));
        } else {
          emit(state.copyWith(
            status: LoginStatus.failure,
            errorMessage: failure.message,
          ));
        }
      },
      (user) {
        _authBloc.add(UserAuthenticated(user));
        emit(state.copyWith(status: LoginStatus.success));
      },
    );
  }

  Future<void> loginWithGoogle() async {
    emit(state.copyWith(status: LoginStatus.loading));

    try {
      debugPrint('[LoginCubit] Triggering loginWithGoogle...');
      final idToken = await _socialAuthService.getGoogleIdToken();
      if (idToken == null || idToken.isEmpty) {
        debugPrint('[LoginCubit] Google Sign-In cancelled by user.');
        emit(state.copyWith(status: LoginStatus.initial));
        return;
      }

      debugPrint('[LoginCubit] Sending Google idToken to Backend API...');
      final result = await _loginWithGoogleUseCase(idToken: idToken);

      result.fold(
        (failure) {
          debugPrint('[LoginCubit] Backend Google Login failed: ${failure.message}');
          emit(state.copyWith(
            status: LoginStatus.failure,
            errorMessage: failure.message,
          ));
        },
        (user) {
          debugPrint('[LoginCubit] Backend Google Login succeeded for user: ${user.email}');
          _authBloc.add(UserAuthenticated(user));
          emit(state.copyWith(status: LoginStatus.success));
        },
      );
    } catch (e, stackTrace) {
      debugPrint('[LoginCubit] Google Sign-In error: $e\n$stackTrace');
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: errorMsg.isNotEmpty
            ? errorMsg
            : 'Đăng nhập Google không thành công. Vui lòng thử lại.',
      ));
    }
  }
}
