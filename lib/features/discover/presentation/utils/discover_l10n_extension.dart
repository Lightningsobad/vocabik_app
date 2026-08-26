import 'package:vocabik_app/l10n/app_localizations.dart';

extension DiscoverL10nExtension on AppLocalizations {
  String getGenreDisplayName(String genre) {
    switch (genre.toLowerCase()) {
      case 'music':
        return genreMusic;
      case 'vlog':
        return genreVlog;
      case 'news':
        return genreNews;
      case 'education':
        return genreEducation;
      case 'entertainment':
        return genreEntertainment;
      case 'ted_talks':
        return genreTedTalks;
      case 'news_english':
        return genreNewsEnglish;
      case 'other':
        return genreOther;
      default:
        return '';
    }
  }

  String getDiscoverLibraryTitle({
    required String genre,
    required String cefr,
  }) {
    final genreText = getGenreDisplayName(genre);
    final hasGenre = genreText.isNotEmpty;
    final hasCefr = cefr.isNotEmpty;

    if (hasGenre && hasCefr) {
      return '$genreText · $cefr';
    } else if (hasGenre) {
      return genreText;
    } else if (hasCefr) {
      return '$homeLibrary · $cefr';
    }
    return homeLibrary;
  }
}
