import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_radius.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';
import 'package:vocabik_app/features/daily_challenge/domain/entities/daily_challenge_config_entity.dart';

class DailyChallengeBanner extends StatefulWidget {
  final DailyChallengeResponseEntity? response;
  final VoidCallback? onTap;

  const DailyChallengeBanner({super.key, this.response, this.onTap});

  @override
  State<DailyChallengeBanner> createState() => _DailyChallengeBannerState();
}

class _DailyChallengeBannerState extends State<DailyChallengeBanner> {
  Timer? _timer;
  String _formattedTime = '00:00';

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  @override
  void didUpdateWidget(covariant DailyChallengeBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.response?.resetAt != widget.response?.resetAt) {
      _updateTime();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    final resetAt = widget.response?.resetAt;
    if (resetAt == null) {
      if (_formattedTime != '00:00') {
        setState(() {
          _formattedTime = '00:00';
        });
      }
      return;
    }

    final now = DateTime.now();
    final difference = resetAt.difference(now);

    if (difference.isNegative) {
      if (_formattedTime != '00:00') {
        setState(() {
          _formattedTime = '00:00';
        });
      }
      return;
    }

    final hours = difference.inHours;
    final minutes = (difference.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (difference.inSeconds % 60).toString().padLeft(2, '0');

    String newFormatted;
    if (hours > 0) {
      final hoursStr = hours.toString().padLeft(2, '0');
      newFormatted = '$hoursStr:$minutes';
    } else {
      newFormatted = '$minutes:$seconds';
    }

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final config = widget.response?.config;
    final videoTitle = config?.videoTitle ?? 'Night Changes';
    final participantCount = widget.response?.participantCount ?? 0;

    final gradientColors = isDark
        ? [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          ]
        : [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.02),
          ];

    final subtitle =
        '$videoTitle · ${l10n.dailyChallengeParticipants(participantCount)}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: BounceWrapper(
        onTap:
            widget.onTap ??
            () {
              context.push('/home/daily-challenge', extra: widget.response);
            },
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg2),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/daily_challenge_screen/trophy.svg',
                width: 32,
                height: 32,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.homeDailyChallenge,
                      style: AppTextStyles.custom(
                        color: colors.textPrimary,
                        fontSize: AppFontSize.lg2,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.custom(
                        color: colors.textSecondary,
                        fontSize: AppFontSize.md,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/home_screen/timer_dailychallenge_icon.png',
                    width: 16,
                    height: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formattedTime,
                    style: AppTextStyles.custom(
                      color: AppColors.streak,
                      fontSize: AppFontSize.md,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: AppFontSize.md,
                    color: colors.textSecondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
