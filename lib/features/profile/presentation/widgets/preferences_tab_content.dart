import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabik_app/l10n/app_localizations.dart';
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
                Expanded(
                  child: SettingToggleButton(
                    text: l10n.themeDark,
                    prefixEmoji: '🌙',
                    isActive: isDarkMode,
                    onTap: () {
                      if (!isDarkMode) {
                        context.read<ThemeCubit>().toggleTheme();
                      }
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: SettingToggleButton(
                    text: l10n.themeLight,
                    prefixEmoji: '☀️',
                    isActive: !isDarkMode,
                    onTap: () {
                      if (isDarkMode) {
                        context.read<ThemeCubit>().toggleTheme();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Sound (Âm thanh khi làm bài)
          BlocBuilder<SoundSettingsCubit, SoundSettingsState>(
            builder: (context, state) {
              return SettingListTile(
                title: l10n.soundDuringExercise,
                trailing: Switch(
                  value: state.isSoundEnabled,
                  activeThumbColor: Theme.of(context).colorScheme.primary,
                  onChanged: (value) {
                    context.read<SoundSettingsCubit>().toggleSound(value);
                  },
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          // Interface Language (Ngôn ngữ giao diện)
          BlocBuilder<LocalizationCubit, LocalizationState>(
            builder: (context, state) {
              final isVi = state.currentLocale.languageCode == 'vi';
              return SettingSectionCard(
                title: l10n.interfaceLanguage,
                child: Row(
                  children: [
                    Expanded(
                      child: SettingToggleButton(
                        text: l10n.languageVietnamese,
                        prefixText: 'VN',
                        isActive: isVi,
                        onTap: () {
                          if (!isVi) {
                            context.read<LocalizationCubit>().changeLanguage('vi');
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: SettingToggleButton(
                        text: l10n.languageEnglish,
                        prefixText: 'GB',
                        isActive: !isVi,
                        onTap: () {
                          if (isVi) {
                            context.read<LocalizationCubit>().changeLanguage('en');
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          // Bot Integration (Tích hợp Bot)
          SettingListTile(
            title: l10n.botIntegrationTelegramZalo,
            prefixEmoji: '✈️',
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
