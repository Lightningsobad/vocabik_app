import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/achievements/data/models/badge_model.dart';
import 'package:vocabik_app/features/achievements/domain/entities/badge_entity.dart';
import 'package:vocabik_app/features/achievements/domain/repositories/badge_repository.dart';
import 'package:vocabik_app/features/achievements/domain/usecases/get_badges_usecase.dart';
import 'package:vocabik_app/features/achievements/presentation/cubit/achievements_cubit.dart';
import 'package:vocabik_app/features/achievements/presentation/cubit/achievements_state.dart';

class MockBadgeRepository implements BadgeRepository {
  String? lastCategoryReceived;
  Either<Failure, List<BadgeEntity>>? responseToReturn;

  @override
  Future<Either<Failure, List<BadgeEntity>>> getBadges({String? category}) async {
    lastCategoryReceived = category;
    return responseToReturn ?? const Right([]);
  }
}

void main() {
  group('BadgeModel & BadgeProgressModel', () {
    test('should parse json with category and progress correctly', () {
      final json = {
        'code': 'first_exercise',
        'displayName': 'First Exercise',
        'description': 'Completed your very first exercise.',
        'category': 'exercise',
        'iconRef': 'badge_first_exercise.svg',
        'locked': false,
        'awardedAt': '2026-08-18T14:30:17.352Z',
        'progress': {
          'current': 1,
          'target': 1,
        },
      };

      final model = BadgeModel.fromJson(json);

      expect(model.code, 'first_exercise');
      expect(model.displayName, 'First Exercise');
      expect(model.category, 'exercise');
      expect(model.locked, false);
      expect(model.progress, isNotNull);
      expect(model.progress!.current, 1);
      expect(model.progress!.target, 1);
      expect(model.progress!.percentage, 1.0);
    });

    test('should calculate percentage correctly for partial progress', () {
      const progress = BadgeProgressEntity(current: 3, target: 10);
      expect(progress.percentage, 0.3);
    });
  });

  group('AchievementsCubit', () {
    late MockBadgeRepository mockRepo;
    late GetBadgesUseCase useCase;
    late AchievementsCubit cubit;

    setUp(() {
      mockRepo = MockBadgeRepository();
      useCase = GetBadgesUseCase(mockRepo);
      cubit = AchievementsCubit(useCase);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is AchievementsInitial', () {
      expect(cubit.state, const AchievementsInitial());
    });

    test('fetchBadges emits [AchievementsLoading, AchievementsLoaded] on success', () async {
      const badges = [
        BadgeEntity(
          code: 'first_exercise',
          displayName: 'First Exercise',
          description: 'Completed your very first exercise.',
          category: 'exercise',
          locked: false,
          progress: BadgeProgressEntity(current: 1, target: 1),
        ),
      ];
      mockRepo.responseToReturn = const Right(badges);

      final expectedStates = [
        const AchievementsLoading(),
        const AchievementsLoaded(badges, selectedCategory: 'exercise'),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.fetchBadges(category: 'exercise');
      expect(mockRepo.lastCategoryReceived, 'exercise');
      expect(cubit.selectedCategory, 'exercise');
    });

    test('fetchBadges emits [AchievementsLoading, AchievementsError] on failure', () async {
      mockRepo.responseToReturn = const Left(ServerFailure('API error'));

      final expectedStates = [
        const AchievementsLoading(),
        const AchievementsError('API error'),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.fetchBadges();
      expect(mockRepo.lastCategoryReceived, isNull);
    });
  });
}
