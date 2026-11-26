import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/features/discover/presentation/widgets/discover_filter_section.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/domain/entities/video_category_entity.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';

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
      MaterialApp(
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
                selectedGenre: '',
                onGenreChanged: (slug) => selectedGenre = slug,
                selectedDuration: '',
                onDurationChanged: (_) {},
                selectedExerciseType: '',
                onExerciseTypeChanged: (_) {},
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Âm nhạc'), findsOneWidget);
    expect(find.text('Thiếu nhi'), findsOneWidget);

    await tester.tap(find.text('Thiếu nhi'));
    expect(selectedGenre, 'kids');
  });
}
