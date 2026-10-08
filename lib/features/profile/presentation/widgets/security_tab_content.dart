import 'package:flutter/material.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'active_sessions_card.dart';

class SecurityTabContent extends StatelessWidget {
  const SecurityTabContent({super.key});

  @override
  Widget build(BuildContext context) {

    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ActiveSessionsCard(),
        ],
      ),
    );
  }
}
