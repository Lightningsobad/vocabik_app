import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';

class LegalSectionItem extends StatelessWidget {
  final String title;
  final String content;

  const LegalSectionItem({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.custom(
              fontSize: AppFontSize.lg,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildRichContent(colors),
        ],
      ),
    );
  }

  Widget _buildRichContent(AppColorsExtension colors) {
    final urlRegex = RegExp(r'(https?://[^\s)]+)');
    final matches = urlRegex.allMatches(content);

    if (matches.isEmpty) {
      return Text(
        content,
        style: AppTextStyles.custom(
          fontSize: AppFontSize.md,
          fontWeight: FontWeight.w500,
          color: colors.textSecondary,
          height: 1.5,
        ),
      );
    }

    final spans = <InlineSpan>[];
    int lastEnd = 0;

    for (final match in matches) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: content.substring(lastEnd, match.start)));
      }
      final url = match.group(0)!;
      spans.add(
        TextSpan(
          text: url,
          style: TextStyle(
            color: colors.primaryAccent,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.w600,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              final uri = Uri.tryParse(url);
              if (uri != null) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
        ),
      );
      lastEnd = match.end;
    }

    if (lastEnd < content.length) {
      spans.add(TextSpan(text: content.substring(lastEnd)));
    }

    return SelectableText.rich(
      TextSpan(
        style: AppTextStyles.custom(
          fontSize: AppFontSize.md,
          fontWeight: FontWeight.w500,
          color: colors.textSecondary,
          height: 1.5,
        ),
        children: spans,
      ),
    );
  }
}
