import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';

import 'integration_platform_card.dart';

class IntegrationContentView extends StatelessWidget {
  const IntegrationContentView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      color: colors.background,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: AppSpacing.xl10 + MediaQuery.paddingOf(context).bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Header Row with Back Button
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.paddingOf(context).top + AppSpacing.xl,
                  left: AppSpacing.lg,
                  right: AppSpacing.lg,
                ),
                child: Row(
                  children: [
                    BounceWrapper(
                      onTap: () {
                        if (context.canPop()) {
                          context.pop();
                        }
                      },
                      child: Container(
                        width: AppSpacing.xl5,
                        height: AppSpacing.xl5,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colors.surfaceCard,
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.borderSubtle),
                        ),
                        child: Icon(
                          LucideIcons.arrowLeft,
                          color: colors.textPrimary,
                          size: AppSpacing.xl,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      l10n.integrationScreenTitle,
                      style: GoogleFonts.nunito(
                        color: colors.textPrimary,
                        fontSize: AppSpacing.xl2,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Platform Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  children: [
                    IntegrationPlatformCard(
                      icon: const _TelegramIcon(),
                      title: l10n.integrationTelegramTitle,
                      description: l10n.integrationTelegramDesc,
                      instructions: [
                        l10n.instructionConnectLabel,
                        l10n.instructionStartLabel,
                        l10n.instructionAutoConnectLabel,
                      ],
                      showConfig: true,
                    ),
                    IntegrationPlatformCard(
                      icon: const _ZaloIcon(),
                      title: l10n.integrationZaloTitle,
                      description: l10n.integrationZaloDesc,
                      showConfig: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class _TelegramIcon extends StatelessWidget {
  const _TelegramIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.xl5,
      height: AppSpacing.xl5,
      decoration: BoxDecoration(
        color: const Color(0xFF229ED9),
        borderRadius: BorderRadius.circular(AppSpacing.lg),
      ),
      child: const Icon(
        Icons.send_rounded,
        color: Colors.white,
        size: AppSpacing.xl,
      ),
    );
  }
}

class _ZaloIcon extends StatelessWidget {
  const _ZaloIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.xl5,
      height: AppSpacing.xl5,
      decoration: BoxDecoration(
        color: const Color(0xFF0068FF),
        borderRadius: BorderRadius.circular(AppSpacing.lg),
      ),
      alignment: Alignment.center,
      child: Text(
        "Z",
        style: GoogleFonts.nunito(
          color: Colors.white,
          fontSize: AppSpacing.xl,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
