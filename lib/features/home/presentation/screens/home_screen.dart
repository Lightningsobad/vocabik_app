import 'package:flutter/material.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/header/app_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const AppHeader(
              streak: 12,
              xp: 1240,
              currentLanguageCode: 'vi',
            ),
            Expanded(
              child: Center(
                child: Text(l10n.homeScreenContent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
