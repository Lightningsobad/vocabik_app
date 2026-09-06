import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/challenge_link_request_model.dart';
import '../models/challenge_link_response_model.dart';
import '../models/friend_model.dart';

abstract class ChallengeFriendRemoteDataSource {
  Future<List<FriendModel>> getFriends({CancelToken? cancelToken});

  Future<ChallengeLinkResponseModel> createChallengeLink({
    required ChallengeLinkRequestModel request,
    CancelToken? cancelToken,
  });
}

List<FriendModel> _parseFriends(dynamic data) {
  if (data is Map<String, dynamic> || data is Map) {
    final friendsList = data['friends'];
    if (friendsList is List) {
      return friendsList
          .map((item) => FriendModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    }
  } else if (data is List) {
    return data
        .map((item) => FriendModel.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }
  return [];
}

ChallengeLinkResponseModel _parseChallengeLink(dynamic data) {
  if (data is Map<String, dynamic>) {
    return ChallengeLinkResponseModel.fromJson(data);
  } else if (data is Map) {
    return ChallengeLinkResponseModel.fromJson(Map<String, dynamic>.from(data));
  }
  throw const FormatException('Invalid challenge link response format');
}

@LazySingleton(as: ChallengeFriendRemoteDataSource)
class ChallengeFriendRemoteDataSourceImpl implements ChallengeFriendRemoteDataSource {
  final Dio _dio;

  ChallengeFriendRemoteDataSourceImpl(this._dio);

  @override
  Future<List<FriendModel>> getFriends({CancelToken? cancelToken}) async {
    try {
      final response = await _dio.get(
        '/friends',
        cancelToken: cancelToken,
      );

      if (response.statusCode == 200 && response.data != null) {
        return await compute(_parseFriends, response.data);
      } else {
        throw ServerException('Failed to load friends list');
      }
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.cancel) {
          throw const RequestCancelledException();
        }
        if (e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.connectionTimeout) {
          throw const NetworkException();
        }
        throw ServerException(
          e.response?.data?['message'] as String? ??
              e.message ??
              'Failed to load friends',
        );
      }
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ChallengeLinkResponseModel> createChallengeLink({
    required ChallengeLinkRequestModel request,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        '/challenge-links',
        data: request.toJson(),
        cancelToken: cancelToken,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return await compute(_parseChallengeLink, response.data);
      } else {
        throw ServerException('Failed to create challenge link');
      }
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.cancel) {
          throw const RequestCancelledException();
        }
        if (e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.connectionTimeout) {
          throw const NetworkException();
        }
        throw ServerException(
          e.response?.data?['message'] as String? ??
              e.message ??
              'Failed to create challenge link',
        );
      }
      throw ServerException(e.toString());
    }
  }
}
