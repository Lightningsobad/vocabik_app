import 'package:equatable/equatable.dart';

class FriendEntity extends Equatable {
  final String userId;
  final String displayName;
  final String? avatarUrl;
  final String? tier;
  final String? cefrLevel;
  final DateTime? lastActive;
  final DateTime? friendedAt;
  final int? xp;
  final int? streak;

  const FriendEntity({
    required this.userId,
    required this.displayName,
    this.avatarUrl,
    this.tier,
    this.cefrLevel,
    this.lastActive,
    this.friendedAt,
    this.xp,
    this.streak,
  });

  String get initials {
    final trimmed = displayName.trim();
    if (trimmed.isEmpty) return 'U';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      final str = parts[0];
      return str.length >= 2 ? str.substring(0, 2).toUpperCase() : str.toUpperCase();
    }
    final first = parts.first.isNotEmpty ? parts.first[0] : '';
    final last = parts.last.isNotEmpty ? parts.last[0] : '';
    return '$first$last'.toUpperCase();
  }

  String get formattedStats {
    if (xp != null && streak != null) {
      return '⚡ $xp XP · 🔥 $streak days';
    } else if (xp != null) {
      return '⚡ $xp XP';
    } else if (streak != null) {
      return '🔥 $streak days';
    }

    final items = <String>[];
    if (cefrLevel != null && cefrLevel!.isNotEmpty) {
      items.add(cefrLevel!.toUpperCase());
    }
    if (tier != null && tier!.isNotEmpty) {
      items.add(tier![0].toUpperCase() + tier!.substring(1).toLowerCase());
    }
    if (items.isNotEmpty) {
      return items.join(' · ');
    }
    return '';
  }

  @override
  List<Object?> get props => [
        userId,
        displayName,
        avatarUrl,
        tier,
        cefrLevel,
        lastActive,
        friendedAt,
        xp,
        streak,
      ];
}
