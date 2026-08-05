import 'package:equatable/equatable.dart';

class IntegrationState extends Equatable {
  final bool isTelegramConnected;
  final bool isZaloConnected;

  const IntegrationState({
    this.isTelegramConnected = false,
    this.isZaloConnected = false,
  });

  IntegrationState copyWith({
    bool? isTelegramConnected,
    bool? isZaloConnected,
  }) {
    return IntegrationState(
      isTelegramConnected: isTelegramConnected ?? this.isTelegramConnected,
      isZaloConnected: isZaloConnected ?? this.isZaloConnected,
    );
  }

  @override
  List<Object> get props => [isTelegramConnected, isZaloConnected];
}
