import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/classroom_entity.dart';
import '../repositories/classroom_repository.dart';

@injectable
class GetClassroomByIdUseCase {
  final ClassroomRepository _repository;

  GetClassroomByIdUseCase(this._repository);

  Future<Either<Failure, ClassroomEntity>> call(String id) {
    return _repository.getClassroomById(id);
  }
}
