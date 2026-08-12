import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/gamification.dart';
import '../entities/daily_streak.dart';
import '../repositories/progress_repository.dart';

class GamificationSummary {
  final Gamification gamification;
  final DailyStreak dailyStreak;

  const GamificationSummary({
    required this.gamification,
    required this.dailyStreak,
  });
}

@lazySingleton
class GetGamificationSummaryUseCase {
  final ProgressRepository _repository;

  GetGamificationSummaryUseCase(this._repository);

  Future<Either<Failure, GamificationSummary>> call() async {
    final gamificationFuture = _repository.getGamificationMe();
    final dailyStreakFuture = _repository.getDailyChallengeStreak();

    final gamificationResult = await gamificationFuture;
    final dailyStreakResult = await dailyStreakFuture;

    return gamificationResult.fold(
      (failure) => Left(failure),
      (gamification) => dailyStreakResult.fold(
        (failure) => Left(failure),
        (dailyStreak) => Right(GamificationSummary(
          gamification: gamification,
          dailyStreak: dailyStreak,
        )),
      ),
    );
  }
}
