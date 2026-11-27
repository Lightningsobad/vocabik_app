import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/features/discover/presentation/widgets/discover_filter_section.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/domain/entities/video_category_entity.dart';
import 'package:vocabik_app/shared/presentation/widgets/app_shimmer.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';

Widget _wrapFilterSection({
  required List<VideoCategoryEntity> categories,
  bool isCategoriesLoading = false,
  ValueChanged<String>? onGenreChanged,
}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('vi'),
    theme: ThemeData.dark().copyWith(
      extensions: [AppColorsExtension.dark],
    ),
    home: Scaffold(
      body: CustomScrollView(
        slivers: [
          DiscoverFilterSection(
            onSearchChanged: (_) {},
            selectedLevelIndex: 0,
            onLevelIndexChanged: (_) {},
            categories: categories,
            isCategoriesLoading: isCategoriesLoading,
            selectedGenre: '',
            onGenreChanged: onGenreChanged ?? (_) {},
            selectedDuration: '',
            onDurationChanged: (_) {},
            selectedExerciseType: '',
            onExerciseTypeChanged: (_) {},
          ),
        ],
      ),
    ),
  );
}

void main() {
  testWidgets('renders dynamic categories in active locale and emits slug on tap', (tester) async {
    String? selectedGenre;
    const categories = [
      VideoCategoryEntity(
        slug: 'music',
        label: 'Âm nhạc',
        shortLabel: 'Âm nhạc',
        shortLabels: {'en': 'Music', 'vi': 'Âm nhạc'},
        sortOrder: 10,
      ),
      VideoCategoryEntity(
        slug: 'kids',
        label: 'Thiếu nhi',
        shortLabel: 'Thiếu nhi',
        shortLabels: {'en': 'Kids', 'vi': 'Thiếu nhi'},
        sortOrder: 170,
      ),
    ];

    await tester.pumpWidget(
      _wrapFilterSection(
        categories: categories,
        onGenreChanged: (slug) => selectedGenre = slug,
      ),
    );

    expect(find.text('Âm nhạc'), findsOneWidget);
    expect(find.text('Thiếu nhi'), findsOneWidget);
    expect(find.byType(AppShimmer), findsNothing);

    await tester.tap(find.text('Thiếu nhi'));
    expect(selectedGenre, 'kids');
  });

  testWidgets('shows All chip and pill shimmers when categories empty and loading', (tester) async {
    await tester.pumpWidget(
      _wrapFilterSection(
        categories: const [],
        isCategoriesLoading: true,
      ),
    );

    expect(find.byKey(const ValueKey('genre_chips_loading')), findsOneWidget);
    expect(find.byType(AppShimmer), findsOneWidget);
    expect(find.text('Tất cả'), findsNWidgets(2)); // CEFR All + Genre All
  });

  testWidgets('hides pill shimmers when loading finishes with empty categories', (tester) async {
    await tester.pumpWidget(
      _wrapFilterSection(
        categories: const [],
        isCategoriesLoading: false,
      ),
    );

    expect(find.byKey(const ValueKey('genre_chips_loaded')), findsOneWidget);
    expect(find.byType(AppShimmer), findsNothing);
    expect(find.text('Tất cả'), findsNWidgets(2));
  });

  testWidgets('transitions from shimmer to loaded categories with left alignment', (tester) async {
    const categories = [
      VideoCategoryEntity(
        slug: 'music',
        label: 'Âm nhạc',
        shortLabel: 'Âm nhạc',
        shortLabels: {'en': 'Music', 'vi': 'Âm nhạc'},
        sortOrder: 10,
      ),
    ];

    await tester.pumpWidget(
      _wrapFilterSection(
        categories: const [],
        isCategoriesLoading: true,
      ),
    );
    expect(find.byType(AppShimmer), findsOneWidget);

    await tester.pumpWidget(
      _wrapFilterSection(
        categories: categories,
        isCategoriesLoading: false,
      ),
    );
    // Mid-transition: incoming loaded row stays left-aligned (not centered).
    await tester.pump(const Duration(milliseconds: 100));
    final loadedTopLeft = tester.getTopLeft(
      find.byKey(const ValueKey('genre_chips_loaded')),
    );
    expect(loadedTopLeft.dx, 0.0);

    await tester.pumpAndSettle();

    expect(find.byType(AppShimmer), findsNothing);
    expect(find.text('Âm nhạc'), findsOneWidget);
  });
}
