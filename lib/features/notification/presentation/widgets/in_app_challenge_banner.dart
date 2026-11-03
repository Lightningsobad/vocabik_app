import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/services/audio_feedback_service.dart';
import '../../../../core/services/notification/notification_router_handler.dart';
import '../../../../shared/presentation/widgets/interactions/bounce_wrapper.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_font_size.dart';
import '../../../../shared/theme/app_radius.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_text_style.dart';

class InAppChallengeBannerListener extends StatefulWidget {
  final Widget child;

  const InAppChallengeBannerListener({super.key, required this.child});

  @override
  State<InAppChallengeBannerListener> createState() =>
      _InAppChallengeBannerListenerState();
}

class _InAppChallengeBannerListenerState
    extends State<InAppChallengeBannerListener>
    with SingleTickerProviderStateMixin {
  StreamSubscription<InAppChallengeEvent>? _subscription;
  InAppChallengeEvent? _currentEvent;
  Timer? _autoDismissTimer;

  late final AnimationController _animController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    if (getIt.isRegistered<NotificationRouterHandler>()) {
      _subscription = getIt<NotificationRouterHandler>()
          .onInAppChallenge
          .listen(_onChallengeReceived);
    }
  }

  void _onChallengeReceived(InAppChallengeEvent event) {
    _autoDismissTimer?.cancel();
    setState(() {
      _currentEvent = event;
    });

    // Play feedback sound if registered
    if (getIt.isRegistered<AudioFeedbackService>()) {
      getIt<AudioFeedbackService>().playCompletionFeedback();
    }

    _animController.forward();

    // Auto dismiss after 7 seconds
    _autoDismissTimer = Timer(const Duration(seconds: 7), () {
      _dismiss();
    });
  }

  void _dismiss() {
    _autoDismissTimer?.cancel();
    _animController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _currentEvent = null;
        });
      }
    });
  }

  void _acceptChallenge() {
    final event = _currentEvent;
    _dismiss();
    if (event != null && event.targetRoute.isNotEmpty) {
      appRouter.push(event.targetRoute);
    }
  }

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    _subscription?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return Stack(
      children: [
        widget.child,
        if (_currentEvent != null)
          Positioned(
            top: 12,
            left: 16,
            right: 16,
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: colors.surfaceCard,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        color: colors.tagNewBackground.withValues(alpha: 0.6),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: colors.tagNewBackground.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  LucideIcons.swords,
                                  color: colors.tagNewBackground,
                                  size: 22,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm2),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '⚔️ Lời thách đấu mới!',
                                    style: AppTextStyles.custom(
                                      color: colors.tagNewBackground,
                                      fontSize: AppFontSize.tnn,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${_currentEvent!.challengerName} đã gửi thử thách',
                                    style: AppTextStyles.custom(
                                      color: colors.textPrimary,
                                      fontSize: AppFontSize.sm,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${_currentEvent!.videoTitle} (${_currentEvent!.challengerScore}%)',
                                    style: AppTextStyles.custom(
                                      color: colors.textSecondary,
                                      fontSize: AppFontSize.tnn,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                LucideIcons.x,
                                color: colors.textSecondary,
                                size: 18,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: _dismiss,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm2),
                        Row(
                          children: [
                            Expanded(
                              child: BounceWrapper(
                                onTap: _dismiss,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: colors.inputBackground,
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.md),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Để sau',
                                      style: AppTextStyles.custom(
                                        color: colors.textSecondary,
                                        fontSize: AppFontSize.tnn,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              flex: 2,
                              child: BounceWrapper(
                                onTap: _acceptChallenge,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: colors.primaryAccent,
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.md),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Chấp nhận ngay 🚀',
                                      style: AppTextStyles.custom(
                                        color: Colors.white,
                                        fontSize: AppFontSize.tnn,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
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
          ),
      ],
    );
  }
}
