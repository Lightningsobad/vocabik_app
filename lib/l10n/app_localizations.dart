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

  /// No description provided for @actionDailyChallenge.
  ///
  /// In vi, this message translates to:
  /// **'Thử thách ngày'**
  String get actionDailyChallenge;

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

  /// No description provided for @profileUpdateSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật tên thành công!'**
  String get profileUpdateSuccess;

  /// No description provided for @actionSave.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get actionSave;

  /// No description provided for @actionEdit.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa'**
  String get actionEdit;

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

  /// No description provided for @profileLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải thông tin hồ sơ.'**
  String get profileLoadError;

  /// No description provided for @profileRetry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get profileRetry;

  /// No description provided for @profileDefaultUser.
  ///
  /// In vi, this message translates to:
  /// **'Người dùng'**
  String get profileDefaultUser;

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
  /// **'Vietnamese'**
  String get languageVietnamese;

  /// No description provided for @languageEnglish.
  ///
  /// In vi, this message translates to:
  /// **'English'**
  String get languageEnglish;

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

  /// No description provided for @deleteAccountDialogTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xóa tài khoản của bạn?'**
  String get deleteAccountDialogTitle;

  /// No description provided for @deleteAccountDialogWarning.
  ///
  /// In vi, this message translates to:
  /// **'Hành động này không thể hoàn tác. Toàn bộ tiến trình học, điểm số XP, chuỗi ngày học Streak, sổ từ vựng cá nhân và danh sách bạn bè của bạn sẽ bị xóa vĩnh viễn.'**
  String get deleteAccountDialogWarning;

  /// No description provided for @deleteAccountPasswordLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu xác nhận'**
  String get deleteAccountPasswordLabel;

  /// No description provided for @deleteAccountPasswordHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mật khẩu của bạn'**
  String get deleteAccountPasswordHint;

  /// No description provided for @deleteAccountPasswordOptionalNote.
  ///
  /// In vi, this message translates to:
  /// **'(Bỏ trống nếu đăng nhập bằng Google)'**
  String get deleteAccountPasswordOptionalNote;

  /// No description provided for @deleteAccountConfirmAction.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận xóa tài khoản'**
  String get deleteAccountConfirmAction;

  /// No description provided for @deleteAccountSuccessMessage.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản của bạn đã được xóa thành công.'**
  String get deleteAccountSuccessMessage;

  /// No description provided for @deleteAccountErrorPasswordRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập mật khẩu để xác nhận xóa tài khoản.'**
  String get deleteAccountErrorPasswordRequired;

  /// No description provided for @deleteAccountErrorInvalidPassword.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu không chính xác, vui lòng thử lại.'**
  String get deleteAccountErrorInvalidPassword;

  /// No description provided for @deleteAccountErrorGeneric.
  ///
  /// In vi, this message translates to:
  /// **'Không thể xóa tài khoản. Vui lòng thử lại sau.'**
  String get deleteAccountErrorGeneric;

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

  /// No description provided for @securityTab_sessionEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Không có phiên hoạt động nào'**
  String get securityTab_sessionEmpty;

  /// No description provided for @securityTab_sessionRetry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get securityTab_sessionRetry;

  /// No description provided for @securityTab_sessionLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải danh sách phiên đăng nhập.'**
  String get securityTab_sessionLoadError;

  /// No description provided for @securityTab_sessionShowMore.
  ///
  /// In vi, this message translates to:
  /// **'Xem thêm ({count})'**
  String securityTab_sessionShowMore(int count);

  /// No description provided for @securityTab_sessionShowLess.
  ///
  /// In vi, this message translates to:
  /// **'Thu gọn'**
  String get securityTab_sessionShowLess;

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

  /// No description provided for @genreMusic.
  ///
  /// In vi, this message translates to:
  /// **'Âm nhạc'**
  String get genreMusic;

  /// No description provided for @genreVlog.
  ///
  /// In vi, this message translates to:
  /// **'Vlog'**
  String get genreVlog;

  /// No description provided for @genreNews.
  ///
  /// In vi, this message translates to:
  /// **'Tin tức'**
  String get genreNews;

  /// No description provided for @genreEducation.
  ///
  /// In vi, this message translates to:
  /// **'Giáo dục'**
  String get genreEducation;

  /// No description provided for @genreEntertainment.
  ///
  /// In vi, this message translates to:
  /// **'Giải trí'**
  String get genreEntertainment;

  /// No description provided for @genreTedTalks.
  ///
  /// In vi, this message translates to:
  /// **'TED Talks'**
  String get genreTedTalks;

  /// No description provided for @genreNewsEnglish.
  ///
  /// In vi, this message translates to:
  /// **'Tin tức Tiếng Anh'**
  String get genreNewsEnglish;

  /// No description provided for @genreOther.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get genreOther;

  /// No description provided for @exerciseTypeMc.
  ///
  /// In vi, this message translates to:
  /// **'Trắc nghiệm'**
  String get exerciseTypeMc;

  /// No description provided for @exerciseTypeFreeText.
  ///
  /// In vi, this message translates to:
  /// **'Điền từ'**
  String get exerciseTypeFreeText;

  /// No description provided for @exerciseTypeSentenceReorder.
  ///
  /// In vi, this message translates to:
  /// **'Sắp xếp câu'**
  String get exerciseTypeSentenceReorder;

  /// No description provided for @discoverTrendingTitle.
  ///
  /// In vi, this message translates to:
  /// **'Trending'**
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

  /// No description provided for @emptyVideos.
  ///
  /// In vi, this message translates to:
  /// **'Không có video nào'**
  String get emptyVideos;

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
  /// **'Dạng bài'**
  String get videoDetailExerciseType;

  /// No description provided for @videoDetailFillBlank.
  ///
  /// In vi, this message translates to:
  /// **'Điền từ'**
  String get videoDetailFillBlank;

  /// No description provided for @videoDetailTypeTheAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Tự gõ đáp án'**
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

  /// No description provided for @videoDetailBlanksCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} chỗ trống'**
  String videoDetailBlanksCount(int count);

  /// No description provided for @videoDetailLength.
  ///
  /// In vi, this message translates to:
  /// **'Độ dài'**
  String get videoDetailLength;

  /// No description provided for @videoDetailShareThis.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ bài này'**
  String get videoDetailShareThis;

  /// No description provided for @videoDetailLastAttempt.
  ///
  /// In vi, this message translates to:
  /// **'Lần trước'**
  String get videoDetailLastAttempt;

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
  /// **'XP theo tuần'**
  String get progressWeeklyXP;

  /// No description provided for @progressAreasToImprove.
  ///
  /// In vi, this message translates to:
  /// **'Điểm cần cải thiện'**
  String get progressAreasToImprove;

  /// No description provided for @progressLearningHistory.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử học tập'**
  String get progressLearningHistory;

  /// No description provided for @progressAchievements.
  ///
  /// In vi, this message translates to:
  /// **'Thành tích'**
  String get progressAchievements;

  /// No description provided for @progressLeaderboard.
  ///
  /// In vi, this message translates to:
  /// **'Xếp hạng'**
  String get progressLeaderboard;

  /// No description provided for @progressDayStreak.
  ///
  /// In vi, this message translates to:
  /// **'ngày streak'**
  String get progressDayStreak;

  /// No description provided for @progressXP.
  ///
  /// In vi, this message translates to:
  /// **'XP'**
  String get progressXP;

  /// No description provided for @progressExercisesDone.
  ///
  /// In vi, this message translates to:
  /// **'bài đã làm'**
  String get progressExercisesDone;

  /// No description provided for @progressAccuracy.
  ///
  /// In vi, this message translates to:
  /// **'độ chính xác'**
  String get progressAccuracy;

  /// No description provided for @progress30DayStreak.
  ///
  /// In vi, this message translates to:
  /// **'Streak 30 ngày'**
  String get progress30DayStreak;

  /// No description provided for @progressStreakFreezeCount.
  ///
  /// In vi, this message translates to:
  /// **'Streak Freeze: {count} còn lại'**
  String progressStreakFreezeCount(int count);

  /// No description provided for @progressXpRatio.
  ///
  /// In vi, this message translates to:
  /// **'{current} / {max} XP'**
  String progressXpRatio(int current, int max);

  /// No description provided for @progressNextLevel.
  ///
  /// In vi, this message translates to:
  /// **'→ Tiếp theo: {title}'**
  String progressNextLevel(String title);

  /// No description provided for @progressMaxLevelReached.
  ///
  /// In vi, this message translates to:
  /// **'Đã đạt cấp độ cao nhất! 🎉'**
  String get progressMaxLevelReached;

  /// No description provided for @progressNoAreasToImprove.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu lỗi cần cải thiện'**
  String get progressNoAreasToImprove;

  /// No description provided for @progressPracticeTarget.
  ///
  /// In vi, this message translates to:
  /// **'Luyện tập {category} →'**
  String progressPracticeTarget(String category);

  /// No description provided for @progressNoLearningHistory.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có lịch sử làm bài gần đây'**
  String get progressNoLearningHistory;

  /// No description provided for @progressDateToday.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get progressDateToday;

  /// No description provided for @progressDateYesterday.
  ///
  /// In vi, this message translates to:
  /// **'Hôm qua'**
  String get progressDateYesterday;

  /// No description provided for @exerciseTitle.
  ///
  /// In vi, this message translates to:
  /// **'ĐANG LUYỆN'**
  String get exerciseTitle;

  /// No description provided for @exerciseCorrect.
  ///
  /// In vi, this message translates to:
  /// **'Chính xác!'**
  String get exerciseCorrect;

  /// No description provided for @exerciseCorrectAwesome.
  ///
  /// In vi, this message translates to:
  /// **'Tuyệt vời!'**
  String get exerciseCorrectAwesome;

  /// No description provided for @exerciseCorrectSpotOn.
  ///
  /// In vi, this message translates to:
  /// **'Chuẩn xác!'**
  String get exerciseCorrectSpotOn;

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

  /// No description provided for @hideVietnameseTranslation.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn dịch tiếng Việt'**
  String get hideVietnameseTranslation;

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

  /// No description provided for @resultWhatWentWrong.
  ///
  /// In vi, this message translates to:
  /// **'Sai ở đâu?'**
  String get resultWhatWentWrong;

  /// No description provided for @resultShare.
  ///
  /// In vi, this message translates to:
  /// **'Chia sẻ'**
  String get resultShare;

  /// No description provided for @resultInstagram.
  ///
  /// In vi, this message translates to:
  /// **'Instagram'**
  String get resultInstagram;

  /// No description provided for @resultCopy.
  ///
  /// In vi, this message translates to:
  /// **'Sao chép'**
  String get resultCopy;

  /// No description provided for @resultChallengeFriend.
  ///
  /// In vi, this message translates to:
  /// **'Thách bạn bè'**
  String get resultChallengeFriend;

  /// No description provided for @resultNextSuggestedExercise.
  ///
  /// In vi, this message translates to:
  /// **'Bài tiếp theo gợi ý →'**
  String get resultNextSuggestedExercise;

  /// No description provided for @resultPracticeAgain.
  ///
  /// In vi, this message translates to:
  /// **'Luyện lại'**
  String get resultPracticeAgain;

  /// No description provided for @resultBackToLibrary.
  ///
  /// In vi, this message translates to:
  /// **'Về thư viện'**
  String get resultBackToLibrary;

  /// No description provided for @resultXpEarned.
  ///
  /// In vi, this message translates to:
  /// **'XP nhận được'**
  String get resultXpEarned;

  /// No description provided for @resultDayStreak.
  ///
  /// In vi, this message translates to:
  /// **'ngày liên tiếp'**
  String get resultDayStreak;

  /// No description provided for @resultNewBadge.
  ///
  /// In vi, this message translates to:
  /// **'Huy hiệu mới: First {level}!'**
  String resultNewBadge(String level);

  /// No description provided for @resultCompletedFirstExercise.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành bài {level} đầu tiên'**
  String resultCompletedFirstExercise(String level);

  /// No description provided for @resultCorrectCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} đúng'**
  String resultCorrectCount(int count);

  /// No description provided for @resultWrongCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} sai'**
  String resultWrongCount(int count);

  /// No description provided for @resultFeatureInDevelopment.
  ///
  /// In vi, this message translates to:
  /// **'Tính năng đang phát triển'**
  String get resultFeatureInDevelopment;

  /// No description provided for @resultScoreCardError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải Score Card'**
  String get resultScoreCardError;

  /// No description provided for @resultNoInternetScoreCard.
  ///
  /// In vi, this message translates to:
  /// **'Không có kết nối mạng để tạo thẻ'**
  String get resultNoInternetScoreCard;

  /// No description provided for @resultCopiedToClipboard.
  ///
  /// In vi, this message translates to:
  /// **'Đã sao chép vào bộ nhớ tạm!'**
  String get resultCopiedToClipboard;

  /// No description provided for @resultProgressSavedSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu tiến độ làm bài!'**
  String get resultProgressSavedSuccess;

  /// No description provided for @resultProgressSaveError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể đồng bộ tiến độ'**
  String get resultProgressSaveError;

  /// No description provided for @resultProgressRetry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get resultProgressRetry;

  /// No description provided for @termsOfServiceTitle.
  ///
  /// In vi, this message translates to:
  /// **'Điều khoản dịch vụ'**
  String get termsOfServiceTitle;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chính sách bảo mật'**
  String get privacyPolicyTitle;

  /// No description provided for @legalLastUpdated.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật lần cuối: {date}'**
  String legalLastUpdated(String date);

  /// No description provided for @legalLastUpdatedDefaultDate.
  ///
  /// In vi, this message translates to:
  /// **'15/06/2026'**
  String get legalLastUpdatedDefaultDate;

  /// No description provided for @tosSection1Title.
  ///
  /// In vi, this message translates to:
  /// **'1. Chấp nhận điều khoản'**
  String get tosSection1Title;

  /// No description provided for @tosSection1Content.
  ///
  /// In vi, this message translates to:
  /// **'Bằng cách sử dụng Vocabik, bạn đồng ý với các điều khoản này, Điều khoản Dịch vụ của YouTube (https://www.youtube.com/t/terms) và Chính sách Quyền riêng tư của Google (https://policies.google.com/privacy).'**
  String get tosSection1Content;

  /// No description provided for @tosSection2Title.
  ///
  /// In vi, this message translates to:
  /// **'2. Tài khoản người dùng'**
  String get tosSection2Title;

  /// No description provided for @tosSection2Content.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chịu trách nhiệm bảo mật thông tin đăng nhập của mình.'**
  String get tosSection2Content;

  /// No description provided for @tosSection3Title.
  ///
  /// In vi, this message translates to:
  /// **'3. Sử dụng dịch vụ & Quy tắc cộng đồng'**
  String get tosSection3Title;

  /// No description provided for @tosSection3Content.
  ///
  /// In vi, this message translates to:
  /// **'Không sử dụng dịch vụ cho mục đích bất hợp pháp, vi phạm Điều khoản YouTube, đăng tải nội dung phản cảm hoặc quấy rối người khác. Vocabik kiên quyết không dung thứ đối với hành vi lạm dụng và nội dung phản cảm.'**
  String get tosSection3Content;

  /// No description provided for @tosSection4Title.
  ///
  /// In vi, this message translates to:
  /// **'4. Nội dung & sở hữu trí tuệ'**
  String get tosSection4Title;

  /// No description provided for @tosSection4Content.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung video thuộc về chủ sở hữu gốc trên YouTube; Vocabik chỉ tạo bài tập học tập.'**
  String get tosSection4Content;

  /// No description provided for @tosSection5Title.
  ///
  /// In vi, this message translates to:
  /// **'5. Thanh toán & hoàn tiền'**
  String get tosSection5Title;

  /// No description provided for @tosSection5Content.
  ///
  /// In vi, this message translates to:
  /// **'Gói Premium có thể hủy bất cứ lúc nào; hoàn tiền trong 7 ngày cho gói năm.'**
  String get tosSection5Content;

  /// No description provided for @tosSection6Title.
  ///
  /// In vi, this message translates to:
  /// **'6. Chấm dứt tài khoản'**
  String get tosSection6Title;

  /// No description provided for @tosSection6Content.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản vi phạm điều khoản, có hành vi lạm dụng hoặc tạo nội dung phản cảm có thể bị khóa hoặc chấm dứt ngay lập tức.'**
  String get tosSection6Content;

  /// No description provided for @tosContact.
  ///
  /// In vi, this message translates to:
  /// **'Liên hệ: support@vocabik.com'**
  String get tosContact;

  /// No description provided for @privacySummaryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tóm tắt:'**
  String get privacySummaryTitle;

  /// No description provided for @privacySummaryContent.
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi thu thập email, tên hiển thị và dữ liệu học tập để cung cấp dịch vụ. Chúng tôi không bán dữ liệu của bạn.'**
  String get privacySummaryContent;

  /// No description provided for @privacySection1Title.
  ///
  /// In vi, this message translates to:
  /// **'1. Thông tin chúng tôi thu thập'**
  String get privacySection1Title;

  /// No description provided for @privacySection1Content.
  ///
  /// In vi, this message translates to:
  /// **'Email, tên hiển thị, mã định danh tài khoản và dữ liệu học tập (tiến độ, điểm số, từ vựng đã lưu) để cá nhân hóa trải nghiệm.'**
  String get privacySection1Content;

  /// No description provided for @privacySection2Title.
  ///
  /// In vi, this message translates to:
  /// **'2. Cách sử dụng thông tin'**
  String get privacySection2Title;

  /// No description provided for @privacySection2Content.
  ///
  /// In vi, this message translates to:
  /// **'Cung cấp dịch vụ học tập, gợi ý video phù hợp, theo dõi tiến độ, bảng xếp hạng và gửi nhắc nhở streak (nếu bạn bật).'**
  String get privacySection2Content;

  /// No description provided for @privacySection3Title.
  ///
  /// In vi, this message translates to:
  /// **'3. Dịch vụ bên thứ ba'**
  String get privacySection3Title;

  /// No description provided for @privacySection3Content.
  ///
  /// In vi, this message translates to:
  /// **'Google Sign-In, YouTube API Services, Firebase (chẩn đoán lỗi Crashlytics, Cloud Messaging, In-App Messaging) và Google Analytics. Khi dùng tính năng YouTube, bạn cũng tuân thủ Chính sách Quyền riêng tư của Google (https://policies.google.com/privacy).'**
  String get privacySection3Content;

  /// No description provided for @privacySection4Title.
  ///
  /// In vi, this message translates to:
  /// **'4. Chẩn đoán & Dữ liệu kỹ thuật'**
  String get privacySection4Title;

  /// No description provided for @privacySection4Content.
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi lưu trữ token xác thực bảo mật và nhật ký lỗi chẩn đoán ẩn danh để cải thiện độ ổn định của ứng dụng.'**
  String get privacySection4Content;

  /// No description provided for @privacySection5Title.
  ///
  /// In vi, this message translates to:
  /// **'5. Quyền của bạn & Yêu cầu xóa dữ liệu'**
  String get privacySection5Title;

  /// No description provided for @privacySection5Content.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có thể gửi yêu cầu xóa tài khoản hoặc tra cứu dữ liệu bất cứ lúc nào tại https://vocabik.com/delete-account hoặc qua email privacy@vocabik.com.'**
  String get privacySection5Content;

  /// No description provided for @privacySection6Title.
  ///
  /// In vi, this message translates to:
  /// **'6. Bảo mật dữ liệu'**
  String get privacySection6Title;

  /// No description provided for @privacySection6Content.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu được mã hóa khi truyền tải qua HTTPS và lưu trữ trên hạ tầng bảo mật.'**
  String get privacySection6Content;

  /// No description provided for @privacyContact.
  ///
  /// In vi, this message translates to:
  /// **'Liên hệ: privacy@vocabik.com'**
  String get privacyContact;

  /// No description provided for @forgotPasswordHeading.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu?'**
  String get forgotPasswordHeading;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhập email, chúng tôi sẽ gửi link đặt lại.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @backToLogin.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại đăng nhập'**
  String get backToLogin;

  /// No description provided for @sendResetLink.
  ///
  /// In vi, this message translates to:
  /// **'Gửi link đặt lại →'**
  String get sendResetLink;

  /// No description provided for @resetPasswordHeading.
  ///
  /// In vi, this message translates to:
  /// **'Đặt mật khẩu mới'**
  String get resetPasswordHeading;

  /// No description provided for @newPasswordHint.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu mới'**
  String get newPasswordHint;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận mật khẩu'**
  String get confirmPasswordHint;

  /// No description provided for @resetPasswordAction.
  ///
  /// In vi, this message translates to:
  /// **'Đặt lại mật khẩu →'**
  String get resetPasswordAction;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu xác nhận không khớp'**
  String get passwordsDoNotMatch;

  /// No description provided for @emailSentSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Link đặt lại mật khẩu đã được gửi đến email.'**
  String get emailSentSuccess;

  /// No description provided for @resetPasswordSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu đã được cập nhật thành công. Vui lòng đăng nhập lại.'**
  String get resetPasswordSuccess;

  /// No description provided for @achievementsYourAchievements.
  ///
  /// In vi, this message translates to:
  /// **'Thành tích của bạn'**
  String get achievementsYourAchievements;

  /// No description provided for @achievementsBadgesUnlocked.
  ///
  /// In vi, this message translates to:
  /// **'{count} / {total} badges đã mở khóa'**
  String achievementsBadgesUnlocked(int count, int total);

  /// No description provided for @achievementsUnlockedHeader.
  ///
  /// In vi, this message translates to:
  /// **'ĐÃ MỞ KHÓA'**
  String get achievementsUnlockedHeader;

  /// No description provided for @achievementsLockedHeader.
  ///
  /// In vi, this message translates to:
  /// **'CHƯA MỞ KHÓA'**
  String get achievementsLockedHeader;

  /// No description provided for @achievementsEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có thành tích nào.'**
  String get achievementsEmpty;

  /// No description provided for @achievementsFilterAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get achievementsFilterAll;

  /// No description provided for @achievementsFilterExercise.
  ///
  /// In vi, this message translates to:
  /// **'Bài tập'**
  String get achievementsFilterExercise;

  /// No description provided for @achievementsFilterStreak.
  ///
  /// In vi, this message translates to:
  /// **'Streak'**
  String get achievementsFilterStreak;

  /// No description provided for @achievementsFilterProficiency.
  ///
  /// In vi, this message translates to:
  /// **'Trình độ'**
  String get achievementsFilterProficiency;

  /// No description provided for @achievementsFilterDiversity.
  ///
  /// In vi, this message translates to:
  /// **'Đa dạng'**
  String get achievementsFilterDiversity;

  /// No description provided for @achievementsFilterVocabulary.
  ///
  /// In vi, this message translates to:
  /// **'Từ vựng'**
  String get achievementsFilterVocabulary;

  /// No description provided for @achievementsFilterSpeed.
  ///
  /// In vi, this message translates to:
  /// **'Tốc độ'**
  String get achievementsFilterSpeed;

  /// No description provided for @achievementsFilterGeneral.
  ///
  /// In vi, this message translates to:
  /// **'Chung'**
  String get achievementsFilterGeneral;

  /// No description provided for @achievementsFilterMilestones.
  ///
  /// In vi, this message translates to:
  /// **'Cột mốc'**
  String get achievementsFilterMilestones;

  /// No description provided for @achievementsFilterGenre.
  ///
  /// In vi, this message translates to:
  /// **'Thể loại'**
  String get achievementsFilterGenre;

  /// No description provided for @dailyChallengeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Daily Challenge'**
  String get dailyChallengeTitle;

  /// No description provided for @dailyChallengeJoinNow.
  ///
  /// In vi, this message translates to:
  /// **'Tham gia ngay! →'**
  String get dailyChallengeJoinNow;

  /// No description provided for @dailyChallengeTopToday.
  ///
  /// In vi, this message translates to:
  /// **'Top hôm nay'**
  String get dailyChallengeTopToday;

  /// No description provided for @dailyChallengeStreakDays.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã tham gia {count} ngày liên tiếp!'**
  String dailyChallengeStreakDays(int count);

  /// No description provided for @dailyChallengeStreakKeep.
  ///
  /// In vi, this message translates to:
  /// **'Tham gia hôm nay để duy trì chuỗi ngày!'**
  String get dailyChallengeStreakKeep;

  /// No description provided for @dailyChallengeParticipants.
  ///
  /// In vi, this message translates to:
  /// **'{count} đang tham gia'**
  String dailyChallengeParticipants(String count);

  /// No description provided for @dailyChallengeNoParticipants.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có ai tham gia hôm nay. Hãy là người đầu tiên!'**
  String get dailyChallengeNoParticipants;

  /// No description provided for @dailyChallengeNotConfigured.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có thử thách nào cho hôm nay'**
  String get dailyChallengeNotConfigured;

  /// No description provided for @xpLeaderboardTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bảng xếp hạng XP'**
  String get xpLeaderboardTitle;

  /// No description provided for @xpLeaderboardResetsIn.
  ///
  /// In vi, this message translates to:
  /// **'Làm mới sau: {time}'**
  String xpLeaderboardResetsIn(String time);

  /// No description provided for @xpLeaderboardResetsInDays.
  ///
  /// In vi, this message translates to:
  /// **'Làm mới sau: {days} ngày'**
  String xpLeaderboardResetsInDays(int days);

  /// No description provided for @xpLeaderboardResetsInHours.
  ///
  /// In vi, this message translates to:
  /// **'Làm mới sau: {hours} giờ'**
  String xpLeaderboardResetsInHours(int hours);

  /// No description provided for @xpLeaderboardResetsInMinutes.
  ///
  /// In vi, this message translates to:
  /// **'Làm mới sau: {minutes} phút'**
  String xpLeaderboardResetsInMinutes(int minutes);

  /// No description provided for @xpLeaderboardResettingSoon.
  ///
  /// In vi, this message translates to:
  /// **'Sắp làm mới'**
  String get xpLeaderboardResettingSoon;

  /// No description provided for @xpLeaderboardFilterThisWeek.
  ///
  /// In vi, this message translates to:
  /// **'Tuần này'**
  String get xpLeaderboardFilterThisWeek;

  /// No description provided for @xpLeaderboardFilterLastWeek.
  ///
  /// In vi, this message translates to:
  /// **'Tuần trước'**
  String get xpLeaderboardFilterLastWeek;

  /// No description provided for @xpLeaderboardFilterThisMonth.
  ///
  /// In vi, this message translates to:
  /// **'Tháng này'**
  String get xpLeaderboardFilterThisMonth;

  /// No description provided for @xpLeaderboardFilterGlobal.
  ///
  /// In vi, this message translates to:
  /// **'Toàn cầu'**
  String get xpLeaderboardFilterGlobal;

  /// No description provided for @xpLeaderboardFilterFriends.
  ///
  /// In vi, this message translates to:
  /// **'Bạn bè'**
  String get xpLeaderboardFilterFriends;

  /// No description provided for @xpLeaderboardYourRank.
  ///
  /// In vi, this message translates to:
  /// **'Hạng của bạn'**
  String get xpLeaderboardYourRank;

  /// No description provided for @xpLeaderboardEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu bảng xếp hạng'**
  String get xpLeaderboardEmpty;

  /// No description provided for @challengeFriendTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thách đấu bạn bè'**
  String get challengeFriendTitle;

  /// No description provided for @challengeFriendSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn bạn bè để cùng làm bài tập này. Điểm cao hơn sẽ chiến thắng.'**
  String get challengeFriendSubtitle;

  /// No description provided for @challengeSearchFriendsHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm bạn bè...'**
  String get challengeSearchFriendsHint;

  /// No description provided for @challengeFriendsSection.
  ///
  /// In vi, this message translates to:
  /// **'BẠN BÈ TRÊN VOCABIK'**
  String get challengeFriendsSection;

  /// No description provided for @challengePickAtLeastOne.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ít nhất 1'**
  String get challengePickAtLeastOne;

  /// No description provided for @challengeSelectedCount.
  ///
  /// In vi, this message translates to:
  /// **'Đã chọn {count}'**
  String challengeSelectedCount(int count);

  /// No description provided for @challengeSend.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lời thách đấu'**
  String get challengeSend;

  /// No description provided for @challengeSendWithCount.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lời thách đấu ({count}) →'**
  String challengeSendWithCount(int count);

  /// No description provided for @challengeBlanksCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} chỗ trống'**
  String challengeBlanksCount(int count);

  /// No description provided for @challengeNoFriendsFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy bạn bè nào'**
  String get challengeNoFriendsFound;

  /// No description provided for @challengeLoadingFriends.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải danh sách bạn bè...'**
  String get challengeLoadingFriends;

  /// No description provided for @challengeLoadFriendsError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải danh sách bạn bè'**
  String get challengeLoadFriendsError;

  /// No description provided for @challengeCreateLinkError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tạo liên kết thách đấu'**
  String get challengeCreateLinkError;

  /// No description provided for @challengeSentTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi lời thách đấu!'**
  String get challengeSentTitle;

  /// No description provided for @challengeSentSubtitleSingle.
  ///
  /// In vi, this message translates to:
  /// **'Điểm {score}% của bạn trong bài “{title}” đã được gửi tới {friend}.'**
  String challengeSentSubtitleSingle(int score, String title, String friend);

  /// No description provided for @challengeSentSubtitleMultiple.
  ///
  /// In vi, this message translates to:
  /// **'Điểm {score}% của bạn trong bài “{title}” đã được gửi tới {count} người bạn.'**
  String challengeSentSubtitleMultiple(int score, String title, int count);

  /// No description provided for @challengeInfo24HoursTitle.
  ///
  /// In vi, this message translates to:
  /// **'Họ có 24 giờ để phản hồi'**
  String get challengeInfo24HoursTitle;

  /// No description provided for @challengeInfo24HoursDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nếu hết thời gian, bạn sẽ mặc định chiến thắng.'**
  String get challengeInfo24HoursDesc;

  /// No description provided for @challengeInfoNotifiedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn sẽ nhận được thông báo'**
  String get challengeInfoNotifiedTitle;

  /// No description provided for @challengeInfoNotifiedDesc.
  ///
  /// In vi, this message translates to:
  /// **'Ngay khi có người hoàn thành bài tập thách đấu.'**
  String get challengeInfoNotifiedDesc;

  /// No description provided for @challengeInfoWinXpTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chiến thắng nhận +50 XP'**
  String get challengeInfoWinXpTitle;

  /// No description provided for @challengeInfoWinXpDesc.
  ///
  /// In vi, this message translates to:
  /// **'Vượt điểm đối thủ để giành chiến thắng.'**
  String get challengeInfoWinXpDesc;

  /// No description provided for @challengeCopyLink.
  ///
  /// In vi, this message translates to:
  /// **'Sao chép link thách đấu'**
  String get challengeCopyLink;

  /// No description provided for @challengeViewLeaderboard.
  ///
  /// In vi, this message translates to:
  /// **'Xem bảng xếp hạng →'**
  String get challengeViewLeaderboard;

  /// No description provided for @challengeLinkCopied.
  ///
  /// In vi, this message translates to:
  /// **'Đã sao chép liên kết thách đấu vào bộ nhớ tạm!'**
  String get challengeLinkCopied;

  /// No description provided for @notebookTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sổ từ vựng'**
  String get notebookTitle;

  /// No description provided for @wordsCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} từ'**
  String wordsCount(int count);

  /// No description provided for @searchWordsPlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm từ vựng...'**
  String get searchWordsPlaceholder;

  /// No description provided for @tabList.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách'**
  String get tabList;

  /// No description provided for @tabFlashcard.
  ///
  /// In vi, this message translates to:
  /// **'Thẻ ghi nhớ'**
  String get tabFlashcard;

  /// No description provided for @tapToFlip.
  ///
  /// In vi, this message translates to:
  /// **'Chạm để lật'**
  String get tapToFlip;

  /// No description provided for @reviewAgain.
  ///
  /// In vi, this message translates to:
  /// **'Ôn lại'**
  String get reviewAgain;

  /// No description provided for @gotIt.
  ///
  /// In vi, this message translates to:
  /// **'Đã thuộc'**
  String get gotIt;

  /// No description provided for @emptyNotebook.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có từ vựng nào được lưu.'**
  String get emptyNotebook;

  /// No description provided for @noSearchResults.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy từ vựng phù hợp.'**
  String get noSearchResults;

  /// No description provided for @reviewFinishedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đã hoàn thành!'**
  String get reviewFinishedTitle;

  /// No description provided for @reviewFinishedDesc.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã ôn tập xong tất cả các thẻ từ vựng.'**
  String get reviewFinishedDesc;

  /// No description provided for @reportUserTitle.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo người dùng'**
  String get reportUserTitle;

  /// No description provided for @reportUserSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn lý do báo cáo tài khoản “{userName}”:'**
  String reportUserSubtitle(String userName);

  /// No description provided for @reportReasonInappropriateName.
  ///
  /// In vi, this message translates to:
  /// **'Tên hiển thị không phù hợp hoặc phản cảm'**
  String get reportReasonInappropriateName;

  /// No description provided for @reportReasonInappropriateAvatar.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh đại diện vi phạm quy chuẩn cộng đồng'**
  String get reportReasonInappropriateAvatar;

  /// No description provided for @reportReasonHarassmentOrCheating.
  ///
  /// In vi, this message translates to:
  /// **'Hành vi quấy rối hoặc gian lận'**
  String get reportReasonHarassmentOrCheating;

  /// No description provided for @reportReasonSpamOrAd.
  ///
  /// In vi, this message translates to:
  /// **'Spam hoặc nội dung quảng cáo'**
  String get reportReasonSpamOrAd;

  /// No description provided for @reportUserSubmit.
  ///
  /// In vi, this message translates to:
  /// **'Gửi báo cáo'**
  String get reportUserSubmit;

  /// No description provided for @reportUserSuccessMessage.
  ///
  /// In vi, this message translates to:
  /// **'Cảm ơn bạn. Báo cáo đã được tiếp nhận và chuyển tới đội ngũ kiểm duyệt.'**
  String get reportUserSuccessMessage;

  /// No description provided for @reportReasonSpam.
  ///
  /// In vi, this message translates to:
  /// **'Quảng cáo hoặc tin rác'**
  String get reportReasonSpam;

  /// No description provided for @reportReasonHarassment.
  ///
  /// In vi, this message translates to:
  /// **'Quấy rối hoặc đe dọa'**
  String get reportReasonHarassment;

  /// No description provided for @reportReasonInappropriateContent.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung không phù hợp / 18+'**
  String get reportReasonInappropriateContent;

  /// No description provided for @reportReasonHateSpeech.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn từ thù hận'**
  String get reportReasonHateSpeech;

  /// No description provided for @reportReasonOther.
  ///
  /// In vi, this message translates to:
  /// **'Lý do khác'**
  String get reportReasonOther;

  /// No description provided for @reportDetailsLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết vi phạm (không bắt buộc)'**
  String get reportDetailsLabel;

  /// No description provided for @reportDetailsHint.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả bổ sung chi tiết vi phạm...'**
  String get reportDetailsHint;

  /// No description provided for @reportSuccess24h.
  ///
  /// In vi, this message translates to:
  /// **'Cảm ơn bạn đã gửi báo cáo. Chúng tôi sẽ xem xét và xử lý vi phạm trong vòng 24 giờ.'**
  String get reportSuccess24h;

  /// No description provided for @reportSubmitting.
  ///
  /// In vi, this message translates to:
  /// **'Đang gửi báo cáo...'**
  String get reportSubmitting;

  /// No description provided for @blockedUsersTitle.
  ///
  /// In vi, this message translates to:
  /// **'Người dùng đã chặn'**
  String get blockedUsersTitle;

  /// No description provided for @blockedUsersEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa chặn người dùng nào.'**
  String get blockedUsersEmpty;

  /// No description provided for @blockedUsersError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải danh sách người dùng đã chặn.'**
  String get blockedUsersError;

  /// No description provided for @unblockAction.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ chặn'**
  String get unblockAction;

  /// No description provided for @unblockSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã bỏ chặn {userName}.'**
  String unblockSuccess(String userName);

  /// No description provided for @unblockConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ chặn người dùng?'**
  String get unblockConfirmTitle;

  /// No description provided for @unblockConfirmMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn bỏ chặn {userName}? Người này sẽ có thể tương tác lại với bạn.'**
  String unblockConfirmMessage(String userName);

  /// No description provided for @blockUserTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chặn người dùng'**
  String get blockUserTitle;

  /// No description provided for @blockUserConfirmMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn chặn {userName}? Hệ thống sẽ tự động hủy kết bạn và ẩn mọi tương tác từ người này.'**
  String blockUserConfirmMessage(String userName);

  /// No description provided for @blockUserAction.
  ///
  /// In vi, this message translates to:
  /// **'Chặn'**
  String get blockUserAction;

  /// No description provided for @blockUserSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã chặn {userName} thành công.'**
  String blockUserSuccess(String userName);

  /// No description provided for @blockUserPromptTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chặn người dùng này?'**
  String get blockUserPromptTitle;

  /// No description provided for @blockUserPromptDesc.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có muốn chặn người dùng này luôn không? Bạn sẽ không còn nhìn thấy hoạt động của họ nữa.'**
  String get blockUserPromptDesc;

  /// No description provided for @actionLater.
  ///
  /// In vi, this message translates to:
  /// **'Để sau'**
  String get actionLater;

  /// No description provided for @actionOptions.
  ///
  /// In vi, this message translates to:
  /// **'Tùy chọn tương tác'**
  String get actionOptions;

  /// No description provided for @reportUserOption.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo vi phạm'**
  String get reportUserOption;

  /// No description provided for @blockUserOption.
  ///
  /// In vi, this message translates to:
  /// **'Chặn người dùng'**
  String get blockUserOption;

  /// No description provided for @cannotReportSelf.
  ///
  /// In vi, this message translates to:
  /// **'Bạn không thể tự báo cáo chính mình.'**
  String get cannotReportSelf;

  /// No description provided for @cannotBlockSelf.
  ///
  /// In vi, this message translates to:
  /// **'Bạn không thể tự chặn chính mình.'**
  String get cannotBlockSelf;

  /// No description provided for @blockedAtDate.
  ///
  /// In vi, this message translates to:
  /// **'Đã chặn: {date}'**
  String blockedAtDate(String date);

  /// No description provided for @unblocking.
  ///
  /// In vi, this message translates to:
  /// **'Đang bỏ chặn...'**
  String get unblocking;

  /// No description provided for @blocking.
  ///
  /// In vi, this message translates to:
  /// **'Đang chặn...'**
  String get blocking;
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
