import '../../domain/entities/challenge_link_entity.dart';

class ChallengeLinkResponseModel extends ChallengeLinkEntity {
  const ChallengeLinkResponseModel({
    required super.uuid,
    required super.url,
    required super.expiresAt,
  });

  factory ChallengeLinkResponseModel.fromJson(Map<String, dynamic> json) {
    return ChallengeLinkResponseModel(
      uuid: json['uuid'] as String? ?? json['id'] as String? ?? '',
      url: json['url'] as String? ?? '',
      expiresAt: json['expiresAt'] != null
          ? (DateTime.tryParse(json['expiresAt'] as String) ??
              DateTime.now().add(const Duration(days: 30)))
          : DateTime.now().add(const Duration(days: 30)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'url': url,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  ChallengeLinkEntity toEntity() {
    return ChallengeLinkEntity(
      uuid: uuid,
      url: url,
      expiresAt: expiresAt,
    );
  }
}
