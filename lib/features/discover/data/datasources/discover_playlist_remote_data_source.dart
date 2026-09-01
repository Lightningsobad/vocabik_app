import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/exceptions.dart';
import '../models/playlist_model.dart';

PaginatedPlaylistResponseModel _parsePlaylists(dynamic data) {
  return PaginatedPlaylistResponseModel.fromJson(data as Map<String, dynamic>);
}

PlaylistModel _parsePlaylistDetail(dynamic data) {
  return PlaylistModel.fromJson(data as Map<String, dynamic>);
}

abstract class DiscoverPlaylistRemoteDataSource {
  Future<PaginatedPlaylistResponseModel> getPlaylists({
    required int page,
    required int pageSize,
  });

  Future<PlaylistModel> getPlaylistDetail(String slug);
}

@LazySingleton(as: DiscoverPlaylistRemoteDataSource)
class DiscoverPlaylistRemoteDataSourceImpl
    implements DiscoverPlaylistRemoteDataSource {
  final Dio dio;

  DiscoverPlaylistRemoteDataSourceImpl(this.dio);

  @override
  Future<PaginatedPlaylistResponseModel> getPlaylists({
    required int page,
    required int pageSize,
  }) async {
    try {
      final response = await dio.get(
        '/public/playlists',
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
        },
      );

      if (response.statusCode == 200) {
        return await compute(_parsePlaylists, response.data);
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
  Future<PlaylistModel> getPlaylistDetail(String slug) async {
    try {
      final response = await dio.get('/public/playlists/$slug');

      if (response.statusCode == 200) {
        return await compute(_parsePlaylistDetail, response.data);
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
