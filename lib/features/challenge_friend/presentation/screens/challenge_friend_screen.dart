import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/presentation/widgets/interactions/bounce_wrapper.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_font_size.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_text_style.dart';
import '../cubit/challenge_friend_cubit.dart';
import '../cubit/challenge_friend_state.dart';
import '../models/challenge_friend_args.dart';
import '../models/challenge_sent_args.dart';
import '../widgets/challenge_exercise_summary_card.dart';
import '../widgets/friend_selection_tile.dart';

class ChallengeFriendScreen extends StatelessWidget {
  final ChallengeFriendArgs args;

  const ChallengeFriendScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ChallengeFriendCubit>()..loadFriends(),
      child: ChallengeFriendView(args: args),
    );
  }
}

class ChallengeFriendView extends StatefulWidget {
  final ChallengeFriendArgs args;

  const ChallengeFriendView({super.key, required this.args});

  @override
  State<ChallengeFriendView> createState() => _ChallengeFriendViewState();
}

class _ChallengeFriendViewState extends State<ChallengeFriendView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<ChallengeFriendCubit, ChallengeFriendState>(
      listenWhen: (previous, current) =>
          previous.createdChallengeLink != current.createdChallengeLink ||
          previous.sendErrorMessage != current.sendErrorMessage,
      listener: (context, state) {
        if (state.createdChallengeLink != null) {
          context.go(
            '/home/challenge-sent',
            extra: ChallengeSentArgs(
              challengeLink: state.createdChallengeLink!,
              selectedFriends: state.selectedFriends.toList(),
              videoTitle: widget.args.videoTitle,
              accuracyScore: widget.args.accuracyScore,
            ),
          );
        } else if (state.sendErrorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.sendErrorMessage ?? l10n.challengeCreateLinkError,
                style: AppTextStyles.custom(
                  color: Colors.white,
                  fontSize: AppFontSize.md,
                ),
              ),
              backgroundColor: colors.danger,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<ChallengeFriendCubit>();
        final selectedCount = state.selectedFriends.length;
        final hasSelection = selectedCount > 0;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.sm),

                    // Back Button Pill
                    _buildBackButton(context, colors),
                    const SizedBox(height: AppSpacing.md),

                    // Header: Swords Icon + Title
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/result_screen/challenge_icon.svg',
                          width: 28,
                          height: 28,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            l10n.challengeFriendTitle,
                            style: AppTextStyles.custom(
                              fontSize: AppFontSize.xl2,
                              fontWeight: FontWeight.w800,
                              color: colors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),

                    // Subtitle
                    Text(
                      l10n.challengeFriendSubtitle,
                      style: AppTextStyles.custom(
                        fontSize: AppFontSize.md,
                        fontWeight: FontWeight.w500,
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Exercise Summary Card
                    ChallengeExerciseSummaryCard(
                      videoTitle: widget.args.videoTitle,
                      artist: widget.args.artist,
                      cefrLevel: widget.args.exercise.cefrLevel,
                      blanksCount: widget.args.exercise.blanks.length,
                      accuracyScore: widget.args.accuracyScore,
                      youtubeVideoId: widget.args.youtubeVideoId,
                    ),
                    const SizedBox(height: AppSpacing.md2),

                    // Search Friends Bar
                    _buildSearchBar(colors, l10n, cubit),
                    const SizedBox(height: AppSpacing.lg),

                    // Friends Section Title & Count
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.challengeFriendsSection,
                          style: AppTextStyles.custom(
                            fontSize: AppFontSize.sm,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: colors.textSecondary,
                          ),
                        ),
                        Text(
                          hasSelection
                              ? l10n.challengeSelectedCount(selectedCount)
                              : l10n.challengePickAtLeastOne,
                          style: AppTextStyles.custom(
                            fontSize: AppFontSize.sm,
                            fontWeight: FontWeight.w600,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm2),

                    // Friends List Content
                    _buildFriendsContent(context, state, cubit, colors, l10n),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Bar
            _buildBottomBar(context, state, cubit, colors, l10n),
          ],
        );
      },
    );
  }

  Widget _buildBackButton(BuildContext context, AppColorsExtension colors) {
    return BounceWrapper(
      onTap: () => context.pop(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1B1B2F),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.borderSubtle, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.chevronLeft, size: 16, color: colors.textPrimary),
            const SizedBox(width: 4),
            Text(
              'Back',
              style: AppTextStyles.custom(
                fontSize: AppFontSize.md,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(
    AppColorsExtension colors,
    AppLocalizations l10n,
    ChallengeFriendCubit cubit,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: colors.inputBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.inputBorder, width: 1),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: cubit.setSearchQuery,
        style: AppTextStyles.custom(
          fontSize: AppFontSize.md,
          color: colors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: l10n.challengeSearchFriendsHint,
          hintStyle: AppTextStyles.custom(
            fontSize: AppFontSize.md,
            color: colors.hintText,
          ),
          prefixIcon: Icon(
            LucideIcons.search,
            size: 20,
            color: colors.textSecondary,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18),
                  color: colors.textSecondary,
                  onPressed: () {
                    _searchController.clear();
                    cubit.setSearchQuery('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
        ),
      ),
    );
  }

  Widget _buildFriendsContent(
    BuildContext context,
    ChallengeFriendState state,
    ChallengeFriendCubit cubit,
    AppColorsExtension colors,
    AppLocalizations l10n,
  ) {
    if (state.status == ChallengeFriendStatus.loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.status == ChallengeFriendStatus.error) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: Center(
          child: Column(
            children: [
              Text(
                state.errorMessage ?? l10n.challengeLoadFriendsError,
                style: AppTextStyles.custom(
                  fontSize: AppFontSize.md,
                  color: colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: cubit.loadFriends,
                child: Text(
                  l10n.homeRetry,
                  style: AppTextStyles.custom(
                    fontWeight: FontWeight.bold,
                    color: colors.primaryAccent,
                    fontSize: AppFontSize.md,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final displayFriends = state.filteredFriends;

    if (displayFriends.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: Center(
          child: Text(
            l10n.challengeNoFriendsFound,
            style: AppTextStyles.custom(
              fontSize: AppFontSize.md,
              color: colors.textSecondary,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPreserver(),
      itemCount: displayFriends.length,
      itemBuilder: (context, index) {
        final friend = displayFriends[index];
        final isSelected = state.selectedFriends.contains(friend);
        return FriendSelectionTile(
          friend: friend,
          isSelected: isSelected,
          onTap: () => cubit.toggleFriend(friend),
        );
      },
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    ChallengeFriendState state,
    ChallengeFriendCubit cubit,
    AppColorsExtension colors,
    AppLocalizations l10n,
  ) {
    final selectedCount = state.selectedFriends.length;
    final isEnabled = selectedCount > 0 && !state.isSending;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(
          top: BorderSide(
            color: colors.borderSubtle.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: BounceWrapper(
          onTap: isEnabled ? () => cubit.sendChallenge(widget.args) : null,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: isEnabled ? colors.primaryAccent : const Color(0xFF1E1E34),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Center(
              child: state.isSending
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Color(0xFF0D0D1A),
                      ),
                    )
                  : Text(
                      selectedCount > 0
                          ? l10n.challengeSendWithCount(selectedCount)
                          : l10n.challengeSend,
                      style: AppTextStyles.custom(
                        fontSize: AppFontSize.lg,
                        fontWeight: FontWeight.w800,
                        color: isEnabled
                            ? const Color(0xFF0D0D1A)
                            : colors.textSecondary,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class NeverScrollableScrollPreserver extends ScrollPhysics {
  const NeverScrollableScrollPreserver({super.parent});

  @override
  NeverScrollableScrollPreserver applyTo(ScrollPhysics? ancestor) {
    return NeverScrollableScrollPreserver(parent: buildParent(ancestor));
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) => false;
}
