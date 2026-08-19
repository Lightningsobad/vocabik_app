import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/exceptions.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/home/data/datasources/home_remote_data_source.dart';
import 'package:vocabik_app/features/home/domain/entities/daily_pick_entity.dart';
import 'package:vocabik_app/features/home/domain/entities/personalized_slot_entity.dart';
import 'package:vocabik_app/features/home/domain/repositories/home_repository.dart';

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DailyPickEntity>> getDailyPick() async {
    try {
      final result = await remoteDataSource.getDailyPick();
      return right(result);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PersonalizedSlotEntity>>> getPersonalizedSlots() async {
    try {
      final result = await remoteDataSource.getPersonalizedSlots();
      return right(result);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}

