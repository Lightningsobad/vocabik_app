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
  });

  bool get isNew {
    final now = DateTime.now();
    final difference = now.difference(publishedAt).inDays;
    return difference <= 7;
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
      ];
}
