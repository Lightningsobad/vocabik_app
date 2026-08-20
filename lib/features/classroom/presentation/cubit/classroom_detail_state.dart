import 'package:equatable/equatable.dart';
import '../../domain/entities/classroom_entity.dart';

enum ClassroomDetailStatus { initial, loading, loaded, error }

class ClassroomDetailState extends Equatable {
  final ClassroomDetailStatus status;
  final ClassroomEntity? classroom;
  final String? errorMessage;
  final int selectedTabIndex;

  const ClassroomDetailState({
    this.status = ClassroomDetailStatus.initial,
    this.classroom,
    this.errorMessage,
    this.selectedTabIndex = 0,
  });

  ClassroomDetailState copyWith({
    ClassroomDetailStatus? status,
    ClassroomEntity? classroom,
    String? errorMessage,
    int? selectedTabIndex,
  }) {
    return ClassroomDetailState(
      status: status ?? this.status,
      classroom: classroom ?? this.classroom,
      errorMessage: errorMessage,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }

  @override
  List<Object?> get props => [
        status,
        classroom,
        errorMessage,
        selectedTabIndex,
      ];
}
