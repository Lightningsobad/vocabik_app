import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocabik_app/shared/data/models/video_category_model.dart';

abstract class SharedVideoLocalDataSource {
  List<VideoCategoryModel>? getCachedCategories();
  DateTime? getCategoriesCachedAt();
  Future<void> saveCategories(
    List<VideoCategoryModel> categories,
    DateTime cachedAt,
  );
}

@LazySingleton(as: SharedVideoLocalDataSource)
class SharedVideoLocalDataSourceImpl implements SharedVideoLocalDataSource {
  final SharedPreferences _prefs;

  static const String _categoriesKey = 'cached_video_categories_v1';
  static const String _cachedAtKey = 'cached_video_categories_at_v1';

  SharedVideoLocalDataSourceImpl(this._prefs);

  @override
  List<VideoCategoryModel>? getCachedCategories() {
    final raw = _prefs.getString(_categoriesKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return null;
      final models = decoded
          .whereType<Map>()
          .map(
            (item) =>
                VideoCategoryModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .where((model) => model.slug.isNotEmpty)
          .toList();
      models.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      return models;
    } catch (_) {
      return null;
    }
  }

  @override
  DateTime? getCategoriesCachedAt() {
    final millis = _prefs.getInt(_cachedAtKey);
    if (millis == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  @override
  Future<void> saveCategories(
    List<VideoCategoryModel> categories,
    DateTime cachedAt,
  ) async {
    final encoded = jsonEncode(categories.map((c) => c.toJson()).toList());
    await _prefs.setString(_categoriesKey, encoded);
    await _prefs.setInt(_cachedAtKey, cachedAt.millisecondsSinceEpoch);
  }
}
