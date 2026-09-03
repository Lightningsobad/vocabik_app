import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/core/errors/exceptions.dart';

import '../../domain/entities/user.dart';
import '../../domain/entities/user_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_local_data_source.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.login(
        LoginRequestModel(email: email, password: password),
      );
      await _localDataSource.saveTokens(
        response.accessToken,
        response.refreshToken,
      );
      try {
        final user = await _remoteDataSource.getMe();
        return right(user);
      } catch (_) {
        return right(response.user);
      }
    } on NetworkException {
      return left(
        const NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra lại.'),
      );
    } on InvalidCredentialsException {
      return left(
        const InvalidCredentialsFailure('Email hoặc mật khẩu không chính xác.'),
      );
    } on NotVerifiedException {
      return left(
        const NotVerifiedFailure('Tài khoản chưa được xác thực email.'),
      );
    } on ServerException {
      return left(const ServerFailure('Lỗi máy chủ, vui lòng thử lại sau.'));
    } catch (e) {
      return left(const ServerFailure('Lỗi hệ thống không xác định.'));
    }
  }

  @override
  Future<Either<Failure, User>> getMe() async {
    try {
      final user = await _remoteDataSource.getMe();
      return right(user);
    } on NetworkException {
      return left(
        const NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra lại.'),
      );
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
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

  @override
  Future<Either<Failure, void>> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      await _remoteDataSource.register(
        RegisterRequestModel(
          email: email,
          password: password,
          displayName: displayName,
        ),
      );
      return right(null);
    } on NetworkException {
      return left(
        const NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra lại.'),
      );
    } on ServerException {
      return left(const UserAlreadyExistsFailure('Tài khoản đã tồn tại.'));
    } catch (e) {
      return left(const ServerFailure('Lỗi hệ thống không xác định.'));
    }
  }

  @override
  Future<Either<Failure, User>> verifyEmail(String token) async {
    try {
      final response = await _remoteDataSource.verifyEmail(token);
      await _localDataSource.saveTokens(
        response.accessToken,
        response.refreshToken,
      );
      try {
        final user = await _remoteDataSource.getMe();
        return right(user);
      } catch (_) {
        return right(response.user);
      }
    } on NetworkException {
      return left(
        const NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra lại.'),
      );
    } on ServerException {
      return left(
        const InvalidTokenFailure('Token không hợp lệ hoặc đã hết hạn.'),
      );
    } catch (e) {
      return left(const ServerFailure('Lỗi hệ thống không xác định.'));
    }
  }

  @override
  Future<Either<Failure, void>> resendVerificationEmail(String email) async {
    try {
      await _remoteDataSource.resendVerificationEmail(email);
      return right(null);
    } on NetworkException {
      return left(
        const NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra lại.'),
      );
    } catch (e) {
      return left(const ServerFailure('Lỗi hệ thống không xác định.'));
    }
  }

  @override
  Future<Either<Failure, void>> setCefrSkipped(bool value) async {
    try {
      await _localDataSource.setCefrSkipped(value);
      return right(null);
    } catch (e) {
      return left(const CacheFailure('Không thể lưu trạng thái.'));
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async {
    try {
      final message = await _remoteDataSource.forgotPassword(email);
      return right(message);
    } on NetworkException {
      return left(
        const NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra lại.'),
      );
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(const ServerFailure('Lỗi hệ thống không xác định.'));
    }
  }

  @override
  Future<Either<Failure, String>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final message = await _remoteDataSource.resetPassword(token, newPassword);
      return right(message);
    } on NetworkException {
      return left(
        const NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra lại.'),
      );
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(const ServerFailure('Lỗi hệ thống không xác định.'));
    }
  }

  @override
  Future<Either<Failure, List<UserSession>>> getSessions() async {
    try {
      final sessions = await _remoteDataSource.getSessions();
      return right(sessions);
    } on NetworkException {
      return left(
        const NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra lại.'),
      );
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(const ServerFailure('Lỗi hệ thống không xác định.'));
    }
  }
}
