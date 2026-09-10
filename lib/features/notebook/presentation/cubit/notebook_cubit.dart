import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/word_entity.dart';
import '../../domain/usecases/get_notebook_words_usecase.dart';
import '../../domain/usecases/update_word_review_status_usecase.dart';
import 'notebook_state.dart';

@injectable
class NotebookCubit extends Cubit<NotebookState> {
  final GetNotebookWordsUseCase _getNotebookWordsUseCase;
  final UpdateWordReviewStatusUseCase _updateWordReviewStatusUseCase;
  Timer? _debounceTimer;

  NotebookCubit(
    this._getNotebookWordsUseCase,
    this._updateWordReviewStatusUseCase,
  ) : super(const NotebookState());

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }

  Future<void> fetchWords() async {
    emit(state.copyWith(status: NotebookStatus.loading, errorMessage: null));

    final result = await _getNotebookWordsUseCase(
      search: state.searchQuery.isNotEmpty ? state.searchQuery : null,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: NotebookStatus.error,
        errorMessage: failure.message,
      )),
      (response) {
        emit(state.copyWith(
          status: NotebookStatus.loaded,
          words: response.words,
          filteredWords: response.words,
          totalCount: response.total,
          currentFlashcardIndex: 0,
          isCardFlipped: false,
        ));
      },
    );
  }

  void searchWords(String query) {
    emit(state.copyWith(
      searchQuery: query,
      isSearching: true,
      currentFlashcardIndex: 0,
      isCardFlipped: false,
    ));

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 350), () async {
      final result = await _getNotebookWordsUseCase(
        search: query.trim().isNotEmpty ? query.trim() : null,
      );

      // Verify query hasn't changed while request was in-flight
      if (state.searchQuery != query) return;

      result.fold(
        (failure) => emit(state.copyWith(
          isSearching: false,
          status: NotebookStatus.error,
          errorMessage: failure.message,
        )),
        (response) {
          emit(state.copyWith(
            isSearching: false,
            status: NotebookStatus.loaded,
            words: response.words,
            filteredWords: response.words,
            totalCount: response.total,
            currentFlashcardIndex: 0,
            isCardFlipped: false,
          ));
        },
      );
    });
  }

  void changeViewMode(NotebookViewMode mode) {
    if (state.viewMode == mode) return;
    emit(state.copyWith(
      viewMode: mode,
      isCardFlipped: false,
    ));
  }

  void flipCard() {
    emit(state.copyWith(isCardFlipped: !state.isCardFlipped));
  }

  Future<void> answerFlashcard(bool needsReview) async {
    final currentWord = state.currentFlashcard;
    if (currentWord == null || state.isUpdatingStatus) return;

    emit(state.copyWith(isUpdatingStatus: true));

    final result = await _updateWordReviewStatusUseCase(
      id: currentWord.id,
      needsReview: needsReview,
    );

    result.fold(
      (failure) {
        // Even if network fails, we advance so the user is not stuck, but keep local state
        _advanceFlashcard(updatedWord: currentWord.copyWith(needsReview: needsReview));
      },
      (updatedWord) {
        _advanceFlashcard(updatedWord: updatedWord);
      },
    );
  }

  void _advanceFlashcard({required WordEntity updatedWord}) {
    final updatedWords = state.words.map((w) {
      return w.id == updatedWord.id ? updatedWord : w;
    }).toList();

    final updatedFiltered = state.filteredWords.map((w) {
      return w.id == updatedWord.id ? updatedWord : w;
    }).toList();

    emit(state.copyWith(
      words: updatedWords,
      filteredWords: updatedFiltered,
      currentFlashcardIndex: state.currentFlashcardIndex + 1,
      isCardFlipped: false,
      isUpdatingStatus: false,
    ));
  }

  void restartFlashcards() {
    emit(state.copyWith(
      currentFlashcardIndex: 0,
      isCardFlipped: false,
    ));
  }
}
