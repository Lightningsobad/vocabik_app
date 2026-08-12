import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/gamification.dart';
import '../entities/daily_streak.dart';

abstract class ProgressRepository {
  Future<Either<Failure, Gamification>> getGamificationMe();
  Future<Either<Failure, DailyStreak>> getDailyChallengeStreak();
}
