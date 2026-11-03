import 'package:flutter/material.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class DiscoverErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const DiscoverErrorState({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl4),
          child: Column(
            children: [
              Text(
                l10n.discoverErrorLoad,
                style: AppTextStyles.custom(
                  color: colors.textSecondary,
                  fontSize: AppFontSize.md,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              BounceWrapper(
                onTap: onRetry,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primaryAccent,
                    borderRadius: BorderRadius.circular(999.0),
                  ),
                  child: Text(
                    l10n.discoverRetryButton,
                    style: AppTextStyles.custom(
                      color: colors.onPrimaryAccent,
                      fontSize: AppFontSize.md,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
