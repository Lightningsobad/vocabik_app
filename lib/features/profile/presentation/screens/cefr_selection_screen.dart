import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/features/profile/presentation/cubit/cefr_selection_cubit.dart';
import 'package:vocabik_app/features/profile/presentation/cubit/cefr_selection_state.dart';
import 'package:vocabik_app/features/profile/presentation/widgets/cefr_card.dart';

class CefrSelectionScreen extends StatelessWidget {
  const CefrSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CefrSelectionCubit>(),
      child: const CefrSelectionScreenView(),
    );
  }
}

class CefrSelectionScreenView extends StatefulWidget {
  const CefrSelectionScreenView({super.key});

  @override
  State<CefrSelectionScreenView> createState() => _CefrSelectionScreenViewState();
}

class _CefrSelectionScreenViewState extends State<CefrSelectionScreenView> {
  void _selectLevel(String level) {
    context.read<CefrSelectionCubit>().selectLevel(level);
  }

  void _submitSelection() {
    context.read<CefrSelectionCubit>().submit();
  }

  void _skip() {
    context.go('/home'); // Or whatever the home route is
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>();
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<CefrSelectionCubit, CefrSelectionState>(
      listener: (context, state) {
        if (state.status == CefrSelectionStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Update failed')),
            );
        } else if (state.status == CefrSelectionStatus.success) {
          context.go('/home');
        }
      },
      child: Scaffold(
        backgroundColor: colors?.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              const SizedBox(height: AppSpacing.xl3),
              Text(
                l10n.whereIsYourEnglish,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colors?.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.weWillSuggest,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: colors?.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl3),
              
              // Grid for CEFR levels
              Expanded(
                child: BlocBuilder<CefrSelectionCubit, CefrSelectionState>(
                  builder: (context, state) {
                    return GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                      childAspectRatio: 0.9,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        CefrCard(
                          title: l10n.levelA1A2,
                          subtitle: l10n.levelA1A2Desc,
                          emoji: '🌱',
                          isSelected: state.selectedLevel == 'A1',
                          onTap: () => _selectLevel('A1'),
                        ),
                        CefrCard(
                          title: l10n.levelB1,
                          subtitle: l10n.levelB1Desc,
                          emoji: '📖',
                          isSelected: state.selectedLevel == 'B1',
                          onTap: () => _selectLevel('B1'),
                        ),
                        CefrCard(
                          title: l10n.levelB2,
                          subtitle: l10n.levelB2Desc,
                          emoji: '🎯',
                          isSelected: state.selectedLevel == 'B2',
                          onTap: () => _selectLevel('B2'),
                        ),
                        CefrCard(
                          title: l10n.levelC1,
                          subtitle: l10n.levelC1Desc,
                          emoji: '🚀',
                          isSelected: state.selectedLevel == 'C1',
                          onTap: () => _selectLevel('C1'),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Start Learning Button
              BlocBuilder<CefrSelectionCubit, CefrSelectionState>(
                builder: (context, state) {
                  return BounceWrapper(
                    onTap: state.selectedLevel != null && state.status != CefrSelectionStatus.loading
                        ? _submitSelection
                        : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: state.selectedLevel != null 
                            ? colors?.primaryAccent
                            : colors?.borderSubtle ?? Colors.grey.shade300, // Disabled state
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      alignment: Alignment.center,
                      child: state.status == CefrSelectionStatus.loading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: colors?.onPrimaryAccent ?? Colors.white, strokeWidth: 2),
                            )
                          : Text(
                              l10n.startLearning,
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: state.selectedLevel != null 
                                    ? colors?.onPrimaryAccent 
                                    : colors?.textSecondary,
                              ),
                            ),
                    ),
                  );
                },
              ),

              const SizedBox(height: AppSpacing.lg),

              // Skip Button
              BounceWrapper(
                onTap: _skip,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    l10n.skipForNow,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colors?.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    ));
  }
}
