import 'package:equatable/equatable.dart';
import '../../domain/entities/challenge_link_entity.dart';
import '../../domain/entities/friend_entity.dart';

enum ChallengeFriendStatus { initial, loading, success, error }

class ChallengeFriendState extends Equatable {
  final ChallengeFriendStatus status;
  final List<FriendEntity> friends;
  final String searchQuery;
  final Set<FriendEntity> selectedFriends;
  final bool isSending;
  final ChallengeLinkEntity? createdChallengeLink;
  final String? errorMessage;
  final String? sendErrorMessage;

  const ChallengeFriendState({
    this.status = ChallengeFriendStatus.initial,
    this.friends = const [],
    this.searchQuery = '',
    this.selectedFriends = const {},
    this.isSending = false,
    this.createdChallengeLink,
    this.errorMessage,
    this.sendErrorMessage,
  });

  List<FriendEntity> get filteredFriends {
    if (searchQuery.trim().isEmpty) return friends;
    final query = searchQuery.toLowerCase().trim();
    return friends.where((friend) {
      return friend.displayName.toLowerCase().contains(query);
    }).toList();
  }

  ChallengeFriendState copyWith({
    ChallengeFriendStatus? status,
    List<FriendEntity>? friends,
    String? searchQuery,
    Set<FriendEntity>? selectedFriends,
    bool? isSending,
    ChallengeLinkEntity? createdChallengeLink,
    String? errorMessage,
    String? sendErrorMessage,
    bool clearSendError = false,
  }) {
    return ChallengeFriendState(
      status: status ?? this.status,
      friends: friends ?? this.friends,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFriends: selectedFriends ?? this.selectedFriends,
      isSending: isSending ?? this.isSending,
      createdChallengeLink: createdChallengeLink ?? this.createdChallengeLink,
      errorMessage: errorMessage ?? this.errorMessage,
      sendErrorMessage: clearSendError ? null : (sendErrorMessage ?? this.sendErrorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        friends,
        searchQuery,
        selectedFriends,
        isSending,
        createdChallengeLink,
        errorMessage,
        sendErrorMessage,
      ];
}
