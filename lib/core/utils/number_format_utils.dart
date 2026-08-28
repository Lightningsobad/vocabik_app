class NumberFormatUtils {
  const NumberFormatUtils._();

  /// Formats an integer into a compact representation (e.g. 1200 -> '1.2k', 1500000 -> '1.5M').
  static String formatCompact(int number) {
    final absNum = number.abs();
    final sign = number < 0 ? '-' : '';

    if (absNum < 1000) {
      return '$number';
    } else if (absNum < 1000000) {
      final value = (absNum / 1000.0);
      return '$sign${_formatNumber(value)}k';
    } else {
      final value = (absNum / 1000000.0);
      return '$sign${_formatNumber(value)}M';
    }
  }

  static String _formatNumber(double value) {
    final str = value.toStringAsFixed(1);
    if (str.endsWith('.0')) {
      return str.substring(0, str.length - 2);
    }
    return str;
  }

  /// Formats time in milliseconds (or seconds if < 10000) to 'm:ss' format.
  static String formatTime(int scoreTimeMs) {
    final totalSeconds =
        scoreTimeMs >= 10000 ? (scoreTimeMs / 1000).round() : scoreTimeMs;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
  /// Formats an integer with commas (e.g. 1234 -> '1,234').
  static String formatWithCommas(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

extension IntNumberFormatExtensions on int {
  /// Formats this integer (representing ms or seconds) into 'm:ss' format.
  String toFormattedTime() => NumberFormatUtils.formatTime(this);

  /// Formats this integer with commas (e.g. 1234 -> '1,234').
  String toFormattedCommas() => NumberFormatUtils.formatWithCommas(this);
}

