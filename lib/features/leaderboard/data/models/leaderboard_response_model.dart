import '../../domain/entities/leaderboard_response_entity.dart';
import 'leaderboard_entry_model.dart';

class LeaderboardResponseModel extends LeaderboardResponseEntity {
  const LeaderboardResponseModel({
    required super.period,
    required super.scope,
    super.nextResetAt,
    required List<LeaderboardEntryModel> super.entries,
    LeaderboardEntryModel? super.ownRank,
    List<LeaderboardEntryModel>? super.surrounding,
    super.totalParticipants,
  });

  factory LeaderboardResponseModel.fromJson(
    Map<String, dynamic> json, {
    String? currentUserId,
  }) {
    final period = json['period'] as String? ?? 'this_week';
    final scope = json['scope'] as String? ?? 'global';
    final nextResetAt = json['nextResetAt'] as String?;

    LeaderboardEntryModel? ownRankModel;
    if (json['ownRank'] != null && json['ownRank'] is Map<String, dynamic>) {
      ownRankModel = LeaderboardEntryModel.fromJson(
        json['ownRank'] as Map<String, dynamic>,
        currentUserId: currentUserId,
      ).copyWith(isCurrentUser: true);
    }

    final effectiveCurrentUserId = ownRankModel?.userId ?? currentUserId;

    final rawEntries = json['entries'] as List<dynamic>? ?? [];
    final entries = rawEntries.map((e) {
      if (e is Map<String, dynamic>) {
        return LeaderboardEntryModel.fromJson(e, currentUserId: effectiveCurrentUserId);
      }
      return const LeaderboardEntryModel(
        rank: 0,
        userId: '',
        displayName: 'User',
        xp: 0,
      );
    }).toList();

    List<LeaderboardEntryModel>? surrounding;
    if (json['surrounding'] != null && json['surrounding'] is List) {
      final rawSurrounding = json['surrounding'] as List<dynamic>;
      surrounding = rawSurrounding.map((e) {
        if (e is Map<String, dynamic>) {
          return LeaderboardEntryModel.fromJson(e, currentUserId: effectiveCurrentUserId);
        }
        return const LeaderboardEntryModel(
          rank: 0,
          userId: '',
          displayName: 'User',
          xp: 0,
        );
      }).toList();
    }

    final totalParticipants = json['totalParticipants'] as int? ??
        (json['ownRank'] is Map<String, dynamic>
            ? (json['ownRank'] as Map<String, dynamic>)['totalParticipants'] as int?
            : null);

    return LeaderboardResponseModel(
      period: period,
      scope: scope,
      nextResetAt: nextResetAt,
      entries: entries,
      ownRank: ownRankModel,
      surrounding: surrounding,
      totalParticipants: totalParticipants,
    );
  }
}
