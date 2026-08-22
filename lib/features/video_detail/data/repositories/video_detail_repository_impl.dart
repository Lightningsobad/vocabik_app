import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/exceptions.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/video_detail/data/datasources/video_detail_remote_data_source.dart';
import 'package:vocabik_app/features/video_detail/domain/entities/video_progress_entity.dart';
import 'package:vocabik_app/features/video_detail/domain/repositories/video_detail_repository.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';

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

  @override
  Future<Either<Failure, int>> getExerciseBlanksCount(String videoId) async {
    try {
      final count = await remoteDataSource.getExerciseBlanksCount(videoId);
      return Right(count);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VideoProgressEntity?>> getLatestProgress(String videoTitle) async {
    try {
      final progressModel = await remoteDataSource.getLatestProgress(videoTitle);
      return Right(progressModel?.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
