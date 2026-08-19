import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/exercise_cubit.dart';
import 'package:vocabik_app/features/exercise/presentation/cubit/exercise_state.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';

class ExerciseHintButton extends StatelessWidget {
  final EdgeInsetsGeometry? padding;

  const ExerciseHintButton({super.key, this.padding});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<ExerciseCubit, ExerciseState>(
      buildWhen: (previous, current) {
        if (previous is ExerciseLoaded && current is ExerciseLoaded) {
          return previous.hintUsedForCurrentBlank != current.hintUsedForCurrentBlank ||
              previous.currentBlankIndex != current.currentBlankIndex;
        }
        return previous.runtimeType != current.runtimeType;
      },
      builder: (context, state) {
        final isHintUsed = state is ExerciseLoaded && state.hintUsedForCurrentBlank;

        return Opacity(
          opacity: isHintUsed ? 0.4 : 1.0,
          child: BounceWrapper(
            onTap: isHintUsed
                ? null
                : () {
                    context.read<ExerciseCubit>().useHint();
                  },
            child: Container(
              padding: padding ??
                  const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
              decoration: BoxDecoration(
                color: colors.optionCardBackground,
                border: Border.all(
                  color: colors.optionCardBorder,
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('💡 ', style: TextStyle(fontSize: 14)),
                  Text(
                    l10n?.exerciseHint.replaceAll('💡', '').trim() ?? 'Gợi ý',
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFBBF24),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
