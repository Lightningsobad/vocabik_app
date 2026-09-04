import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/challenge_link_entity.dart';
import '../../domain/entities/friend_entity.dart';
import '../../domain/repositories/challenge_friend_repository.dart';
import '../datasources/challenge_friend_remote_datasource.dart';
import '../models/challenge_link_request_model.dart';

@LazySingleton(as: ChallengeFriendRepository)
class ChallengeFriendRepositoryImpl implements ChallengeFriendRepository {
  final ChallengeFriendRemoteDataSource _remoteDataSource;

  ChallengeFriendRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<FriendEntity>>> getFriends() async {
    try {
      final models = await _remoteDataSource.getFriends();
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on NetworkException {
      return const Left(NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChallengeLinkEntity>> createChallengeLink({
    required String videoSlug,
    required String exerciseVersion,
    required int challengerScoreAccuracy,
    required int challengerScoreTimeMs,
  }) async {
    try {
      final request = ChallengeLinkRequestModel(
        videoSlug: videoSlug,
        exerciseVersion: exerciseVersion,
        challengerScoreAccuracy: challengerScoreAccuracy,
        challengerScoreTimeMs: challengerScoreTimeMs,
      );
      final model = await _remoteDataSource.createChallengeLink(request: request);
      return Right(model.toEntity());
    } on NetworkException {
      return const Left(NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
