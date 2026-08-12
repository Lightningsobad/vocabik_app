import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'gamification_global_state.dart';

@lazySingleton
class GamificationGlobalCubit extends Cubit<GamificationGlobalState> {
  GamificationGlobalCubit() : super(const GamificationGlobalState());

  void updateStats({required int streak, required int xp}) {
    emit(state.copyWith(
      streak: streak,
      xp: xp,
    ));
  }
}
