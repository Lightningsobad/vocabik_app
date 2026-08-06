import 'package:flutter/material.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';

class FloatingChatButton extends StatelessWidget {
  const FloatingChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    
    return BounceWrapper(
      onTap: () {
        // TODO: Implement role switcher or chat
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          shape: BoxShape.circle,
          border: Border.all(color: colors.borderSubtle),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            '\uD83D\uDE0A', // Smiley face
            style: TextStyle(fontSize: 28),
          ),
        ),
      ),
    );
  }
}
