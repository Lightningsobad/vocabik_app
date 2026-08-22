enum ExerciseType {
  multipleChoice('Multiple choice'),
  typeTheAnswer('Type the answer');

  final String value;
  const ExerciseType(this.value);

  static ExerciseType fromString(String? value) {
    if (value == null) return ExerciseType.multipleChoice;
    return ExerciseType.values.firstWhere(
      (e) => e.value.toLowerCase() == value.trim().toLowerCase(),
      orElse: () => ExerciseType.multipleChoice,
    );
  }
}
