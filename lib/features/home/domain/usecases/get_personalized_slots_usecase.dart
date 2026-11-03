import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/home/domain/entities/personalized_slot_entity.dart';
import 'package:vocabik_app/features/home/domain/repositories/home_repository.dart';

@injectable
class GetPersonalizedSlotsUseCase {
  final HomeRepository repository;

  GetPersonalizedSlotsUseCase(this.repository);

  Future<Either<Failure, List<PersonalizedSlotEntity>>> call() {
    return repository.getPersonalizedSlots();
  }
}
