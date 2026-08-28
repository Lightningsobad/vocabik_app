extension StringExtensions on String {
  /// Normalizes an answer string by trimming, lowercasing,
  /// and stripping out common punctuation characters.
  String normalizeAnswer() {
    return trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[.,!?:;"\u201C\u201D\u2018\u2019\(\)\[\]]'), '');
  }

  /// Extracts version number from strings like "v1", "v2", or "1".
  int extractVersionNumber() {
    final match = RegExp(r'\d+').firstMatch(this);
    if (match != null) {
      return int.tryParse(match.group(0)!) ?? 1;
    }
    return 1;
  }

  /// Capitalizes the first letter of the string and lowercases the rest.
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Extracts up to two uppercase initials from the string (e.g. "John Doe" -> "JD", "Alice" -> "AL").
  String toInitials() {
    final trimmedName = trim();
    if (trimmedName.isEmpty) return '';
    final words = trimmedName.split(RegExp(r'\s+'));
    if (words.length == 1) {
      return words.first
          .substring(0, words.first.length >= 2 ? 2 : 1)
          .toUpperCase();
    } else {
      return '${words.first[0]}${words.last[0]}'.toUpperCase();
    }
  }
}

