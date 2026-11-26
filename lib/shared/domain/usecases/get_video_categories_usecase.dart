import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/shared/domain/entities/video_category_entity.dart';
import 'package:vocabik_app/shared/domain/repositories/shared_video_repository.dart';

@injectable
class GetVideoCategoriesUseCase {
  final SharedVideoRepository repository;

  GetVideoCategoriesUseCase(this.repository);

  List<VideoCategoryEntity> getCached() {
    return repository.getCachedCategories();
  }

  Future<Either<Failure, List<VideoCategoryEntity>>> call({
    bool forceRefresh = false,
  }) {
    return repository.getCategories(forceRefresh: forceRefresh);
  }
}
