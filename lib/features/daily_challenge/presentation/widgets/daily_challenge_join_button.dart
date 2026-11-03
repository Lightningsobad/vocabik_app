import 'package:flutter/material.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/buttons/primary_button.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class DailyChallengeJoinButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isCompleted;

  const DailyChallengeJoinButton({
    super.key,
    required this.onTap,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: PrimaryButton(
        text: l10n.dailyChallengeJoinNow,
        textStyle: AppTextStyles.custom(
          fontWeight: FontWeight.w800,
          fontSize: AppFontSize.xl,
        ),
        padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
        onPressed: onTap,
      ),
    );
  }
}
