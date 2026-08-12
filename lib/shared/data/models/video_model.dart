import 'package:vocabik_app/core/domain/entities/paginated_result.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';

class PaginatedVideoResponseModel {
  final List<VideoModel> items;
  final int page;
  final int pageSize;
  final int totalItems;
  final int totalPages;

  PaginatedVideoResponseModel({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
  });

  factory PaginatedVideoResponseModel.fromJson(Map<String, dynamic> json) {
    return PaginatedVideoResponseModel(
      items: (json['items'] as List<dynamic>)
          .map((item) => VideoModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      page: json['page'] as int,
      pageSize: json['pageSize'] as int,
      totalItems: json['totalItems'] as int,
      totalPages: json['totalPages'] as int,
    );
  }

  PaginatedResult<VideoEntity> toEntity() {
    return PaginatedResult<VideoEntity>(
      items: items.map((e) => e.toEntity()).toList(),
      page: page,
      pageSize: pageSize,
      totalItems: totalItems,
      totalPages: totalPages,
    );
  }
}

class VideoModel {
  final String id;
  final String youtubeVideoId;
  final String title;
  final String thumbnailUrl;
  final String category;
  final String cefrLevel;
  final String? artist;
  final DateTime publishedAt;
  final bool breakingBadge;
  final String? canonicalVersion;
  final Map<String, int>? reactionCounts;

  VideoModel({
    required this.id,
    required this.youtubeVideoId,
    required this.title,
    required this.thumbnailUrl,
    required this.category,
    required this.cefrLevel,
    this.artist,
    required this.publishedAt,
    required this.breakingBadge,
    this.canonicalVersion,
    this.reactionCounts,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] as String,
      youtubeVideoId: json['youtubeVideoId'] as String,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      category: json['category'] as String,
      cefrLevel: json['cefrLevel'] as String,
      artist: json['artist'] as String?,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      breakingBadge: json['breakingBadge'] as bool? ?? false,
      canonicalVersion: json['canonicalVersion'] as String?,
      reactionCounts: json['reactionCounts'] != null
          ? Map<String, int>.from(json['reactionCounts'] as Map)
          : null,
    );
  }

  VideoEntity toEntity() {
    return VideoEntity(
      id: id,
      youtubeVideoId: youtubeVideoId,
      title: title,
      thumbnailUrl: thumbnailUrl,
      category: category,
      cefrLevel: cefrLevel,
      artist: artist,
      publishedAt: publishedAt,
      breakingBadge: breakingBadge,
      canonicalVersion: canonicalVersion,
      reactionCounts: reactionCounts ?? const {},
    );
  }
}
