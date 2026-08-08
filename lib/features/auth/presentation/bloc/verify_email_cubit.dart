import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'verify_email_state.dart';
import '../../domain/use_cases/verify_email_use_case.dart';
import '../../domain/use_cases/resend_email_use_case.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../../domain/use_cases/sign_out_use_case.dart';

@injectable
class VerifyEmailCubit extends Cubit<VerifyEmailState> {
  final VerifyEmailUseCase _verifyEmailUseCase;
  final ResendEmailUseCase _resendEmailUseCase;
  final LoginUseCase _loginUseCase;
  final SignOutUseCase _signOutUseCase;
  Timer? _timer;

  VerifyEmailCubit(
    this._verifyEmailUseCase,
    this._resendEmailUseCase,
    this._loginUseCase,
    this._signOutUseCase,
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
      (failure) => emit(state.copyWith(
        status: VerifyEmailStatus.failure,
        errorMessage: failure.message,
      )),
      (_) {
        emit(state.copyWith(status: VerifyEmailStatus.initial));
        startTimer();
      },
    );
  }

  Future<void> verifyWithToken(String token, String email, String password) async {
    emit(state.copyWith(status: VerifyEmailStatus.loading));
    
    final result = await _verifyEmailUseCase(token);
    
    await result.fold(
      (failure) async {
        emit(state.copyWith(
          status: VerifyEmailStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (_) async {
        // Just emit success directly when using the token to verify
        emit(state.copyWith(status: VerifyEmailStatus.success));
      },
    );
  }

  Future<void> checkVerificationOnOtherDevice(String email, String password) async {
    emit(state.copyWith(status: VerifyEmailStatus.loading));
    
    final loginResult = await _loginUseCase(email: email, password: password);
    
    loginResult.fold(
      (failure) => emit(state.copyWith(
        status: VerifyEmailStatus.failure,
        errorMessage: failure.message,
      )),
      (_) async {
        // If login succeeds, it means the user is successfully verified on the backend.
        // We sign out immediately to discard the potentially inconsistent token and force re-login.
        await _signOutUseCase();
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
