import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/challenge_link_entity.dart';
import '../entities/friend_entity.dart';

abstract class ChallengeFriendRepository {
  Future<Either<Failure, List<FriendEntity>>> getFriends();

  Future<Either<Failure, ChallengeLinkEntity>> createChallengeLink({
    required String videoSlug,
    required String exerciseVersion,
    required int challengerScoreAccuracy,
    required int challengerScoreTimeMs,
  });
}
