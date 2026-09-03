import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/progress/domain/entities/progress_error_insights.dart';
import 'package:vocabik_app/features/progress/domain/entities/progress_history.dart';
import 'package:vocabik_app/features/progress/domain/entities/progress_summary.dart';
import 'package:vocabik_app/features/progress/domain/repositories/progress_repository.dart';
import 'package:vocabik_app/features/progress/domain/use_cases/get_progress_error_insights_use_case.dart';
import 'package:vocabik_app/features/progress/domain/use_cases/get_progress_history_use_case.dart';
import 'package:vocabik_app/features/progress/presentation/cubit/progress_cubit.dart';

class FakeProgressRepository implements ProgressRepository {
  final Either<Failure, ProgressHistory> historyResult;
  final Either<Failure, ProgressErrorInsights> insightsResult;

  FakeProgressRepository({
    required this.historyResult,
    required this.insightsResult,
  });

  @override
  Future<Either<Failure, ProgressSummary>> getProgressSummary() async {
    return left(const ServerFailure('Not used'));
  }

  @override
  Future<Either<Failure, ProgressHistory>> getProgressHistory() async {
    return historyResult;
  }

  @override
  Future<Either<Failure, ProgressErrorInsights>> getProgressErrorInsights() async {
    return insightsResult;
  }
}

void main() {
  const dummyHistory = ProgressHistory(items: []);
  const dummyInsights = ProgressErrorInsights(
    state: 'active',
    categories: [],
    trend: [],
  );

  group('ProgressCubit', () {
    test('loadProgressData emits ProgressLoading and then ProgressLoaded on success', () async {
      final fakeRepo = FakeProgressRepository(
        historyResult: right(dummyHistory),
        insightsResult: right(dummyInsights),
      );
      final historyUseCase = GetProgressHistoryUseCase(fakeRepo);
      final insightsUseCase = GetProgressErrorInsightsUseCase(fakeRepo);
      final cubit = ProgressCubit(historyUseCase, insightsUseCase);

      expect(cubit.state, isA<ProgressInitial>());

      final future = cubit.loadProgressData();
      expect(cubit.state, isA<ProgressLoading>());

      await future;

      expect(cubit.state, isA<ProgressLoaded>());
      final loaded = cubit.state as ProgressLoaded;
      expect(loaded.history, equals(dummyHistory));
      expect(loaded.errorInsights, equals(dummyInsights));
    });

    test('loadProgressData handles partial failures gracefully', () async {
      final fakeRepo = FakeProgressRepository(
        historyResult: right(dummyHistory),
        insightsResult: left(const ServerFailure('Insights failed')),
      );
      final historyUseCase = GetProgressHistoryUseCase(fakeRepo);
      final insightsUseCase = GetProgressErrorInsightsUseCase(fakeRepo);
      final cubit = ProgressCubit(historyUseCase, insightsUseCase);

      await cubit.loadProgressData();

      expect(cubit.state, isA<ProgressLoaded>());
      final loaded = cubit.state as ProgressLoaded;
      expect(loaded.history, equals(dummyHistory));
      expect(loaded.errorInsights, isNull);
    });
  });
}
