class ChallengeLinkRequestModel {
  final String videoSlug;
  final String exerciseVersion;
  final int challengerScoreAccuracy;
  final int challengerScoreTimeMs;

  const ChallengeLinkRequestModel({
    required this.videoSlug,
    required this.exerciseVersion,
    required this.challengerScoreAccuracy,
    required this.challengerScoreTimeMs,
  });

  Map<String, dynamic> toJson() {
    return {
      'videoSlug': videoSlug,
      'exerciseVersion': exerciseVersion,
      'challengerScoreAccuracy': challengerScoreAccuracy,
      'challengerScoreTimeMs': challengerScoreTimeMs,
    };
  }
}
