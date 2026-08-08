class UpdateProfileRequestModel {
  final String cefrLevel;

  const UpdateProfileRequestModel({
    required this.cefrLevel,
  });

  Map<String, dynamic> toJson() {
    return {
      'cefrLevel': cefrLevel,
    };
  }
}
