import 'package:equatable/equatable.dart';

class ClassroomEntity extends Equatable {
  final String id;
  final String name;
  final String joinCode;
  final bool isActive;
  final int studentCount;
  final DateTime? createdAt;
  final String? recentAssignmentTitle;
  final int? assignmentProgressCurrent;
  final int? assignmentProgressTotal;
  final String? assignmentDueDate;

  const ClassroomEntity({
    required this.id,
    required this.name,
    required this.joinCode,
    required this.isActive,
    required this.studentCount,
    this.createdAt,
    this.recentAssignmentTitle,
    this.assignmentProgressCurrent,
    this.assignmentProgressTotal,
    this.assignmentDueDate,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        joinCode,
        isActive,
        studentCount,
        createdAt,
        recentAssignmentTitle,
        assignmentProgressCurrent,
        assignmentProgressTotal,
        assignmentDueDate,
      ];
}
