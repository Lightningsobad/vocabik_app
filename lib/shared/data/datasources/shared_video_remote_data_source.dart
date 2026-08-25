import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/exceptions.dart';
import 'package:vocabik_app/shared/data/models/video_model.dart';

PaginatedVideoResponseModel _parseVideos(dynamic data) {
  return PaginatedVideoResponseModel.fromJson(data);
}

List<VideoModel> _parseTrendingVideos(dynamic data) {
  final map = data as Map<String, dynamic>;
  final items = map['items'] as List<dynamic>;
  return items
      .map((item) => VideoModel.fromJson(item as Map<String, dynamic>))
      .toList();
}

abstract class SharedVideoRemoteDataSource {
  Future<PaginatedVideoResponseModel> getVideos({
    required int page,
    required int pageSize,
    String? cefr,
    String? genre,
    String? window,
  });

  Future<List<VideoModel>> getTrendingVideos({String? cefr});
}

@LazySingleton(as: SharedVideoRemoteDataSource)
class SharedVideoRemoteDataSourceImpl implements SharedVideoRemoteDataSource {
  final Dio dio;

  SharedVideoRemoteDataSourceImpl(this.dio);

  @override
  Future<PaginatedVideoResponseModel> getVideos({
    required int page,
    required int pageSize,
    String? cefr,
    String? genre,
    String? window,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'pageSize': pageSize,
      };

      if (cefr != null && cefr.isNotEmpty && cefr.toLowerCase() != 'all') queryParameters['cefr'] = cefr;
      if (genre != null && genre.isNotEmpty && genre.toLowerCase() != 'all') queryParameters['genre'] = genre;
      if (window != null && window.isNotEmpty) queryParameters['window'] = window;

      final response = await dio.get(
        '/public/videos',
        queryParameters: queryParameters,
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

  @override
  Future<List<VideoModel>> getTrendingVideos({String? cefr}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (cefr != null && cefr.isNotEmpty && cefr.toLowerCase() != 'all') {
        queryParameters['cefr'] = cefr;
      }

      final response = await dio.get(
        '/public/videos/trending',
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      );
      
      if (response.statusCode == 200) {
        return await compute(_parseTrendingVideos, response.data);
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
