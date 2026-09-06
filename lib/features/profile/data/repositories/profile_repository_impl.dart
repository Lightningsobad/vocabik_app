import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/core/errors/exceptions.dart';

import '../../domain/repositories/profile_repository.dart';
import '../data_sources/profile_remote_data_source.dart';
import '../models/update_profile_request_model.dart';
import '../models/update_profile_response_model.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, UpdateProfileResponseModel>> updateProfile({
    String? cefrLevel,
    String? displayName,
  }) async {
    try {
      final result = await _remoteDataSource.updateProfile(
        UpdateProfileRequestModel(
          cefrLevel: cefrLevel,
          displayName: displayName,
        ),
      );
      return right(result);
    } on NetworkException {
      return left(const NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra lại.'));
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(const ServerFailure('Lỗi hệ thống không xác định.'));
    }
  }
}
