import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/core/services/analytics_service.dart';

class FakeFirebaseAnalytics implements FirebaseAnalytics {
  final List<String> recordedEvents = [];
  final Map<String, Object?> recordedParams = {};
  String? userId;
  final Map<String, String?> userProperties = {};
  bool resetCalled = false;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    final name = invocation.memberName.toString();

    if (name.contains('logLogin')) {
      recordedEvents.add('login');
      recordedParams['method'] = invocation.namedArguments[#loginMethod];
      return Future<void>.value();
    }
    if (name.contains('logSignUp')) {
      recordedEvents.add('sign_up');
      recordedParams['method'] = invocation.namedArguments[#signUpMethod];
      return Future<void>.value();
    }
    if (name.contains('logScreenView')) {
      recordedEvents.add('screen_view');
      recordedParams['screen_name'] = invocation.namedArguments[#screenName];
      return Future<void>.value();
    }
    if (name.contains('logSelectItem')) {
      recordedEvents.add('select_item');
      recordedParams['item_list_name'] = invocation.namedArguments[#itemListName];
      recordedParams['items'] = invocation.namedArguments[#items];
      return Future<void>.value();
    }
    if (name.contains('logViewItemList')) {
      recordedEvents.add('view_item_list');
      recordedParams['item_list_id'] = invocation.namedArguments[#itemListId];
      recordedParams['item_list_name'] = invocation.namedArguments[#itemListName];
      return Future<void>.value();
    }
    if (name.contains('logViewItem')) {
      recordedEvents.add('view_item');
      recordedParams['items'] = invocation.namedArguments[#items];
      return Future<void>.value();
    }
    if (name.contains('logSearch')) {
      recordedEvents.add('search');
      recordedParams['search_term'] = invocation.namedArguments[#searchTerm];
      return Future<void>.value();
    }
    if (name.contains('logBeginCheckout')) {
      recordedEvents.add('begin_checkout');
      recordedParams['value'] = invocation.namedArguments[#value];
      recordedParams['currency'] = invocation.namedArguments[#currency];
      return Future<void>.value();
    }
    if (name.contains('logPurchase')) {
      recordedEvents.add('purchase');
      recordedParams['transaction_id'] = invocation.namedArguments[#transactionId];
      recordedParams['value'] = invocation.namedArguments[#value];
      recordedParams['currency'] = invocation.namedArguments[#currency];
      return Future<void>.value();
    }
    if (name.contains('logPostScore')) {
      recordedEvents.add('post_score');
      recordedParams['score'] = invocation.namedArguments[#score];
      return Future<void>.value();
    }
    if (name.contains('logUnlockAchievement')) {
      recordedEvents.add('unlock_achievement');
      recordedParams['achievement_id'] = invocation.namedArguments[#id];
      return Future<void>.value();
    }
    if (name.contains('logEarnVirtualCurrency')) {
      recordedEvents.add('earn_virtual_currency');
      recordedParams['virtual_currency_name'] = invocation.namedArguments[#virtualCurrencyName];
      recordedParams['value'] = invocation.namedArguments[#value];
      return Future<void>.value();
    }
    if (name.contains('logShare')) {
      recordedEvents.add('share');
      recordedParams['content_type'] = invocation.namedArguments[#contentType];
      recordedParams['item_id'] = invocation.namedArguments[#itemId];
      recordedParams['method'] = invocation.namedArguments[#method];
      return Future<void>.value();
    }
    if (name.contains('logSelectContent')) {
      recordedEvents.add('select_content');
      recordedParams['content_type'] = invocation.namedArguments[#contentType];
      recordedParams['item_id'] = invocation.namedArguments[#itemId];
      return Future<void>.value();
    }
    if (name.contains('logEvent')) {
      final eventName = invocation.namedArguments[#name] as String;
      recordedEvents.add(eventName);
      final params = invocation.namedArguments[#parameters] as Map<String, Object?>?;
      if (params != null) {
        recordedParams.addAll(params);
      }
      return Future<void>.value();
    }
    if (name.contains('setUserId')) {
      userId = invocation.namedArguments[#id] as String?;
      return Future<void>.value();
    }
    if (name.contains('setUserProperty')) {
      final propName = invocation.namedArguments[#name] as String;
      final propVal = invocation.namedArguments[#value] as String?;
      userProperties[propName] = propVal;
      return Future<void>.value();
    }
    if (name.contains('resetAnalyticsData')) {
      resetCalled = true;
      userId = null;
      userProperties.clear();
      return Future<void>.value();
    }
    return Future<void>.value();
  }
}

void main() {
  late FakeFirebaseAnalytics fakeAnalytics;
  late AnalyticsService service;

  setUp(() {
    fakeAnalytics = FakeFirebaseAnalytics();
    service = FirebaseAnalyticsServiceImpl(analytics: fakeAnalytics);
  });

  group('AnalyticsService Standard Events', () {
    test('logLogin calls analytics logLogin', () async {
      await service.logLogin(method: 'google');
      expect(fakeAnalytics.recordedEvents, contains('login'));
      expect(fakeAnalytics.recordedParams['method'], equals('google'));
    });

    test('logSignUp calls analytics logSignUp', () async {
      await service.logSignUp(method: 'email');
      expect(fakeAnalytics.recordedEvents, contains('sign_up'));
      expect(fakeAnalytics.recordedParams['method'], equals('email'));
    });

    test('logScreenView logs screen_view', () async {
      await service.logScreenView(
        screenName: 'HomeScreen',
        screenClass: 'HomeScreenWidget',
      );
      expect(fakeAnalytics.recordedEvents, contains('screen_view'));
      expect(fakeAnalytics.recordedParams['screen_name'], equals('HomeScreen'));
    });

    test('logSelectItem logs select_item with item details', () async {
      await service.logSelectItem(
        itemId: 'vid_123',
        itemName: 'Lesson 1',
        itemCategory: 'Grammar',
        itemListName: 'home_feed',
      );
      expect(fakeAnalytics.recordedEvents, contains('select_item'));
      expect(fakeAnalytics.recordedParams['item_list_name'], equals('home_feed'));
    });

    test('logViewItem logs view_item', () async {
      await service.logViewItem(
        itemId: 'vid_123',
        itemName: 'Lesson 1',
        itemCategory: 'Grammar',
      );
      expect(fakeAnalytics.recordedEvents, contains('view_item'));
    });

    test('logViewItemList logs view_item_list', () async {
      await service.logViewItemList(
        itemListId: 'cat_travel',
        itemListName: 'Travel English',
      );
      expect(fakeAnalytics.recordedEvents, contains('view_item_list'));
      expect(
        fakeAnalytics.recordedParams['item_list_id'],
        equals('cat_travel'),
      );
    });

    test('logSearch logs search term', () async {
      await service.logSearch(searchTerm: 'business');
      expect(fakeAnalytics.recordedEvents, contains('search'));
      expect(fakeAnalytics.recordedParams['search_term'], equals('business'));
    });

    test('logBeginCheckout logs begin_checkout', () async {
      await service.logBeginCheckout(
        packageId: 'yearly_sub',
        value: 49.99,
        currency: 'USD',
      );
      expect(fakeAnalytics.recordedEvents, contains('begin_checkout'));
      expect(fakeAnalytics.recordedParams['value'], equals(49.99));
      expect(fakeAnalytics.recordedParams['currency'], equals('USD'));
    });

    test('logPurchase logs purchase event', () async {
      await service.logPurchase(
        transactionId: 'tx_999',
        packageId: 'yearly_sub',
        value: 49.99,
        currency: 'USD',
      );
      expect(fakeAnalytics.recordedEvents, contains('purchase'));
      expect(fakeAnalytics.recordedParams['transaction_id'], equals('tx_999'));
    });

    test('logLevelStart and logLevelEnd log level events', () async {
      await service.logLevelStart(
        levelName: 'Exercise 1',
        cefrLevel: 'B1',
        exerciseType: 'shadowing',
      );
      expect(fakeAnalytics.recordedEvents, contains('level_start'));
      expect(fakeAnalytics.recordedParams['level_name'], equals('Exercise 1'));
      expect(fakeAnalytics.recordedParams['cefr_level'], equals('B1'));

      await service.logLevelEnd(
        levelName: 'Exercise 1',
        success: true,
        score: 95,
        durationSeconds: 120,
      );
      expect(fakeAnalytics.recordedEvents, contains('level_end'));
      expect(fakeAnalytics.recordedParams['success'], equals(1));
      expect(fakeAnalytics.recordedParams['score'], equals(95));
      expect(fakeAnalytics.recordedParams['duration_seconds'], equals(120));
    });

    test('logPostScore, logUnlockAchievement, logEarnVirtualCurrency', () async {
      await service.logPostScore(score: 100, level: 2, character: 'vid_1');
      expect(fakeAnalytics.recordedEvents, contains('post_score'));
      expect(fakeAnalytics.recordedParams['score'], equals(100));

      await service.logUnlockAchievement(achievementId: 'streak_7');
      expect(fakeAnalytics.recordedEvents, contains('unlock_achievement'));
      expect(fakeAnalytics.recordedParams['achievement_id'], equals('streak_7'));

      await service.logEarnVirtualCurrency(
        virtualCurrencyName: 'xp',
        value: 50,
      );
      expect(fakeAnalytics.recordedEvents, contains('earn_virtual_currency'));
      expect(fakeAnalytics.recordedParams['value'], equals(50));
    });

    test('logShare and logSelectContent', () async {
      await service.logShare(
        contentType: 'score_card',
        itemId: 'score_123',
        method: 'system_share',
      );
      expect(fakeAnalytics.recordedEvents, contains('share'));

      await service.logSelectContent(
        contentType: 'cefr_filter',
        itemId: 'B2',
      );
      expect(fakeAnalytics.recordedEvents, contains('select_content'));
    });
  });

  group('AnalyticsService Custom Events', () {
    test('logDailyChallengeComplete logs custom daily challenge', () async {
      await service.logDailyChallengeComplete(
        challengeId: 'daily_2026_09_27',
        date: '2026-09-27',
        score: 90,
        streakCount: 5,
      );
      expect(fakeAnalytics.recordedEvents, contains('daily_challenge_complete'));
      expect(
        fakeAnalytics.recordedParams['challenge_id'],
        equals('daily_2026_09_27'),
      );
      expect(fakeAnalytics.recordedParams['streak_count'], equals(5));
    });

    test('logHintUsed logs hint usage', () async {
      await service.logHintUsed(
        exerciseId: 'ex_1',
        hintType: 'translation',
        remainingHints: 2,
      );
      expect(fakeAnalytics.recordedEvents, contains('hint_used'));
      expect(fakeAnalytics.recordedParams['hint_type'], equals('translation'));
      expect(fakeAnalytics.recordedParams['remaining_hints'], equals(2));
    });

    test('logVideoPlayMilestone logs milestone progress', () async {
      await service.logVideoPlayMilestone(
        videoId: 'vid_456',
        milestonePercent: 50,
        durationSeconds: 180,
      );
      expect(fakeAnalytics.recordedEvents, contains('video_play_milestone'));
      expect(fakeAnalytics.recordedParams['milestone_percent'], equals(50));
    });

    test('logClassroomJoined logs classroom joining', () async {
      await service.logClassroomJoined(
        classroomId: 'cls_10',
        classroomName: 'IELTS Master',
      );
      expect(fakeAnalytics.recordedEvents, contains('classroom_joined'));
      expect(
        fakeAnalytics.recordedParams['classroom_name'],
        equals('IELTS Master'),
      );
    });

    test('logNotebookWordSaved logs word saving', () async {
      await service.logNotebookWordSaved(
        word: 'serendipity',
        cefrLevel: 'C1',
      );
      expect(fakeAnalytics.recordedEvents, contains('notebook_word_saved'));
      expect(fakeAnalytics.recordedParams['word'], equals('serendipity'));
    });
  });

  group('AnalyticsService User Identity & Properties', () {
    test('setUserId sets user identifier', () async {
      await service.setUserId('usr_12345');
      expect(fakeAnalytics.userId, equals('usr_12345'));
    });

    test('setUserProperty stores user properties', () async {
      await service.setUserProperty(name: 'user_tier', value: 'premium');
      await service.setUserProperty(name: 'cefr_level', value: 'B2');
      expect(fakeAnalytics.userProperties['user_tier'], equals('premium'));
      expect(fakeAnalytics.userProperties['cefr_level'], equals('B2'));
    });

    test('resetAnalyticsData clears identity and properties', () async {
      await service.setUserId('usr_12345');
      await service.setUserProperty(name: 'user_tier', value: 'premium');

      await service.resetAnalyticsData();
      expect(fakeAnalytics.resetCalled, isTrue);
      expect(fakeAnalytics.userId, isNull);
      expect(fakeAnalytics.userProperties, isEmpty);
    });

    test('getNavigatorObserver returns a NavigatorObserver', () {
      final observer = service.getNavigatorObserver();
      expect(observer, isA<NavigatorObserver>());
    });
  });
}
