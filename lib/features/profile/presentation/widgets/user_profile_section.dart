import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'package:vocabik_app/shared/presentation/widgets/interactions/bounce_wrapper.dart';
import 'dart:developer' as developer;

class UserProfileSection extends StatefulWidget {
  const UserProfileSection({super.key});

  @override
  State<UserProfileSection> createState() => _UserProfileSectionState();
}

class _UserProfileSectionState extends State<UserProfileSection> {
  late TextEditingController _nameController;
  late FocusNode _nameFocusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'An Nguyễn');
    _nameFocusNode = FocusNode();

    _nameFocusNode.addListener(() {
      setState(() {
        _isFocused = _nameFocusNode.hasFocus;
      });

      if (!_nameFocusNode.hasFocus) {
        _performAutoSave();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  void _performAutoSave() {
    // Giả lập gọi API
    developer.log('Auto-saved new name: ${_nameController.text}', name: 'ProfileScreen');
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar and Change Photo
          Row(
            children: [
              Container(
                width: 64.0,
                height: 64.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.surfaceCard,
                  border: Border.all(color: colors.borderSubtle, width: 1.0),
                ),
                alignment: Alignment.center,
                child: Text(
                  'AN',
                  style: GoogleFonts.nunito(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 22.0,
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              BounceWrapper(
                onTap: () {
                  // TODO: Change photo logic
                },
                child: Container(
                  constraints: const BoxConstraints(minHeight: 48.0),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: colors.borderSubtle, width: 1.0),
                    color: colors.surfaceCard,
                  ),
                  child: Text(
                    'Change photo',
                    style: GoogleFonts.nunito(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          
          // Name Field
          Text(
            'Your name',
            style: GoogleFonts.nunito(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 14.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Container(
            decoration: BoxDecoration(
              color: colors.surfaceCard,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: _isFocused ? AppColors.accent : colors.borderSubtle,
                width: 1.5,
              ),
            ),
            child: TextField(
              controller: _nameController,
              focusNode: _nameFocusNode,
              style: GoogleFonts.nunito(
                color: colors.textPrimary,
                fontSize: 16.0,
              ),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                border: InputBorder.none,
                isDense: true,
              ),
              onSubmitted: (_) {
                _nameFocusNode.unfocus(); // Sẽ trigger listener bên trên để lưu
              },
            ),
          ),
          const SizedBox(height: 20.0),
          
          // Email Static
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Email: ',
                  style: GoogleFonts.nunito(color: colors.textSecondary),
                ),
                TextSpan(
                  text: 'an.nguyen@gmail.com',
                  style: GoogleFonts.nunito(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ' (readonly)',
                  style: GoogleFonts.nunito(color: colors.textSecondary, fontSize: 13.0),
                ),
              ],
            ),
            style: GoogleFonts.nunito(fontSize: 15.0),
          ),
          const SizedBox(height: 12.0),
          
          // Member Since
          Text(
            'Member since: 15/05/2026',
            style: GoogleFonts.nunito(
              color: colors.textSecondary,
              fontSize: 15.0,
            ),
          ),
        ],
      ),
    );
  }
}
