import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';

import '../models/email_input.dart';
import '../models/password_input.dart';
import '../../domain/use_cases/login_use_case.dart';
import 'auth_bloc.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;
  final AuthBloc _authBloc;

  LoginCubit(
    this._loginUseCase,
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
}
