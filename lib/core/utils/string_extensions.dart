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
}

