import 'package:equatable/equatable.dart';

class UpdateProfileResponseModel extends Equatable {
  final String? cefrLevel;
  final String? displayName;

  const UpdateProfileResponseModel({
    this.cefrLevel,
    this.displayName,
  });

  factory UpdateProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponseModel(
      cefrLevel: json['cefrLevel'] as String?,
      displayName: json['displayName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (cefrLevel != null) 'cefrLevel': cefrLevel,
      if (displayName != null) 'displayName': displayName,
    };
  }

  @override
  List<Object?> get props => [cefrLevel, displayName];
}
