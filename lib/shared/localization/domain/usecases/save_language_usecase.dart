import 'package:injectable/injectable.dart';
import '../repositories/localization_repository.dart';

@lazySingleton
class SaveLanguageUseCase {
  final LocalizationRepository _repository;

  SaveLanguageUseCase(this._repository);

  Future<void> call(String languageCode) {
    return _repository.saveLanguage(languageCode);
  }
}
