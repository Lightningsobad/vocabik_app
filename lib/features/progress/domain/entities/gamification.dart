import 'package:equatable/equatable.dart';

class Gamification extends Equatable {
  final int currentStreak;
  final int xp;
  final LevelInfo? levelInfo;
  final int streakFreeze;
  final int? exercisesDone;
  final double? accuracy;

  const Gamification({
    required this.currentStreak,
    required this.xp,
    this.levelInfo,
    required this.streakFreeze,
    this.exercisesDone,
    this.accuracy,
  });

  @override
  List<Object?> get props => [currentStreak, xp, levelInfo, streakFreeze, exercisesDone, accuracy];
}

class LevelInfo extends Equatable {
  final String currentLevel;
  final String nextLevel;
  final int currentXpInLevel;
  final int maxXpInLevel;

  const LevelInfo({
    required this.currentLevel,
    required this.nextLevel,
    required this.currentXpInLevel,
    required this.maxXpInLevel,
  });

  @override
  List<Object?> get props => [currentLevel, nextLevel, currentXpInLevel, maxXpInLevel];
}
