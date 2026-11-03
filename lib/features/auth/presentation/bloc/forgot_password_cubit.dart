import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';

import '../models/email_input.dart';
import '../../domain/use_cases/forgot_password_use_case.dart';
import 'forgot_password_state.dart';

@injectable
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  ForgotPasswordCubit(this._forgotPasswordUseCase) : super(const ForgotPasswordState());

  void emailChanged(String value) {
    final email = EmailInput.dirty(value);
    emit(
      state.copyWith(
        email: email,
        status: ForgotPasswordStatus.initial,
      ),
    );
  }

  Future<void> submit() async {
    final email = EmailInput.dirty(state.email.value);

    final isValid = Formz.validate([email]);
    if (!isValid) {
      emit(
        state.copyWith(
          email: email,
          status: ForgotPasswordStatus.initial,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        email: email,
        status: ForgotPasswordStatus.loading,
      ),
    );

    final result = await _forgotPasswordUseCase(email.value);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ForgotPasswordStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (message) => emit(
        state.copyWith(
          status: ForgotPasswordStatus.success,
          successMessage: message,
        ),
      ),
    );
  }
}
