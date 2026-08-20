import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/presentation/widgets/interactions/bounce_wrapper.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/classroom_entity.dart';

class ClassroomCard extends StatelessWidget {
  final ClassroomEntity classroom;
  final VoidCallback onTap;

  const ClassroomCard({
    super.key,
    required this.classroom,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    final assignmentText = classroom.recentAssignmentTitle != null &&
            classroom.recentAssignmentTitle!.isNotEmpty
        ? l10n.assignmentLabel(classroom.recentAssignmentTitle!)
        : l10n.assignmentLabel(l10n.noAssignmentYet);

    final hasProgress = classroom.assignmentProgressCurrent != null &&
        classroom.assignmentProgressTotal != null &&
        classroom.assignmentProgressTotal! > 0;

    return BounceWrapper(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: colors.borderSubtle,
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    classroom.name,
                    style: GoogleFonts.nunito(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w800,
                      color: colors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  l10n.studentsCount(classroom.studentCount),
                  style: GoogleFonts.nunito(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w600,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              assignmentText,
              style: GoogleFonts.nunito(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (hasProgress) ...[
              const SizedBox(height: 12.0),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: LinearProgressIndicator(
                        value: (classroom.assignmentProgressCurrent! /
                                classroom.assignmentProgressTotal!)
                            .clamp(0.0, 1.0),
                        minHeight: 6.0,
                        backgroundColor: colors.inputBackground,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(colors.primaryAccent),
                      ),
                    ),
                  ),
                  if (classroom.assignmentDueDate != null) ...[
                    const SizedBox(width: 12.0),
                    Text(
                      l10n.assignmentDue(
                        classroom.assignmentProgressCurrent!,
                        classroom.assignmentProgressTotal!,
                        classroom.assignmentDueDate!,
                      ),
                      style: GoogleFonts.nunito(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
