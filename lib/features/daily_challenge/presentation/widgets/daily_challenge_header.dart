import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class DailyChallengeHeader extends StatefulWidget {
  final DateTime? resetAt;

  const DailyChallengeHeader({super.key, required this.resetAt});

  @override
  State<DailyChallengeHeader> createState() => _DailyChallengeHeaderState();
}

class _DailyChallengeHeaderState extends State<DailyChallengeHeader> {
  Timer? _timer;
  String _formattedTime = '00:00:00';

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  @override
  void didUpdateWidget(covariant DailyChallengeHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.resetAt != widget.resetAt) {
      _updateTime();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    if (widget.resetAt == null) {
      if (_formattedTime != '00:00:00') {
        setState(() {
          _formattedTime = '00:00:00';
        });
      }
      return;
    }

    final now = DateTime.now();
    final difference = widget.resetAt!.difference(now);

    if (difference.isNegative) {
      if (_formattedTime != '00:00:00') {
        setState(() {
          _formattedTime = '00:00:00';
        });
      }
      return;
    }

    final hours = difference.inHours.toString().padLeft(2, '0');
    final minutes = (difference.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (difference.inSeconds % 60).toString().padLeft(2, '0');

    final newFormatted = '$hours:$minutes:$seconds';
    if (newFormatted != _formattedTime) {
      setState(() {
        _formattedTime = newFormatted;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.dailyChallengeTitle,
                      style: AppTextStyles.custom(
                        color: colors.textPrimary,
                        fontSize: AppFontSize.xl5,
                        fontWeight: FontWeight.w900,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                SvgPicture.asset(
                  'assets/daily_challenge_screen/trophy.svg',
                  width: 34,
                  height: 34,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/daily_challenge_screen/timer_dailychallenge_icon.png',
                width: 18,
                height: 18,
              ),
              const SizedBox(width: 6),
              Text(
                _formattedTime,
                style: AppTextStyles.custom(
                  color: AppColors.streak,
                  fontSize: AppFontSize.mdt,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
