import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'crashlytics_service.dart';

class AppBlocObserver extends BlocObserver {
  final CrashlyticsService _crashlyticsService;

  AppBlocObserver(this._crashlyticsService);

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      final sanitizedError = error is DioException
          ? 'DioException [status: ${error.response?.statusCode}, type: ${error.type}]'
          : error.toString();
      debugPrint('[BlocObserver] Error in ${bloc.runtimeType}: $sanitizedError');
    }
    _crashlyticsService.recordError(
      error,
      stackTrace,
      reason: 'BlocException in ${bloc.runtimeType}',
      fatal: false,
    );
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      debugPrint('[BlocObserver] ${bloc.runtimeType} changed');
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (kDebugMode) {
      debugPrint(
        '[BlocObserver] ${bloc.runtimeType} event: ${transition.event.runtimeType}',
      );
    }
  }
}
