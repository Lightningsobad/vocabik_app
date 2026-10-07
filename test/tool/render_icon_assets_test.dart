import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class VocabikIconPainter extends CustomPainter {
  final bool isForegroundOnly;

  const VocabikIconPainter({this.isForegroundOnly = false});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    if (!isForegroundOnly) {
      // 1. Draw rounded squircle background
      final bgPaint = Paint()
        ..color = const Color(0xFF0D0D1A)
        ..style = PaintingStyle.fill;
      final borderPaint = Paint()
        ..color = const Color(0xFF094D4F)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.026;

      final bgRRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.013, h * 0.013, w * 0.974, h * 0.974),
        Radius.circular(w * 0.3),
      );
      canvas.drawRRect(bgRRect, bgPaint);
      canvas.drawRRect(bgRRect, borderPaint);
    }

    // Scale and translate factors
    // If foreground only (for adaptive icon), scale down slightly into safe zone
    final scaleFactor = isForegroundOnly ? 0.72 : 1.0;
    final iconBoxSize = w * 0.66 * scaleFactor;
    final s = iconBoxSize / 24.0;
    final tx = (w - 24.0 * s) / 2.0;
    final ty = (h - 24.0 * s) / 2.0 - (isForegroundOnly ? h * 0.02 : 0);

    // 2. Draw Play arrow (Material play_arrow_rounded exact path)
    final playPath = Path();
    playPath.moveTo(8.0 * s + tx, 6.82 * s + ty);
    playPath.lineTo(8.0 * s + tx, 17.18 * s + ty);
    playPath.cubicTo(
      8.0 * s + tx,
      (17.18 + 0.79) * s + ty,
      (8.0 + 0.87) * s + tx,
      (17.18 + 1.27) * s + ty,
      (8.0 + 1.54) * s + ty,
      (17.18 + 0.84) * s + ty,
    );
    playPath.lineTo(17.68 * s + tx, 12.84 * s + ty);
    playPath.cubicTo(
      (17.68 + 0.62) * s + tx,
      (12.84 - 0.39) * s + ty,
      (17.68 + 0.62) * s + tx,
      (12.84 - 1.29) * s + ty,
      17.68 * s + tx,
      11.15 * s + ty,
    );
    playPath.lineTo(9.54 * s + tx, 5.98 * s + ty);
    playPath.cubicTo(
      (9.54 - 0.67) * s + tx,
      (5.98 - 0.43) * s + ty,
      8.0 * s + tx,
      (5.98 + 0.05) * s + ty,
      8.0 * s + tx,
      6.82 * s + ty,
    );
    playPath.close();

    final playPaint = Paint()
      ..color = const Color(0xFF00E6CB)
      ..style = PaintingStyle.fill;
    canvas.drawPath(playPath, playPaint);

    // 3. Draw Underline Pill
    final underlineWidth = w * 0.43 * scaleFactor;
    final underlineHeight = w * 0.08 * scaleFactor;
    final underlineRadius = underlineHeight / 2.0;
    final underlineLeft = (w - underlineWidth) / 2.0;
    final underlineBottom = isForegroundOnly
        ? (h * 0.5 + iconBoxSize * 0.38)
        : (h - w * 0.16 - underlineHeight);

    final underlineRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        underlineLeft,
        underlineBottom,
        underlineWidth,
        underlineHeight,
      ),
      Radius.circular(underlineRadius),
    );

    final underlinePaint = Paint()
      ..color = const Color(0xFFA854F7)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(underlineRRect, underlinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class VocabikSplashLogoPainter extends CustomPainter {
  final bool isDark;
  final double emblemSize;

  const VocabikSplashLogoPainter({
    this.isDark = false,
    this.emblemSize = 420.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Center coordinates
    final cx = w / 2.0;
    final cy = h / 2.0;

    // Emblem bounds
    final left = cx - emblemSize / 2.0;
    final top = cy - emblemSize / 2.0;
    final emblemRect = Rect.fromLTWH(left, top, emblemSize, emblemSize);

    // 1. Squircle background & border (exact match to VocabikLogo widget)
    final bgPaint = Paint()
      ..color = const Color(0xFF0D0D1A)
      ..style = PaintingStyle.fill;

    final borderColor =
        isDark ? const Color(0xFF094D4F) : const Color(0xFF0B3145);
    final borderWidth = emblemSize * 0.025;
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final squircleRRect = RRect.fromRectAndRadius(
      emblemRect,
      Radius.circular(emblemSize * 0.3),
    );

    canvas.drawRRect(squircleRRect, bgPaint);
    canvas.drawRRect(squircleRRect, borderPaint);

    // 2. Play arrow icon (Icons.play_arrow_rounded)
    final playSize = emblemSize * 0.66;
    final s = playSize / 24.0;
    final tx = cx - 12.0 * s;
    final ty = cy - 12.0 * s;

    final playPath = Path();
    playPath.moveTo(8.0 * s + tx, 6.82 * s + ty);
    playPath.lineTo(8.0 * s + tx, 17.18 * s + ty);
    playPath.cubicTo(
      8.0 * s + tx,
      (17.18 + 0.79) * s + ty,
      (8.0 + 0.87) * s + tx,
      (17.18 + 1.27) * s + ty,
      (8.0 + 1.54) * s + ty,
      (17.18 + 0.84) * s + ty,
    );
    playPath.lineTo(17.68 * s + tx, 12.84 * s + ty);
    playPath.cubicTo(
      (17.68 + 0.62) * s + tx,
      (12.84 - 0.39) * s + ty,
      (17.68 + 0.62) * s + tx,
      (12.84 - 1.29) * s + ty,
      17.68 * s + tx,
      11.15 * s + ty,
    );
    playPath.lineTo(9.54 * s + tx, 5.98 * s + ty);
    playPath.cubicTo(
      (9.54 - 0.67) * s + tx,
      (5.98 - 0.43) * s + ty,
      8.0 * s + tx,
      (5.98 + 0.05) * s + ty,
      8.0 * s + tx,
      6.82 * s + ty,
    );
    playPath.close();

    final playColor =
        isDark ? const Color(0xFF00E6CB) : const Color(0xFF0790B3);
    final playPaint = Paint()
      ..color = playColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(playPath, playPaint);

    // 3. Underline pill (exact match to VocabikLogo widget)
    final underlineWidth = emblemSize * 0.43;
    final underlineHeight = emblemSize * 0.08;
    final underlineRadius = underlineHeight / 2.0;
    final underlineLeft = cx - underlineWidth / 2.0;
    final underlineBottom = top + emblemSize - (emblemSize * 0.16);
    final underlineTop = underlineBottom - underlineHeight;

    final underlineRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        underlineLeft,
        underlineTop,
        underlineWidth,
        underlineHeight,
      ),
      Radius.circular(underlineRadius),
    );

    final underlineColor =
        isDark ? const Color(0xFFA854F7) : const Color(0xFF9234EB);
    final underlinePaint = Paint()
      ..color = underlineColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(underlineRRect, underlinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void main() {
  test('Render Vocabik logo to branding pngs via Canvas', () async {
    const size = 1024.0;
    final outDir = Directory('assets/branding');
    if (!outDir.existsSync()) {
      outDir.createSync(recursive: true);
    }

    // 1. App launcher icons
    for (final isFg in [false, true]) {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, size, size));

      final painter = VocabikIconPainter(isForegroundOnly: isFg);
      painter.paint(canvas, const Size(size, size));

      final picture = recorder.endRecording();
      final image = await picture.toImage(size.toInt(), size.toInt());
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      final fileName = isFg ? 'app_icon_foreground.png' : 'app_icon.png';
      final file = File('assets/branding/$fileName');
      file.writeAsBytesSync(byteData!.buffer.asUint8List());

      expect(file.existsSync(), isTrue);
      expect(file.lengthSync(), greaterThan(1000));
    }

    // 2. Dedicated Splash logos with safe-zone margin (Android 12+ 160dp in 288dp circle)
    for (final isDark in [false, true]) {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, size, size));

      final painter = VocabikSplashLogoPainter(isDark: isDark);
      painter.paint(canvas, const Size(size, size));

      final picture = recorder.endRecording();
      final image = await picture.toImage(size.toInt(), size.toInt());
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      final fileName = isDark ? 'splash_logo_dark.png' : 'splash_logo.png';
      final file = File('assets/branding/$fileName');
      file.writeAsBytesSync(byteData!.buffer.asUint8List());

      expect(file.existsSync(), isTrue);
      expect(file.lengthSync(), greaterThan(1000));
    }
  });
}
