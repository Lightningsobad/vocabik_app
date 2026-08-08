import 'package:flutter/material.dart';
import 'package:vocabik_app/features/home/domain/entities/video_entity.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';

class MockCourseModel {
  final String id;
  final String title;
  final String subtitle;
  final String level;
  final String category;
  final String duration;
  final bool isNew;
  final bool isCompleted;
  final int practicersCount;

  const MockCourseModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.level,
    required this.category,
    required this.duration,
    this.isNew = false,
    this.isCompleted = false,
    this.practicersCount = 0,
  });

  VideoEntity toEntity() {
    return VideoEntity(
      id: id,
      youtubeVideoId: '',
      title: title,
      thumbnailUrl: '',
      category: category,
      cefrLevel: level,
      artist: subtitle,
      publishedAt: isNew ? DateTime.now() : DateTime.now().subtract(const Duration(days: 30)),
      breakingBadge: false,
    );
  }
}

class MockCategoryModel {
  final String id;
  final String title;

  const MockCategoryModel({
    required this.id,
    required this.title,
  });
}

// Hàm giả lập gradient ngẫu nhiên
List<Color> generateRandomGradient(AppColorsExtension colors) {
  final list = [
    [const Color(0xFFF43F5E), const Color(0xFFFDBA74)], // Pink -> Orange
    [const Color(0xFF8B5CF6), const Color(0xFFC084FC)], // Purple -> Light Purple
    [const Color(0xFF0EA5E9), const Color(0xFF38BDF8)], // Blue -> Light Blue
    [const Color(0xFF10B981), const Color(0xFF34D399)], // Green -> Emerald
    [const Color(0xFFF59E0B), const Color(0xFFFCD34D)], // Amber -> Yellow
    [const Color(0xFFEC4899), const Color(0xFFF472B6)], // Rose -> Pink
  ];
  list.shuffle();
  return list.first;
}

final List<MockCourseModel> mockDailyPick = [
  const MockCourseModel(
    id: '1',
    title: 'Shape of You',
    subtitle: 'Ed Sheeran',
    level: 'B1',
    category: 'Pop',
    duration: '3:53',
    practicersCount: 1200,
  ),
];

final List<MockCourseModel> mockRecommended = [
  const MockCourseModel(
    id: '2',
    title: 'Believer',
    subtitle: 'Imagine Dragons',
    level: 'B1',
    category: 'Pop',
    duration: '3:24',
  ),
  const MockCourseModel(
    id: '3',
    title: 'Counting Stars',
    subtitle: 'OneRepublic',
    level: 'B1',
    category: 'Pop',
    duration: '4:17',
  ),
  const MockCourseModel(
    id: '4',
    title: 'Someone Like You',
    subtitle: 'Adele',
    level: 'A2',
    category: 'Acoustic',
    duration: '4:45',
  ),
];

final List<MockCourseModel> mockTrending = [
  const MockCourseModel(
    id: '5',
    title: 'Flowers',
    subtitle: 'Miley Cyrus',
    level: 'B1',
    category: 'Pop',
    duration: '3:20',
    isCompleted: true,
    practicersCount: 1500,
  ),
  const MockCourseModel(
    id: '6',
    title: 'Blinding Lights',
    subtitle: 'The Weeknd',
    level: 'B2',
    category: 'Pop',
    duration: '3:22',
  ),
];

final List<MockCourseModel> mockRecentlyAdded = [
  const MockCourseModel(
    id: '7',
    title: 'As It Was',
    subtitle: 'Harry Styles',
    level: 'B1',
    category: 'Pop',
    duration: '2:47',
    isNew: true,
    practicersCount: 870,
  ),
  const MockCourseModel(
    id: '8',
    title: 'Believer',
    subtitle: 'Imagine Dragons',
    level: 'B1',
    category: 'Pop',
    duration: '3:24',
    isNew: true,
  ),
];

final List<MockCourseModel> mockLibrary = [
  const MockCourseModel(id: '9', title: 'Shape of You', subtitle: 'Ed Sheeran', level: 'B1', category: 'Pop', duration: '3:53', practicersCount: 1200),
  const MockCourseModel(id: '10', title: 'Blinding Lights', subtitle: 'The Weeknd', level: 'B2', category: 'Pop', duration: '3:22', practicersCount: 980),
  const MockCourseModel(id: '11', title: 'Flowers', subtitle: 'Miley Cyrus', level: 'B1', category: 'Pop', duration: '3:20', isCompleted: true),
  const MockCourseModel(id: '12', title: 'As It Was', subtitle: 'Harry Styles', level: 'B1', category: 'Pop', duration: '2:47', isNew: true),
  const MockCourseModel(id: '13', title: 'Believer', subtitle: 'Imagine Dragons', level: 'B1', category: 'Pop', duration: '3:24', isNew: true, practicersCount: 920),
  const MockCourseModel(id: '14', title: 'Happy', subtitle: 'Pharrell Williams', level: 'A2', category: 'Pop', duration: '3:53', practicersCount: 1300),
  const MockCourseModel(id: '15', title: 'Bad Guy', subtitle: 'Billie Eilish', level: 'B2', category: 'Pop', duration: '3:14', practicersCount: 700),
  const MockCourseModel(id: '16', title: 'The power of vulnerability', subtitle: 'Brené Brown · TED', level: 'C1', category: 'Talk', duration: '20:19', practicersCount: 410),
];
