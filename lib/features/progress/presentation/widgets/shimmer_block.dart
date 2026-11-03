import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBlock extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBlock({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    // Using a subtle greyish color for the shimmer
    final baseColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF334155) // slate 700
        : const Color(0xFFE2E8F0); // slate 200
    final highlightColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF475569) // slate 600
        : const Color(0xFFF1F5F9); // slate 100

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
