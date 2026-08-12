import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/exceptions.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';
import 'package:vocabik_app/features/video_detail/data/datasources/video_detail_remote_data_source.dart';
import 'package:vocabik_app/features/video_detail/domain/repositories/video_detail_repository.dart';

@LazySingleton(as: VideoDetailRepository)
class VideoDetailRepositoryImpl implements VideoDetailRepository {
  final VideoDetailRemoteDataSource remoteDataSource;

  VideoDetailRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, VideoEntity>> getVideoDetail(String id) async {
    try {
      final videoModel = await remoteDataSource.getVideoDetail(id);
      return Right(videoModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
