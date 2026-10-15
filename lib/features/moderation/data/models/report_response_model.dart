import 'package:equatable/equatable.dart';

class ReportResponseModel extends Equatable {
  final bool success;
  final String? reportId;
  final String message;

  const ReportResponseModel({
    required this.success,
    this.reportId,
    required this.message,
  });

  factory ReportResponseModel.fromJson(Map<String, dynamic> json) {
    return ReportResponseModel(
      success: json['success'] as bool? ?? true,
      reportId: json['reportId'] as String?,
      message: json['message'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [success, reportId, message];
}
