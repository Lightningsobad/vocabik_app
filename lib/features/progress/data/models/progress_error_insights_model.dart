import '../../domain/entities/progress_error_insights.dart';

class ErrorCategoryModel extends ErrorCategory {
  const ErrorCategoryModel({
    required super.category,
    required super.accuracyPct,
    required super.errorCount,
  });

  factory ErrorCategoryModel.fromJson(Map<String, dynamic> json) {
    return ErrorCategoryModel(
      category: json['category'] as String? ?? '',
      accuracyPct: json['accuracyPct'] as int? ?? 0,
      errorCount: json['errorCount'] as int? ?? 0,
    );
  }
}

class ErrorTrendModel extends ErrorTrend {
  const ErrorTrendModel({
    required super.weekLabel,
    required super.accuracyPct,
  });

  factory ErrorTrendModel.fromJson(Map<String, dynamic> json) {
    return ErrorTrendModel(
      weekLabel: json['weekLabel'] as String? ?? '',
      accuracyPct: json['accuracyPct'] as int? ?? 0,
    );
  }
}

class ProgressErrorInsightsModel extends ProgressErrorInsights {
  const ProgressErrorInsightsModel({
    required super.state,
    required super.categories,
    required super.trend,
  });

  factory ProgressErrorInsightsModel.fromJson(Map<String, dynamic> json) {
    return ProgressErrorInsightsModel(
      state: json['state'] as String? ?? 'ok',
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => ErrorCategoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      trend: (json['trend'] as List<dynamic>?)
              ?.map((e) => ErrorTrendModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
