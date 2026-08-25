import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vocabik_app/features/pricing/presentation/widgets/pricing_faq_item.dart';
import 'package:vocabik_app/features/pricing/presentation/widgets/pricing_plan_card.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/buttons/segmented_toggle.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class PricingScreen extends StatefulWidget {
  const PricingScreen({super.key});

  @override
  State<PricingScreen> createState() => _PricingScreenState();
}

class _PricingScreenState extends State<PricingScreen> {
  bool _isYearly = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    final freeFeatures = [
      l10n.pricingFreeFeat1,
      l10n.pricingFreeFeat2,
      l10n.pricingFreeFeat3,
      l10n.pricingFreeFeat4,
      l10n.pricingFreeFeat5,
    ];

    final premiumFeatures = [
      l10n.pricingPremiumFeat1,
      l10n.pricingPremiumFeat2,
      l10n.pricingPremiumFeat3,
      l10n.pricingPremiumFeat4,
      l10n.pricingPremiumFeat5,
      l10n.pricingPremiumFeat6,
      l10n.pricingPremiumFeat7,
    ];

    return Scaffold(
      backgroundColor: colors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Header Title & Subtitle
            Text(
              l10n.pricingTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.xl8,
                fontWeight: FontWeight.w900,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.pricingSubtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.custom(
                fontSize: AppFontSize.lg2,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // 2. Billing Toggle (Monthly / Yearly)
            SegmentedToggle<bool>(
              selectedValue: _isYearly,
              isExpanded: true,
              itemPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.lg,
              ),
              options: [
                SegmentedToggleOption(value: false, label: l10n.pricingMonthly),
                SegmentedToggleOption(value: true, label: l10n.pricingYearly),
              ],
              onChanged: (val) {
                setState(() {
                  _isYearly = val;
                });
              },
            ),
            const SizedBox(height: AppSpacing.xl3),

            // 3. Free Plan Card
            PricingPlanCard(
              type: PricingPlanType.free,
              title: l10n.pricingFreeTag,
              price: l10n.pricingFreeTitle,
              period: l10n.pricingFreeForever,
              features: freeFeatures,
              buttonText: l10n.pricingFreeBtn,
              onAction: () {
                // Free plan action
              },
            ),
            const SizedBox(height: AppSpacing.xl3),

            // 4. Premium Plan Card
            PricingPlanCard(
              type: PricingPlanType.premium,
              title: l10n.pricingPremiumTag,
              price: _isYearly
                  ? l10n.pricingPremiumPriceYearly
                  : l10n.pricingPremiumPriceMonthly,
              period: _isYearly
                  ? l10n.pricingPremiumPerYear
                  : l10n.pricingPremiumPerMonth,
              popularBadgeText: l10n.pricingPremiumMostPopular,
              features: premiumFeatures,
              buttonText: l10n.pricingPremiumBtn,
              bottomNote: l10n.pricingCancelAnytime,
              onAction: () {
                // Start premium action
              },
            ),
            const SizedBox(height: AppSpacing.xl),

            // 5. Trust / Security Badges
            _buildTrustBadges(colors, l10n),
            const SizedBox(height: AppSpacing.xl4),

            // 6. Frequently Asked Questions Title
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.pricingFaqTitle,
                style: AppTextStyles.custom(
                  fontSize: AppFontSize.xl4,
                  fontWeight: FontWeight.w900,
                  color: colors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // 7. FAQ items
            PricingFaqItem(
              question: l10n.pricingFaq1Q,
              answer: l10n.pricingFaq1A,
            ),
            const SizedBox(height: AppSpacing.md),
            PricingFaqItem(
              question: l10n.pricingFaq2Q,
              answer: l10n.pricingFaq2A,
            ),
            const SizedBox(height: AppSpacing.md),
            PricingFaqItem(
              question: l10n.pricingFaq3Q,
              answer: l10n.pricingFaq3A,
            ),
            const SizedBox(height: AppSpacing.md),
            PricingFaqItem(
              question: l10n.pricingFaq4Q,
              answer: l10n.pricingFaq4A,
            ),

            // Extra padding at bottom
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustBadges(AppColorsExtension colors, AppLocalizations l10n) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBadgeItem(
              iconPath: 'assets/pricing_screen/lock_icon.svg',
              text: l10n.pricingBadgeSecure,
              colors: colors,
            ),
            const SizedBox(width: AppSpacing.xl),
            _buildBadgeItem(
              iconPath: 'assets/pricing_screen/cancel_icon.svg',
              text: l10n.pricingBadgeCancel,
              colors: colors,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBadgeItem(
              iconPath: 'assets/pricing_screen/earth_icon.svg',
              text: l10n.pricingBadgeCard,
              colors: colors,
            ),
            const SizedBox(width: AppSpacing.xl),
            _buildBadgeItem(
              iconPath: 'assets/pricing_screen/support_24h_icon.svg',
              text: l10n.pricingBadgeSupport,
              colors: colors,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBadgeItem({
    required String iconPath,
    required String text,
    required AppColorsExtension colors,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(iconPath, width: 16, height: 16),
        const SizedBox(width: AppSpacing.xs),
        Text(
          text,
          style: AppTextStyles.custom(
            fontSize: AppFontSize.mdt,
            fontWeight: FontWeight.w700,
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }
}
