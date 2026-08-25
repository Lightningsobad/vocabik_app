import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

/// An optimized confetti celebration overlay that triggers once and drops
/// star particles evenly across the top horizontal width of the screen.
class CelebrationConfettiOverlay extends StatefulWidget {
  final bool shouldPlay;
  final int emitterCount;
  final Duration duration;
  final List<Color> colors;
  final Widget? child;

  static const List<Color> defaultColors = [
    Color(0xFFFFD700), // Gold
    Color(0xFF00E5CC), // Cyan
    Color(0xFFFF4081), // Pink
    Color(0xFF7C4DFF), // Purple
    Color(0xFFFF9100), // Orange
  ];

  const CelebrationConfettiOverlay({
    super.key,
    required this.shouldPlay,
    this.emitterCount = 5,
    this.duration = const Duration(seconds: 3),
    this.colors = defaultColors,
    this.child,
  });

  @override
  State<CelebrationConfettiOverlay> createState() =>
      _CelebrationConfettiOverlayState();
}

class _CelebrationConfettiOverlayState
    extends State<CelebrationConfettiOverlay> {
  late final ConfettiController _controller;
  bool _hasPlayed = false;

  // Pre-computed normalized offsets (-1.0 to 1.0) for a 5-pointed star.
  // Eliminates sin, cos, and pi calculations at runtime during particle generation.
  static final List<Offset> _starOffsets = List.generate(10, (i) {
    final double r = i.isEven ? 1.0 : 0.4;
    final double angle = i * (pi / 5);
    return Offset(r * sin(angle), -r * cos(angle));
  });

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: widget.duration);
    if (widget.shouldPlay) {
      _playOnce();
    }
  }

  @override
  void didUpdateWidget(covariant CelebrationConfettiOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldPlay && !_hasPlayed) {
      _playOnce();
    }
  }

  void _playOnce() {
    _hasPlayed = true;
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static Path _drawPrecomputedStar(Size size) {
    final path = Path();
    final double max = min(size.width, size.height);
    final double half = max / 2;

    for (int i = 0; i < _starOffsets.length; i++) {
      final x = half + half * _starOffsets[i].dx;
      final y = half + half * _starOffsets[i].dy;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          if (widget.child != null) widget.child!,
          Align(
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(widget.emitterCount, (index) {
                return ConfettiWidget(
                  confettiController: _controller,
                  blastDirection: pi / 2, // Downward
                  blastDirectionality: BlastDirectionality.directional,
                  maxBlastForce: 25,
                  minBlastForce: 12,
                  emissionFrequency: 0.08,
                  numberOfParticles: 6, // 6 particles per emitter (~30 total across top)
                  gravity: 0.4, // Fast falling speed
                  createParticlePath: _drawPrecomputedStar,
                  colors: widget.colors,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
