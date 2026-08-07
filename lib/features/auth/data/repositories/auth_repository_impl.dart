import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/core/errors/exceptions.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_local_data_source.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/login_request_model.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, User>> login({required String email, required String password}) async {
    try {
      final response = await _remoteDataSource.login(
        LoginRequestModel(email: email, password: password),
      );
      await _localDataSource.saveTokens(response.accessToken, response.refreshToken);
      return right(response.user);
    } on NetworkException {
      return left(const NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra lại.'));
    } on InvalidCredentialsException {
      return left(const InvalidCredentialsFailure('Email hoặc mật khẩu không chính xác.'));
    } on ServerException {
      return left(const ServerFailure('Lỗi máy chủ, vui lòng thử lại sau.'));
    } catch (e) {
      return left(const ServerFailure('Lỗi hệ thống không xác định.'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      try {
        await _remoteDataSource.signOut();
      } catch (e) {
        // Ghi log lỗi từ API nhưng VẪN TIẾP TỤC xóa local token
      }
      await _localDataSource.clear();
      return right(null);
    } catch (e) {
      return left(const ServerFailure('Không thể đăng xuất'));
    }
  }
}
