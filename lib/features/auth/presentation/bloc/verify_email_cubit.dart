import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'verify_email_state.dart';
import 'auth_bloc.dart';
import '../../domain/use_cases/verify_email_use_case.dart';
import '../../domain/use_cases/resend_email_use_case.dart';
import '../../domain/use_cases/login_use_case.dart';

@injectable
class VerifyEmailCubit extends Cubit<VerifyEmailState> {
  final VerifyEmailUseCase _verifyEmailUseCase;
  final ResendEmailUseCase _resendEmailUseCase;
  final LoginUseCase _loginUseCase;
  final AuthBloc _authBloc;
  Timer? _timer;

  VerifyEmailCubit(
    this._verifyEmailUseCase,
    this._resendEmailUseCase,
    this._loginUseCase,
    this._authBloc,
  ) : super(const VerifyEmailState());

  void startTimer() {
    emit(state.copyWith(countdown: 45));
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.countdown > 0) {
        emit(state.copyWith(countdown: state.countdown - 1));
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> resendEmail(String email) async {
    if (state.countdown > 0) return;

    emit(state.copyWith(status: VerifyEmailStatus.loading));

    final result = await _resendEmailUseCase(email);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: VerifyEmailStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        emit(state.copyWith(status: VerifyEmailStatus.initial));
        startTimer();
      },
    );
  }

  Future<void> verifyWithToken(
    String token,
    String email,
    String password,
  ) async {
    emit(state.copyWith(status: VerifyEmailStatus.loading));

    final result = await _verifyEmailUseCase(token);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: VerifyEmailStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (user) {
        _authBloc.add(UserAuthenticated(user));
        emit(state.copyWith(status: VerifyEmailStatus.success));
      },
    );
  }

  Future<void> checkVerificationOnOtherDevice(
    String email,
    String password,
  ) async {
    emit(state.copyWith(status: VerifyEmailStatus.loading));

    final loginResult = await _loginUseCase(email: email, password: password);

    loginResult.fold(
      (failure) => emit(
        state.copyWith(
          status: VerifyEmailStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (user) {
        _authBloc.add(UserAuthenticated(user));
        emit(state.copyWith(status: VerifyEmailStatus.success));
      },
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
