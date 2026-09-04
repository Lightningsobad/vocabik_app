import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/challenge_link_entity.dart';
import '../repositories/challenge_friend_repository.dart';

@injectable
class CreateChallengeLinkUseCase {
  final ChallengeFriendRepository _repository;

  CreateChallengeLinkUseCase(this._repository);

  Future<Either<Failure, ChallengeLinkEntity>> call({
    required String videoSlug,
    required String exerciseVersion,
    required int challengerScoreAccuracy,
    required int challengerScoreTimeMs,
  }) {
    return _repository.createChallengeLink(
      videoSlug: videoSlug,
      exerciseVersion: exerciseVersion,
      challengerScoreAccuracy: challengerScoreAccuracy,
      challengerScoreTimeMs: challengerScoreTimeMs,
    );
  }
}
