import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/video_detail/domain/entities/reaction_result_entity.dart';
import 'package:vocabik_app/features/video_detail/domain/repositories/video_detail_repository.dart';

@injectable
class SendVideoReactionUseCase {
  final VideoDetailRepository repository;

  SendVideoReactionUseCase(this.repository);

  Future<Either<Failure, ReactionResultEntity>> call(String videoId, String reactionType) async {
    return repository.sendVideoReaction(videoId, reactionType);
  }
}
