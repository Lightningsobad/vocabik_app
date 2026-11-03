import '../../domain/entities/challenge_link_entity.dart';
import '../../domain/entities/friend_entity.dart';

class ChallengeSentArgs {
  final ChallengeLinkEntity challengeLink;
  final List<FriendEntity> selectedFriends;
  final String videoTitle;
  final int accuracyScore;

  const ChallengeSentArgs({
    required this.challengeLink,
    required this.selectedFriends,
    required this.videoTitle,
    required this.accuracyScore,
  });
}
