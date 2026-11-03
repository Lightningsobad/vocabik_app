import 'package:equatable/equatable.dart';
import '../../data/models/update_profile_response_model.dart';

enum UpdateProfileStatus { initial, loading, success, failure }

class UpdateProfileState extends Equatable {
  final UpdateProfileStatus status;
  final UpdateProfileResponseModel? updatedProfile;
  final String? errorMessage;

  const UpdateProfileState({
    this.status = UpdateProfileStatus.initial,
    this.updatedProfile,
    this.errorMessage,
  });

  UpdateProfileState copyWith({
    UpdateProfileStatus? status,
    UpdateProfileResponseModel? updatedProfile,
    String? errorMessage,
  }) {
    return UpdateProfileState(
      status: status ?? this.status,
      updatedProfile: updatedProfile ?? this.updatedProfile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, updatedProfile, errorMessage];
}
