import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/daily_challenge/domain/entities/daily_challenge_config_entity.dart';
import 'package:vocabik_app/features/daily_challenge/domain/entities/daily_challenge_leaderboard_entity.dart';
import 'package:vocabik_app/features/daily_challenge/domain/entities/daily_challenge_streak_entity.dart';
import 'package:vocabik_app/features/daily_challenge/domain/repositories/daily_challenge_repository.dart';
import 'package:vocabik_app/features/daily_challenge/domain/usecases/submit_daily_challenge_result_usecase.dart';

class FakeDailyChallengeRepository implements DailyChallengeRepository {
  Either<Failure, String> submitResultReturnValue;
  int? lastScoreAccuracy;
  int? lastScoreTimeMs;

  FakeDailyChallengeRepository({required this.submitResultReturnValue});

  @override
  Future<Either<Failure, DailyChallengeResponseEntity>> getConfig() async {
    return left(const ServerFailure('Not used'));
  }

  @override
  Future<Either<Failure, List<DailyChallengeLeaderboardItemEntity>>>
      getLeaderboard(String date) async {
    return left(const ServerFailure('Not used'));
  }

  @override
  Future<Either<Failure, DailyChallengeStreakEntity>> getStreak() async {
    return left(const ServerFailure('Not used'));
  }

  @override
  Future<Either<Failure, String>> submitResult({
    required int scoreAccuracy,
    required int scoreTimeMs,
  }) async {
    lastScoreAccuracy = scoreAccuracy;
    lastScoreTimeMs = scoreTimeMs;
    return submitResultReturnValue;
  }
}

void main() {
  test('should return result id on successful submission', () async {
    const expectedId = 'facc6317-c84a-46c2-bde3-9e5e2ae6ab44';
    final fakeRepo = FakeDailyChallengeRepository(
      submitResultReturnValue: const Right(expectedId),
    );
    final useCase = SubmitDailyChallengeResultUseCase(fakeRepo);

    final result = await useCase(
      scoreAccuracy: 100,
      scoreTimeMs: 50,
    );

    expect(result, const Right(expectedId));
    expect(fakeRepo.lastScoreAccuracy, 100);
    expect(fakeRepo.lastScoreTimeMs, 50);
  });

  test('should return Failure on repository failure', () async {
    const failure = ServerFailure('Submission error');
    final fakeRepo = FakeDailyChallengeRepository(
      submitResultReturnValue: const Left(failure),
    );
    final useCase = SubmitDailyChallengeResultUseCase(fakeRepo);

    final result = await useCase(
      scoreAccuracy: 80,
      scoreTimeMs: 120,
    );

    expect(result, const Left(failure));
    expect(fakeRepo.lastScoreAccuracy, 80);
    expect(fakeRepo.lastScoreTimeMs, 120);
  });
}
