import 'package:equatable/equatable.dart';

class DailyChallengeStreakEntity extends Equatable {
  final String userId;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastParticipationDate;
  final DateTime? updatedAt;

  const DailyChallengeStreakEntity({
    required this.userId,
    required this.currentStreak,
    required this.longestStreak,
    this.lastParticipationDate,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        userId,
        currentStreak,
        longestStreak,
        lastParticipationDate,
        updatedAt,
      ];
}
