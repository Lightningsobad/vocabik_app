import 'package:equatable/equatable.dart';

class UserSession extends Equatable {
  final String id;
  final String device;
  final String ip;
  final DateTime? createdAt;
  final DateTime? lastActive;
  final bool current;

  const UserSession({
    required this.id,
    required this.device,
    required this.ip,
    this.createdAt,
    this.lastActive,
    required this.current,
  });

  @override
  List<Object?> get props => [
        id,
        device,
        ip,
        createdAt,
        lastActive,
        current,
      ];
}
