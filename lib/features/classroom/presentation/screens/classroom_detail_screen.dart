import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/di/injection.dart';
import '../../../../shared/presentation/widgets/interactions/bounce_wrapper.dart';
import '../../../../shared/presentation/widgets/shared_segmented_tab_bar.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/classroom_entity.dart';
import '../cubit/classroom_detail_cubit.dart';
import '../cubit/classroom_detail_state.dart';
import '../widgets/classroom_empty_tab_view.dart';
import '../widgets/join_code_card.dart';

class ClassroomDetailScreen extends StatelessWidget {
  final String id;
  final ClassroomEntity? classroom;

  const ClassroomDetailScreen({
    super.key,
    required this.id,
    this.classroom,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = getIt<ClassroomDetailCubit>();
        cubit.init(classroom);
        if (classroom == null) {
          cubit.fetchClassroom(id);
        }
        return cubit;
      },
      child: const _ClassroomDetailView(),
    );
  }
}

class _ClassroomDetailView extends StatelessWidget {
  const _ClassroomDetailView();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        top: false,
        child: BlocBuilder<ClassroomDetailCubit, ClassroomDetailState>(
          builder: (context, state) {
            if (state.status == ClassroomDetailStatus.loading &&
                state.classroom == null) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(colors.primaryAccent),
                ),
              );
            }

            if (state.status == ClassroomDetailStatus.error &&
                state.classroom == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48.0, color: colors.danger),
                      const SizedBox(height: 12.0),
                      Text(
                        state.errorMessage ?? l10n.authGenericError,
                        style: GoogleFonts.nunito(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                          color: colors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      BounceWrapper(
                        onTap: () => context.pop(),
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
                            l10n.videoDetailBack,
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
              );
            }

            final classroom = state.classroom;
            if (classroom == null) {
              return const SizedBox.shrink();
            }

            final tabs = [
              l10n.studentsTabTitle(classroom.studentCount),
              l10n.assignments,
              l10n.statistics,
            ];

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                bottom: 88.0 + MediaQuery.paddingOf(context).bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),
                  // Back button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: BounceWrapper(
                      onTap: () => context.pop(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            size: 18.0,
                            color: colors.textSecondary,
                          ),
                          const SizedBox(width: 6.0),
                          Text(
                            l10n.myClassrooms,
                            style: GoogleFonts.nunito(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  // Classroom Name
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      classroom.name,
                      style: GoogleFonts.nunito(
                        fontSize: 28.0,
                        fontWeight: FontWeight.w900,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Join Code Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: JoinCodeCard(joinCode: classroom.joinCode),
                  ),
                  const SizedBox(height: 20.0),
                  // Segmented Tab Bar
                  SharedSegmentedTabBar(
                    selectedIndex: state.selectedTabIndex,
                    onTabChanged: (index) {
                      context.read<ClassroomDetailCubit>().setTabIndex(index);
                    },
                    tabs: tabs,
                  ),
                  const SizedBox(height: 16.0),
                  // Tab View Content (Initially shows empty state since API is not yet available)
                  if (state.selectedTabIndex == 0) ...[
                    const ClassroomEmptyTabView(),
                  ] else if (state.selectedTabIndex == 1) ...[
                    const ClassroomEmptyTabView(),
                  ] else if (state.selectedTabIndex == 2) ...[
                    const ClassroomEmptyTabView(),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
