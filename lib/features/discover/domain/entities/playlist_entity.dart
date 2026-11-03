import 'package:equatable/equatable.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';

class PlaylistEntity extends Equatable {
  final String slug;
  final String title;
  final String? description;
  final String? coverImageUrl;
  final int videoCount;
  final int totalDurationSeconds;
  final String? canonicalVersion;
  final List<VideoEntity> videos;

  const PlaylistEntity({
    required this.slug,
    required this.title,
    this.description,
    this.coverImageUrl,
    this.videoCount = 0,
    this.totalDurationSeconds = 0,
    this.canonicalVersion,
    this.videos = const [],
  });

  /// Approximate duration in minutes (e.g. 25 min)
  int get approximateMinutes {
    if (totalDurationSeconds <= 0) return 0;
    return (totalDurationSeconds / 60).round();
  }

  PlaylistEntity copyWith({
    String? slug,
    String? title,
    String? description,
    String? coverImageUrl,
    int? videoCount,
    int? totalDurationSeconds,
    String? canonicalVersion,
    List<VideoEntity>? videos,
  }) {
    return PlaylistEntity(
      slug: slug ?? this.slug,
      title: title ?? this.title,
      description: description ?? this.description,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      videoCount: videoCount ?? this.videoCount,
      totalDurationSeconds: totalDurationSeconds ?? this.totalDurationSeconds,
      canonicalVersion: canonicalVersion ?? this.canonicalVersion,
      videos: videos ?? this.videos,
    );
  }

  @override
  List<Object?> get props => [
        slug,
        title,
        description,
        coverImageUrl,
        videoCount,
        totalDurationSeconds,
        canonicalVersion,
        videos,
      ];
}
