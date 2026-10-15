import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/core/errors/exceptions.dart';
import 'package:vocabik_app/features/moderation/data/datasources/moderation_remote_data_source.dart';
import 'package:vocabik_app/features/moderation/data/models/report_request_model.dart';

void main() {
  late Dio dio;
  late ModerationRemoteDataSourceImpl dataSource;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://api.vocabik.com/api/v1'));
    dataSource = ModerationRemoteDataSourceImpl(dio);
  });

  group('submitReport', () {
    test('sends POST /reports and parses success response', () async {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            expect(options.path, '/reports');
            expect(options.data['targetType'], 'user');
            expect(options.data['targetId'], 'u-1');
            expect(options.data['reason'], 'spam');
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 201,
                data: {
                  'success': true,
                  'reportId': 'rep-1',
                  'message': 'Report received',
                },
              ),
            );
          },
        ),
      );

      final result = await dataSource.submitReport(
        const ReportRequestModel(
          targetType: 'user',
          targetId: 'u-1',
          reason: 'spam',
        ),
      );

      expect(result.success, true);
      expect(result.reportId, 'rep-1');
      expect(result.message, 'Report received');
    });

    test('throws ServerException on CANNOT_REPORT_SELF', () async {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.reject(
              DioException(
                requestOptions: options,
                response: Response(
                  requestOptions: options,
                  statusCode: 400,
                  data: {'message': 'CANNOT_REPORT_SELF'},
                ),
              ),
            );
          },
        ),
      );

      expect(
        () => dataSource.submitReport(
          const ReportRequestModel(
            targetType: 'user',
            targetId: 'me',
            reason: 'spam',
          ),
        ),
        throwsA(
          isA<ServerException>().having(
            (e) => e.message,
            'message',
            'Bạn không thể tự báo cáo chính mình.',
          ),
        ),
      );
    });
  });

  group('blockUser', () {
    test('sends POST /users/:id/block and returns success', () async {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            expect(options.path, '/users/u-2/block');
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'success': true,
                  'targetUserId': 'u-2',
                  'message': 'Đã chặn',
                },
              ),
            );
          },
        ),
      );

      final result = await dataSource.blockUser('u-2');

      expect(result.success, true);
      expect(result.targetUserId, 'u-2');
    });

    test('throws ServerException on CANNOT_BLOCK_SELF', () async {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.reject(
              DioException(
                requestOptions: options,
                response: Response(
                  requestOptions: options,
                  statusCode: 400,
                  data: {'message': 'CANNOT_BLOCK_SELF'},
                ),
              ),
            );
          },
        ),
      );

      expect(
        () => dataSource.blockUser('me'),
        throwsA(
          isA<ServerException>().having(
            (e) => e.message,
            'message',
            'Bạn không thể tự chặn chính mình.',
          ),
        ),
      );
    });
  });

  group('unblockUser', () {
    test('sends DELETE /users/:id/block and returns success', () async {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            expect(options.path, '/users/u-3/block');
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'success': true,
                  'targetUserId': 'u-3',
                  'message': 'Đã bỏ chặn',
                },
              ),
            );
          },
        ),
      );

      final result = await dataSource.unblockUser('u-3');

      expect(result.success, true);
      expect(result.targetUserId, 'u-3');
    });
  });

  group('getBlockedUsers', () {
    test('sends GET /users/blocked and parses list', () async {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            expect(options.path, '/users/blocked');
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: [
                  {
                    'userId': 'u-blocked',
                    'displayName': 'Blocked Person',
                    'blockedAt': '2026-10-14T08:00:00.000Z',
                  }
                ],
              ),
            );
          },
        ),
      );

      final list = await dataSource.getBlockedUsers();

      expect(list.length, 1);
      expect(list.first.userId, 'u-blocked');
      expect(list.first.displayName, 'Blocked Person');
    });
  });
}
