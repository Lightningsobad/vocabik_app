// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get homeTitle => 'Home';

  @override
  String get homeScreenContent => 'Home Screen Content';

  @override
  String get discoverTitle => 'Discover';

  @override
  String get progressTitle => 'Progress';

  @override
  String get profileTitle => 'Profile';

  @override
  String get discoverScreenContent => 'Discover Screen Content';

  @override
  String get progressScreenContent => 'Progress Screen Content';

  @override
  String get profileSettingsTitle => 'Profile & Settings';

  @override
  String get profileTab => 'Profile';

  @override
  String get preferencesTab => 'Preferences';

  @override
  String get subscriptionTab => 'Subscription';

  @override
  String get securityTab => 'Security';

  @override
  String get accountTab => 'Account';

  @override
  String tabNotImplemented(int tabIndex) {
    return 'Content for Tab $tabIndex is not implemented yet.';
  }

  @override
  String get actionAchievements => 'Achievements';

  @override
  String get actionNotebook => 'Notebook';

  @override
  String get actionLeaderboard => 'Leaderboard';

  @override
  String get actionClassroom => 'Classroom';

  @override
  String get actionDailyChallenge => 'Daily Challenge';

  @override
  String get actionBotIntegration => 'Bot integration';

  @override
  String get profileChangePhoto => 'Change photo';

  @override
  String get profileYourName => 'Your name';

  @override
  String get profileEmail => 'Email: ';

  @override
  String get profileReadOnly => ' (readonly)';

  @override
  String profileMemberSince(String date) {
    return 'Member since: $date';
  }

  @override
  String get appearance => 'Appearance';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get soundDuringExercise => 'Sound during exercise';

  @override
  String get interfaceLanguage => 'Interface Language';

  @override
  String get languageVietnamese => 'Vietnamese';

  @override
  String get languageEnglish => 'English';

  @override
  String get botIntegrationTelegramZalo => 'Bot Integration (Telegram / Zalo)';

  @override
  String get subscriptionFreePlanTitle => 'Free Plan';

  @override
  String get subscriptionFreePlanDesc => 'Learn more richly with Premium.';

  @override
  String get subscriptionUpgradeBtn => 'Upgrade to Premium →';

  @override
  String get accountExportData => 'Export my data';

  @override
  String get accountLogOut => 'Log out';

  @override
  String get accountDeletePermanently => 'Delete account permanently';

  @override
  String get securityTab_currentPasswordLabel => 'Current password';

  @override
  String get securityTab_newPasswordLabel => 'New password';

  @override
  String get securityTab_updateButton => 'Update';

  @override
  String get securityTab_activeSessionsTitle => 'Active sessions';

  @override
  String get action_show => 'Show';

  @override
  String get action_hide => 'Hide';

  @override
  String get integrationScreenTitle => 'Integration';

  @override
  String get integrationTelegramTitle => 'Telegram Bot';

  @override
  String get integrationTelegramDesc =>
      'Receive exercises every morning via Telegram';

  @override
  String get integrationZaloTitle => 'Zalo OA';

  @override
  String get integrationZaloDesc => 'Similar structure to Telegram';

  @override
  String get statusNotConnected => 'Not connected';

  @override
  String get statusConnected => 'Connected';

  @override
  String get instructionConnectLabel => '1. Press \"Connect\" below';

  @override
  String get instructionStartLabel => '2. Press Start in Telegram';

  @override
  String get instructionAutoConnectLabel => '3. Bot will auto connect';

  @override
  String get timeToReceiveLabel => 'Time to receive';

  @override
  String get levelLabel => 'Level';

  @override
  String get connectTelegramBtn => 'Connect Telegram Bot →';

  @override
  String get connectZaloBtn => 'Connect Zalo OA →';

  @override
  String get disconnectBtn => 'Disconnect';
}
