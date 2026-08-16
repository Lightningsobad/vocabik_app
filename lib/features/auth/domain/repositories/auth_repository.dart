import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({required String email, required String password});
  Future<Either<Failure, User>> getMe();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, void>> register({required String email, required String password, required String displayName});
  Future<Either<Failure, User>> verifyEmail(String token);
  Future<Either<Failure, void>> resendVerificationEmail(String email);
  Future<Either<Failure, void>> setCefrSkipped(bool value);
}
