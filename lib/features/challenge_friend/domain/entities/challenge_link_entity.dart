import 'package:equatable/equatable.dart';

class ChallengeLinkEntity extends Equatable {
  final String uuid;
  final String url;
  final DateTime expiresAt;

  const ChallengeLinkEntity({
    required this.uuid,
    required this.url,
    required this.expiresAt,
  });

  @override
  List<Object?> get props => [uuid, url, expiresAt];
}
