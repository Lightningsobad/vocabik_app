import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'cefr_selection_state.dart';
import '../../domain/use_cases/update_profile_use_case.dart';

@injectable
class CefrSelectionCubit extends Cubit<CefrSelectionState> {
  final UpdateProfileUseCase _updateProfileUseCase;

  CefrSelectionCubit(this._updateProfileUseCase) : super(const CefrSelectionState());

  void selectLevel(String level) {
    emit(state.copyWith(
      selectedLevel: level,
      status: CefrSelectionStatus.initial,
    ));
  }

  Future<void> submit() async {
    if (state.selectedLevel == null) return;

    emit(state.copyWith(status: CefrSelectionStatus.loading));

    final result = await _updateProfileUseCase(state.selectedLevel!);
    
    result.fold(
      (failure) => emit(state.copyWith(
        status: CefrSelectionStatus.failure,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: CefrSelectionStatus.success)),
    );
  }
}
