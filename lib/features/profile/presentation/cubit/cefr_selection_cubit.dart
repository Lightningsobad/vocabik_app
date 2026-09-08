import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'cefr_selection_state.dart';
import '../../domain/use_cases/update_profile_use_case.dart';
import '../../../auth/domain/use_cases/set_cefr_skipped_use_case.dart';

@injectable
class CefrSelectionCubit extends Cubit<CefrSelectionState> {
  final UpdateProfileUseCase _updateProfileUseCase;
  final SetCefrSkippedUseCase _setCefrSkippedUseCase;

  CefrSelectionCubit(
    this._updateProfileUseCase,
    this._setCefrSkippedUseCase,
  ) : super(const CefrSelectionState());

  @override
  void emit(CefrSelectionState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  void selectLevel(String level) {
    if (isClosed) return;
    emit(state.copyWith(
      selectedLevel: level,
      status: CefrSelectionStatus.initial,
    ));
  }

  Future<void> submit() async {
    if (state.selectedLevel == null || isClosed) return;

    emit(state.copyWith(status: CefrSelectionStatus.loading));

    final result = await _updateProfileUseCase(cefrLevel: state.selectedLevel!);
    
    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(state.copyWith(
          status: CefrSelectionStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (_) async {
        await _setCefrSkippedUseCase(true);
        if (isClosed) return;
        emit(state.copyWith(status: CefrSelectionStatus.success));
      },
    );
  }

  Future<void> skip() async {
    await _setCefrSkippedUseCase(true);
    if (isClosed) return;
    emit(state.copyWith(status: CefrSelectionStatus.success));
  }
}
