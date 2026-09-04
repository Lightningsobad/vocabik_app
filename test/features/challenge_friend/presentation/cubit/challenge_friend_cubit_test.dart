import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/challenge_friend/domain/entities/challenge_link_entity.dart';
import 'package:vocabik_app/features/challenge_friend/domain/entities/friend_entity.dart';
import 'package:vocabik_app/features/challenge_friend/domain/repositories/challenge_friend_repository.dart';
import 'package:vocabik_app/features/challenge_friend/domain/usecases/create_challenge_link_usecase.dart';
import 'package:vocabik_app/features/challenge_friend/domain/usecases/get_friends_usecase.dart';
import 'package:vocabik_app/features/challenge_friend/presentation/cubit/challenge_friend_cubit.dart';
import 'package:vocabik_app/features/challenge_friend/presentation/cubit/challenge_friend_state.dart';
import 'package:vocabik_app/features/challenge_friend/presentation/models/challenge_friend_args.dart';
import 'package:vocabik_app/features/exercise/domain/entities/exercise_entity.dart';

class FakeChallengeFriendRepository implements ChallengeFriendRepository {
  List<FriendEntity> friendsToReturn = [];
  ChallengeLinkEntity? linkToReturn;
  Failure? failureToReturn;

  @override
  Future<Either<Failure, List<FriendEntity>>> getFriends() async {
    if (failureToReturn != null) return Left(failureToReturn!);
    return Right(friendsToReturn);
  }

  @override
  Future<Either<Failure, ChallengeLinkEntity>> createChallengeLink({
    required String videoSlug,
    required String exerciseVersion,
    required int challengerScoreAccuracy,
    required int challengerScoreTimeMs,
  }) async {
    if (failureToReturn != null) return Left(failureToReturn!);
    return Right(linkToReturn!);
  }
}

void main() {
  late FakeChallengeFriendRepository repository;
  late GetFriendsUseCase getFriendsUseCase;
  late CreateChallengeLinkUseCase createChallengeLinkUseCase;
  late ChallengeFriendCubit cubit;

  const sampleFriend1 = FriendEntity(
    userId: '1',
    displayName: 'Minh Khôi',
    xp: 1240,
    streak: 4,
  );
  const sampleFriend2 = FriendEntity(
    userId: '2',
    displayName: 'Thu Hà',
    xp: 1180,
    streak: 5,
  );

  setUp(() {
    repository = FakeChallengeFriendRepository();
    getFriendsUseCase = GetFriendsUseCase(repository);
    createChallengeLinkUseCase = CreateChallengeLinkUseCase(repository);
    cubit = ChallengeFriendCubit(getFriendsUseCase, createChallengeLinkUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('ChallengeFriendCubit', () {
    test('initial state has default values', () {
      expect(cubit.state.status, ChallengeFriendStatus.initial);
      expect(cubit.state.friends, isEmpty);
      expect(cubit.state.selectedFriends, isEmpty);
      expect(cubit.state.searchQuery, isEmpty);
    });

    test('loadFriends emits success with list of friends', () async {
      repository.friendsToReturn = [sampleFriend1, sampleFriend2];

      await cubit.loadFriends();

      expect(cubit.state.status, ChallengeFriendStatus.success);
      expect(cubit.state.friends.length, 2);
    });

    test('filtering friends by search query works correctly', () async {
      repository.friendsToReturn = [sampleFriend1, sampleFriend2];
      await cubit.loadFriends();

      cubit.setSearchQuery('Minh');
      expect(cubit.state.filteredFriends.length, 1);
      expect(cubit.state.filteredFriends.first.displayName, 'Minh Khôi');

      cubit.setSearchQuery('Thu');
      expect(cubit.state.filteredFriends.length, 1);
      expect(cubit.state.filteredFriends.first.displayName, 'Thu Hà');

      cubit.setSearchQuery('Unknown');
      expect(cubit.state.filteredFriends, isEmpty);
    });

    test('toggling friend selection adds and removes from selectedFriends', () {
      cubit.toggleFriend(sampleFriend1);
      expect(cubit.state.selectedFriends.contains(sampleFriend1), isTrue);
      expect(cubit.state.selectedFriends.length, 1);

      cubit.toggleFriend(sampleFriend2);
      expect(cubit.state.selectedFriends.length, 2);

      cubit.toggleFriend(sampleFriend1);
      expect(cubit.state.selectedFriends.contains(sampleFriend1), isFalse);
      expect(cubit.state.selectedFriends.length, 1);
    });

    test('sendChallenge emits createdChallengeLink upon success', () async {
      final sampleLink = ChallengeLinkEntity(
        uuid: 'uuid-123',
        url: 'https://vocabik.com/challenge/uuid-123',
        expiresAt: DateTime.now().add(const Duration(days: 30)),
      );
      repository.linkToReturn = sampleLink;

      cubit.toggleFriend(sampleFriend1);

      const sampleExercise = ExerciseEntity(
        status: 'ready',
        videoId: 'shape-of-you',
        cefrLevel: 'B1',
        versionId: 'v1',
        strategy: 'standard',
        isCanonical: true,
        blankPositions: [],
        blanks: [],
        answerOptions: {},
        createdAt: '',
        lines: [],
      );

      await cubit.sendChallenge(
        const ChallengeFriendArgs(
          exercise: sampleExercise,
          durationMs: 90000,
          accuracyScore: 85,
          videoTitle: 'Shape of You',
        ),
      );

      expect(cubit.state.createdChallengeLink, sampleLink);
      expect(cubit.state.isSending, isFalse);
    });
  });
}
