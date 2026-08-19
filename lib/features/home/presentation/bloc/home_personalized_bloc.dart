import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:injectable/injectable.dart';
import 'package:vocabik_app/features/home/domain/usecases/get_personalized_slots_usecase.dart';

import 'home_personalized_event.dart';
import 'home_personalized_state.dart';

@injectable
class HomePersonalizedBloc extends Bloc<HomePersonalizedEvent, HomePersonalizedState> {
  final GetPersonalizedSlotsUseCase getPersonalizedSlotsUseCase;

  HomePersonalizedBloc(this.getPersonalizedSlotsUseCase) : super(HomePersonalizedInitial()) {
    on<FetchPersonalizedSlots>(
      _onFetchPersonalizedSlots,
      transformer: droppable(),
    );
    on<RefreshPersonalizedSlots>(
      _onRefreshPersonalizedSlots,
      transformer: droppable(),
    );
  }

  Future<void> _onFetchPersonalizedSlots(
    FetchPersonalizedSlots event,
    Emitter<HomePersonalizedState> emit,
  ) async {
    emit(HomePersonalizedLoading());
    final result = await getPersonalizedSlotsUseCase();
    result.fold(
      (failure) => emit(HomePersonalizedError(failure.message)),
      (slots) => emit(HomePersonalizedLoaded(slots)),
    );
  }

  Future<void> _onRefreshPersonalizedSlots(
    RefreshPersonalizedSlots event,
    Emitter<HomePersonalizedState> emit,
  ) async {
    final result = await getPersonalizedSlotsUseCase();
    result.fold(
      (failure) => emit(HomePersonalizedError(failure.message)),
      (slots) => emit(HomePersonalizedLoaded(slots)),
    );
  }
}
