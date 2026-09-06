import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/friend_entity.dart';
import '../repositories/challenge_friend_repository.dart';

@injectable
class GetFriendsUseCase {
  final ChallengeFriendRepository _repository;

  GetFriendsUseCase(this._repository);

  Future<Either<Failure, List<FriendEntity>>> call() {
    return _repository.getFriends();
  }
}
