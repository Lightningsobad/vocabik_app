import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/classroom_entity.dart';
import '../../domain/usecases/get_classroom_by_id_use_case.dart';
import 'classroom_detail_state.dart';

@injectable
class ClassroomDetailCubit extends Cubit<ClassroomDetailState> {
  final GetClassroomByIdUseCase _getClassroomByIdUseCase;

  ClassroomDetailCubit(
    this._getClassroomByIdUseCase,
  ) : super(const ClassroomDetailState());

  void init(ClassroomEntity? initialClassroom) {
    if (initialClassroom != null) {
      emit(state.copyWith(
        status: ClassroomDetailStatus.loaded,
        classroom: initialClassroom,
      ));
    }
  }

  void setTabIndex(int index) {
    emit(state.copyWith(selectedTabIndex: index));
  }

  Future<void> fetchClassroom(String id) async {
    emit(state.copyWith(status: ClassroomDetailStatus.loading));

    final result = await _getClassroomByIdUseCase(id);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ClassroomDetailStatus.error,
        errorMessage: failure.message,
      )),
      (classroom) => emit(state.copyWith(
        status: ClassroomDetailStatus.loaded,
        classroom: classroom,
      )),
    );
  }
}
