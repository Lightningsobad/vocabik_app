import 'dart:ui';
import 'package:equatable/equatable.dart';

enum LocalizationStatus { initial, loading, success, failure }

class LocalizationState extends Equatable {
  final Locale currentLocale;
  final LocalizationStatus status;
  final String? errorMessage;

  const LocalizationState({
    required this.currentLocale,
    this.status = LocalizationStatus.initial,
    this.errorMessage,
  });

  LocalizationState copyWith({
    Locale? currentLocale,
    LocalizationStatus? status,
    String? errorMessage,
  }) {
    return LocalizationState(
      currentLocale: currentLocale ?? this.currentLocale,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [currentLocale, status, errorMessage];
}
