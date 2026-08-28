import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/progress_summary.dart';
import '../entities/progress_history.dart';
import '../entities/progress_error_insights.dart';

abstract class ProgressRepository {
  Future<Either<Failure, ProgressSummary>> getProgressSummary();
  Future<Either<Failure, ProgressHistory>> getProgressHistory();
  Future<Either<Failure, ProgressErrorInsights>> getProgressErrorInsights();
}
