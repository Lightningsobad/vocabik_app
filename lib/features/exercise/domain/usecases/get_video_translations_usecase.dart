import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/core/network/app_cancel_token.dart';
import 'package:vocabik_app/features/exercise/domain/entities/translation_entity.dart';
import 'package:vocabik_app/features/exercise/domain/repositories/exercise_repository.dart';

@injectable
class GetVideoTranslationsUseCase {
  final ExerciseRepository repository;

  GetVideoTranslationsUseCase(this.repository);

  Future<Either<Failure, List<TranslationEntity>>> call(
    GetVideoTranslationsParams params,
  ) async {
    return repository.getVideoTranslations(
      videoId: params.videoId,
      lang: params.lang,
      language: params.language,
      cancelToken: params.cancelToken,
    );
  }
}

class GetVideoTranslationsParams {
  final String videoId;
  final String lang;
  final String language;
  final AppCancelToken? cancelToken;

  GetVideoTranslationsParams({
    required this.videoId,
    this.lang = 'vi',
    this.language = 'vi',
    this.cancelToken,
  });
}
