import 'package:equatable/equatable.dart';

class ErrorCategory extends Equatable {
  final String category;
  final int accuracyPct;
  final int errorCount;

  const ErrorCategory({
    required this.category,
    required this.accuracyPct,
    required this.errorCount,
  });

  @override
  List<Object?> get props => [category, accuracyPct, errorCount];
}

class ErrorTrend extends Equatable {
  final String weekLabel;
  final int accuracyPct;

  const ErrorTrend({
    required this.weekLabel,
    required this.accuracyPct,
  });

  @override
  List<Object?> get props => [weekLabel, accuracyPct];
}

class ProgressErrorInsights extends Equatable {
  final String state;
  final List<ErrorCategory> categories;
  final List<ErrorTrend> trend;

  const ProgressErrorInsights({
    required this.state,
    required this.categories,
    required this.trend,
  });

  @override
  List<Object?> get props => [state, categories, trend];
}
