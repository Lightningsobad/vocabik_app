import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class AppModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  Dio get dio => Dio(BaseOptions(
        baseUrl: 'https://api.vocabik.com/api/v1',
        headers: {
          'x-client-type': 'mobile',
          'accept': '*/*',
        },
      ));
}
