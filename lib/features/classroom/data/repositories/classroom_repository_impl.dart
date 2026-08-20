import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/classroom_entity.dart';
import '../../domain/repositories/classroom_repository.dart';
import '../datasources/classroom_remote_data_source.dart';

@LazySingleton(as: ClassroomRepository)
class ClassroomRepositoryImpl implements ClassroomRepository {
  final ClassroomRemoteDataSource _remoteDataSource;

  ClassroomRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<ClassroomEntity>>> getClassrooms() async {
    try {
      final models = await _remoteDataSource.getClassrooms();
      return Right(models);
    } on NetworkException {
      return const Left(NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ClassroomEntity>> createClassroom(String name) async {
    try {
      final model = await _remoteDataSource.createClassroom(name);
      return Right(model);
    } on NetworkException {
      return const Left(NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ClassroomEntity>> getClassroomById(String id) async {
    try {
      final model = await _remoteDataSource.getClassroomById(id);
      return Right(model);
    } on NetworkException {
      return const Left(NetworkFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
