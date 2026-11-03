class ReportRequestModel {
  final String targetType;
  final String targetId;
  final String reason;
  final String? details;

  const ReportRequestModel({
    required this.targetType,
    required this.targetId,
    required this.reason,
    this.details,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'targetType': targetType,
      'targetId': targetId,
      'reason': reason,
    };
    if (details != null && details!.trim().isNotEmpty) {
      map['details'] = details!.trim();
    }
    return map;
  }
}
