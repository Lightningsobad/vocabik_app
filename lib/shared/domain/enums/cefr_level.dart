import 'package:vocabik_app/l10n/app_localizations.dart';

enum CefrLevel {
  all(null, 'All'),
  a1('A1', 'A1'),
  a2('A2', 'A2'),
  b1('B1', 'B1'),
  b2('B2', 'B2'),
  c1('C1', 'C1');

  final String? code;
  final String displayName;

  const CefrLevel(this.code, this.displayName);

  String getLocalizedName(AppLocalizations l10n) {
    if (this == CefrLevel.all) {
      return l10n.homeAll;
    }
    return displayName;
  }

  static CefrLevel fromIndex(int index) {
    if (index >= 0 && index < CefrLevel.values.length) {
      return CefrLevel.values[index];
    }
    return CefrLevel.all;
  }

  static CefrLevel fromCode(String? code) {
    if (code == null || code.isEmpty) return CefrLevel.all;
    return CefrLevel.values.firstWhere(
      (e) => e.code?.toUpperCase() == code.trim().toUpperCase(),
      orElse: () => CefrLevel.all,
    );
  }
}
