import 'package:equatable/equatable.dart';
import '../../domain/entities/badge_entity.dart';

abstract class AchievementsState extends Equatable {
  const AchievementsState();

  @override
  List<Object?> get props => [];
}

class AchievementsInitial extends AchievementsState {
  const AchievementsInitial();
}

class AchievementsLoading extends AchievementsState {
  const AchievementsLoading();
}

class AchievementsLoaded extends AchievementsState {
  final List<BadgeEntity> badges;

  const AchievementsLoaded(this.badges);

  List<BadgeEntity> get unlockedBadges =>
      badges.where((b) => !b.locked).toList();

  List<BadgeEntity> get lockedBadges =>
      badges.where((b) => b.locked).toList();

  int get unlockedCount => unlockedBadges.length;
  int get totalCount => badges.length;

  @override
  List<Object?> get props => [badges];
}

class AchievementsError extends AchievementsState {
  final String message;

  const AchievementsError(this.message);

  @override
  List<Object?> get props => [message];
}
