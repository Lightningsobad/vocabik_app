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
  String get homeDailyPickTitle => 'Handpicked for you today';

  @override
  String get homeRecommendedTitle => 'ALSO FOR YOU';

  @override
  String get homeTodayProgress => 'Today';

  @override
  String get homeUnlimited => 'Go unlimited';

  @override
  String get homeAll => 'All';

  @override
  String get homeDailyChallenge => 'Today\'s Daily Challenge';

  @override
  String get homeTrending => 'Trending this week';

  @override
  String get homeViewAll => 'See all →';

  @override
  String get homeRecentlyAdded => 'Newly added';

  @override
  String get homeLibrary => 'Library';

  @override
  String get homePricing => 'Pricing';

  @override
  String get homePrivacyPolicy => 'Privacy Policy';

  @override
  String get homeTerms => 'Terms';

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
  String get genreMusic => 'Music';

  @override
  String get genreVlog => 'Vlog';

  @override
  String get genreNews => 'News';

  @override
  String get genreEducation => 'Education';

  @override
  String get genreEntertainment => 'Entertainment';

  @override
  String get genreTedTalks => 'TED Talks';

  @override
  String get genreNewsEnglish => 'News English';

  @override
  String get genreOther => 'Other';

  @override
  String get exerciseTypeMc => 'MC';

  @override
  String get exerciseTypeFreeText => 'Free-text';

  @override
  String get exerciseTypeSentenceReorder => 'Sentence reorder';

  @override
  String get discoverTrendingTitle => 'Trending';

  @override
  String get discoverPlaylistTitle => 'Selected Playlists';

  @override
  String get discoverTimeUnder3 => '< 3 mins';

  @override
  String get discoverTime3To7 => '3-7 mins';

  @override
  String get discoverTimeOver7 => '> 7 mins';

  @override
  String get discoverFilter7Days => '7 Days';

  @override
  String get discoverEmptyResult => 'No results found';

  @override
  String get discoverErrorLoad => 'An error occurred';

  @override
  String get discoverRetryButton => 'Retry';

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
  String get emailHint => 'Your email';

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
  String get alreadyHaveAccountPrompt => 'Already have an account? ';

  @override
  String get loginActionLink => 'Log in →';

  @override
  String get checkYourEmail => 'Check your email';

  @override
  String checkEmailSubtitle(String email) {
    return 'We have sent it to:\n$email';
  }

  @override
  String resendIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get resendEmail => 'Resend email';

  @override
  String get iHaveVerified => 'I\'ve verified → continue';

  @override
  String get spamCheckTip => 'Don\'t see it? Check your Spam folder.';

  @override
  String get whereIsYourEnglish => 'Where is your English right now?';

  @override
  String get weWillSuggest => 'We\'ll suggest the exercises that fit you best.';

  @override
  String get levelA1A2 => 'A1–A2';

  @override
  String get levelA1A2Desc => 'Beginner';

  @override
  String get levelB1 => 'B1';

  @override
  String get levelB1Desc => 'Basic';

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
  String get emptyVideos => 'No videos found';

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

  @override
  String videoDetailBlanksCount(int count) {
    return '$count blanks';
  }

  @override
  String get videoDetailLength => 'Length';

  @override
  String get videoDetailShareThis => 'Share this exercise';

  @override
  String get videoDetailLastAttempt => 'Last attempt';

  @override
  String get authGenericError => 'An error occurred';

  @override
  String get loginTitle => 'Log in to Vocabik';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithFacebook => 'Continue with Facebook';

  @override
  String get emailInvalid => 'Invalid email';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get forgotPassword => 'Forgot password? →';

  @override
  String get actionLogin => 'Log in';

  @override
  String get noAccount => 'No account yet? ';

  @override
  String get signUpFreeAction => 'Sign up free →';

  @override
  String get progressYourProgress => 'Your progress';

  @override
  String get progressWeeklyXP => 'Weekly XP';

  @override
  String get progressAreasToImprove => 'Areas to improve';

  @override
  String get progressLearningHistory => 'Learning history';

  @override
  String get exerciseTitle => 'PRACTICE';

  @override
  String get exerciseCorrect => 'Correct!';

  @override
  String get exerciseCorrectAwesome => 'Awesome!';

  @override
  String get exerciseCorrectSpotOn => 'Spot on!';

  @override
  String get exerciseAlmost => 'Almost!';

  @override
  String get exerciseHint => 'Hint';

  @override
  String get exerciseContinue => 'Continue →';

  @override
  String get exerciseCheck => 'Check';

  @override
  String get exercisePlayingVideo => 'Playing video...';

  @override
  String get exerciseCompleted => 'Exercise completed!';

  @override
  String get viewVietnameseTranslation => 'Show Vietnamese';

  @override
  String get nameCannotBeEmpty => 'Name cannot be empty';

  @override
  String get termsText => 'Terms';

  @override
  String get securityText => 'Security';

  @override
  String get signUpTermsPrefix => 'By signing up, you agree to ';

  @override
  String get signUpTermsAnd => ' & ';

  @override
  String get verifySuccessRedirect => 'Verification successful. Redirecting...';

  @override
  String get verifyFailed => 'Verification failed';

  @override
  String get updateFailed => 'Update failed';

  @override
  String get invalidToken => 'Invalid or expired token.';

  @override
  String get networkError => 'No network connection. Please check again.';

  @override
  String get serverError => 'Server error, please try again later.';

  @override
  String get exerciseTypeAnswerHint => 'Type the answer...';

  @override
  String get exercisePleaseEnterAnswer => 'Please enter an answer';

  @override
  String exerciseAlmostCorrect(String answer) {
    return 'Almost correct — the answer is \"$answer\".';
  }

  @override
  String get userAlreadyExists => 'Account already exists.';

  @override
  String get resultWhatWentWrong => 'What went wrong?';

  @override
  String get resultShare => 'Share';

  @override
  String get resultInstagram => 'Instagram';

  @override
  String get resultCopy => 'Copy';

  @override
  String get resultChallengeFriend => 'Challenge a friend';

  @override
  String get resultNextSuggestedExercise => 'Next suggested exercise →';

  @override
  String get resultPracticeAgain => 'Practice again';

  @override
  String get resultBackToLibrary => 'Back to library';

  @override
  String get resultXpEarned => 'XP earned';

  @override
  String get resultDayStreak => 'day streak';

  @override
  String resultNewBadge(String level) {
    return 'New badge: First $level!';
  }

  @override
  String resultCompletedFirstExercise(String level) {
    return 'Completed your first $level exercise';
  }

  @override
  String resultCorrectCount(int count) {
    return '$count correct';
  }

  @override
  String resultWrongCount(int count) {
    return '$count wrong';
  }

  @override
  String get resultFeatureInDevelopment => 'Feature in development';

  @override
  String get resultScoreCardError => 'Unable to load Score Card';

  @override
  String get resultNoInternetScoreCard =>
      'No internet connection to generate Score Card';

  @override
  String get resultCopiedToClipboard => 'Copied to clipboard!';

  @override
  String get resultProgressSavedSuccess => 'Progress saved successfully!';

  @override
  String get resultProgressSaveError => 'Could not sync progress';

  @override
  String get resultProgressRetry => 'Retry sync';

  @override
  String get myClassrooms => 'My classrooms';

  @override
  String get newClass => '+ New class';

  @override
  String get students => 'Students';

  @override
  String get assignments => 'Assignments';

  @override
  String get statistics => 'Statistics';

  @override
  String get joinCode => 'Join code';

  @override
  String get copy => 'Copy';

  @override
  String get createClassroom => 'Create new classroom';

  @override
  String get classroomName => 'Classroom name';

  @override
  String get classroomNameHint => 'e.g. 12A2 team';

  @override
  String get create => 'Create';

  @override
  String get createSuccess => 'Classroom created successfully';

  @override
  String get createClassroomError => 'Failed to create classroom';

  @override
  String get emptyClassrooms => 'No classrooms yet';

  @override
  String get noAssignmentYet => 'No assignment yet';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get enterClassroomName => 'Please enter a classroom name';

  @override
  String studentsCount(int count) {
    return '$count students';
  }

  @override
  String studentsTabTitle(int count) {
    return 'Students ($count)';
  }

  @override
  String assignmentDue(int current, int total, String date) {
    return '$current/$total · Due $date';
  }

  @override
  String assignmentLabel(String title) {
    return 'Assignment: $title';
  }

  @override
  String get termsOfServiceTitle => 'Terms of Service';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String legalLastUpdated(String date) {
    return 'Last updated: $date';
  }

  @override
  String get legalLastUpdatedDefaultDate => '15/06/2026';

  @override
  String get tosSection1Title => '1. Acceptance of Terms';

  @override
  String get tosSection1Content =>
      'By using Vocabik, you agree to these terms.';

  @override
  String get tosSection2Title => '2. User Account';

  @override
  String get tosSection2Content =>
      'You are responsible for safeguarding your login credentials.';

  @override
  String get tosSection3Title => '3. Use of Service';

  @override
  String get tosSection3Content =>
      'Do not use the service for illegal purposes or violate YouTube ToS.';

  @override
  String get tosSection4Title => '4. Content & Intellectual Property';

  @override
  String get tosSection4Content =>
      'Video content belongs to original owners on YouTube; Vocabik only creates learning exercises.';

  @override
  String get tosSection5Title => '5. Payment & Refunds';

  @override
  String get tosSection5Content =>
      'Premium plans can be canceled anytime; 7-day refund for annual plans.';

  @override
  String get tosSection6Title => '6. Account Termination';

  @override
  String get tosSection6Content =>
      'You can delete your account anytime; we may terminate accounts that violate terms.';

  @override
  String get tosContact => 'Contact: support@vocabik.com';

  @override
  String get privacySummaryTitle => 'Summary:';

  @override
  String get privacySummaryContent =>
      'We collect email and learning data to provide services. We do not sell your data.';

  @override
  String get privacySection1Title => '1. Information We Collect';

  @override
  String get privacySection1Content =>
      'Email, display name, and learning data (progress, scores, saved vocabulary) to personalize your experience.';

  @override
  String get privacySection2Title => '2. How We Use Information';

  @override
  String get privacySection2Content =>
      'Provide learning services, recommend suitable videos, track progress, and send streak reminders (if enabled).';

  @override
  String get privacySection3Title => '3. Third-Party Services';

  @override
  String get privacySection3Content =>
      'Google OAuth, Facebook, YouTube API, Polar.sh (payments), and Google Analytics 4.';

  @override
  String get privacySection4Title => '4. Cookies & Tracking';

  @override
  String get privacySection4Content =>
      'We use essential cookies for login and anonymous analytics cookies.';

  @override
  String get privacySection5Title => '5. Your Rights';

  @override
  String get privacySection5Content =>
      'You can delete, export, or edit your data anytime in Settings.';

  @override
  String get privacySection6Title => '6. Data Security';

  @override
  String get privacySection6Content =>
      'Data is encrypted in transit and stored on secure infrastructure.';

  @override
  String get privacyContact => 'Contact: privacy@vocabik.com';

  @override
  String get pricingTitle => 'Learn English without limits';

  @override
  String get pricingSubtitle => 'Unlock Vocabik Premium from \$5/mo.';

  @override
  String get pricingMonthly => 'Monthly';

  @override
  String get pricingYearly => 'Yearly -33%';

  @override
  String get pricingFreeTag => 'FREE';

  @override
  String get pricingFreeTitle => 'Free';

  @override
  String get pricingFreeForever => 'forever';

  @override
  String get pricingFreeFeat1 => 'Curated library';

  @override
  String get pricingFreeFeat2 => '5 exercises / day';

  @override
  String get pricingFreeFeat3 => 'MC + Free-text';

  @override
  String get pricingFreeFeat4 => 'Progress tracking';

  @override
  String get pricingFreeFeat5 => 'Score Card';

  @override
  String get pricingFreeBtn => 'Use for free';

  @override
  String get pricingPremiumTag => 'PREMIUM';

  @override
  String get pricingPremiumTitle => 'PREMIUM';

  @override
  String get pricingPremiumMostPopular => 'MOST POPULAR';

  @override
  String get pricingPremiumPriceMonthly => '\$5';

  @override
  String get pricingPremiumPriceYearly => '\$40';

  @override
  String get pricingPremiumPerMonth => '/mo';

  @override
  String get pricingPremiumPerYear => '/yr';

  @override
  String get pricingPremiumFeat1 => 'Everything in Free';

  @override
  String get pricingPremiumFeat2 => 'Paste any YouTube URL';

  @override
  String get pricingPremiumFeat3 => 'Unlimited learning';

  @override
  String get pricingPremiumFeat4 => 'All exercise versions';

  @override
  String get pricingPremiumFeat5 => 'Streak Freeze';

  @override
  String get pricingPremiumFeat6 => 'Unlimited hints';

  @override
  String get pricingPremiumFeat7 => 'Suggest a video for the library';

  @override
  String get pricingPremiumBtn => 'Start Premium →';

  @override
  String get pricingCancelAnytime => 'Cancel anytime';

  @override
  String get pricingBadgeSecure => 'Secure payment';

  @override
  String get pricingBadgeCancel => 'Cancel anytime';

  @override
  String get pricingBadgeCard => 'Visa/Mastercard';

  @override
  String get pricingBadgeSupport => '24h support';

  @override
  String get pricingFaqTitle => 'Frequently asked questions';

  @override
  String get pricingFaq1Q => 'Can I cancel?';

  @override
  String get pricingFaq1A => 'Yes, anytime, at no cost.';

  @override
  String get pricingFaq2Q => 'Can I use a Vietnamese card?';

  @override
  String get pricingFaq2A => 'Yes, we accept international Visa/Mastercard.';

  @override
  String get pricingFaq3Q => 'Is there a free trial?';

  @override
  String get pricingFaq3A => 'The Free plan is a permanent trial.';

  @override
  String get pricingFaq4Q => 'Can I get an annual refund?';

  @override
  String get pricingFaq4A => 'Within 7 days of payment.';

  @override
  String get forgotPasswordHeading => 'Forgot password?';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your email, we will send you a reset link.';

  @override
  String get backToLogin => 'Back to login';

  @override
  String get sendResetLink => 'Send reset link →';

  @override
  String get resetPasswordHeading => 'Set new password';

  @override
  String get newPasswordHint => 'New password';

  @override
  String get confirmPasswordHint => 'Confirm password';

  @override
  String get resetPasswordAction => 'Reset password →';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get emailSentSuccess =>
      'A password reset link has been sent to your email.';

  @override
  String get resetPasswordSuccess =>
      'Password updated successfully. You may now sign in.';
}
