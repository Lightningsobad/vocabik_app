import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/core/network/auth_interceptor.dart';
import 'package:vocabik_app/features/auth/data/data_sources/auth_local_data_source.dart';

import 'package:vocabik_app/features/auth/data/models/user_model.dart';

class FakeAuthLocalDataSource implements AuthLocalDataSource {
  String? accessToken;
  String? refreshToken;
  UserModel? user;
  bool cleared = false;
  bool skipped = false;

  @override
  Future<void> init() async {}

  @override
  Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
    user = null;
    cleared = true;
  }

  @override
  String? getAccessToken() => accessToken;

  @override
  String? getRefreshToken() => refreshToken;

  @override
  bool isCefrSkipped() => skipped;

  @override
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }

  @override
  Future<void> saveUser(UserModel user) async {
    this.user = user;
  }

  @override
  UserModel? getUser() => user;

  @override
  Future<void> setCefrSkipped(bool value) async {
    skipped = value;
  }

  @override
  bool isLegalAccepted(String version, {String? userId}) => true;

  @override
  Future<void> setLegalAccepted(String version, {String? userId}) async {}
}

class MockHttpClientAdapter implements HttpClientAdapter {
  late ResponseBody Function(RequestOptions options) handler;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late FakeAuthLocalDataSource fakeLocalDataSource;
  late MockHttpClientAdapter mockAdapter;
  late Dio dio;
  bool sessionExpiredCalled = false;

  setUp(() {
    fakeLocalDataSource = FakeAuthLocalDataSource();
    mockAdapter = MockHttpClientAdapter();
    sessionExpiredCalled = false;

    dio = Dio(BaseOptions(baseUrl: 'https://api.vocabik.com/api/v1'));
    dio.httpClientAdapter = mockAdapter;

    dio.interceptors.add(
      AuthInterceptor(
        dio: dio,
        authLocalDataSource: fakeLocalDataSource,
        onSessionExpired: () {
          sessionExpiredCalled = true;
        },
      ),
    );
  });

  test('onRequest attaches Authorization header when token exists', () async {
    fakeLocalDataSource.accessToken = 'test_access_token';

    mockAdapter.handler = (options) {
      expect(options.headers['Authorization'], 'Bearer test_access_token');
      return ResponseBody.fromString(
        jsonEncode({'success': true}),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    };

    final response = await dio.get('/test');
    expect(response.statusCode, 200);
  });

  test('onRequest does not attach Authorization header when token is null', () async {
    fakeLocalDataSource.accessToken = null;

    mockAdapter.handler = (options) {
      expect(options.headers.containsKey('Authorization'), isFalse);
      return ResponseBody.fromString(
        jsonEncode({'success': true}),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    };

    final response = await dio.get('/test');
    expect(response.statusCode, 200);
  });

  test('onError with 401 refreshes token and retries request successfully', () async {
    fakeLocalDataSource.accessToken = 'expired_token';
    fakeLocalDataSource.refreshToken = 'valid_refresh_token';

    int callCount = 0;
    mockAdapter.handler = (options) {
      if (options.path.contains('/auth/refresh')) {
        // Verify refresh token call
        final data = options.data is Map ? options.data : jsonDecode(options.data as String);
        expect(data['refreshToken'], 'valid_refresh_token');
        return ResponseBody.fromString(
          jsonEncode({
            'userId': '123',
            'email': 'test@example.com',
            'tokens': {
              'accessToken': 'new_access_token',
              'refreshToken': 'new_refresh_token',
            },
          }),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      }

      callCount++;
      if (callCount == 1) {
        // First call fails with 401
        return ResponseBody.fromString(
          jsonEncode({'error': 'Unauthorized'}),
          401,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      } else {
        // Retry call succeeds with new token
        expect(options.headers['Authorization'], 'Bearer new_access_token');
        return ResponseBody.fromString(
          jsonEncode({'data': 'success_after_refresh'}),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      }
    };

    final response = await dio.get('/users/profile');
    expect(response.statusCode, 200);
    expect(response.data['data'], 'success_after_refresh');
    expect(fakeLocalDataSource.accessToken, 'new_access_token');
    expect(fakeLocalDataSource.refreshToken, 'new_refresh_token');
    expect(sessionExpiredCalled, isFalse);
  });

  test('onError with 401 preserves old refreshToken when backend does not return new refreshToken', () async {
    fakeLocalDataSource.accessToken = 'expired_token';
    fakeLocalDataSource.refreshToken = 'original_refresh_token';

    int callCount = 0;
    mockAdapter.handler = (options) {
      if (options.path.contains('/auth/refresh')) {
        // Backend only returns new accessToken without refreshToken
        return ResponseBody.fromString(
          jsonEncode({
            'tokens': {
              'accessToken': 'brand_new_access_token',
            },
          }),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      }

      callCount++;
      if (callCount == 1) {
        return ResponseBody.fromString(
          jsonEncode({'error': 'Unauthorized'}),
          401,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      } else {
        expect(options.headers['Authorization'], 'Bearer brand_new_access_token');
        return ResponseBody.fromString(
          jsonEncode({'data': 'success'}),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      }
    };

    final response = await dio.get('/users/profile');
    expect(response.statusCode, 200);
    expect(fakeLocalDataSource.accessToken, 'brand_new_access_token');
    // Verify old refresh token is preserved and NOT overwritten by empty string
    expect(fakeLocalDataSource.refreshToken, 'original_refresh_token');
    expect(sessionExpiredCalled, isFalse);
  });

  test('onError with 401 triggers onSessionExpired when refresh token fails with 401', () async {
    fakeLocalDataSource.accessToken = 'expired_token';
    fakeLocalDataSource.refreshToken = 'invalid_refresh_token';

    mockAdapter.handler = (options) {
      if (options.path.contains('/auth/refresh')) {
        return ResponseBody.fromString(
          jsonEncode({'error': 'Invalid refresh token'}),
          401,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      }
      return ResponseBody.fromString(
        jsonEncode({'error': 'Unauthorized'}),
        401,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    };

    expect(
      () => dio.get('/users/profile'),
      throwsA(isA<DioException>()),
    );

    await pumpEventQueue();

    expect(fakeLocalDataSource.cleared, isTrue);
    expect(sessionExpiredCalled, isTrue);
  });
}
