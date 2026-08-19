import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/home/domain/entities/daily_pick_entity.dart';
import 'package:vocabik_app/features/home/domain/repositories/home_repository.dart';

@injectable
class GetDailyPickUseCase {
  final HomeRepository repository;

  GetDailyPickUseCase(this.repository);

  Future<Either<Failure, DailyPickEntity>> call() {
    return repository.getDailyPick();
  }
}
