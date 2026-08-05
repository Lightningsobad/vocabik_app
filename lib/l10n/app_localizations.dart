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
