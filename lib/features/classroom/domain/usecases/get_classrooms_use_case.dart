import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/classroom_entity.dart';
import '../repositories/classroom_repository.dart';

@injectable
class GetClassroomsUseCase {
  final ClassroomRepository _repository;

  GetClassroomsUseCase(this._repository);

  Future<Either<Failure, List<ClassroomEntity>>> call() {
    return _repository.getClassrooms();
  }
}
