import 'package:equatable/equatable.dart';

class DailyStreak extends Equatable {
  final List<bool> last30Days; // true if active, false if inactive/missed

  const DailyStreak({
    required this.last30Days,
  });

  @override
  List<Object?> get props => [last30Days];
}
