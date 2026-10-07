import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/core/services/app_bloc_observer.dart';
import 'package:vocabik_app/core/services/crashlytics_service.dart';

class FakeFirebaseCrashlytics extends Fake implements FirebaseCrashlytics {
  bool collectionEnabled = false;
  String? userId;
  final Map<String, Object> customKeys = {};
  final List<String> logs = [];
  final List<dynamic> recordedErrors = [];

  @override
  Future<void> setCrashlyticsCollectionEnabled(bool enabled) async {
    collectionEnabled = enabled;
  }

  @override
  Future<void> setUserIdentifier(String identifier) async {
    userId = identifier;
  }

  @override
  Future<void> setCustomKey(String key, Object value) async {
    customKeys[key] = value;
  }

  @override
  Future<void> log(String message) async {
    logs.add(message);
  }

  @override
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    Iterable<Object> information = const [],
    bool fatal = false,
    bool? printDetails,
  }) async {
    recordedErrors.add({
      'exception': exception,
      'stack': stack,
      'reason': reason,
      'fatal': fatal,
    });
  }

  @override
  Future<void> recordFlutterFatalError(
    FlutterErrorDetails flutterErrorDetails, {
    bool fatal = true,
  }) async {
    recordedErrors.add({
      'exception': flutterErrorDetails.exception,
      'stack': flutterErrorDetails.stack,
      'fatal': fatal,
    });
  }
}

class TestCubit extends Cubit<int> {
  TestCubit() : super(0);

  void triggerError() {
    addError(Exception('Test error inside cubit'), StackTrace.current);
  }
}

void main() {
  late FakeFirebaseCrashlytics fakeCrashlytics;
  late CrashlyticsService service;

  setUp(() {
    fakeCrashlytics = FakeFirebaseCrashlytics();
    service = FirebaseCrashlyticsServiceImpl(crashlytics: fakeCrashlytics);
  });

  group('CrashlyticsService', () {
    test('init configures collection', () async {
      await service.init();
      // In tests, kDebugMode is true, so shouldCollect is false
      expect(fakeCrashlytics.collectionEnabled, isFalse);
    });

    test('recordError captures exception and metadata', () async {
      final error = Exception('Network timeout');
      final stack = StackTrace.current;
      await service.recordError(
        error,
        stack,
        reason: 'HTTP request failed',
        fatal: false,
      );

      expect(fakeCrashlytics.recordedErrors.length, equals(1));
      final record = fakeCrashlytics.recordedErrors.first as Map<String, dynamic>;
      expect(record['exception'], equals(error));
      expect(record['reason'], equals('HTTP request failed'));
      expect(record['fatal'], isFalse);
    });

    test('recordFlutterFatalError records fatal framework error', () async {
      final details = FlutterErrorDetails(
        exception: Exception('RenderFlex overflowed'),
        stack: StackTrace.current,
      );
      await service.recordFlutterFatalError(details);

      expect(fakeCrashlytics.recordedErrors.length, equals(1));
      final record = fakeCrashlytics.recordedErrors.first as Map<String, dynamic>;
      expect(record['fatal'], isTrue);
    });

    test('setUserId, setCustomKey, log, setCrashlyticsCollectionEnabled', () async {
      await service.setUserId('usr_999');
      expect(fakeCrashlytics.userId, equals('usr_999'));

      await service.setCustomKey('user_tier', 'standard');
      await service.setCustomKey('cefr_level', 'B2');
      expect(fakeCrashlytics.customKeys['user_tier'], equals('standard'));
      expect(fakeCrashlytics.customKeys['cefr_level'], equals('B2'));

      await service.log('User entered HomeScreen');
      expect(fakeCrashlytics.logs, contains('User entered HomeScreen'));

      await service.setCrashlyticsCollectionEnabled(true);
      expect(fakeCrashlytics.collectionEnabled, isTrue);
    });
  });

  group('AppBlocObserver', () {
    test('forwards bloc errors to CrashlyticsService', () {
      final observer = AppBlocObserver(service);
      Bloc.observer = observer;

      final cubit = TestCubit();
      cubit.triggerError();

      expect(fakeCrashlytics.recordedErrors.isNotEmpty, isTrue);
      final record = fakeCrashlytics.recordedErrors.first as Map<String, dynamic>;
      expect(record['reason'], contains('TestCubit'));

      cubit.close();
    });
  });
}
