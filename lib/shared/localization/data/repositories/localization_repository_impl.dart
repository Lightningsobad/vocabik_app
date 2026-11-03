import 'package:injectable/injectable.dart';
import '../../domain/repositories/localization_repository.dart';
import '../datasources/localization_local_data_source.dart';

@LazySingleton(as: LocalizationRepository)
class LocalizationRepositoryImpl implements LocalizationRepository {
  final LocalizationLocalDataSource _localDataSource;

  LocalizationRepositoryImpl(this._localDataSource);

  @override
  Future<String?> getLanguage() {
    return _localDataSource.getLanguage();
  }

  @override
  Future<void> saveLanguage(String languageCode) {
    return _localDataSource.saveLanguage(languageCode);
  }
}
