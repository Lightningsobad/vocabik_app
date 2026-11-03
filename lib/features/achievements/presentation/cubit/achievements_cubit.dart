import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/get_badges_usecase.dart';
import 'achievements_state.dart';

@injectable
class AchievementsCubit extends Cubit<AchievementsState> {
  final GetBadgesUseCase _getBadgesUseCase;
  String? _selectedCategory;

  AchievementsCubit(this._getBadgesUseCase)
      : super(const AchievementsInitial());

  String? get selectedCategory => _selectedCategory;

  Future<void> fetchBadges({String? category}) async {
    _selectedCategory = category;
    emit(const AchievementsLoading());

    final result = await _getBadgesUseCase(category: category);
    result.fold(
      (failure) => emit(AchievementsError(failure.message)),
      (badges) => emit(AchievementsLoaded(badges, selectedCategory: category)),
    );
  }

  Future<void> selectCategory(String? category) async {
    if (_selectedCategory == category && state is AchievementsLoaded) {
      return;
    }
    await fetchBadges(category: category);
  }
}
