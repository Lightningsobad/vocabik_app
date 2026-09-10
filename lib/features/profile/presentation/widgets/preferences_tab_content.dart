import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
import 'package:vocabik_app/shared/theme/app_font_size.dart';
import 'package:vocabik_app/shared/theme/app_text_style.dart';
import 'package:vocabik_app/shared/theme/cubit/theme_cubit.dart';
import 'package:vocabik_app/shared/localization/cubit/localization_cubit.dart';
import 'package:vocabik_app/shared/localization/cubit/localization_state.dart';
import 'package:vocabik_app/shared/settings/cubit/sound_settings_cubit.dart';
import 'package:vocabik_app/shared/theme/app_spacing.dart';
import 'package:vocabik_app/shared/theme/app_colors.dart';
import 'setting_section_card.dart';
import 'setting_toggle_button.dart';
import 'setting_list_tile.dart';

class PreferencesTabContent extends StatelessWidget {
  const PreferencesTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PreferencesTabContentView();
  }
}

class _PreferencesTabContentView extends StatelessWidget {
  const _PreferencesTabContentView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Appearance (Giao diện)
          SettingSectionCard(
            title: l10n.appearance,
            child: Row(
              children: [
                SettingToggleButton(
                  text: l10n.themeDark,
                  iconAsset: 'assets/profile_screen/moon_icon.svg',
                  isActive: isDarkMode,
                  onTap: () {
                    if (!isDarkMode) {
                      context.read<ThemeCubit>().toggleTheme();
                    }
                  },
                ),
                const SizedBox(width: AppSpacing.md),
                SettingToggleButton(
                  text: l10n.themeLight,
                  iconAsset: 'assets/profile_screen/sun.svg',
                  isActive: !isDarkMode,
                  onTap: () {
                    if (isDarkMode) {
                      context.read<ThemeCubit>().toggleTheme();
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Sound (Âm thanh khi làm bài)
          BlocBuilder<SoundSettingsCubit, SoundSettingsState>(
            builder: (context, state) {
              return SettingListTile(
                title: l10n.soundDuringExercise,
                trailing: Switch(
                  value: state.isSoundEnabled,
                  activeThumbColor: Colors.white,
                  activeTrackColor: colors.primaryAccent,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: colors.tabUnselectedBackground,
                  trackOutlineColor: const WidgetStatePropertyAll(
                    Colors.transparent,
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (value) {
                    context.read<SoundSettingsCubit>().toggleSound(value);
                  },
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.sm),

          // Interface Language (Ngôn ngữ giao diện)
          BlocBuilder<LocalizationCubit, LocalizationState>(
            builder: (context, state) {
              final isVi = state.currentLocale.languageCode == 'vi';
              return SettingSectionCard(
                title: l10n.interfaceLanguage,
                child: Row(
                  children: [
                    SettingToggleButton(
                      text: 'Vietnamese',
                      prefixText: 'VN',
                      isActive: isVi,
                      onTap: () {
                        if (!isVi) {
                          context.read<LocalizationCubit>().changeLanguage(
                            'vi',
                          );
                        }
                      },
                    ),
                    const SizedBox(width: AppSpacing.md),
                    SettingToggleButton(
                      text: 'English',
                      prefixText: 'GB',
                      isActive: !isVi,
                      onTap: () {
                        if (isVi) {
                          context.read<LocalizationCubit>().changeLanguage(
                            'en',
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.sm),

          // Bot Integration (Tích hợp Bot)
          SettingListTile(
            title: l10n.botIntegrationTelegramZalo,
            titleStyle: AppTextStyles.custom(
              fontSize: AppFontSize.mdt,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
            prefixAsset: 'assets/profile_screen/plane_icon.svg',
            trailing: Icon(Icons.chevron_right, color: colors.textSecondary),
            onTap: () {
              context.push('/profile/integration');
            },
          ),
        ],
      ),
    );
  }
}
