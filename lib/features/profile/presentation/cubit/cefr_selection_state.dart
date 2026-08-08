import 'package:equatable/equatable.dart';

enum CefrSelectionStatus { initial, loading, success, failure }

class CefrSelectionState extends Equatable {
  final CefrSelectionStatus status;
  final String? errorMessage;
  final String? selectedLevel;

  const CefrSelectionState({
    this.status = CefrSelectionStatus.initial,
    this.errorMessage,
    this.selectedLevel,
  });

  CefrSelectionState copyWith({
    CefrSelectionStatus? status,
    String? errorMessage,
    String? selectedLevel,
  }) {
    return CefrSelectionState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      selectedLevel: selectedLevel ?? this.selectedLevel,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, selectedLevel];
}
