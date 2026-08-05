import 'package:flutter_bloc/flutter_bloc.dart';
import 'integration_state.dart';

class IntegrationCubit extends Cubit<IntegrationState> {
  IntegrationCubit() : super(const IntegrationState());

  void toggleTelegramConnection() {
    emit(state.copyWith(isTelegramConnected: !state.isTelegramConnected));
  }

  void toggleZaloConnection() {
    emit(state.copyWith(isZaloConnected: !state.isZaloConnected));
  }
}
