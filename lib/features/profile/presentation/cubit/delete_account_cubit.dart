import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/features/auth/domain/use_cases/delete_account_use_case.dart';
import 'delete_account_state.dart';

@injectable
class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  final DeleteAccountUseCase _deleteAccountUseCase;

  DeleteAccountCubit(this._deleteAccountUseCase)
      : super(const DeleteAccountState());

  Future<void> deleteAccount({String? password, String? reason}) async {
    if (isClosed) return;
    emit(state.copyWith(
      status: DeleteAccountStatus.loading,
      failure: null,
      errorMessage: null,
    ));

    final result = await _deleteAccountUseCase(
      password: password,
      reason: reason,
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: DeleteAccountStatus.failure,
          failure: failure,
          errorMessage: failure.message,
        ));
      },
      (_) {
        emit(state.copyWith(status: DeleteAccountStatus.success));
      },
    );
  }

  void reset() {
    if (!isClosed) {
      emit(const DeleteAccountState());
    }
  }
}
