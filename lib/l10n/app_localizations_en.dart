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

  @override
  String get homeDailyPickTitle => '☀️ Handpicked for you today';

  @override
  String get homeRecommendedTitle => 'ALSO FOR YOU';

  @override
  String get homeTodayProgress => 'Today';

  @override
  String get homeUnlimited => 'Unlimited';

  @override
  String get homeAll => 'All';

  @override
  String get homeDailyChallenge => 'Today\'s Daily Challenge';

  @override
  String get homeTrending => 'Trending this week 🔥';

  @override
  String get homeViewAll => 'See all →';

  @override
  String get homeRecentlyAdded => 'Newly added ✨';

  @override
  String get homeLibrary => 'Library';

  @override
  String get homePricing => 'Pricing';

  @override
  String get homePrivacyPolicy => 'Privacy Policy';

  @override
  String get homeTerms => 'Terms of Service';

  @override
  String homePracticed(String count) {
    return '$count practiced';
  }

  @override
  String homeLessons(int current, int total) {
    return '$current / $total lessons';
  }

  @override
  String get homeDailyPickTag => 'DAILY PICK';

  @override
  String get homeNewTag => 'NEW';

  @override
  String homeChallengeParticipants(String count) {
    return '$count participants';
  }

  @override
  String get discoverSearchHint => 'Search by song, artist...';

  @override
  String get discoverFilterAll => 'All';

  @override
  String get discoverTrendingTitle => 'Trending 🔥';

  @override
  String get discoverPlaylistTitle => 'Selected Playlists';

  @override
  String get discoverTimeUnder3 => '< 3 mins';

  @override
  String get discoverTime3To7 => '3-7 mins';

  @override
  String get discoverTimeOver7 => '> 7 mins';

  @override
  String discoverSearchResultsWithQuery(int count, String query) {
    return 'Found $count results for \"$query\"';
  }

  @override
  String discoverSearchResults(int count) {
    return 'Found $count results';
  }

  @override
  String discoverVideosCount(int count) {
    return '$count videos';
  }

  @override
  String get logoutConfirmTitle => 'Log out';

  @override
  String get logoutConfirmMessage => 'Are you sure you want to log out?';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get signUpTitle => 'Sign up';

  @override
  String get createFreeAccount => 'Create a free account';

  @override
  String get startLearningToday => 'Start learning today';

  @override
  String get signUpWithGoogle => 'Sign up with Google';

  @override
  String get orText => 'or';

  @override
  String get yourName => 'Your name';

  @override
  String get emailHint => 'Email';

  @override
  String get passwordHint => 'Password';

  @override
  String get passwordStrengthNone => 'None';

  @override
  String get passwordStrengthWeak => 'Weak';

  @override
  String get passwordStrengthMedium => 'Medium';

  @override
  String get passwordStrengthStrong => 'Strong';

  @override
  String get signUpTerms => 'By signing up, you agree to the Terms & Privacy';

  @override
  String get alreadyHaveAccount => 'Already have an account? Log in →';

  @override
  String get checkYourEmail => 'Check your email';

  @override
  String checkEmailSubtitle(String email) {
    return 'We have sent it to:\n$email';
  }

  @override
  String resendIn(int seconds) {
    return 'Resend in $seconds seconds';
  }

  @override
  String get iHaveVerified => 'I have verified → continue';

  @override
  String get spamCheckTip =>
      '💡 Can\'t find the email? Check your Spam folder.';

  @override
  String get whereIsYourEnglish => 'Where is your English at?';

  @override
  String get weWillSuggest =>
      'We will suggest the most suitable lessons for you.';

  @override
  String get levelA1A2 => 'A1–A2';

  @override
  String get levelA1A2Desc => 'Beginner';

  @override
  String get levelB1 => 'B1';

  @override
  String get levelB1Desc => 'Elementary';

  @override
  String get levelB2 => 'B2';

  @override
  String get levelB2Desc => 'Intermediate';

  @override
  String get levelC1 => 'C1';

  @override
  String get levelC1Desc => 'Advanced';

  @override
  String get startLearning => 'Start learning →';

  @override
  String get skipForNow => 'Skip, I\'ll choose later';

  @override
  String get actionSignUp => 'Sign up';

  @override
  String get homeVideosEmpty => 'No exercises found.';

  @override
  String get homeVideosError => 'Failed to load exercises.';

  @override
  String get homeRetry => 'Retry';

  @override
  String get emptySectionText => 'No video yet';

  @override
  String get videoDetailBack => 'Back';

  @override
  String get videoDetailMultipleChoice => 'Multiple choice';

  @override
  String get videoDetailExerciseType => 'Exercise type';

  @override
  String get videoDetailFillBlank => 'Fill-blank';

  @override
  String get videoDetailTypeTheAnswer => 'Type the answer';

  @override
  String get videoDetailVersion => 'VERSION';

  @override
  String get videoDetailVocabulary => 'Vocabulary';

  @override
  String get videoDetailGrammar => 'Grammar';

  @override
  String get videoDetailSpeed => 'Speed';

  @override
  String get videoDetailStartPractice => 'Start practice →';
}
