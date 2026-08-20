import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/di/injection.dart';
import '../../../../shared/presentation/widgets/app_shimmer.dart';
import '../../../../shared/presentation/widgets/interactions/bounce_wrapper.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/classroom_list_cubit.dart';
import '../cubit/classroom_list_state.dart';
import '../widgets/classroom_card.dart';
import '../widgets/create_classroom_dialog.dart';

class MyClassroomsScreen extends StatelessWidget {
  const MyClassroomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ClassroomListCubit>()..fetchClassrooms(),
      child: const _MyClassroomsView(),
    );
  }
}

class _MyClassroomsView extends StatelessWidget {
  const _MyClassroomsView();

  void _showCreateDialog(BuildContext context) {
    final cubit = context.read<ClassroomListCubit>();
    final l10n = AppLocalizations.of(context)!;

    CreateClassroomDialog.show(
      context,
      onSubmit: (name) async {
        final success = await cubit.createClassroom(name);
        if (success && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n.createSuccess,
                style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return success;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: 88.0 + MediaQuery.paddingOf(context).bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              // Header Row: Title + "+ New class" Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          if (Navigator.canPop(context)) ...[
                            BounceWrapper(
                              onTap: () => context.pop(),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: colors.textPrimary,
                                  size: 24.0,
                                ),
                              ),
                            ),
                          ],
                          Flexible(
                            child: Text(
                              l10n.myClassrooms,
                              style: GoogleFonts.nunito(
                                fontSize: 26.0,
                                fontWeight: FontWeight.w900,
                                color: colors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    BounceWrapper(
                      onTap: () => _showCreateDialog(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 9.0,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primaryAccent,
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        child: Text(
                          l10n.newClass,
                          style: GoogleFonts.nunito(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w800,
                            color: colors.onPrimaryAccent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              // List view / state
              Expanded(
                child: BlocBuilder<ClassroomListCubit, ClassroomListState>(
                  builder: (context, state) {
                    if (state.status == ClassroomListStatus.loading &&
                        state.classrooms.isEmpty) {
                      return _buildLoadingSkeleton(colors);
                    }

                    if (state.status == ClassroomListStatus.error &&
                        state.classrooms.isEmpty) {
                      return _buildErrorState(context, state.errorMessage ?? '', colors);
                    }

                    if (state.status == ClassroomListStatus.loaded &&
                        state.classrooms.isEmpty) {
                      return _buildEmptyState(context, colors);
                    }

                    return RefreshIndicator(
                      onRefresh: () =>
                          context.read<ClassroomListCubit>().fetchClassrooms(),
                      color: colors.primaryAccent,
                      backgroundColor: colors.surfaceCard,
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: state.classrooms.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 14.0),
                        itemBuilder: (context, index) {
                          final classroom = state.classrooms[index];
                          return ClassroomCard(
                            classroom: classroom,
                            onTap: () {
                              context.push(
                                '/profile/classrooms/${classroom.id}',
                                extra: classroom,
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton(AppColorsExtension colors) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: 3,
      separatorBuilder: (context, index) => const SizedBox(height: 14.0),
      itemBuilder: (context, index) {
        return AppShimmer(
          child: Container(
            height: 100.0,
            decoration: BoxDecoration(
              color: colors.surfaceCard,
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    String message,
    AppColorsExtension colors,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return RefreshIndicator(
      onRefresh: () => context.read<ClassroomListCubit>().fetchClassrooms(),
      color: colors.primaryAccent,
      backgroundColor: colors.surfaceCard,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.all(24.0),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48.0,
                  color: colors.danger,
                ),
                const SizedBox(height: 12.0),
                Text(
                  message.isNotEmpty ? message : l10n.authGenericError,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16.0),
                BounceWrapper(
                  onTap: () =>
                      context.read<ClassroomListCubit>().fetchClassrooms(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: colors.tabUnselectedBackground,
                      borderRadius: BorderRadius.circular(100.0),
                      border: Border.all(color: colors.tabUnselectedBorder),
                    ),
                    child: Text(
                      l10n.homeRetry,
                      style: GoogleFonts.nunito(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppColorsExtension colors) {
    final l10n = AppLocalizations.of(context)!;

    return RefreshIndicator(
      onRefresh: () => context.read<ClassroomListCubit>().fetchClassrooms(),
      color: colors.primaryAccent,
      backgroundColor: colors.surfaceCard,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.all(32.0),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.school_outlined,
                  size: 64.0,
                  color: colors.textSecondary.withValues(alpha: 0.4),
                ),
                const SizedBox(height: 16.0),
                Text(
                  l10n.emptyClassrooms,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20.0),
                BounceWrapper(
                  onTap: () => _showCreateDialog(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primaryAccent,
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    child: Text(
                      l10n.newClass,
                      style: GoogleFonts.nunito(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w800,
                        color: colors.onPrimaryAccent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
