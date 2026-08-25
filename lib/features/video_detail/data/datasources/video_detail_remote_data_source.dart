import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/exceptions.dart';
import 'package:vocabik_app/features/video_detail/data/models/reaction_response_model.dart';
import 'package:vocabik_app/features/video_detail/data/models/video_progress_model.dart';
import 'package:vocabik_app/shared/data/models/video_model.dart';

VideoModel _parseVideoDetail(dynamic data) {
  return VideoModel.fromJson(data);
}

abstract class VideoDetailRemoteDataSource {
  Future<VideoModel> getVideoDetail(String id);
  Future<int> getExerciseBlanksCount(String videoId);
  Future<VideoProgressModel?> getLatestProgress(String videoId);
  Future<ReactionResponseModel> sendVideoReaction(String videoId, String reactionType);
}

@LazySingleton(as: VideoDetailRemoteDataSource)
class VideoDetailRemoteDataSourceImpl implements VideoDetailRemoteDataSource {
  final Dio dio;

  VideoDetailRemoteDataSourceImpl(this.dio);

  @override
  Future<VideoModel> getVideoDetail(String id) async {
    try {
      final response = await dio.get('/public/videos/$id');
      
      if (response.statusCode == 200) {
        return await compute(_parseVideoDetail, response.data);
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unknown DioException');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<int> getExerciseBlanksCount(String videoId) async {
    try {
      final response = await dio.get('/public/videos/$videoId/exercise');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['blanks'] is List) {
          return (data['blanks'] as List).length;
        }
        return 0;
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unknown DioException');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<VideoProgressModel?> getLatestProgress(String videoId) async {
    try {
      final response = await dio.get('/progress/videos/$videoId');
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          if (data['lastAttempt'] == null) {
            return null;
          }
          return VideoProgressModel.fromJson(data);
        }
        return null;
      } else {
        return null;
      }
    } catch (_) {
      // Return null so the main video detail still loads smoothly
      return null;
    }
  }

  @override
  Future<ReactionResponseModel> sendVideoReaction(String videoId, String reactionType) async {
    try {
      final response = await dio.post(
        '/reactions',
        data: {
          'targetType': 'VIDEO',
          'targetId': videoId,
          'reactionType': reactionType,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return ReactionResponseModel.fromJson(data);
        }
        throw ServerException('Invalid response data');
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unknown DioException');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
