import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/classroom_entity.dart';

abstract class ClassroomRepository {
  Future<Either<Failure, List<ClassroomEntity>>> getClassrooms();
  Future<Either<Failure, ClassroomEntity>> createClassroom(String name);
  Future<Either<Failure, ClassroomEntity>> getClassroomById(String id);
}
