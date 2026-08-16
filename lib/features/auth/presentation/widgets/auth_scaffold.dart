import 'package:flutter/material.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';

class AuthScaffold extends StatelessWidget {
  final Widget body;

  const AuthScaffold({
    super.key,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>();

    return Scaffold(
      backgroundColor: colors?.background ?? Colors.white,
      body: Stack(
        children: [
          // Background Glow Effect in dark mode
          if (Theme.of(context).brightness == Brightness.dark)
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topCenter,
                      radius: 1.1,
                      colors: [
                        (colors?.primaryAccent ?? const Color(0xFF00E5CC))
                            .withValues(alpha: 0.15),
                        (colors?.primaryAccent ?? const Color(0xFF00E5CC))
                            .withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          // Main content
          Positioned.fill(
            child: body,
          ),
        ],
      ),
    );
  }
}
