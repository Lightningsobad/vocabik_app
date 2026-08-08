import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/exceptions.dart';
import 'package:vocabik_app/features/home/data/models/video_model.dart';

PaginatedVideoResponseModel _parseVideos(dynamic data) {
  return PaginatedVideoResponseModel.fromJson(data);
}

abstract class VideoRemoteDataSource {
  Future<PaginatedVideoResponseModel> getVideos({
    required int page,
    required int pageSize,
  });
}

@LazySingleton(as: VideoRemoteDataSource)
class VideoRemoteDataSourceImpl implements VideoRemoteDataSource {
  final Dio dio;

  VideoRemoteDataSourceImpl(this.dio);

  @override
  Future<PaginatedVideoResponseModel> getVideos({
    required int page,
    required int pageSize,
  }) async {
    try {
      final response = await dio.get(
        '/public/videos',
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
        },
      );
      
      if (response.statusCode == 200) {
        return await compute(_parseVideos, response.data);
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
