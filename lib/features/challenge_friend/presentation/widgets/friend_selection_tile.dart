import 'package:flutter/material.dart';
import '../../../../shared/presentation/widgets/interactions/bounce_wrapper.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_font_size.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_text_style.dart';
import '../../domain/entities/friend_entity.dart';

class FriendSelectionTile extends StatelessWidget {
  final FriendEntity friend;
  final bool isSelected;
  final VoidCallback onTap;

  const FriendSelectionTile({
    super.key,
    required this.friend,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm2),
      child: BounceWrapper(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF0F262B)
                : colors.surfaceCard,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected ? colors.primaryAccent : colors.borderSubtle,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              // Avatar
              _buildAvatar(colors),
              const SizedBox(width: AppSpacing.md),

              // Name and Stats
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      friend.displayName,
                      style: AppTextStyles.custom(
                        fontSize: AppFontSize.md2,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (friend.formattedStats.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        friend.formattedStats,
                        style: AppTextStyles.custom(
                          fontSize: AppFontSize.sm2,
                          fontWeight: FontWeight.w500,
                          color: colors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),

              // Selection Circle
              _buildSelectionIndicator(colors),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(AppColorsExtension colors) {
    const size = 44.0;
    if (friend.avatarUrl != null && friend.avatarUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          friend.avatarUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildInitialsAvatar(colors, size),
        ),
      );
    }
    return _buildInitialsAvatar(colors, size);
  }

  Widget _buildInitialsAvatar(AppColorsExtension colors, double size) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? colors.primaryAccent : const Color(0xFF22253B),
        shape: BoxShape.circle,
      ),
      child: Text(
        friend.initials,
        style: AppTextStyles.custom(
          fontSize: AppFontSize.md,
          fontWeight: FontWeight.w800,
          color: isSelected ? const Color(0xFF0D0D1A) : colors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildSelectionIndicator(AppColorsExtension colors) {
    if (isSelected) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: colors.primaryAccent,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_rounded,
          size: 16,
          color: Color(0xFF0D0D1A),
        ),
      );
    }

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF3B3B52),
          width: 1.8,
        ),
      ),
    );
  }
}
