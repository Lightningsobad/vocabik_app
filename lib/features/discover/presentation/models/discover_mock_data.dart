import 'package:flutter/material.dart';
import 'package:vocabik_app/features/home/presentation/models/home_mock_data.dart';
import 'package:vocabik_app/features/discover/presentation/widgets/playlist_card.dart';

class DiscoverMockData {
  // Reuse courses from home for trending and categories
  static List<MockCourseModel> get trendingCourses => mockTrending;
  static List<MockCourseModel> get categoryCourses => mockRecentlyAdded; // Just reusing for demo

  static List<MockCourseModel> get allCourses => [...mockTrending, ...mockRecommended, ...mockRecentlyAdded, ...mockLibrary];

  static List<MockPlaylistModel> get playlists => [
    MockPlaylistModel(
      id: 'pl1',
      title: 'Pop Hits A2–B1',
      videoCount: 15,
      duration: '~60 phút',
      gradientColors: [const Color(0xFFC471ED), const Color(0xFFF64F59)],
    ),
    MockPlaylistModel(
      id: 'pl2',
      title: 'Rap for Beginners',
      videoCount: 10,
      duration: '~45 phút',
      gradientColors: [const Color(0xFF11998e), const Color(0xFF38ef7d)],
    ),
    MockPlaylistModel(
      id: 'pl3',
      title: 'Acoustic Chill',
      videoCount: 20,
      duration: '~80 phút',
      gradientColors: [const Color(0xFFff9966), const Color(0xFFff5e62)],
    ),
  ];
}
