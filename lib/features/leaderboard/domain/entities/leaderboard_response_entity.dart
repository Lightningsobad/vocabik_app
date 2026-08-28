import 'package:equatable/equatable.dart';
import 'leaderboard_entry_entity.dart';

class LeaderboardResponseEntity extends Equatable {
  final String period;
  final String scope;
  final String? nextResetAt;
  final List<LeaderboardEntryEntity> entries;
  final LeaderboardEntryEntity? ownRank;
  final List<LeaderboardEntryEntity>? surrounding;
  final int? totalParticipants;

  const LeaderboardResponseEntity({
    required this.period,
    required this.scope,
    this.nextResetAt,
    required this.entries,
    this.ownRank,
    this.surrounding,
    this.totalParticipants,
  });

  @override
  List<Object?> get props => [
        period,
        scope,
        nextResetAt,
        entries,
        ownRank,
        surrounding,
        totalParticipants,
      ];
}
