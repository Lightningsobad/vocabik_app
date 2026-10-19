import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/presentation/widgets/buttons/primary_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vocabik_app/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:vocabik_app/features/profile/presentation/cubit/cefr_selection_cubit.dart';
import 'package:vocabik_app/features/profile/presentation/cubit/cefr_selection_state.dart';
import 'package:vocabik_app/features/profile/presentation/widgets/cefr_card.dart';
import 'package:vocabik_app/features/profile/presentation/widgets/delete_account_confirmation_dialog.dart';

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
  State<CefrSelectionScreenView> createState() =>
      _CefrSelectionScreenViewState();
}

class _CefrSelectionScreenViewState extends State<CefrSelectionScreenView> {
  void _selectLevel(String level) {
    context.read<CefrSelectionCubit>().selectLevel(level);
  }

  void _submitSelection() {
    context.read<CefrSelectionCubit>().submit();
  }

  void _skip() {
    context.read<CefrSelectionCubit>().skip();
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
              SnackBar(content: Text(state.errorMessage ?? l10n.updateFailed)),
            );
        } else if (state.status == CefrSelectionStatus.success) {
          context.go('/home');
        }
      },
      child: AuthScaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.lg,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.whereIsYourEnglish,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: colors?.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.weWillSuggest,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colors?.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl3),

                  // Grid for CEFR levels
                  BlocBuilder<CefrSelectionCubit, CefrSelectionState>(
                    builder: (context, state) {
                      return GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: AppSpacing.md,
                        mainAxisSpacing: AppSpacing.md,
                        childAspectRatio: 1.0,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          CefrCard(
                            title: l10n.levelA1A2,
                            subtitle: l10n.levelA1A2Desc,
                            iconPath: 'assets/cefr_screen/a1_a2_icon.svg',
                            isSelected: state.selectedLevel == 'A1',
                            onTap: () => _selectLevel('A1'),
                          ),
                          CefrCard(
                            title: l10n.levelB1,
                            subtitle: l10n.levelB1Desc,
                            iconPath: 'assets/cefr_screen/b1_icon.svg',
                            isSelected: state.selectedLevel == 'B1',
                            onTap: () => _selectLevel('B1'),
                          ),
                          CefrCard(
                            title: l10n.levelB2,
                            subtitle: l10n.levelB2Desc,
                            iconPath: 'assets/cefr_screen/b2_icon.svg',
                            isSelected: state.selectedLevel == 'B2',
                            onTap: () => _selectLevel('B2'),
                          ),
                          CefrCard(
                            title: l10n.levelC1,
                            subtitle: l10n.levelC1Desc,
                            iconPath: 'assets/cefr_screen/c1_icon.svg',
                            isSelected: state.selectedLevel == 'C1',
                            onTap: () => _selectLevel('C1'),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: AppSpacing.xl3),

                  // Start Learning Button
                  BlocBuilder<CefrSelectionCubit, CefrSelectionState>(
                    builder: (context, state) {
                      return PrimaryButton(
                        text: l10n.startLearning,
                        isLoading: state.status == CefrSelectionStatus.loading,
                        onPressed:
                            state.selectedLevel != null &&
                                state.status != CefrSelectionStatus.loading
                            ? _submitSelection
                            : null,
                      );
                    },
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // Skip Button
                  BounceWrapper(
                    onTap: _skip,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                      ),
                      child: Text(
                        l10n.skipForNow,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: colors?.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Actions: Sign out / Delete account
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      BounceWrapper(
                        onTap: () {
                          context.read<AuthBloc>().add(LogoutRequested());
                          context.go('/login');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                            vertical: AppSpacing.xs,
                          ),
                          child: Text(
                            l10n.accountLogOut,
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: colors?.textSecondary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        '•',
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          color: colors?.textSecondary,
                        ),
                      ),
                      BounceWrapper(
                        onTap: () => DeleteAccountConfirmationDialog.show(context),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                            vertical: AppSpacing.xs,
                          ),
                          child: Text(
                            l10n.accountDeletePermanently,
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: colors?.danger ?? Colors.red,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Legal Links
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      BounceWrapper(
                        onTap: () => context.push('/terms-of-service'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                            vertical: AppSpacing.xs,
                          ),
                          child: Text(
                            l10n.termsText,
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: colors?.textSecondary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        '•',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: colors?.textSecondary,
                        ),
                      ),
                      BounceWrapper(
                        onTap: () => context.push('/privacy-policy'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                            vertical: AppSpacing.xs,
                          ),
                          child: Text(
                            l10n.securityText,
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: colors?.textSecondary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
