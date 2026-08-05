import 'package:injectable/injectable.dart';
import '../repositories/localization_repository.dart';

@lazySingleton
class GetLanguageUseCase {
  final LocalizationRepository _repository;

  GetLanguageUseCase(this._repository);

  Future<String?> call() {
    return _repository.getLanguage();
  }
}
