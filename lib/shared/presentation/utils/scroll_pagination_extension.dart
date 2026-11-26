import 'package:flutter/widgets.dart';

extension ScrollControllerPaginationX on ScrollController {
  /// Returns true when the scroll position is within the viewport-proportional
  /// prefetch window (clamped between 600px and 1200px) from the end.
  bool get isNearPrefetchThreshold {
    if (!hasClients) return false;
    final pos = position;
    final threshold = (pos.viewportDimension * 1.5).clamp(600.0, 1200.0);
    return pos.pixels >= (pos.maxScrollExtent - threshold);
  }
}
