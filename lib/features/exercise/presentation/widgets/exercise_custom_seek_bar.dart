import 'package:flutter/material.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/exercise_state.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';

class ExerciseCustomSeekBar extends StatelessWidget {
  final int currentPositionMs;
  final int totalDurationMs;
  final ExerciseLoaded? exerciseState;
  final ValueChanged<double> onSeek;

  const ExerciseCustomSeekBar({
    super.key,
    required this.currentPositionMs,
    required this.totalDurationMs,
    required this.exerciseState,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final primaryColor = colors.primaryAccent;
    final dangerColor = colors.danger;
    final trackColor = colors.videoSeekBarTrack;
    final progressColor = colors.videoSeekBarProgress;

    final state = exerciseState;
    final checkResults = state?.checkResults ?? const {};
    final currentBlankIndex = state?.currentBlankIndex ?? 0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final barWidth = constraints.maxWidth;
        final duration = totalDurationMs > 0 ? totalDurationMs : 1;
        final progressRatio = (currentPositionMs / duration).clamp(0.0, 1.0);
        final currentBarWidth = progressRatio * barWidth;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragUpdate: (details) {
            final localX = details.localPosition.dx.clamp(0.0, barWidth);
            onSeek(localX / barWidth);
          },
          onTapDown: (details) {
            final localX = details.localPosition.dx.clamp(0.0, barWidth);
            onSeek(localX / barWidth);
          },
          child: Container(
            height: 24, // Touch target height
            alignment: Alignment.center,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.centerLeft,
              children: [
                // Background Track
                Container(
                  width: barWidth,
                  height: 4,
                  decoration: BoxDecoration(
                    color: trackColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Played Progress Bar
                Container(
                  width: currentBarWidth,
                  height: 4,
                  decoration: BoxDecoration(
                    color: progressColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Stop Point Dots
                if (state != null)
                  ...state.exercise.blanks.map((blank) {
                    final blankIndex = blank.blankIndex;
                    final endMs = state.blankEndMsMap[blankIndex] ?? 0;
                    final dotFraction = (endMs / duration).clamp(0.0, 1.0);
                    final dotX = dotFraction * barWidth;

                    final isAnswered = checkResults.containsKey(blankIndex);
                    final isCorrect = checkResults[blankIndex] == true;
                    final isActive = blankIndex == currentBlankIndex;

                    Color dotColor;
                    Color borderColor = Colors.transparent;
                    double dotSize = 9.0;

                    if (isAnswered) {
                      if (isCorrect) {
                        dotColor = primaryColor;
                      } else {
                        dotColor = dangerColor;
                      }
                    } else if (isActive) {
                      dotColor = colors.videoSeekBarDotActive;
                      borderColor = primaryColor;
                      dotSize = 11.0;
                    } else {
                      dotColor = colors.videoSeekBarDotInactive;
                    }

                    return Positioned(
                      left: dotX - (dotSize / 2),
                      child: Container(
                        width: dotSize,
                        height: dotSize,
                        decoration: BoxDecoration(
                          color: dotColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: borderColor != Colors.transparent
                                ? borderColor
                                : colors.videoSeekBarDotBorder,
                            width: isActive ? 2.0 : 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colors.cardShadowColor,
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),
        );
      },
    );
  }
}
