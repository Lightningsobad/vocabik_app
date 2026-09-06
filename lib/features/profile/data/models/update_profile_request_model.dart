class UpdateProfileRequestModel {
  final String? cefrLevel;
  final String? displayName;

  const UpdateProfileRequestModel({
    this.cefrLevel,
    this.displayName,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (cefrLevel != null) {
      map['cefrLevel'] = cefrLevel;
    }
    if (displayName != null) {
      map['displayName'] = displayName;
    }
    return map;
  }
}
