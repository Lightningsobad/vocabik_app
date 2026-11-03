import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vocabik_app/core/errors/failures.dart';
import 'package:vocabik_app/features/notebook/domain/entities/notebook_words_result.dart';
import 'package:vocabik_app/features/notebook/domain/entities/word_entity.dart';
import 'package:vocabik_app/features/notebook/domain/repositories/notebook_repository.dart';
import 'package:vocabik_app/features/notebook/domain/usecases/get_notebook_words_usecase.dart';
import 'package:vocabik_app/features/notebook/domain/usecases/update_word_review_status_usecase.dart';
import 'package:vocabik_app/features/notebook/presentation/cubit/notebook_cubit.dart';
import 'package:vocabik_app/features/notebook/presentation/screens/notebook_screen.dart';
import 'package:vocabik_app/features/notebook/presentation/widgets/flashcard_action_buttons.dart';
import 'package:vocabik_app/features/notebook/presentation/widgets/flashcard_flip_card.dart';
import 'package:vocabik_app/features/notebook/presentation/widgets/flashcard_study_view.dart';
import 'package:vocabik_app/features/notebook/presentation/widgets/word_list_card.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_theme.dart';

class FakeNotebookRepository implements NotebookRepository {
  List<WordEntity> words;

  FakeNotebookRepository({this.words = const []});

  @override
  Future<Either<Failure, NotebookWordsResult>> getWords({String? search}) async {
    if (search != null && search.isNotEmpty) {
      final filtered = words
          .where((w) =>
              w.word.toLowerCase().contains(search.toLowerCase()) ||
              w.definitionVi.toLowerCase().contains(search.toLowerCase()))
          .toList();
      return Right(NotebookWordsResult(words: filtered, total: filtered.length));
    }
    return Right(NotebookWordsResult(words: words, total: words.length));
  }

  @override
  Future<Either<Failure, WordEntity>> updateReviewStatus({
    required String id,
    required bool needsReview,
  }) async {
    final word = words.firstWhere((w) => w.id == id);
    final updated = word.copyWith(needsReview: needsReview);
    return Right(updated);
  }
}

final sampleWords = [
  WordEntity(
    id: 'w1',
    word: 'Persistent',
    ipa: '/pəˈsɪstənt/',
    definitionVi: 'Kiên trì, bền bỉ',
    exampleSentence: 'She was persistent in learning vocabulary.',
    cefrLevel: 'B2',
    savedAt: DateTime(2026, 1, 1),
    needsReview: true,
  ),
  WordEntity(
    id: 'w2',
    word: 'Eloquence',
    ipa: '/ˈeləkwəns/',
    definitionVi: 'Tài hùng biện',
    exampleSentence: 'His eloquence moved the audience.',
    cefrLevel: 'C1',
    savedAt: DateTime(2026, 1, 2),
    needsReview: false,
  ),
];

Widget _buildTestWidget(NotebookCubit cubit) {
  return MaterialApp(
    locale: const Locale('vi'),
    theme: AppTheme.darkTheme,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: BlocProvider<NotebookCubit>.value(
      value: cubit,
      child: const NotebookScreen(),
    ),
  );
}

