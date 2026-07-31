import 'package:flutter/material.dart';

class StatBadge extends StatelessWidget {
  final String emoji;
  final String valueText;
  final Color color;

  const StatBadge({
    super.key,
    required this.emoji,
    required this.valueText,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 13),
        ),
        const SizedBox(width: 3),
        Text(
          valueText,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            fontFamily: 'Display', // Customize this if using a specific font
          ),
        ),
      ],
    );
  }
}
