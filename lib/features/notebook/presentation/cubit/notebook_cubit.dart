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

  NotebookCubit(
    this._getNotebookWordsUseCase,
    this._updateWordReviewStatusUseCase,
  ) : super(const NotebookState());

  Future<void> fetchWords() async {
    emit(state.copyWith(status: NotebookStatus.loading, errorMessage: null));

    final result = await _getNotebookWordsUseCase();
    result.fold(
      (failure) => emit(state.copyWith(
        status: NotebookStatus.error,
        errorMessage: failure.message,
      )),
      (words) {
        final filtered = _applyFilter(words, state.searchQuery);
        emit(state.copyWith(
          status: NotebookStatus.loaded,
          words: words,
          filteredWords: filtered,
          currentFlashcardIndex: 0,
          isCardFlipped: false,
        ));
      },
    );
  }

  void searchWords(String query) {
    final filtered = _applyFilter(state.words, query);
    emit(state.copyWith(
      searchQuery: query,
      filteredWords: filtered,
      currentFlashcardIndex: 0,
      isCardFlipped: false,
    ));
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

  List<WordEntity> _applyFilter(List<WordEntity> list, String query) {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) return list;

    return list.where((item) {
      final matchesWord = item.word.toLowerCase().contains(trimmed);
      final matchesDef = item.definitionVi.toLowerCase().contains(trimmed);
      final matchesExample = item.exampleSentence.toLowerCase().contains(trimmed);
      return matchesWord || matchesDef || matchesExample;
    }).toList();
  }
}
