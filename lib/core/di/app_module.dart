import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocabik_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/auth_bloc.dart';
import '../network/auth_interceptor.dart';
import 'injection.dart';

@module
abstract class AppModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  Dio dio(AuthLocalDataSource authLocalDataSource) {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.vocabik.com/api/v1',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'accept': '*/*'},
      ),
    );

    dio.interceptors.add(
      AuthInterceptor(
        dio: dio,
        authLocalDataSource: authLocalDataSource,
        onSessionExpired: () {
          if (getIt.isRegistered<AuthBloc>()) {
            getIt<AuthBloc>().add(const SessionExpired());
          }
        },
      ),
    );

    return dio;
  }
}
