import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/core/di/injection.dart';
import 'package:vocabik_app/features/auth/domain/entities/user_session.dart';
import 'package:vocabik_app/features/profile/presentation/cubit/active_sessions_cubit.dart';
import 'package:vocabik_app/features/profile/presentation/cubit/active_sessions_state.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';

import 'session_item_widget.dart';

class ActiveSessionsCard extends StatelessWidget {
  const ActiveSessionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ActiveSessionsCubit>()..loadSessions(),
      child: const _ActiveSessionsCardContent(),
    );
  }
}

class _ActiveSessionsCardContent extends StatefulWidget {
  const _ActiveSessionsCardContent();

  @override
  State<_ActiveSessionsCardContent> createState() => _ActiveSessionsCardContentState();
}

class _ActiveSessionsCardContentState extends State<_ActiveSessionsCardContent> {
  bool _isExpanded = false;

  Widget _buildLoadingState(AppColorsExtension colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Center(
        child: SizedBox(
          width: 24.0,
          height: 24.0,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: colors.primaryAccent,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    String? message,
    AppColorsExtension colors,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message ?? l10n.securityTab_sessionLoadError,
          style: GoogleFonts.nunito(
            color: colors.textSecondary,
            fontSize: 14.0,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        GestureDetector(
          onTap: () => context.read<ActiveSessionsCubit>().loadSessions(),
          child: Text(
            l10n.securityTab_sessionRetry,
            style: GoogleFonts.nunito(
              color: colors.primaryAccent,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSessionsList(
    BuildContext context,
    List<UserSession> sessions,
    AppColorsExtension colors,
    AppLocalizations l10n,
  ) {
    if (sessions.isEmpty) {
      return Text(
        l10n.securityTab_sessionEmpty,
        style: GoogleFonts.nunito(
          color: colors.textSecondary,
          fontSize: 14.0,
        ),
      );
    }

    const maxCollapsedCount = 5;
    final bool canExpand = sessions.length > maxCollapsedCount;
    final displaySessions = (canExpand && !_isExpanded)
        ? sessions.take(maxCollapsedCount).toList()
        : sessions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...displaySessions.map((session) => SessionItemWidget(session: session)),
        if (canExpand) ...[
          const SizedBox(height: 8.0),
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                _isExpanded
                    ? l10n.securityTab_sessionShowLess
                    : l10n.securityTab_sessionShowMore(
                        sessions.length - maxCollapsedCount),
                style: GoogleFonts.nunito(
                  color: colors.primaryAccent,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.securityTab_activeSessionsTitle,
              style: GoogleFonts.nunito(
                color: colors.textPrimary,
                fontSize: 18.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16.0),
            BlocBuilder<ActiveSessionsCubit, ActiveSessionsState>(
              builder: (context, state) {
                switch (state.status) {
                  case ActiveSessionsStatus.initial:
                  case ActiveSessionsStatus.loading:
                    return _buildLoadingState(colors);
                  case ActiveSessionsStatus.failure:
                    return _buildErrorState(
                      context,
                      state.errorMessage,
                      colors,
                      l10n,
                    );
                  case ActiveSessionsStatus.success:
                    return _buildSessionsList(
                      context,
                      state.sessions,
                      colors,
                      l10n,
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
