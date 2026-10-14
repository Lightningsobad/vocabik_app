import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

abstract class AnalyticsService {
  Future<void> logLogin({required String method});
  Future<void> logSignUp({required String method});
  Future<void> logScreenView({required String screenName, String? screenClass});
  Future<void> logSelectItem({
    required String itemId,
    required String itemName,
    String? itemCategory,
    String? itemListName,
  });
  Future<void> logViewItem({
    required String itemId,
    required String itemName,
    String? itemCategory,
  });
  Future<void> logViewItemList({
    required String itemListId,
    required String itemListName,
  });
  Future<void> logSearch({required String searchTerm});
  Future<void> logLevelStart({
    required String levelName,
    String? cefrLevel,
    String? exerciseType,
  });
  Future<void> logLevelEnd({
    required String levelName,
    required bool success,
    int? score,
    int? durationSeconds,
  });
  Future<void> logPostScore({
    required int score,
    int? level,
    String? character,
  });
  Future<void> logUnlockAchievement({required String achievementId});
  Future<void> logEarnVirtualCurrency({
    required String virtualCurrencyName,
    required num value,
  });
  Future<void> logShare({
    required String contentType,
    required String itemId,
    required String method,
  });
  Future<void> logSelectContent({
    required String contentType,
    required String itemId,
  });

  // Custom Vocabik Events
  Future<void> logDailyChallengeComplete({
    required String challengeId,
    required String date,
    required int score,
    int? streakCount,
  });
  Future<void> logHintUsed({
    required String exerciseId,
    required String hintType,
    int? remainingHints,
  });
  Future<void> logVideoPlayMilestone({
    required String videoId,
    required int milestonePercent,
    int? durationSeconds,
  });
  Future<void> logNotebookWordSaved({
    required String word,
    String? cefrLevel,
  });
  Future<void> logCustomEvent(
    String name, [
    Map<String, Object>? parameters,
  ]);

  // User Identity & Properties
  Future<void> setUserId(String? userId);
  Future<void> setUserProperty({
    required String name,
    required String? value,
  });
  Future<void> resetAnalyticsData();

  NavigatorObserver getNavigatorObserver();
}

class FirebaseAnalyticsServiceImpl implements AnalyticsService {
  final FirebaseAnalytics? _providedAnalytics;

  FirebaseAnalyticsServiceImpl({FirebaseAnalytics? analytics})
      : _providedAnalytics = analytics;

  FirebaseAnalytics? get _analytics {
    if (_providedAnalytics != null) return _providedAnalytics;
    try {
      if (Firebase.apps.isNotEmpty) {
        return FirebaseAnalytics.instance;
      }
    } catch (e) {
      _logDebug('FirebaseAnalytics not available: $e');
    }
    return null;
  }

  void _logDebug(String message) {
    if (kDebugMode) {
      debugPrint('[Analytics] $message');
    }
  }

  @override
  Future<void> logLogin({required String method}) async {
    _logDebug('login(method: $method)');
    try {
      await _analytics?.logLogin(loginMethod: method);
    } catch (e) {
      _logDebug('logLogin error: $e');
    }
  }

  @override
  Future<void> logSignUp({required String method}) async {
    _logDebug('sign_up(method: $method)');
    try {
      await _analytics?.logSignUp(signUpMethod: method);
    } catch (e) {
      _logDebug('logSignUp error: $e');
    }
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    _logDebug('screen_view(screenName: $screenName, screenClass: $screenClass)');
    try {
      await _analytics?.logScreenView(
        screenName: screenName,
        screenClass: screenClass ?? screenName,
      );
    } catch (e) {
      _logDebug('logScreenView error: $e');
    }
  }

  @override
  Future<void> logSelectItem({
    required String itemId,
    required String itemName,
    String? itemCategory,
    String? itemListName,
  }) async {
    _logDebug(
      'select_item(itemId: $itemId, itemName: $itemName, category: $itemCategory, list: $itemListName)',
    );
    try {
      await _analytics?.logSelectItem(
        itemListName: itemListName,
        items: [
          AnalyticsEventItem(
            itemId: itemId,
            itemName: itemName,
            itemCategory: itemCategory,
          ),
        ],
      );
    } catch (e) {
      _logDebug('logSelectItem error: $e');
    }
  }

