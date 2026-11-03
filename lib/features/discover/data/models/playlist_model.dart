import 'package:vocabik_app/core/domain/entities/paginated_result.dart';
import 'package:vocabik_app/features/discover/domain/entities/playlist_entity.dart';
import 'package:vocabik_app/shared/data/models/video_model.dart';

class PaginatedPlaylistResponseModel {
  final List<PlaylistModel> items;
  final int page;
  final int pageSize;
  final int totalItems;
  final int totalPages;

  PaginatedPlaylistResponseModel({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
  });

  factory PaginatedPlaylistResponseModel.fromJson(Map<String, dynamic> json) {
    return PaginatedPlaylistResponseModel(
      items: (json['items'] as List<dynamic>?)
              ?.map((item) =>
                  PlaylistModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 10,
      totalItems: json['totalItems'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }

  PaginatedResult<PlaylistEntity> toEntity() {
    return PaginatedResult<PlaylistEntity>(
      items: items.map((e) => e.toEntity()).toList(),
      page: page,
      pageSize: pageSize,
      totalItems: totalItems,
      totalPages: totalPages,
    );
  }
}

class PlaylistModel {
  final String slug;
  final String title;
  final String? description;
  final String? coverImageUrl;
  final int videoCount;
  final int totalDurationSeconds;
  final String? canonicalVersion;
  final List<VideoModel>? videos;

  PlaylistModel({
    required this.slug,
    required this.title,
    this.description,
    this.coverImageUrl,
    this.videoCount = 0,
    this.totalDurationSeconds = 0,
    this.canonicalVersion,
    this.videos,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    final rawVideos = json['videos'] as List<dynamic>?;
    final parsedVideos = rawVideos
        ?.map((item) => VideoModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return PlaylistModel(
      slug: json['slug'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      videoCount: json['videoCount'] as int? ?? (parsedVideos?.length ?? 0),
      totalDurationSeconds: json['totalDurationSeconds'] as int? ?? 0,
      canonicalVersion: json['canonicalVersion'] as String?,
      videos: parsedVideos,
    );
  }

  PlaylistEntity toEntity() {
    return PlaylistEntity(
      slug: slug,
      title: title,
      description: description,
      coverImageUrl: coverImageUrl,
      videoCount: videoCount,
      totalDurationSeconds: totalDurationSeconds,
      canonicalVersion: canonicalVersion,
      videos: videos?.map((v) => v.toEntity()).toList() ?? const [],
    );
  }
}
