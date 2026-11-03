import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/main_shell/presentation/cubit/main_shell_cubit.dart';
import 'package:vocabik_app/features/progress/domain/entities/progress_error_insights.dart';
import 'package:vocabik_app/features/progress/domain/entities/progress_history.dart';
import 'package:vocabik_app/features/progress/domain/entities/progress_summary.dart';
import 'package:vocabik_app/features/progress/domain/repositories/progress_repository.dart';
import 'package:vocabik_app/features/progress/domain/use_cases/get_progress_summary_use_case.dart';
import 'package:vocabik_app/shared/gamification/cubit/gamification_global_cubit.dart';

class FakeProgressRepository implements ProgressRepository {
  final Either<Failure, ProgressSummary> summaryResult;

  FakeProgressRepository({required this.summaryResult});

  @override
  Future<Either<Failure, ProgressSummary>> getProgressSummary() async {
    return summaryResult;
  }

  @override
  Future<Either<Failure, ProgressHistory>> getProgressHistory() async {
    return left(const ServerFailure('Not implemented'));
  }

  @override
  Future<Either<Failure, ProgressErrorInsights>> getProgressErrorInsights() async {
    return left(const ServerFailure('Not implemented'));
  }
}

void main() {
  const dummySummary = ProgressSummary(
    streak: ProgressStreak(
      currentStreak: 7,
      longestStreak: 14,
      freezeActive: false,
      freezeCount: 0,
      heatmap30Days: [],
    ),
    level: ProgressLevel(
      level: 'B1',
      currentTitle: 'Intermediate',
      currentXpInLevel: 250,
      xpRequiredForNextLevel: 500,
      totalXp: 1250,
      progressPct: 50,
      remainingXp: 250,
    ),
    weeklyXp: [],
    stats: ProgressStats(exercisesCompleted: 42, accuracyPct: 85),
  );

  group('MainShellCubit', () {
    test('loadSummary updates state and GamificationGlobalCubit on success', () async {
      final fakeRepo = FakeProgressRepository(summaryResult: right(dummySummary));
      final useCase = GetProgressSummaryUseCase(fakeRepo);
      final gamificationCubit = GamificationGlobalCubit();
      final cubit = MainShellCubit(useCase, gamificationCubit);

      expect(cubit.state.summary, isNull);
      expect(cubit.state.isLoading, isFalse);

      final future = cubit.loadSummary();
      expect(gamificationCubit.state.isLoading, isTrue);

      await future;

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.summary, equals(dummySummary));
      expect(cubit.state.errorMessage, isNull);

      // Verify GamificationGlobalCubit was synchronized
      expect(gamificationCubit.state.streak, equals(7));
      expect(gamificationCubit.state.xp, equals(1250));
      expect(gamificationCubit.state.isLoading, isFalse);
    });

    test('loadSummary handles failure properly', () async {
      final fakeRepo = FakeProgressRepository(
        summaryResult: left(const ServerFailure('API error occurred')),
      );
      final useCase = GetProgressSummaryUseCase(fakeRepo);
      final gamificationCubit = GamificationGlobalCubit();
      final cubit = MainShellCubit(useCase, gamificationCubit);

      await cubit.loadSummary();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.summary, isNull);
      expect(cubit.state.errorMessage, equals('API error occurred'));
      expect(gamificationCubit.state.isLoading, isFalse);
    });
  });
}