void main() {
  group('NotebookScreen and Flashcard Tab', () {
    testWidgets('renders list view and switches to flashcard view without layout crash', (tester) async {
      final repo = FakeNotebookRepository(words: sampleWords);
      final cubit = NotebookCubit(
        GetNotebookWordsUseCase(repo),
        UpdateWordReviewStatusUseCase(repo),
      );

      await cubit.fetchWords();

      await tester.pumpWidget(_buildTestWidget(cubit));
      await tester.pumpAndSettle();

      // List mode: renders 2 word cards
      expect(find.byType(WordListCard), findsNWidgets(2));
      expect(find.text('Persistent'), findsOneWidget);
      expect(find.text('Eloquence'), findsOneWidget);

      // Switch to Flashcard tab
      final flashcardTab = find.text('Thẻ ghi nhớ');
      expect(flashcardTab, findsOneWidget);
      await tester.tap(flashcardTab);
      await tester.pumpAndSettle();

      // Ensure no layout exception occurred
      expect(tester.takeException(), isNull);

      // Flashcard view should now be displayed
      expect(find.byType(FlashcardStudyView), findsOneWidget);
      expect(find.byType(FlashcardFlipCard), findsOneWidget);
      expect(find.byType(FlashcardActionButtons), findsOneWidget);

      // Progress text shows 1 / 2
      expect(find.text('1 / 2'), findsOneWidget);

      // Tap to flip card
      await tester.tap(find.byType(FlashcardFlipCard));
      await tester.pumpAndSettle();
      expect(find.text('Kiên trì, bền bỉ'), findsOneWidget);

      // Press "Got It" button to advance to next word
      final gotItBtn = find.text('Đã thuộc');
      expect(gotItBtn, findsOneWidget);
      await tester.tap(gotItBtn);
      await tester.pumpAndSettle();

      // Now at 2 / 2
      expect(find.text('2 / 2'), findsOneWidget);
      expect(find.text('Eloquence'), findsOneWidget);

      cubit.close();
    });

    testWidgets('handles empty search query in flashcard view correctly', (tester) async {
      final repo = FakeNotebookRepository(words: sampleWords);
      final cubit = NotebookCubit(
        GetNotebookWordsUseCase(repo),
        UpdateWordReviewStatusUseCase(repo),
      );

      await cubit.fetchWords();

      await tester.pumpWidget(_buildTestWidget(cubit));
      await tester.pumpAndSettle();

      // Switch to Flashcard tab
      await tester.tap(find.text('Thẻ ghi nhớ'));
      await tester.pumpAndSettle();

      // Search for non-existent word
      cubit.searchWords('non_existing_word_12345');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      // Should show empty/no search results message, not crash
      expect(find.byType(FlashcardFlipCard), findsNothing);
      expect(tester.takeException(), isNull);

      cubit.close();
    });

    testWidgets('displays total words count from API and renders song title in card', (tester) async {
      final wordsWithSong = [
        WordEntity(
          id: 'w1',
          word: 'know',
          ipa: '/nəʊ/',
          definitionVi: 'biết',
          exampleSentence: "You don't know you beautiful",
          videoSourceId: 'vid-1',
          videoSourceTitle: 'What Makes You Beautiful',
          cefrLevel: 'B2',
          savedAt: DateTime(2026, 9, 4),
          needsReview: false,
        ),
      ];

      final repo = FakeNotebookRepository(words: wordsWithSong);
      final cubit = NotebookCubit(
        GetNotebookWordsUseCase(repo),
        UpdateWordReviewStatusUseCase(repo),
      );

      await cubit.fetchWords();

      await tester.pumpWidget(_buildTestWidget(cubit));
      await tester.pumpAndSettle();

      // Total count header displays 1 word
      expect(find.text('1 từ'), findsOneWidget);

      // Card displays song title with date
      expect(find.text('What Makes You Beautiful · 04/09/2026'), findsOneWidget);

      // Card displays word, IPA, CEFR badge, and definition
      expect(find.text('know'), findsOneWidget);
      expect(find.text('/nəʊ/'), findsOneWidget);
      expect(find.text('B2'), findsOneWidget);
      expect(find.text('biết'), findsOneWidget);

      cubit.close();
    });

    testWidgets('searches words via API debounce and updates list', (tester) async {
      final repo = FakeNotebookRepository(words: sampleWords);
      final cubit = NotebookCubit(
        GetNotebookWordsUseCase(repo),
        UpdateWordReviewStatusUseCase(repo),
      );

      await cubit.fetchWords();

      await tester.pumpWidget(_buildTestWidget(cubit));
      await tester.pumpAndSettle();

      expect(find.text('2 từ'), findsOneWidget);
      expect(find.text('Persistent'), findsOneWidget);
      expect(find.text('Eloquence'), findsOneWidget);

      // Perform search for 'Elo'
      cubit.searchWords('Elo');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      // Only Eloquence is displayed
      expect(find.text('1 từ'), findsOneWidget);
      expect(find.text('Eloquence'), findsOneWidget);
      expect(find.text('Persistent'), findsNothing);

      cubit.close();
    });
  });
}
