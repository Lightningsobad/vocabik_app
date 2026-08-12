import '../../domain/entities/daily_streak.dart';

class DailyStreakModel extends DailyStreak {
  const DailyStreakModel({
    required super.last30Days,
  });

  factory DailyStreakModel.fromJson(dynamic json) {
    List<bool> days = List.generate(30, (_) => false);
    if (json is List) {
      if (json.isNotEmpty && json.first is bool) {
        days = json.map((e) => e == true).toList();
      } else if (json.isNotEmpty && json.first is Map) {
         days = json.map((e) => (e['completed'] == true)).toList();
      } else if (json.isNotEmpty && json.first is String) {
          days = json.map((e) => true).toList();
      }
      
      if (days.length > 30) {
        days = days.sublist(days.length - 30);
      } else while(days.length < 30) {
        days.insert(0, false);
      }
    }
    return DailyStreakModel(last30Days: days);
  }
}
