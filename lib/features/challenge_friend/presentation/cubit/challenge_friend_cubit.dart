import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/friend_entity.dart';
import '../../domain/usecases/create_challenge_link_usecase.dart';
import '../../domain/usecases/get_friends_usecase.dart';
import '../models/challenge_friend_args.dart';
import 'challenge_friend_state.dart';

@injectable
class ChallengeFriendCubit extends Cubit<ChallengeFriendState> {
  final GetFriendsUseCase _getFriendsUseCase;
  final CreateChallengeLinkUseCase _createChallengeLinkUseCase;

  ChallengeFriendCubit(
    this._getFriendsUseCase,
    this._createChallengeLinkUseCase,
  ) : super(const ChallengeFriendState());

  Future<void> loadFriends() async {
    emit(state.copyWith(
      status: ChallengeFriendStatus.loading,
      errorMessage: null,
    ));

    final result = await _getFriendsUseCase();

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: ChallengeFriendStatus.error,
          errorMessage: failure.message,
        ));
      },
      (friends) {
        emit(state.copyWith(
          status: ChallengeFriendStatus.success,
          friends: friends,
        ));
      },
    );
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void toggleFriend(FriendEntity friend) {
    final updated = Set<FriendEntity>.from(state.selectedFriends);
    if (updated.contains(friend)) {
      updated.remove(friend);
    } else {
      updated.add(friend);
    }
    emit(state.copyWith(selectedFriends: updated));
  }

  Future<void> sendChallenge(ChallengeFriendArgs args) async {
    if (state.selectedFriends.isEmpty || state.isSending) return;

    emit(state.copyWith(
      isSending: true,
      clearSendError: true,
    ));

    final result = await _createChallengeLinkUseCase(
      videoSlug: args.exercise.videoId,
      exerciseVersion: args.exercise.versionId,
      challengerScoreAccuracy: args.accuracyScore,
      challengerScoreTimeMs: args.durationMs,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          isSending: false,
          sendErrorMessage: failure.message,
        ));
      },
      (challengeLink) {
        emit(state.copyWith(
          isSending: false,
          createdChallengeLink: challengeLink,
        ));
      },
    );
  }
}
