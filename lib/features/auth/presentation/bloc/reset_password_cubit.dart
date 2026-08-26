import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';

import '../models/password_input.dart';
import '../../domain/use_cases/reset_password_use_case.dart';
import 'reset_password_state.dart';

@injectable
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPasswordUseCase _resetPasswordUseCase;

  ResetPasswordCubit(this._resetPasswordUseCase) : super(const ResetPasswordState());

  void newPasswordChanged(String value) {
    final newPassword = PasswordInput.dirty(value);
    final isMatch = state.confirmPassword.isPure || value == state.confirmPassword.value;
    emit(
      state.copyWith(
        newPassword: newPassword,
        isPasswordMatch: isMatch,
        status: ResetPasswordStatus.initial,
      ),
    );
  }

  void confirmPasswordChanged(String value) {
    final confirmPassword = PasswordInput.dirty(value);
    final isMatch = state.newPassword.value == value;
    emit(
      state.copyWith(
        confirmPassword: confirmPassword,
        isPasswordMatch: isMatch,
        status: ResetPasswordStatus.initial,
      ),
    );
  }

  Future<void> submit({required String token}) async {
    final newPassword = PasswordInput.dirty(state.newPassword.value);
    final confirmPassword = PasswordInput.dirty(state.confirmPassword.value);
    final isMatch = newPassword.value == confirmPassword.value;

    final isValid = Formz.validate([newPassword, confirmPassword]) && isMatch;
    if (!isValid) {
      emit(
        state.copyWith(
          newPassword: newPassword,
          confirmPassword: confirmPassword,
          isPasswordMatch: isMatch,
          status: ResetPasswordStatus.initial,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        newPassword: newPassword,
        confirmPassword: confirmPassword,
        isPasswordMatch: isMatch,
        status: ResetPasswordStatus.loading,
      ),
    );

    final result = await _resetPasswordUseCase(
      token: token,
      newPassword: newPassword.value,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ResetPasswordStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (message) => emit(
        state.copyWith(
          status: ResetPasswordStatus.success,
          successMessage: message,
        ),
      ),
    );
  }
}
