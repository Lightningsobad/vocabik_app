import '../../domain/entities/classroom_entity.dart';

class ClassroomModel extends ClassroomEntity {
  const ClassroomModel({
    required super.id,
    required super.name,
    required super.joinCode,
    required super.isActive,
    required super.studentCount,
    super.createdAt,
    super.recentAssignmentTitle,
    super.assignmentProgressCurrent,
    super.assignmentProgressTotal,
    super.assignmentDueDate,
  });

  factory ClassroomModel.fromJson(Map<String, dynamic> json) {
    final activeAssignment = json['active_assignment'];
    String? assignmentTitle;
    int? progressCurrent;
    int? progressTotal;
    String? dueDate;

    if (activeAssignment is Map<String, dynamic>) {
      assignmentTitle = activeAssignment['title'] as String?;
      progressCurrent = (activeAssignment['progress_current'] as num?)?.toInt();
      progressTotal = (activeAssignment['progress_total'] as num?)?.toInt();
      dueDate = activeAssignment['due_date'] as String?;
    } else if (activeAssignment is String) {
      assignmentTitle = activeAssignment;
    }

    return ClassroomModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      joinCode: json['join_code'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
      studentCount: (json['student_count'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      recentAssignmentTitle: assignmentTitle,
      assignmentProgressCurrent: progressCurrent,
      assignmentProgressTotal: progressTotal,
      assignmentDueDate: dueDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'join_code': joinCode,
      'is_active': isActive,
      'student_count': studentCount,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }
}
