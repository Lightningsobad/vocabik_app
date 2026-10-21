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
  String get allPagesTitle => 'All pages';

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
  String get actionDailyChallenge => 'Daily Challenge';

  @override
  String get profileChangePhoto => 'Change photo';

  @override
  String get profileYourName => 'Your name';

  @override
  String get profileUpdateSuccess => 'Name updated successfully!';

  @override
  String get actionSave => 'Save';

  @override
  String get actionEdit => 'Edit';

  @override
  String get profileEmail => 'Email: ';

  @override
  String get profileReadOnly => ' (readonly)';

  @override
  String profileMemberSince(String date) {
    return 'Member since: $date';
  }

  @override
  String get profileLoadError => 'Could not load profile information.';

  @override
  String get profileRetry => 'Retry';

  @override
  String get profileDefaultUser => 'User';

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
  String get accountLogOut => 'Log out';

  @override
  String get accountDeletePermanently => 'Delete account permanently';

  @override
  String get deleteAccountDialogTitle => 'Delete your account?';

  @override
  String get deleteAccountDialogWarning =>
      'This action cannot be undone. All your learning progress, XP points, streak, personal notebook, and friends list will be permanently deleted.';

  @override
  String get deleteAccountPasswordLabel => 'Confirmation password';

  @override
  String get deleteAccountPasswordHint => 'Enter your password';

  @override
  String get deleteAccountPasswordOptionalNote =>
      '(Leave blank if signed in with Google)';

  @override
  String get deleteAccountConfirmAction => 'Confirm delete account';

  @override
  String get deleteAccountSuccessMessage =>
      'Your account has been deleted successfully.';

  @override
  String get deleteAccountErrorPasswordRequired =>
      'Password is required to confirm account deletion.';

  @override
  String get deleteAccountErrorInvalidPassword =>
      'Incorrect password. Please try again.';

  @override
  String get deleteAccountErrorGeneric =>
      'Could not delete account. Please try again later.';

  @override
  String get securityTab_currentPasswordLabel => 'Current password';

  @override
  String get securityTab_newPasswordLabel => 'New password';

  @override
  String get securityTab_updateButton => 'Update';

  @override
  String get securityTab_activeSessionsTitle => 'Active sessions';

  @override
  String get securityTab_sessionEmpty => 'No active sessions';

  @override
  String get securityTab_sessionRetry => 'Retry';

  @override
  String get securityTab_sessionLoadError => 'Unable to load active sessions.';

  @override
  String securityTab_sessionShowMore(int count) {
    return 'Show more ($count)';
  }

  @override
  String get securityTab_sessionShowLess => 'Show less';

  @override
  String get action_show => 'Show';

  @override
  String get action_hide => 'Hide';

  @override
  String get homeDailyPickTitle => 'Handpicked for you today';

  @override
  String get homeRecommendedTitle => 'ALSO FOR YOU';

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
  String get homePrivacyPolicy => 'Privacy Policy';

  @override
  String get homeTerms => 'Terms';

  @override
  String homePracticed(String count) {
    return '$count practiced';
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
  String get progressAchievements => 'Achievements';

  @override
  String get progressLeaderboard => 'Leaderboard';

  @override
  String get progressDayStreak => 'day streak';

  @override
  String get progressXP => 'XP';

  @override
  String get progressExercisesDone => 'exercises done';

  @override
  String get progressAccuracy => 'accuracy';

  @override
  String get progress30DayStreak => '30-day streak';

  @override
  String progressStreakFreezeCount(int count) {
    return 'Streak Freeze: $count left';
  }

  @override
  String progressXpRatio(int current, int max) {
    return '$current / $max XP';
  }

  @override
  String progressNextLevel(String title) {
    return '→ Next: $title';
  }

  @override
  String get progressMaxLevelReached => 'Max level reached! 🎉';

  @override
  String get progressNoAreasToImprove => 'No weak points data yet';

  @override
  String progressPracticeTarget(String category) {
    return 'Practice $category →';
  }

  @override
  String get progressNoLearningHistory => 'No recent learning history';

  @override
  String get progressDateToday => 'Today';

  @override
  String get progressDateYesterday => 'Yesterday';

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
  String get hideVietnameseTranslation => 'Hide translation';

  @override
  String get nameCannotBeEmpty => 'Name cannot be empty';

  @override
  String get termsText => 'Terms';

  @override
  String get securityText => 'Privacy Policy';

  @override
  String get signUpTermsPrefix =>
      'By continuing, you confirm that you are at least 13 years old and agree to our ';

  @override
  String get signUpTermsAnd => ' & ';

  @override
  String get legalConsentTitle => 'Terms & Privacy Update';

  @override
  String get legalConsentDescription =>
      'Vocabik has updated its Terms of Service and Privacy Policy for users aged 13 and older. Please review and accept to continue.';

  @override
  String get legalConsentAgreeButton => 'I\'m 13+ & I Agree';

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
  String shareLessonMessage(String title, String url) {
    return 'Practice English with \"$title\" on Vocabik!\n$url';
  }

  @override
  String shareScoreCardMessage(int score, String title, String url) {
    return 'I just scored $score% on \"$title\" on Vocabik! 🎯\n$url';
  }

  @override
  String get resultSharingImage => 'Preparing score card image...';

  @override
  String get resultShareImageFailedFallback =>
      'Could not prepare image, sharing link instead...';

  @override
  String get termsOfServiceTitle => 'Terms of Service';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String legalLastUpdated(String date) {
    return 'Last updated: $date';
  }

  @override
  String get legalLastUpdatedDefaultDate => '15/10/2026';

  @override
  String get tosSection1Title => '1. Acceptance of Terms';

  @override
  String get tosSection1Content =>
      'Vocabik is an English learning service designed for individuals who are at least 13 years old. By using Vocabik and creating an account, you confirm that you are 13 years of age or older, and agree to these Terms, YouTube\'s Terms of Service (https://www.youtube.com/t/terms), and Google\'s Privacy Policy (https://policies.google.com/privacy).';

  @override
  String get tosSection2Title => '2. User Account';

  @override
  String get tosSection2Content =>
      'You are responsible for safeguarding your login credentials.';

  @override
  String get tosSection3Title => '3. Use of Service & User Conduct';

  @override
  String get tosSection3Content =>
      'Do not use the service for illegal purposes, violate YouTube Terms of Service, post abusive content, or harass others. Vocabik enforces zero tolerance for objectionable content and abusive users.';

  @override
  String get tosSection4Title => '4. Content & Intellectual Property';

  @override
  String get tosSection4Content =>
      'Video content belongs to original owners on YouTube; Vocabik only creates learning exercises.';

  @override
  String get tosSection5Title => '5. Account Termination';

  @override
  String get tosSection5Content =>
      'Accounts that violate terms, engage in abusive behavior, or post objectionable content may be terminated immediately.';

  @override
  String get tosContact => 'Contact: support@vocabik.com';

  @override
  String get privacySummaryTitle => 'Summary:';

  @override
  String get privacySummaryContent =>
      'Vocabik is designed for users aged 13 and older. We collect email, display name, and learning data to provide services and do not sell your data. We do not knowingly collect personal information from children under 13.';

  @override
  String get privacySection1Title => '1. Information We Collect';

  @override
  String get privacySection1Content =>
      'Email, display name, pseudonymous identifiers, and learning data (progress, scores, saved vocabulary) to personalize your experience.';

  @override
  String get privacySection2Title => '2. How We Use Information';

  @override
  String get privacySection2Content =>
      'Provide learning services, recommend suitable videos, track progress, maintain leaderboards, and send streak reminders (if enabled).';

  @override
  String get privacySection3Title => '3. Third-Party Services';

  @override
  String get privacySection3Content =>
      'Google Sign-In, YouTube API Services, Firebase (Crashlytics diagnostics, Cloud Messaging, In-App Messaging), and Google Analytics. By using YouTube-powered features, you agree to the Google Privacy Policy (https://policies.google.com/privacy).';

  @override
  String get privacySection4Title => '4. Cookies & Diagnostics';

  @override
  String get privacySection4Content =>
      'We collect necessary authentication tokens and pseudonymous diagnostic crash logs linked to your account to improve app performance.';

  @override
  String get privacySection5Title => '5. Your Rights & Data Deletion';

  @override
  String get privacySection5Content =>
      'You can request account deletion or data inquiry at any time by visiting https://vocabik.com/delete-account or contacting privacy@vocabik.com.';

  @override
  String get privacySection6Title => '6. Data Security';

  @override
  String get privacySection6Content =>
      'Data is encrypted in transit using HTTPS and stored on secure infrastructure.';

  @override
  String get privacyContact => 'Contact: privacy@vocabik.com';

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

  @override
  String get achievementsYourAchievements => 'Your achievements';

  @override
  String achievementsBadgesUnlocked(int count, int total) {
    return '$count / $total badges unlocked';
  }

  @override
  String get achievementsUnlockedHeader => 'UNLOCKED';

  @override
  String get achievementsLockedHeader => 'LOCKED';

  @override
  String get achievementsEmpty => 'No achievements available yet.';

  @override
  String get achievementsFilterAll => 'All';

  @override
  String get achievementsFilterExercise => 'Exercise';

  @override
  String get achievementsFilterStreak => 'Streak';

  @override
  String get achievementsFilterProficiency => 'Proficiency';

  @override
  String get achievementsFilterDiversity => 'Diversity';

  @override
  String get achievementsFilterVocabulary => 'Vocabulary';

  @override
  String get achievementsFilterSpeed => 'Speed';

  @override
  String get achievementsFilterGeneral => 'General';

  @override
  String get achievementsFilterMilestones => 'Milestones';

  @override
  String get achievementsFilterGenre => 'Genre';

  @override
  String get dailyChallengeTitle => 'Daily Challenge';

  @override
  String get dailyChallengeJoinNow => 'Join now! →';

  @override
  String get dailyChallengeTopToday => 'Top today';

  @override
  String dailyChallengeStreakDays(int count) {
    return 'You\'ve joined $count days in a row!';
  }

  @override
  String get dailyChallengeStreakKeep =>
      'Join today to start or keep your streak!';

  @override
  String dailyChallengeParticipants(String count) {
    return '$count participants';
  }

  @override
  String get dailyChallengeNoParticipants =>
      'No participants yet today. Be the first!';

  @override
  String get dailyChallengeNotConfigured => 'No challenge available for today';

  @override
  String get xpLeaderboardTitle => 'XP Leaderboard';

  @override
  String xpLeaderboardResetsIn(String time) {
    return 'Resets in: $time';
  }

  @override
  String xpLeaderboardResetsInDays(int days) {
    return 'Resets in: $days days';
  }

  @override
  String xpLeaderboardResetsInHours(int hours) {
    return 'Resets in: $hours hours';
  }

  @override
  String xpLeaderboardResetsInMinutes(int minutes) {
    return 'Resets in: $minutes mins';
  }

  @override
  String get xpLeaderboardResettingSoon => 'Resetting soon';

  @override
  String get xpLeaderboardFilterThisWeek => 'This week';

  @override
  String get xpLeaderboardFilterLastWeek => 'Last week';

  @override
  String get xpLeaderboardFilterThisMonth => 'This month';

  @override
  String get xpLeaderboardFilterGlobal => 'Global';

  @override
  String get xpLeaderboardFilterFriends => 'Friends';

  @override
  String get xpLeaderboardYourRank => 'Your rank';

  @override
  String get xpLeaderboardEmpty => 'No leaderboard data found';

  @override
  String get challengeFriendTitle => 'Challenge a friend';

  @override
  String get challengeFriendSubtitle =>
      'Pick friends to take this exercise. Higher score wins.';

  @override
  String get challengeSearchFriendsHint => 'Search friends...';

  @override
  String get challengeFriendsSection => 'FRIENDS ON VOCABIK';

  @override
  String get challengePickAtLeastOne => 'Pick at least 1';

  @override
  String challengeSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get challengeSend => 'Send challenge';

  @override
  String challengeSendWithCount(int count) {
    return 'Send challenge ($count) →';
  }

  @override
  String challengeBlanksCount(int count) {
    return '$count blanks';
  }

  @override
  String get challengeNoFriendsFound => 'No friends found';

  @override
  String get challengeLoadingFriends => 'Loading friends...';

  @override
  String get challengeLoadFriendsError => 'Failed to load friends';

  @override
  String get challengeCreateLinkError => 'Failed to create challenge link';

  @override
  String get challengeSentTitle => 'Challenge sent!';

  @override
  String challengeSentSubtitleSingle(int score, String title, String friend) {
    return 'Your score $score% on “$title” was sent to $friend.';
  }

  @override
  String challengeSentSubtitleMultiple(int score, String title, int count) {
    return 'Your score $score% on “$title” was sent to $count friends.';
  }

  @override
  String get challengeInfo24HoursTitle => 'They have 24 hours to reply';

  @override
  String get challengeInfo24HoursDesc =>
      'If they run out of time, you win by default.';

  @override
  String get challengeInfoNotifiedTitle => 'You\'ll be notified';

  @override
  String get challengeInfoNotifiedDesc =>
      'As soon as someone finishes the challenge.';

  @override
  String get challengeInfoWinXpTitle => 'Win to earn +50 XP';

  @override
  String get challengeInfoWinXpDesc => 'Beat their score to win.';

  @override
  String get challengeCopyLink => 'Copy challenge link';

  @override
  String get challengeViewLeaderboard => 'View leaderboard →';

  @override
  String get challengeLinkCopied => 'Challenge link copied to clipboard!';

  @override
  String get notebookTitle => 'Notebook';

  @override
  String wordsCount(int count) {
    return '$count words';
  }

  @override
  String get searchWordsPlaceholder => 'Search words...';

  @override
  String get tabList => 'List';

  @override
  String get tabFlashcard => 'Flashcard';

  @override
  String get tapToFlip => 'Tap to flip';

  @override
  String get reviewAgain => 'Review again';

  @override
  String get gotIt => 'Got it';

  @override
  String get emptyNotebook => 'No words saved yet.';

  @override
  String get noSearchResults => 'No words found matching your search.';

  @override
  String get reviewFinishedTitle => 'All caught up!';

  @override
  String get reviewFinishedDesc => 'You have reviewed all your flashcards.';

  @override
  String get reportUserTitle => 'Report user';

  @override
  String reportUserSubtitle(String userName) {
    return 'Select a reason for reporting account “$userName”:';
  }

  @override
  String get reportReasonInappropriateName =>
      'Inappropriate or offensive display name';

  @override
  String get reportReasonInappropriateAvatar =>
      'Profile picture violates community guidelines';

  @override
  String get reportReasonHarassmentOrCheating => 'Harassment or cheating';

  @override
  String get reportReasonSpamOrAd => 'Spam or advertising content';

  @override
  String get reportUserSubmit => 'Submit report';

  @override
  String get reportUserSuccessMessage =>
      'Thank you. Your report has been received and forwarded to our moderation team.';

  @override
  String get reportReasonSpam => 'Spam or advertising content';

  @override
  String get reportReasonHarassment => 'Harassment or bullying';

  @override
  String get reportReasonInappropriateContent => 'Inappropriate content / 18+';

  @override
  String get reportReasonHateSpeech => 'Hate speech';

  @override
  String get reportReasonOther => 'Other reason';

  @override
  String get reportDetailsLabel => 'Violation details (optional)';

  @override
  String get reportDetailsHint =>
      'Enter additional details about this violation...';

  @override
  String get reportSuccess24h =>
      'Thank you for your report. Our moderation team will review and take action within 24 hours.';

  @override
  String get reportSubmitting => 'Submitting report...';

  @override
  String get blockedUsersTitle => 'Blocked users';

  @override
  String get blockedUsersEmpty => 'You have not blocked any users.';

  @override
  String get blockedUsersError => 'Unable to load blocked users.';

  @override
  String get unblockAction => 'Unblock';

  @override
  String unblockSuccess(String userName) {
    return 'Unblocked $userName.';
  }

  @override
  String get unblockConfirmTitle => 'Unblock user?';

  @override
  String unblockConfirmMessage(String userName) {
    return 'Are you sure you want to unblock $userName? They will be able to interact with you again.';
  }

  @override
  String get blockUserTitle => 'Block user';

  @override
  String blockUserConfirmMessage(String userName) {
    return 'Are you sure you want to block $userName? They will be removed from your friends and hidden from all interactions.';
  }

  @override
  String get blockUserAction => 'Block';

  @override
  String blockUserSuccess(String userName) {
    return 'Blocked $userName successfully.';
  }

  @override
  String get blockUserPromptTitle => 'Block this user?';

  @override
  String get blockUserPromptDesc =>
      'Would you like to block this user as well? You will no longer see their activity.';

  @override
  String get actionLater => 'Later';

  @override
  String get actionOptions => 'Interaction options';

  @override
  String get reportUserOption => 'Report violation';

  @override
  String get blockUserOption => 'Block user';

  @override
  String get cannotReportSelf => 'You cannot report yourself.';

  @override
  String get cannotBlockSelf => 'You cannot block yourself.';

  @override
  String blockedAtDate(String date) {
    return 'Blocked on: $date';
  }

  @override
  String get unblocking => 'Unblocking...';

  @override
  String get blocking => 'Blocking...';

  @override
  String get reportVideoTitle => 'Report video';

  @override
  String reportVideoSubtitle(String videoTitle) {
    return 'Select a reason for reporting video “$videoTitle”:';
  }

  @override
  String get reportVideoOption => 'Report this video';

  @override
  String get reportVideoTooltip => 'Report video violation';
}
