import 'package:flutter/material.dart';
import 'package:vocabik_app/shared/presentation/widgets/header/app_header.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: const Center(
                child: Text('Discover Screen Content'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
