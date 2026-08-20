import 'package:equatable/equatable.dart';
import '../../domain/entities/classroom_entity.dart';

enum ClassroomListStatus { initial, loading, loaded, error }
enum CreateClassroomStatus { initial, loading, success, error }

class ClassroomListState extends Equatable {
  final ClassroomListStatus status;
  final List<ClassroomEntity> classrooms;
  final String? errorMessage;
  final CreateClassroomStatus createStatus;
  final String? createErrorMessage;

  const ClassroomListState({
    this.status = ClassroomListStatus.initial,
    this.classrooms = const [],
    this.errorMessage,
    this.createStatus = CreateClassroomStatus.initial,
    this.createErrorMessage,
  });

  ClassroomListState copyWith({
    ClassroomListStatus? status,
    List<ClassroomEntity>? classrooms,
    String? errorMessage,
    CreateClassroomStatus? createStatus,
    String? createErrorMessage,
  }) {
    return ClassroomListState(
      status: status ?? this.status,
      classrooms: classrooms ?? this.classrooms,
      errorMessage: errorMessage,
      createStatus: createStatus ?? this.createStatus,
      createErrorMessage: createErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        classrooms,
        errorMessage,
        createStatus,
        createErrorMessage,
      ];
}
