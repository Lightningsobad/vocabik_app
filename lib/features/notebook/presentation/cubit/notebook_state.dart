import 'package:equatable/equatable.dart';
import '../../domain/entities/word_entity.dart';

enum NotebookStatus { initial, loading, loaded, error }

enum NotebookViewMode { list, flashcard }

class NotebookState extends Equatable {
  final NotebookStatus status;
  final List<WordEntity> words;
  final List<WordEntity> filteredWords;
  final String searchQuery;
  final NotebookViewMode viewMode;
  final int currentFlashcardIndex;
  final bool isCardFlipped;
  final bool isUpdatingStatus;
  final String? errorMessage;

  const NotebookState({
    this.status = NotebookStatus.initial,
    this.words = const [],
    this.filteredWords = const [],
    this.searchQuery = '',
    this.viewMode = NotebookViewMode.list,
    this.currentFlashcardIndex = 0,
    this.isCardFlipped = false,
    this.isUpdatingStatus = false,
    this.errorMessage,
  });

  WordEntity? get currentFlashcard {
    final list = searchQuery.isNotEmpty ? filteredWords : words;
    if (list.isEmpty || currentFlashcardIndex < 0 || currentFlashcardIndex >= list.length) {
      return null;
    }
    return list[currentFlashcardIndex];
  }

  int get totalFlashcards {
    final list = searchQuery.isNotEmpty ? filteredWords : words;
    return list.length;
  }

  bool get isFlashcardFinished {
    final total = totalFlashcards;
    return total > 0 && currentFlashcardIndex >= total;
  }

  NotebookState copyWith({
    NotebookStatus? status,
    List<WordEntity>? words,
    List<WordEntity>? filteredWords,
    String? searchQuery,
    NotebookViewMode? viewMode,
    int? currentFlashcardIndex,
    bool? isCardFlipped,
    bool? isUpdatingStatus,
    String? errorMessage,
  }) {
    return NotebookState(
      status: status ?? this.status,
      words: words ?? this.words,
      filteredWords: filteredWords ?? this.filteredWords,
      searchQuery: searchQuery ?? this.searchQuery,
      viewMode: viewMode ?? this.viewMode,
      currentFlashcardIndex:
          currentFlashcardIndex ?? this.currentFlashcardIndex,
      isCardFlipped: isCardFlipped ?? this.isCardFlipped,
      isUpdatingStatus: isUpdatingStatus ?? this.isUpdatingStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        words,
        filteredWords,
        searchQuery,
        viewMode,
        currentFlashcardIndex,
        isCardFlipped,
        isUpdatingStatus,
        errorMessage,
      ];
}
