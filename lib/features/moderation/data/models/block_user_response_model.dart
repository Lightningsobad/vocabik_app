import 'package:equatable/equatable.dart';

class BlockUserResponseModel extends Equatable {
  final bool success;
  final String? targetUserId;
  final String message;

  const BlockUserResponseModel({
    required this.success,
    this.targetUserId,
    required this.message,
  });

  factory BlockUserResponseModel.fromJson(Map<String, dynamic> json) {
    return BlockUserResponseModel(
      success: json['success'] as bool? ?? true,
      targetUserId: json['targetUserId'] as String?,
      message: json['message'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [success, targetUserId, message];
}
