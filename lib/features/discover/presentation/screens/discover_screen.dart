import 'package:flutter/material.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: Text(l10n.discoverScreenContent),
      ),
    );
  }
}
