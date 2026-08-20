import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/create_classroom_use_case.dart';
import '../../domain/usecases/get_classrooms_use_case.dart';
import 'classroom_list_state.dart';

@injectable
class ClassroomListCubit extends Cubit<ClassroomListState> {
  final GetClassroomsUseCase _getClassroomsUseCase;
  final CreateClassroomUseCase _createClassroomUseCase;

  ClassroomListCubit(
    this._getClassroomsUseCase,
    this._createClassroomUseCase,
  ) : super(const ClassroomListState());

  Future<void> fetchClassrooms() async {
    emit(state.copyWith(status: ClassroomListStatus.loading));

    final result = await _getClassroomsUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: ClassroomListStatus.error,
        errorMessage: failure.message,
      )),
      (classrooms) => emit(state.copyWith(
        status: ClassroomListStatus.loaded,
        classrooms: classrooms,
      )),
    );
  }

  Future<bool> createClassroom(String name) async {
    emit(state.copyWith(createStatus: CreateClassroomStatus.loading));

    final result = await _createClassroomUseCase(name);

    return result.fold(
      (failure) {
        emit(state.copyWith(
          createStatus: CreateClassroomStatus.error,
          createErrorMessage: failure.message,
        ));
        return false;
      },
      (newClassroom) {
        emit(state.copyWith(
          createStatus: CreateClassroomStatus.success,
        ));
        // Refresh list
        fetchClassrooms();
        return true;
      },
    );
  }

  void resetCreateStatus() {
    emit(state.copyWith(createStatus: CreateClassroomStatus.initial));
  }
}