  @override
  Future<void> logViewItem({
    required String itemId,
    required String itemName,
    String? itemCategory,
  }) async {
    _logDebug('view_item(itemId: $itemId, itemName: $itemName, category: $itemCategory)');
    try {
      await _analytics?.logViewItem(
        items: [
          AnalyticsEventItem(
            itemId: itemId,
            itemName: itemName,
            itemCategory: itemCategory,
          ),
        ],
      );
    } catch (e) {
      _logDebug('logViewItem error: $e');
    }
  }

  @override
  Future<void> logViewItemList({
    required String itemListId,
    required String itemListName,
  }) async {
    _logDebug('view_item_list(id: $itemListId, name: $itemListName)');
    try {
      await _analytics?.logViewItemList(
        itemListId: itemListId,
        itemListName: itemListName,
      );
    } catch (e) {
      _logDebug('logViewItemList error: $e');
    }
  }

  @override
  Future<void> logSearch({required String searchTerm}) async {
    _logDebug('search(term: $searchTerm)');
    try {
      await _analytics?.logSearch(searchTerm: searchTerm);
    } catch (e) {
      _logDebug('logSearch error: $e');
    }
  }

  @override
  Future<void> logLevelStart({
    required String levelName,
    String? cefrLevel,
    String? exerciseType,
  }) async {
    _logDebug('level_start(name: $levelName, cefr: $cefrLevel, type: $exerciseType)');
    try {
      await _analytics?.logEvent(
        name: 'level_start',
        parameters: {
          'level_name': levelName,
          'cefr_level': ?cefrLevel,
          'exercise_type': ?exerciseType,
        },
      );
    } catch (e) {
      _logDebug('logLevelStart error: $e');
    }
  }

  @override
  Future<void> logLevelEnd({
    required String levelName,
    required bool success,
    int? score,
    int? durationSeconds,
  }) async {
    _logDebug(
      'level_end(name: $levelName, success: $success, score: $score, duration: $durationSeconds)',
    );
    try {
      await _analytics?.logEvent(
        name: 'level_end',
        parameters: {
          'level_name': levelName,
          'success': success ? 1 : 0,
          'score': ?score,
          'duration_seconds': ?durationSeconds,
        },
      );
    } catch (e) {
      _logDebug('logLevelEnd error: $e');
    }
  }

  @override
  Future<void> logPostScore({
    required int score,
    int? level,
    String? character,
  }) async {
    _logDebug('post_score(score: $score, level: $level, character: $character)');
    try {
      await _analytics?.logPostScore(
        score: score,
        level: level,
        character: character,
      );
    } catch (e) {
      _logDebug('logPostScore error: $e');
    }
  }

  @override
  Future<void> logUnlockAchievement({required String achievementId}) async {
    _logDebug('unlock_achievement(id: $achievementId)');
    try {
      await _analytics?.logUnlockAchievement(id: achievementId);
    } catch (e) {
      _logDebug('logUnlockAchievement error: $e');
    }
  }

  @override
  Future<void> logEarnVirtualCurrency({
    required String virtualCurrencyName,
    required num value,
  }) async {
    _logDebug('earn_virtual_currency(name: $virtualCurrencyName, value: $value)');
    try {
      await _analytics?.logEarnVirtualCurrency(
        virtualCurrencyName: virtualCurrencyName,
        value: value,
      );
    } catch (e) {
      _logDebug('logEarnVirtualCurrency error: $e');
    }
  }

  @override
  Future<void> logShare({
    required String contentType,
    required String itemId,
    required String method,
  }) async {
    _logDebug('share(contentType: $contentType, itemId: $itemId, method: $method)');
    try {
      await _analytics?.logShare(
        contentType: contentType,
        itemId: itemId,
        method: method,
      );
    } catch (e) {
      _logDebug('logShare error: $e');
    }
  }

