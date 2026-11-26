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
    final page = (json['page'] as num?)?.toInt() ?? 1;
    final pageSize = (json['pageSize'] as num?)?.toInt() ?? 20;
    final totalItems =
        (json['totalItems'] as num?)?.toInt() ??
        (json['totalCount'] as num?)?.toInt() ??
        0;

    int totalPages;
    if (json['totalPages'] != null) {
      totalPages = (json['totalPages'] as num).toInt();
    } else if (json['hasMore'] != null) {
      final hasMore = json['hasMore'] as bool;
      if (!hasMore) {
        totalPages = page;
      } else {
        final computedPages =
            pageSize > 0 ? (totalItems / pageSize).ceil() : page + 1;
        totalPages = computedPages > page ? computedPages : page + 1;
      }
    } else {
      totalPages = page;
    }

    return PaginatedVideoResponseModel(
      items: (json['items'] as List<dynamic>? ?? const [])
          .map((item) => VideoModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      page: page,
      pageSize: pageSize,
      totalItems: totalItems,
      totalPages: totalPages,
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
  final int durationSeconds;
  final int practiced;

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
    this.durationSeconds = 0,
    this.practiced = 0,
  });

  static final RegExp _youtubeIdRegex = RegExp(
    r'(?:vi\/|v=|\/embed\/|\/v\/|youtu\.be\/|\/shorts\/)([a-zA-Z0-9_-]{11})',
  );

  static String _extractYoutubeId(String? url) {
    if (url == null || url.isEmpty) return '';
    return _youtubeIdRegex.firstMatch(url)?.group(1) ?? '';
  }

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    final thumb = json['thumbnailUrl'] as String? ?? '';
    final directYtId = json['youtubeVideoId'] as String?;
    final youtubeVideoId = (directYtId != null && directYtId.isNotEmpty)
        ? directYtId
        : _extractYoutubeId(thumb);
    final publishedAtRaw = json['publishedAt'] as String?;

    final rawCategory = (json['category'] as String?)?.trim();
    final category = (rawCategory != null && rawCategory.isNotEmpty)
        ? rawCategory
        : ((json['genre'] as String?) ?? '');

    return VideoModel(
      id: json['id'] as String,
      youtubeVideoId: youtubeVideoId,
      title: json['title'] as String,
      thumbnailUrl: thumb,
      category: category,
      cefrLevel: json['cefrLevel'] as String? ?? '',
      artist: json['artist'] as String?,
      publishedAt: publishedAtRaw != null
          ? (DateTime.tryParse(publishedAtRaw) ??
              DateTime.fromMillisecondsSinceEpoch(0))
          : DateTime.fromMillisecondsSinceEpoch(0),
      breakingBadge: json['breakingBadge'] as bool? ?? false,
      canonicalVersion: json['canonicalVersion'] as String?,
      reactionCounts: json['reactionCounts'] != null
          ? Map<String, int>.from(json['reactionCounts'] as Map)
          : null,
      durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
      practiced: (json['practiced'] as num?)?.toInt() ?? 0,
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
      durationSeconds: durationSeconds,
      practiced: practiced,
    );
  }
}
