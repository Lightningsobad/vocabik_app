import 'package:flutter_test/flutter_test.dart';
import 'package:vocabik_app/core/utils/number_format_utils.dart';
import 'package:vocabik_app/core/utils/string_extensions.dart';

void main() {
  group('NumberFormatUtils.formatCompact', () {
    test('formats numbers less than 1000 correctly', () {
      expect(NumberFormatUtils.formatCompact(0), '0');
      expect(NumberFormatUtils.formatCompact(5), '5');
      expect(NumberFormatUtils.formatCompact(999), '999');
    });

    test('formats thousands with k suffix', () {
      expect(NumberFormatUtils.formatCompact(1000), '1k');
      expect(NumberFormatUtils.formatCompact(1200), '1.2k');
      expect(NumberFormatUtils.formatCompact(1234), '1.2k');
      expect(NumberFormatUtils.formatCompact(1290), '1.3k');
      expect(NumberFormatUtils.formatCompact(999999), '1000k');
    });

    test('formats millions with M suffix', () {
      expect(NumberFormatUtils.formatCompact(1000000), '1M');
      expect(NumberFormatUtils.formatCompact(1500000), '1.5M');
      expect(NumberFormatUtils.formatCompact(2500000), '2.5M');
    });
  });

  group('StringExtensions.capitalize', () {
    test('capitalizes empty string', () {
      expect(''.capitalize(), '');
    });

    test('capitalizes lowercase word', () {
      expect('music'.capitalize(), 'Music');
      expect('pop'.capitalize(), 'Pop');
    });

    test('handles already capitalized or uppercase string', () {
      expect('MUSIC'.capitalize(), 'Music');
      expect('Pop'.capitalize(), 'Pop');
    });
  });
}
