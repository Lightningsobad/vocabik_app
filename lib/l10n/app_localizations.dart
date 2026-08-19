import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @homeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get homeTitle;

  /// No description provided for @homeScreenContent.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung trang chủ'**
  String get homeScreenContent;

  /// No description provided for @discoverTitle.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá'**
  String get discoverTitle;

  /// No description provided for @progressTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ'**
  String get progressTitle;

  /// No description provided for @profileTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ'**
  String get profileTitle;

  /// No description provided for @discoverScreenContent.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung Khám phá'**
  String get discoverScreenContent;

  /// No description provided for @progressScreenContent.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung Tiến độ'**
  String get progressScreenContent;

  /// No description provided for @profileSettingsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ & Cài đặt'**
  String get profileSettingsTitle;

  /// No description provided for @profileTab.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ'**
  String get profileTab;

  /// No description provided for @preferencesTab.
  ///
  /// In vi, this message translates to:
  /// **'Tuỳ chỉnh'**
  String get preferencesTab;

  /// No description provided for @subscriptionTab.
  ///
  /// In vi, this message translates to:
  /// **'Gói cước'**
  String get subscriptionTab;

  /// No description provided for @securityTab.
  ///
  /// In vi, this message translates to:
  /// **'Bảo mật'**
  String get securityTab;

  /// No description provided for @accountTab.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản'**
  String get accountTab;

  /// No description provided for @tabNotImplemented.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung cho Tab {tabIndex} chưa được phát triển.'**
  String tabNotImplemented(int tabIndex);

  /// No description provided for @actionAchievements.
  ///
  /// In vi, this message translates to:
  /// **'Thành tích'**
  String get actionAchievements;

  /// No description provided for @actionNotebook.
  ///
  /// In vi, this message translates to:
  /// **'Sổ từ vựng'**
  String get actionNotebook;

  /// No description provided for @actionLeaderboard.
  ///
  /// In vi, this message translates to:
  /// **'Xếp hạng'**
  String get actionLeaderboard;

  /// No description provided for @actionClassroom.
  ///
  /// In vi, this message translates to:
  /// **'Lớp học'**
  String get actionClassroom;

  /// No description provided for @actionDailyChallenge.
  ///
  /// In vi, this message translates to:
  /// **'Thử thách ngày'**
  String get actionDailyChallenge;

  /// No description provided for @actionBotIntegration.
  ///
  /// In vi, this message translates to:
  /// **'Tích hợp Bot'**
  String get actionBotIntegration;

  /// No description provided for @profileChangePhoto.
  ///
  /// In vi, this message translates to:
  /// **'Đổi ảnh'**
  String get profileChangePhoto;

  /// No description provided for @profileYourName.
  ///
  /// In vi, this message translates to:
  /// **'Tên của bạn'**
  String get profileYourName;

  /// No description provided for @profileEmail.
  ///
  /// In vi, this message translates to:
  /// **'Email: '**
  String get profileEmail;

  /// No description provided for @profileReadOnly.
  ///
  /// In vi, this message translates to:
  /// **' (chỉ xem)'**
  String get profileReadOnly;

  /// No description provided for @profileMemberSince.
  ///
  /// In vi, this message translates to:
  /// **'Thành viên từ: {date}'**
  String profileMemberSince(String date);

  /// No description provided for @appearance.
  ///
  /// In vi, this message translates to:
  /// **'Giao diện'**
  String get appearance;

  /// No description provided for @themeDark.
  ///
  /// In vi, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In vi, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @soundDuringExercise.
  ///
  /// In vi, this message translates to:
  /// **'Âm thanh khi làm bài'**
  String get soundDuringExercise;

  /// No description provided for @interfaceLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ giao diện'**
  String get interfaceLanguage;

  /// No description provided for @languageVietnamese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Việt'**
  String get languageVietnamese;

  /// No description provided for @languageEnglish.
  ///
  /// In vi, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @botIntegrationTelegramZalo.
  ///
  /// In vi, this message translates to:
  /// **'Tích hợp Bot (Telegram / Zalo)'**
  String get botIntegrationTelegramZalo;

  /// No description provided for @subscriptionFreePlanTitle.
  ///
  /// In vi, this message translates to:
  /// **'Gói Free'**
  String get subscriptionFreePlanTitle;

  /// No description provided for @subscriptionFreePlanDesc.
  ///
  /// In vi, this message translates to:
  /// **'Học phong phú hơn với Premium.'**
  String get subscriptionFreePlanDesc;

  /// No description provided for @subscriptionUpgradeBtn.
  ///
  /// In vi, this message translates to:
  /// **'Nâng lên Premium →'**
  String get subscriptionUpgradeBtn;

  /// No description provided for @accountExportData.
  ///
  /// In vi, this message translates to:
  /// **'Xuất dữ liệu của tôi'**
  String get accountExportData;

  /// No description provided for @accountLogOut.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get accountLogOut;

  /// No description provided for @accountDeletePermanently.
  ///
  /// In vi, this message translates to:
  /// **'Xóa tài khoản vĩnh viễn'**
  String get accountDeletePermanently;

  /// No description provided for @securityTab_currentPasswordLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu hiện tại'**
  String get securityTab_currentPasswordLabel;

  /// No description provided for @securityTab_newPasswordLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu mới'**
  String get securityTab_newPasswordLabel;

  /// No description provided for @securityTab_updateButton.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật'**
  String get securityTab_updateButton;

  /// No description provided for @securityTab_activeSessionsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Phiên đăng nhập'**
  String get securityTab_activeSessionsTitle;

  /// No description provided for @action_show.
  ///
  /// In vi, this message translates to:
  /// **'Hiện'**
  String get action_show;

  /// No description provided for @action_hide.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn'**
  String get action_hide;

  /// No description provided for @integrationScreenTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tích hợp'**
  String get integrationScreenTitle;

  /// No description provided for @integrationTelegramTitle.
  ///
  /// In vi, this message translates to:
  /// **'Telegram Bot'**
  String get integrationTelegramTitle;

  /// No description provided for @integrationTelegramDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nhận bài tập mỗi sáng qua Telegram'**
  String get integrationTelegramDesc;

  /// No description provided for @integrationZaloTitle.
  ///
  /// In vi, this message translates to:
  /// **'Zalo OA'**
  String get integrationZaloTitle;

  /// No description provided for @integrationZaloDesc.
  ///
  /// In vi, this message translates to:
  /// **'Cấu trúc tương tự Telegram'**
  String get integrationZaloDesc;

  /// No description provided for @statusNotConnected.
  ///
  /// In vi, this message translates to:
  /// **'Chưa kết nối'**
  String get statusNotConnected;

  /// No description provided for @statusConnected.
  ///
  /// In vi, this message translates to:
  /// **'Đã kết nối'**
  String get statusConnected;

  /// No description provided for @instructionConnectLabel.
  ///
  /// In vi, this message translates to:
  /// **'1. Nhấn \"Kết nối\" bên dưới'**
  String get instructionConnectLabel;

  /// No description provided for @instructionStartLabel.
  ///
  /// In vi, this message translates to:
  /// **'2. Nhấn Start trong Telegram'**
  String get instructionStartLabel;

  /// No description provided for @instructionAutoConnectLabel.
  ///
  /// In vi, this message translates to:
  /// **'3. Bot tự kết nối tài khoản'**
  String get instructionAutoConnectLabel;

  /// No description provided for @timeToReceiveLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian nhận bài'**
  String get timeToReceiveLabel;

  /// No description provided for @levelLabel.
  ///
  /// In vi, this message translates to:
  /// **'Level'**
  String get levelLabel;

  /// No description provided for @connectTelegramBtn.
  ///
  /// In vi, this message translates to:
  /// **'Kết nối Telegram Bot →'**
  String get connectTelegramBtn;

  /// No description provided for @connectZaloBtn.
  ///
  /// In vi, this message translates to:
  /// **'Kết nối Zalo OA →'**
  String get connectZaloBtn;

  /// No description provided for @disconnectBtn.
  ///
  /// In vi, this message translates to:
  /// **'Hủy kết nối'**
  String get disconnectBtn;

  /// No description provided for @homeDailyPickTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tuyển chọn cho bạn hôm nay'**
  String get homeDailyPickTitle;

  /// No description provided for @homeRecommendedTitle.
  ///
  /// In vi, this message translates to:
  /// **'CŨNG DÀNH CHO BẠN'**
  String get homeRecommendedTitle;

  /// No description provided for @homeTodayProgress.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get homeTodayProgress;

  /// No description provided for @homeUnlimited.
  ///
  /// In vi, this message translates to:
  /// **'Không giới hạn'**
  String get homeUnlimited;

  /// No description provided for @homeAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get homeAll;

  /// No description provided for @homeDailyChallenge.
  ///
  /// In vi, this message translates to:
  /// **'Daily Challenge hôm nay'**
  String get homeDailyChallenge;

  /// No description provided for @homeTrending.
  ///
  /// In vi, this message translates to:
  /// **'Trending tuần này'**
  String get homeTrending;

  /// No description provided for @homeViewAll.
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả →'**
  String get homeViewAll;

  /// No description provided for @homeRecentlyAdded.
  ///
  /// In vi, this message translates to:
  /// **'Mới thêm'**
  String get homeRecentlyAdded;

  /// No description provided for @homeLibrary.
  ///
  /// In vi, this message translates to:
  /// **'Thư viện'**
  String get homeLibrary;

  /// No description provided for @homePricing.
  ///
  /// In vi, this message translates to:
  /// **'Bảng giá'**
  String get homePricing;

  /// No description provided for @homePrivacyPolicy.
  ///
  /// In vi, this message translates to:
  /// **'Chính sách bảo mật'**
  String get homePrivacyPolicy;

  /// No description provided for @homeTerms.
  ///
  /// In vi, this message translates to:
  /// **'Điều khoản'**
  String get homeTerms;

  /// No description provided for @homePracticed.
  ///
  /// In vi, this message translates to:
  /// **'{count} đã luyện'**
  String homePracticed(String count);

  /// No description provided for @homeLessons.
  ///
  /// In vi, this message translates to:
  /// **'{current} / {total} bài'**
  String homeLessons(int current, int total);

  /// No description provided for @homeDailyPickTag.
  ///
  /// In vi, this message translates to:
  /// **'DAILY PICK'**
  String get homeDailyPickTag;

  /// No description provided for @homeNewTag.
  ///
  /// In vi, this message translates to:
  /// **'NEW'**
  String get homeNewTag;

  /// No description provided for @homeChallengeParticipants.
  ///
  /// In vi, this message translates to:
  /// **'{count} người đã tham gia'**
  String homeChallengeParticipants(String count);

  /// No description provided for @discoverSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm theo bài hát, nghệ sĩ...'**
  String get discoverSearchHint;

  /// No description provided for @discoverFilterAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get discoverFilterAll;

  /// No description provided for @discoverTrendingTitle.
  ///
  /// In vi, this message translates to:
  /// **'Trending 🔥'**
  String get discoverTrendingTitle;

  /// No description provided for @discoverPlaylistTitle.
  ///
  /// In vi, this message translates to:
  /// **'Playlist tuyển chọn'**
  String get discoverPlaylistTitle;

  /// No description provided for @discoverTimeUnder3.
  ///
  /// In vi, this message translates to:
  /// **'< 3 phút'**
  String get discoverTimeUnder3;

  /// No description provided for @discoverTime3To7.
  ///
  /// In vi, this message translates to:
  /// **'3-7 phút'**
  String get discoverTime3To7;

  /// No description provided for @discoverTimeOver7.
  ///
  /// In vi, this message translates to:
  /// **'> 7 phút'**
  String get discoverTimeOver7;

  /// No description provided for @discoverFilter7Days.
  ///
  /// In vi, this message translates to:
  /// **'7 Ngày'**
  String get discoverFilter7Days;

  /// No description provided for @discoverEmptyResult.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy kết quả'**
  String get discoverEmptyResult;

  /// No description provided for @discoverErrorLoad.
  ///
  /// In vi, this message translates to:
  /// **'Đã có lỗi xảy ra'**
  String get discoverErrorLoad;

  /// No description provided for @discoverRetryButton.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get discoverRetryButton;

  /// No description provided for @discoverSearchResultsWithQuery.
  ///
  /// In vi, this message translates to:
  /// **'Found {count} kết quả cho \"{query}\"'**
  String discoverSearchResultsWithQuery(int count, String query);

  /// No description provided for @discoverSearchResults.
  ///
  /// In vi, this message translates to:
  /// **'Found {count} kết quả'**
  String discoverSearchResults(int count);

  /// No description provided for @discoverVideosCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} videos'**
  String discoverVideosCount(int count);

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn đăng xuất không?'**
  String get logoutConfirmMessage;

  /// No description provided for @actionCancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get actionCancel;

  /// No description provided for @actionConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get actionConfirm;

  /// No description provided for @signUpTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get signUpTitle;

  /// No description provided for @createFreeAccount.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản miễn phí'**
  String get createFreeAccount;

  /// No description provided for @startLearningToday.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu học ngay hôm nay'**
  String get startLearningToday;

  /// No description provided for @signUpWithGoogle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký với Google'**
  String get signUpWithGoogle;

  /// No description provided for @orText.
  ///
  /// In vi, this message translates to:
  /// **'hoặc'**
  String get orText;

  /// No description provided for @yourName.
  ///
  /// In vi, this message translates to:
  /// **'Tên của bạn'**
  String get yourName;

  /// No description provided for @emailHint.
  ///
  /// In vi, this message translates to:
  /// **'Email của bạn'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get passwordHint;

  /// No description provided for @passwordStrengthNone.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có'**
  String get passwordStrengthNone;

  /// No description provided for @passwordStrengthWeak.
  ///
  /// In vi, this message translates to:
  /// **'Yếu'**
  String get passwordStrengthWeak;

  /// No description provided for @passwordStrengthMedium.
  ///
  /// In vi, this message translates to:
  /// **'Trung bình'**
  String get passwordStrengthMedium;

  /// No description provided for @passwordStrengthStrong.
  ///
  /// In vi, this message translates to:
  /// **'Mạnh'**
  String get passwordStrengthStrong;

  /// No description provided for @signUpTerms.
  ///
  /// In vi, this message translates to:
  /// **'Bằng cách đăng ký, bạn đồng ý Điều khoản & Bảo mật'**
  String get signUpTerms;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In vi, this message translates to:
  /// **'Đã có tài khoản? Đăng nhập →'**
  String get alreadyHaveAccount;

  /// No description provided for @alreadyHaveAccountPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Đã có tài khoản? '**
  String get alreadyHaveAccountPrompt;

  /// No description provided for @loginActionLink.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập →'**
  String get loginActionLink;

  /// No description provided for @checkYourEmail.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra email của bạn'**
  String get checkYourEmail;

  /// No description provided for @checkEmailSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi đã gửi đến:\n{email}'**
  String checkEmailSubtitle(String email);

  /// No description provided for @resendIn.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lại sau {seconds} giây'**
  String resendIn(int seconds);

  /// No description provided for @resendEmail.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lại email'**
  String get resendEmail;

  /// No description provided for @iHaveVerified.
  ///
  /// In vi, this message translates to:
  /// **'Tôi đã xác thực → tiếp tục'**
  String get iHaveVerified;

  /// No description provided for @spamCheckTip.
  ///
  /// In vi, this message translates to:
  /// **'Không thấy email? Kiểm tra thư mục Spam.'**
  String get spamCheckTip;

  /// No description provided for @whereIsYourEnglish.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Anh của bạn hiện ở đâu?'**
  String get whereIsYourEnglish;

  /// No description provided for @weWillSuggest.
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi sẽ gợi ý bài phù hợp nhất với bạn.'**
  String get weWillSuggest;

  /// No description provided for @levelA1A2.
  ///
  /// In vi, this message translates to:
  /// **'A1–A2'**
  String get levelA1A2;

  /// No description provided for @levelA1A2Desc.
  ///
  /// In vi, this message translates to:
  /// **'Mới bắt đầu'**
  String get levelA1A2Desc;

  /// No description provided for @levelB1.
  ///
  /// In vi, this message translates to:
  /// **'B1'**
  String get levelB1;

  /// No description provided for @levelB1Desc.
  ///
  /// In vi, this message translates to:
  /// **'Cơ bản'**
  String get levelB1Desc;

  /// No description provided for @levelB2.
  ///
  /// In vi, this message translates to:
  /// **'B2'**
  String get levelB2;

  /// No description provided for @levelB2Desc.
  ///
  /// In vi, this message translates to:
  /// **'Khá'**
  String get levelB2Desc;

  /// No description provided for @levelC1.
  ///
  /// In vi, this message translates to:
  /// **'C1'**
  String get levelC1;

  /// No description provided for @levelC1Desc.
  ///
  /// In vi, this message translates to:
  /// **'Nâng cao'**
  String get levelC1Desc;

  /// No description provided for @startLearning.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu học →'**
  String get startLearning;

  /// No description provided for @skipForNow.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua, tôi tự chọn sau'**
  String get skipForNow;

  /// No description provided for @actionSignUp.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get actionSignUp;

  /// No description provided for @homeVideosEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bài tập nào.'**
  String get homeVideosEmpty;

  /// No description provided for @homeVideosError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải danh sách bài tập.'**
  String get homeVideosError;

  /// No description provided for @homeRetry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get homeRetry;

  /// No description provided for @emptySectionText.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có video nào'**
  String get emptySectionText;

  /// No description provided for @videoDetailBack.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get videoDetailBack;

  /// No description provided for @videoDetailMultipleChoice.
  ///
  /// In vi, this message translates to:
  /// **'Trắc nghiệm'**
  String get videoDetailMultipleChoice;

  /// No description provided for @videoDetailExerciseType.
  ///
  /// In vi, this message translates to:
  /// **'Kiểu bài'**
  String get videoDetailExerciseType;

  /// No description provided for @videoDetailFillBlank.
  ///
  /// In vi, this message translates to:
  /// **'Điền từ'**
  String get videoDetailFillBlank;

  /// No description provided for @videoDetailTypeTheAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Gõ đáp án'**
  String get videoDetailTypeTheAnswer;

  /// No description provided for @videoDetailVersion.
  ///
  /// In vi, this message translates to:
  /// **'PHIÊN BẢN'**
  String get videoDetailVersion;

  /// No description provided for @videoDetailVocabulary.
  ///
  /// In vi, this message translates to:
  /// **'Từ vựng'**
  String get videoDetailVocabulary;

  /// No description provided for @videoDetailGrammar.
  ///
  /// In vi, this message translates to:
  /// **'Ngữ pháp'**
  String get videoDetailGrammar;

  /// No description provided for @videoDetailSpeed.
  ///
  /// In vi, this message translates to:
  /// **'Tốc độ'**
  String get videoDetailSpeed;

  /// No description provided for @videoDetailStartPractice.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu luyện tập →'**
  String get videoDetailStartPractice;

  /// No description provided for @authGenericError.
  ///
  /// In vi, this message translates to:
  /// **'Có lỗi xảy ra'**
  String get authGenericError;

  /// No description provided for @loginTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập vào Vocabik'**
  String get loginTitle;

  /// No description provided for @continueWithGoogle.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục với Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithFacebook.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục với Facebook'**
  String get continueWithFacebook;

  /// No description provided for @emailInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Email không hợp lệ'**
  String get emailInvalid;

  /// No description provided for @passwordMinLength.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu phải từ 6 ký tự'**
  String get passwordMinLength;

  /// No description provided for @forgotPassword.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu? →'**
  String get forgotPassword;

  /// No description provided for @actionLogin.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get actionLogin;

  /// No description provided for @noAccount.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tài khoản? '**
  String get noAccount;

  /// No description provided for @signUpFreeAction.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký miễn phí →'**
  String get signUpFreeAction;

  /// No description provided for @progressYourProgress.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ của bạn'**
  String get progressYourProgress;

  /// No description provided for @progressWeeklyXP.
  ///
  /// In vi, this message translates to:
  /// **'XP hàng tuần'**
  String get progressWeeklyXP;

  /// No description provided for @progressAreasToImprove.
  ///
  /// In vi, this message translates to:
  /// **'Cần cải thiện'**
  String get progressAreasToImprove;

  /// No description provided for @progressLearningHistory.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử học tập'**
  String get progressLearningHistory;

  /// No description provided for @exerciseTitle.
  ///
  /// In vi, this message translates to:
  /// **'ĐANG LUYỆN'**
  String get exerciseTitle;

  /// No description provided for @exerciseCorrect.
  ///
  /// In vi, this message translates to:
  /// **'Chính xác! 🎉'**
  String get exerciseCorrect;

  /// No description provided for @exerciseAlmost.
  ///
  /// In vi, this message translates to:
  /// **'Gần đúng!'**
  String get exerciseAlmost;

  /// No description provided for @exerciseHint.
  ///
  /// In vi, this message translates to:
  /// **'💡 Gợi ý'**
  String get exerciseHint;

  /// No description provided for @exerciseContinue.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục →'**
  String get exerciseContinue;

  /// No description provided for @exerciseCheck.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra'**
  String get exerciseCheck;

  /// No description provided for @exercisePlayingVideo.
  ///
  /// In vi, this message translates to:
  /// **'Đang phát video...'**
  String get exercisePlayingVideo;

  /// No description provided for @exerciseCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành bài tập!'**
  String get exerciseCompleted;

  /// No description provided for @viewVietnameseTranslation.
  ///
  /// In vi, this message translates to:
  /// **'Xem dịch tiếng Việt'**
  String get viewVietnameseTranslation;

  /// No description provided for @nameCannotBeEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Tên không được để trống'**
  String get nameCannotBeEmpty;

  /// No description provided for @termsText.
  ///
  /// In vi, this message translates to:
  /// **'Điều khoản'**
  String get termsText;

  /// No description provided for @securityText.
  ///
  /// In vi, this message translates to:
  /// **'Bảo mật'**
  String get securityText;

  /// No description provided for @signUpTermsPrefix.
  ///
  /// In vi, this message translates to:
  /// **'Bằng cách đăng ký, bạn đồng ý '**
  String get signUpTermsPrefix;

  /// No description provided for @signUpTermsAnd.
  ///
  /// In vi, this message translates to:
  /// **' & '**
  String get signUpTermsAnd;

  /// No description provided for @verifySuccessRedirect.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực thành công. Đang chuyển hướng...'**
  String get verifySuccessRedirect;

  /// No description provided for @verifyFailed.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực thất bại'**
  String get verifyFailed;

  /// No description provided for @updateFailed.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật thất bại'**
  String get updateFailed;

  /// No description provided for @invalidToken.
  ///
  /// In vi, this message translates to:
  /// **'Token không hợp lệ hoặc đã hết hạn.'**
  String get invalidToken;

  /// No description provided for @networkError.
  ///
  /// In vi, this message translates to:
  /// **'Không có kết nối mạng. Vui lòng kiểm tra lại.'**
  String get networkError;

  /// No description provided for @serverError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi máy chủ, vui lòng thử lại sau.'**
  String get serverError;

  /// No description provided for @exerciseTypeAnswerHint.
  ///
  /// In vi, this message translates to:
  /// **'Gõ đáp án...'**
  String get exerciseTypeAnswerHint;

  /// No description provided for @exercisePleaseEnterAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập đáp án'**
  String get exercisePleaseEnterAnswer;

  /// No description provided for @exerciseAlmostCorrect.
  ///
  /// In vi, this message translates to:
  /// **'Gần đúng — đáp án là \"{answer}\".'**
  String exerciseAlmostCorrect(String answer);

  /// No description provided for @userAlreadyExists.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản đã tồn tại.'**
  String get userAlreadyExists;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