  @override
  Future<void> logSelectContent({
    required String contentType,
    required String itemId,
  }) async {
    _logDebug('select_content(contentType: $contentType, itemId: $itemId)');
    try {
      await _analytics?.logSelectContent(
        contentType: contentType,
        itemId: itemId,
      );
    } catch (e) {
      _logDebug('logSelectContent error: $e');
    }
  }

  @override
  Future<void> logDailyChallengeComplete({
    required String challengeId,
    required String date,
    required int score,
    int? streakCount,
  }) async {
    _logDebug(
      'daily_challenge_complete(id: $challengeId, date: $date, score: $score, streak: $streakCount)',
    );
    try {
      await _analytics?.logEvent(
        name: 'daily_challenge_complete',
        parameters: {
          'challenge_id': challengeId,
          'date': date,
          'score': score,
          'streak_count': ?streakCount,
        },
      );
    } catch (e) {
      _logDebug('logDailyChallengeComplete error: $e');
    }
  }

  @override
  Future<void> logHintUsed({
    required String exerciseId,
    required String hintType,
    int? remainingHints,
  }) async {
    _logDebug(
      'hint_used(exerciseId: $exerciseId, hintType: $hintType, remaining: $remainingHints)',
    );
    try {
      await _analytics?.logEvent(
        name: 'hint_used',
        parameters: {
          'exercise_id': exerciseId,
          'hint_type': hintType,
          'remaining_hints': ?remainingHints,
        },
      );
    } catch (e) {
      _logDebug('logHintUsed error: $e');
    }
  }

  @override
  Future<void> logVideoPlayMilestone({
    required String videoId,
    required int milestonePercent,
    int? durationSeconds,
  }) async {
    _logDebug(
      'video_play_milestone(videoId: $videoId, milestone: $milestonePercent%, duration: $durationSeconds)',
    );
    try {
      await _analytics?.logEvent(
        name: 'video_play_milestone',
        parameters: {
          'video_id': videoId,
          'milestone_percent': milestonePercent,
          'duration_seconds': ?durationSeconds,
        },
      );
    } catch (e) {
      _logDebug('logVideoPlayMilestone error: $e');
    }
  }

  @override
  Future<void> logNotebookWordSaved({
    required String word,
    String? cefrLevel,
  }) async {
    _logDebug('notebook_word_saved(word: $word, cefr: $cefrLevel)');
    try {
      await _analytics?.logEvent(
        name: 'notebook_word_saved',
        parameters: {
          'word': word,
          'cefr_level': ?cefrLevel,
        },
      );
    } catch (e) {
      _logDebug('logNotebookWordSaved error: $e');
    }
  }

  @override
  Future<void> logCustomEvent(
    String name, [
    Map<String, Object>? parameters,
  ]) async {
    _logDebug('custom_event($name, params: $parameters)');
    try {
      await _analytics?.logEvent(name: name, parameters: parameters);
    } catch (e) {
      _logDebug('logCustomEvent error: $e');
    }
  }

  @override
  Future<void> setUserId(String? userId) async {
    _logDebug('setUserId: [REDACTED]');
    try {
      await _analytics?.setUserId(id: userId);
    } catch (e) {
      _logDebug('setUserId error: $e');
    }
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    _logDebug('setUserProperty($name)');
    try {
      await _analytics?.setUserProperty(name: name, value: value);
    } catch (e) {
      _logDebug('setUserProperty error: $e');
    }
  }

  @override
  Future<void> resetAnalyticsData() async {
    _logDebug('resetAnalyticsData()');
    try {
      await _analytics?.resetAnalyticsData();
    } catch (e) {
      _logDebug('resetAnalyticsData error: $e');
    }
  }

  @override
  NavigatorObserver getNavigatorObserver() {
    final analytics = _analytics;
    if (analytics != null) {
      return FirebaseAnalyticsObserver(analytics: analytics);
    }
    return NavigatorObserver();
  }
}
