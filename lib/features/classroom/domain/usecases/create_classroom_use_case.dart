import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/classroom_entity.dart';
import '../repositories/classroom_repository.dart';

@injectable
class CreateClassroomUseCase {
  final ClassroomRepository _repository;

  CreateClassroomUseCase(this._repository);

  Future<Either<Failure, ClassroomEntity>> call(String name) {
    return _repository.createClassroom(name);
  }
}
