import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class SubscriptionTabContent extends StatelessWidget {
  const SubscriptionTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [_FreePlanCard()],
      ),
    );
  }
}

class _FreePlanCard extends StatelessWidget {
  const _FreePlanCard();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg2),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg2),
        border: Border.all(color: colors.borderSubtle, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header gói: Icon + Tiêu đề
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/profile_screen/free_icon.svg',
                width: 28.0,
                height: 28.0,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.subscriptionFreePlanTitle,
                  style: AppTextStyles.custom(
                    fontSize: AppFontSize.xl3,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Mô tả gói cước
          Text(
            l10n.subscriptionFreePlanDesc,
            style: AppTextStyles.custom(
              fontSize: AppFontSize.lg,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg2),

          // Nút Nâng lên Premium
          const Align(
            alignment: Alignment.centerLeft,
            child: _PremiumUpgradeButton(),
          ),
        ],
      ),
    );
  }
}

class _PremiumUpgradeButton extends StatelessWidget {
  const _PremiumUpgradeButton();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return BounceWrapper(
      onTap: () => context.push('/profile/pricing'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: colors.premiumBackground,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Text(
          l10n.subscriptionUpgradeBtn,
          style: AppTextStyles.custom(
            fontSize: AppFontSize.lg2,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
