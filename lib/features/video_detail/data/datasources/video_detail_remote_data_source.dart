import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/exceptions.dart';
import 'package:vocabik_app/shared/data/models/video_model.dart';

VideoModel _parseVideoDetail(dynamic data) {
  return VideoModel.fromJson(data);
}

abstract class VideoDetailRemoteDataSource {
  Future<VideoModel> getVideoDetail(String id);
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
}
