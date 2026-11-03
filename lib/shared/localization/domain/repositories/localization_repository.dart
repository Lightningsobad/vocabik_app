abstract class LocalizationRepository {
  Future<String?> getLanguage();
  Future<void> saveLanguage(String languageCode);
}
