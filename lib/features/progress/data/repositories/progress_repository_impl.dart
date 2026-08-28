import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/progress_summary.dart';
import '../../domain/entities/progress_history.dart';
import '../../domain/entities/progress_error_insights.dart';
import '../../domain/repositories/progress_repository.dart';
import '../data_sources/progress_remote_data_source.dart';

@LazySingleton(as: ProgressRepository)
class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressRemoteDataSource _remoteDataSource;

  ProgressRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, ProgressSummary>> getProgressSummary() async {
    try {
      final result = await _remoteDataSource.getProgressSummary();
      return Right(result);
    } on NetworkException {
      return const Left(NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProgressHistory>> getProgressHistory() async {
    try {
      final result = await _remoteDataSource.getProgressHistory();
      return Right(result);
    } on NetworkException {
      return const Left(NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProgressErrorInsights>> getProgressErrorInsights() async {
    try {
      final result = await _remoteDataSource.getProgressErrorInsights();
      return Right(result);
    } on NetworkException {
      return const Left(NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
