import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/home/domain/entities/daily_pick_entity.dart';
import 'package:vocabik_app/features/home/domain/entities/personalized_slot_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, DailyPickEntity>> getDailyPick();
  Future<Either<Failure, List<PersonalizedSlotEntity>>> getPersonalizedSlots();
}

