import 'package:flutter/material.dart';
import 'package:vocabik_app/shared/presentation/widgets/buttons/primary_button.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

enum PricingPlanType { free, premium }

class PricingPlanCard extends StatelessWidget {
  final PricingPlanType type;
  final String title;
  final String price;
  final String period;
  final List<String> features;
  final String buttonText;
  final String? popularBadgeText;
  final String? bottomNote;
  final VoidCallback onAction;

  const PricingPlanCard({
    super.key,
    required this.type,
    required this.title,
    required this.price,
    required this.period,
    required this.features,
    required this.buttonText,
    this.popularBadgeText,
    this.bottomNote,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final isPremium = type == PricingPlanType.premium;

    final checkColor = isPremium ? colors.premiumBackground : colors.success;
    final borderColor = isPremium
        ? colors.premiumBackground
        : colors.borderSubtle;
    final badgeLabelColor = isPremium
        ? colors.premiumBackground
        : colors.textSecondary;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.xl1),
          decoration: BoxDecoration(
            color: colors.surfaceCard,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: borderColor, width: 0.5),
            boxShadow: isPremium
                ? [
                    BoxShadow(
                      color: colors.premiumBackground.withValues(alpha: 0.5),
                      blurRadius: 32,
                      spreadRadius: 0,
                      offset: const Offset(0, 0),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Tag name
              Text(
                title,
                style: AppTextStyles.custom(
                  fontSize: AppFontSize.sm,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  height: 1.75,
                  color: badgeLabelColor,
                ),
              ),
              const SizedBox(height: AppSpacing.tnn),

              // 2. Price section
              if (isPremium)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      price,
                      style: AppTextStyles.custom(
                        fontSize: AppFontSize.xl8,
                        fontWeight: FontWeight.w900,
                        color: colors.textPrimary,
                      ),
                    ),
                    if (period.isNotEmpty) ...[
                      const SizedBox(width: AppSpacing.tn),
                      Text(
                        period,
                        style: AppTextStyles.custom(
                          fontSize: AppFontSize.lg,
                          fontWeight: FontWeight.w700,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      price,
                      style: AppTextStyles.custom(
                        fontSize: AppFontSize.xl8,
                        fontWeight: FontWeight.w900,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.tn),
                    if (period.isNotEmpty)
                      Text(
                        period,
                        style: AppTextStyles.custom(
                          fontSize: AppFontSize.mdt,
                          fontWeight: FontWeight.w600,
                          color: colors.textSecondary,
                        ),
                      ),
                  ],
                ),
              const SizedBox(height: AppSpacing.xl),

              // 3. Features list
              ...features.map((feature) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '✓',
                        style: TextStyle(
                          color: checkColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w100,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          feature,
                          style: AppTextStyles.custom(
                            fontSize: AppFontSize.lg,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: AppSpacing.lg2),

              // 4. Action button
              if (isPremium)
                PrimaryButton(
                  text: buttonText,
                  backgroundColor: colors.logoUnderline,
                  textColor: Colors.white,
                  onPressed: onAction,
                )
              else
                PrimaryButton(
                  text: buttonText,
                  variant: PrimaryButtonVariant.secondary,
                  backgroundColor: colors.tabUnselectedBackground,
                  textStyle: AppTextStyles.custom(
                    color: colors.textPrimary,
                    fontSize: AppFontSize.lg2,
                    fontWeight: FontWeight.w800,
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: AppSpacing.md,
                    horizontal: AppSpacing.lg2,
                  ),
                  border: Border.all(color: colors.optionCardBorder, width: 1),
                  onPressed: onAction,
                ),

              // 5. Bottom note if any (e.g. Cancel anytime)
              if (bottomNote != null) ...[
                const SizedBox(height: AppSpacing.sm2),
                Center(
                  child: Text(
                    bottomNote!,
                    style: AppTextStyles.custom(
                      fontSize: AppFontSize.mdt,
                      fontWeight: FontWeight.w600,
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        // MOST POPULAR Floating Badge
        if (isPremium && popularBadgeText != null)
          Positioned(
            top: -12,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md2,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colors.premiumBackground,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: colors.premiumBackground.withValues(alpha: 0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  popularBadgeText!,
                  style: AppTextStyles.custom(
                    fontSize: AppFontSize.tnn,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
