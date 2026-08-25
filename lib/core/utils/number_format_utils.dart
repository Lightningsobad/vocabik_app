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
}
