import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/presentation/widgets/interactions/bounce_wrapper.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class CreateClassroomDialog extends StatefulWidget {
  final Future<bool> Function(String name) onSubmit;

  const CreateClassroomDialog({
    super.key,
    required this.onSubmit,
  });

  static Future<bool?> show(
    BuildContext context, {
    required Future<bool> Function(String name) onSubmit,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => CreateClassroomDialog(onSubmit: onSubmit),
    );
  }

  @override
  State<CreateClassroomDialog> createState() => _CreateClassroomDialogState();
}

class _CreateClassroomDialogState extends State<CreateClassroomDialog> {
  final _controller = TextEditingController();
  String? _errorText;
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _controller.text.trim();
    if (name.isEmpty) {
      setState(() {
        _errorText = l10n.enterClassroomName;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    final success = await widget.onSubmit(name);

    if (mounted) {
      if (success) {
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          _isLoading = false;
          _errorText = l10n.createClassroomError;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: colors.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: colors.borderSubtle),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.createClassroom,
              style: GoogleFonts.nunito(
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              l10n.classroomName,
              style: GoogleFonts.nunito(
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _controller,
              autofocus: true,
              style: GoogleFonts.nunito(
                color: colors.textPrimary,
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: l10n.classroomNameHint,
                hintStyle: GoogleFonts.nunito(
                  color: colors.hintText,
                  fontSize: 14.0,
                ),
                filled: true,
                fillColor: colors.inputBackground,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: colors.inputBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: colors.primaryAccent, width: 1.5),
                ),
                errorText: _errorText,
                errorStyle: GoogleFonts.nunito(
                  color: colors.danger,
                  fontSize: 12.0,
                ),
              ),
              onChanged: (_) {
                if (_errorText != null) {
                  setState(() {
                    _errorText = null;
                  });
                }
              },
              onSubmitted: (_) => _handleCreate(),
            ),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BounceWrapper(
                  onTap: _isLoading ? () {} : () => Navigator.of(context).pop(false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: colors.tabUnselectedBackground,
                      borderRadius: BorderRadius.circular(100.0),
                      border: Border.all(color: colors.tabUnselectedBorder),
                    ),
                    child: Text(
                      l10n.actionCancel,
                      style: GoogleFonts.nunito(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                BounceWrapper(
                  onTap: _isLoading ? () {} : _handleCreate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primaryAccent,
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 18.0,
                            height: 18.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colors.onPrimaryAccent,
                              ),
                            ),
                          )
                        : Text(
                            l10n.create,
                            style: GoogleFonts.nunito(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w800,
                              color: colors.onPrimaryAccent,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
