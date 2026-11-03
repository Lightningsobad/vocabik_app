import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/use_cases/update_profile_use_case.dart';
import 'update_profile_state.dart';

@injectable
class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  final UpdateProfileUseCase _updateProfileUseCase;

  UpdateProfileCubit(this._updateProfileUseCase)
      : super(const UpdateProfileState());

  @override
  void emit(UpdateProfileState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  Future<void> updateProfile({
    String? displayName,
    String? cefrLevel,
  }) async {
    if (isClosed) return;
    emit(state.copyWith(
      status: UpdateProfileStatus.loading,
      errorMessage: null,
    ));

    final result = await _updateProfileUseCase(
      displayName: displayName,
      cefrLevel: cefrLevel,
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(state.copyWith(
          status: UpdateProfileStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (response) {
        if (isClosed) return;
        emit(state.copyWith(
          status: UpdateProfileStatus.success,
          updatedProfile: response,
        ));
      },
    );
  }

  void reset() {
    if (!isClosed) {
      emit(const UpdateProfileState());
    }
  }
}
