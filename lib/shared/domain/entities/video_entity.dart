import 'package:equatable/equatable.dart';

class VideoEntity extends Equatable {
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
  final Map<String, int> reactionCounts;
  final int durationSeconds;
  final int practiced;
  final bool isNew;

  const VideoEntity({
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
    this.reactionCounts = const {},
    this.durationSeconds = 0,
    this.practiced = 0,
    this.isNew = false,
  });

  int get maxVersionNumber {
    final versionStr = canonicalVersion ?? 'v1';
    return int.tryParse(versionStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
  }

  String get formattedDuration {
    if (durationSeconds <= 0) return '0:00';
    final hours = durationSeconds ~/ 3600;
    final minutes = (durationSeconds % 3600) ~/ 60;
    final remainingSeconds = durationSeconds % 60;
    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  VideoEntity copyWith({
    String? id,
    String? youtubeVideoId,
    String? title,
    String? thumbnailUrl,
    String? category,
    String? cefrLevel,
    String? artist,
    DateTime? publishedAt,
    bool? breakingBadge,
    String? canonicalVersion,
    Map<String, int>? reactionCounts,
    int? durationSeconds,
    int? practiced,
    bool? isNew,
  }) {
    return VideoEntity(
      id: id ?? this.id,
      youtubeVideoId: youtubeVideoId ?? this.youtubeVideoId,
      title: title ?? this.title,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      category: category ?? this.category,
      cefrLevel: cefrLevel ?? this.cefrLevel,
      artist: artist ?? this.artist,
      publishedAt: publishedAt ?? this.publishedAt,
      breakingBadge: breakingBadge ?? this.breakingBadge,
      canonicalVersion: canonicalVersion ?? this.canonicalVersion,
      reactionCounts: reactionCounts ?? this.reactionCounts,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      practiced: practiced ?? this.practiced,
      isNew: isNew ?? this.isNew,
    );
  }

  @override
  List<Object?> get props => [
        id,
        youtubeVideoId,
        title,
        thumbnailUrl,
        category,
        cefrLevel,
        artist,
        publishedAt,
        breakingBadge,
        canonicalVersion,
        reactionCounts,
        durationSeconds,
        practiced,
        isNew,
      ];
}
