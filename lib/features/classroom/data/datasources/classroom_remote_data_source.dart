import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/classroom_model.dart';

abstract class ClassroomRemoteDataSource {
  Future<List<ClassroomModel>> getClassrooms({CancelToken? cancelToken});
  Future<ClassroomModel> createClassroom(String name, {CancelToken? cancelToken});
  Future<ClassroomModel> getClassroomById(String id, {CancelToken? cancelToken});
}

List<ClassroomModel> _parseClassroomList(dynamic data) {
  if (data is Map<String, dynamic> && data['classrooms'] is List) {
    return (data['classrooms'] as List)
        .map((item) => ClassroomModel.fromJson(item as Map<String, dynamic>))
        .toList();
  } else if (data is List) {
    return data
        .map((item) => ClassroomModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
  return [];
}

ClassroomModel _parseClassroom(dynamic data) {
  if (data is Map<String, dynamic>) {
    if (data['data'] is Map<String, dynamic>) {
      return ClassroomModel.fromJson(data['data'] as Map<String, dynamic>);
    }
    return ClassroomModel.fromJson(data);
  }
  return const ClassroomModel(
    id: '',
    name: '',
    joinCode: '',
    isActive: true,
    studentCount: 0,
  );
}

@LazySingleton(as: ClassroomRemoteDataSource)
class ClassroomRemoteDataSourceImpl implements ClassroomRemoteDataSource {
  final Dio _dio;

  ClassroomRemoteDataSourceImpl(this._dio);

  @override
  Future<List<ClassroomModel>> getClassrooms({CancelToken? cancelToken}) async {
    try {
      final response = await _dio.get(
        '/classrooms',
        cancelToken: cancelToken,
        options: Options(
          headers: {'accept': '*/*'},
        ),
      );
      return await compute(_parseClassroomList, response.data);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.connectionTimeout) {
          throw const NetworkException();
        }
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          throw const ServerException('Session expired');
        } else if (statusCode != null) {
          throw ServerException('API Error: $statusCode - ${e.message}');
        }
      }
      throw ServerException('Failed to load classrooms: $e');
    }
  }

  @override
  Future<ClassroomModel> createClassroom(String name, {CancelToken? cancelToken}) async {
    try {
      final response = await _dio.post(
        '/classrooms',
        data: {'name': name},
        cancelToken: cancelToken,
        options: Options(
          headers: {
            'accept': '*/*',
            'Content-Type': 'application/json',
          },
        ),
      );
      return await compute(_parseClassroom, response.data);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.connectionTimeout) {
          throw const NetworkException();
        }
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          throw const ServerException('Session expired');
        } else if (statusCode != null) {
          throw ServerException('API Error: $statusCode - ${e.message}');
        }
      }
      throw ServerException('Failed to create classroom: $e');
    }
  }

  @override
  Future<ClassroomModel> getClassroomById(String id, {CancelToken? cancelToken}) async {
    try {
      final response = await _dio.get(
        '/classrooms/$id',
        cancelToken: cancelToken,
        options: Options(
          headers: {'accept': '*/*'},
        ),
      );
      return await compute(_parseClassroom, response.data);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.connectionTimeout) {
          throw const NetworkException();
        }
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          throw const ServerException('Session expired');
        } else if (statusCode != null) {
          throw ServerException('API Error: $statusCode - ${e.message}');
        }
      }
      throw ServerException('Failed to get classroom detail: $e');
    }
  }
}
