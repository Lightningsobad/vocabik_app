// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get homeTitle => 'Trang chủ';

  @override
  String get homeScreenContent => 'Nội dung trang chủ';

  @override
  String get discoverTitle => 'Khám phá';

  @override
  String get progressTitle => 'Tiến độ';

  @override
  String get profileTitle => 'Hồ sơ';

  @override
  String get discoverScreenContent => 'Nội dung Khám phá';

  @override
  String get progressScreenContent => 'Nội dung Tiến độ';

  @override
  String get profileSettingsTitle => 'Hồ sơ & Cài đặt';

  @override
  String get profileTab => 'Hồ sơ';

  @override
  String get preferencesTab => 'Tuỳ chỉnh';

  @override
  String get subscriptionTab => 'Gói cước';

  @override
  String get securityTab => 'Bảo mật';

  @override
  String get accountTab => 'Tài khoản';

  @override
  String tabNotImplemented(int tabIndex) {
    return 'Nội dung cho Tab $tabIndex chưa được phát triển.';
  }

  @override
  String get actionAchievements => 'Thành tích';

  @override
  String get actionNotebook => 'Sổ từ vựng';

  @override
  String get actionLeaderboard => 'Xếp hạng';

  @override
  String get actionClassroom => 'Lớp học';

  @override
  String get actionDailyChallenge => 'Thử thách ngày';

  @override
  String get actionBotIntegration => 'Tích hợp Bot';

  @override
  String get profileChangePhoto => 'Đổi ảnh';

  @override
  String get profileYourName => 'Tên của bạn';

  @override
  String get profileEmail => 'Email: ';

  @override
  String get profileReadOnly => ' (chỉ xem)';

  @override
  String profileMemberSince(String date) {
    return 'Thành viên từ: $date';
  }

  @override
  String get appearance => 'Giao diện';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get soundDuringExercise => 'Âm thanh khi làm bài';

  @override
  String get interfaceLanguage => 'Ngôn ngữ giao diện';

  @override
  String get languageVietnamese => 'Tiếng Việt';

  @override
  String get languageEnglish => 'English';

  @override
  String get botIntegrationTelegramZalo => 'Tích hợp Bot (Telegram / Zalo)';

  @override
  String get subscriptionFreePlanTitle => 'Gói Free';

  @override
  String get subscriptionFreePlanDesc => 'Học phong phú hơn với Premium.';

  @override
  String get subscriptionUpgradeBtn => 'Nâng lên Premium →';

  @override
  String get accountExportData => 'Xuất dữ liệu của tôi';

  @override
  String get accountLogOut => 'Đăng xuất';

  @override
  String get accountDeletePermanently => 'Xóa tài khoản vĩnh viễn';

  @override
  String get securityTab_currentPasswordLabel => 'Mật khẩu hiện tại';

  @override
  String get securityTab_newPasswordLabel => 'Mật khẩu mới';

  @override
  String get securityTab_updateButton => 'Cập nhật';

  @override
  String get securityTab_activeSessionsTitle => 'Phiên đăng nhập';

  @override
  String get action_show => 'Hiện';

  @override
  String get action_hide => 'Ẩn';

  @override
  String get integrationScreenTitle => 'Tích hợp';

  @override
  String get integrationTelegramTitle => 'Telegram Bot';

  @override
  String get integrationTelegramDesc => 'Nhận bài tập mỗi sáng qua Telegram';

  @override
  String get integrationZaloTitle => 'Zalo OA';

  @override
  String get integrationZaloDesc => 'Cấu trúc tương tự Telegram';

  @override
  String get statusNotConnected => 'Chưa kết nối';

  @override
  String get statusConnected => 'Đã kết nối';

  @override
  String get instructionConnectLabel => '1. Nhấn \"Kết nối\" bên dưới';

  @override
  String get instructionStartLabel => '2. Nhấn Start trong Telegram';

  @override
  String get instructionAutoConnectLabel => '3. Bot tự kết nối tài khoản';

  @override
  String get timeToReceiveLabel => 'Thời gian nhận bài';

  @override
  String get levelLabel => 'Level';

  @override
  String get connectTelegramBtn => 'Kết nối Telegram Bot →';

  @override
  String get connectZaloBtn => 'Kết nối Zalo OA →';

  @override
  String get disconnectBtn => 'Hủy kết nối';

  @override
  String get homeDailyPickTitle => '☀️ Tuyển chọn cho bạn hôm nay';

  @override
  String get homeRecommendedTitle => 'CŨNG DÀNH CHO BẠN';

  @override
  String get homeTodayProgress => 'Hôm nay';

  @override
  String get homeUnlimited => 'Không giới hạn';

  @override
  String get homeAll => 'Tất cả';

  @override
  String get homeDailyChallenge => 'Daily Challenge hôm nay';

  @override
  String get homeTrending => 'Trending tuần này 🔥';

  @override
  String get homeViewAll => 'Xem tất cả →';

  @override
  String get homeRecentlyAdded => 'Mới thêm ✨';

  @override
  String get homeLibrary => 'Thư viện';

  @override
  String get homePricing => 'Bảng giá';

  @override
  String get homePrivacyPolicy => 'Chính sách bảo mật';

  @override
  String get homeTerms => 'Điều khoản';

  @override
  String homePracticed(String count) {
    return '$count đã luyện';
  }

  @override
  String homeLessons(int current, int total) {
    return '$current / $total bài';
  }

  @override
  String get homeDailyPickTag => 'DAILY PICK';

  @override
  String get homeNewTag => 'NEW';

  @override
  String homeChallengeParticipants(String count) {
    return '$count người đã tham gia';
  }

  @override
  String get discoverSearchHint => 'Tìm theo bài hát, nghệ sĩ...';

  @override
  String get discoverFilterAll => 'Tất cả';

  @override
  String get discoverTrendingTitle => 'Trending 🔥';

  @override
  String get discoverPlaylistTitle => 'Playlist tuyển chọn';

  @override
  String get discoverTimeUnder3 => '< 3 phút';

  @override
  String get discoverTime3To7 => '3-7 phút';

  @override
  String get discoverTimeOver7 => '> 7 phút';

  @override
  String get discoverFilter7Days => '7 Ngày';

  @override
  String get discoverEmptyResult => 'Không tìm thấy kết quả';

  @override
  String get discoverErrorLoad => 'Đã có lỗi xảy ra';

  @override
  String get discoverRetryButton => 'Thử lại';

  @override
  String discoverSearchResultsWithQuery(int count, String query) {
    return 'Found $count kết quả cho \"$query\"';
  }

  @override
  String discoverSearchResults(int count) {
    return 'Found $count kết quả';
  }

  @override
  String discoverVideosCount(int count) {
    return '$count videos';
  }

  @override
  String get logoutConfirmTitle => 'Đăng xuất';

  @override
  String get logoutConfirmMessage => 'Bạn có chắc chắn muốn đăng xuất không?';

  @override
  String get actionCancel => 'Hủy';

  @override
  String get actionConfirm => 'Xác nhận';

  @override
  String get signUpTitle => 'Đăng ký';

  @override
  String get createFreeAccount => 'Tạo tài khoản miễn phí';

  @override
  String get startLearningToday => 'Bắt đầu học ngay hôm nay';

  @override
  String get signUpWithGoogle => 'Đăng ký với Google';

  @override
  String get orText => 'hoặc';

  @override
  String get yourName => 'Tên của bạn';

  @override
  String get emailHint => 'Email';

  @override
  String get passwordHint => 'Mật khẩu';

  @override
  String get passwordStrengthNone => 'Chưa có';

  @override
  String get passwordStrengthWeak => 'Yếu';

  @override
  String get passwordStrengthMedium => 'Trung bình';

  @override
  String get passwordStrengthStrong => 'Mạnh';

  @override
  String get signUpTerms =>
      'Bằng cách đăng ký, bạn đồng ý Điều khoản & Bảo mật';

  @override
  String get alreadyHaveAccount => 'Đã có tài khoản? Đăng nhập →';

  @override
  String get checkYourEmail => 'Kiểm tra email của bạn';

  @override
  String checkEmailSubtitle(String email) {
    return 'Chúng tôi đã gửi đến:\n$email';
  }

  @override
  String resendIn(int seconds) {
    return 'Gửi lại sau $seconds giây';
  }

  @override
  String get iHaveVerified => 'Tôi đã xác thực → tiếp tục';

  @override
  String get spamCheckTip => '💡 Không thấy email? Kiểm tra thư mục Spam.';

  @override
  String get whereIsYourEnglish => 'Tiếng Anh của bạn hiện ở đâu?';

  @override
  String get weWillSuggest => 'Chúng tôi sẽ gợi ý bài phù hợp nhất với bạn.';

  @override
  String get levelA1A2 => 'A1–A2';

  @override
  String get levelA1A2Desc => 'Mới bắt đầu';

  @override
  String get levelB1 => 'B1';

  @override
  String get levelB1Desc => 'Cơ bản';

  @override
  String get levelB2 => 'B2';

  @override
  String get levelB2Desc => 'Khá';

  @override
  String get levelC1 => 'C1';

  @override
  String get levelC1Desc => 'Nâng cao';

  @override
  String get startLearning => 'Bắt đầu học →';

  @override
  String get skipForNow => 'Bỏ qua, tôi tự chọn sau';

  @override
  String get actionSignUp => 'Đăng ký';

  @override
  String get homeVideosEmpty => 'Chưa có bài tập nào.';

  @override
  String get homeVideosError => 'Không thể tải danh sách bài tập.';

  @override
  String get homeRetry => 'Thử lại';

  @override
  String get emptySectionText => 'Chưa có video nào';

  @override
  String get videoDetailBack => 'Quay lại';

  @override
  String get videoDetailMultipleChoice => 'Trắc nghiệm';

  @override
  String get videoDetailExerciseType => 'Kiểu bài';

  @override
  String get videoDetailFillBlank => 'Điền từ';

  @override
  String get videoDetailTypeTheAnswer => 'Gõ đáp án';

  @override
  String get videoDetailVersion => 'PHIÊN BẢN';

  @override
  String get videoDetailVocabulary => 'Từ vựng';

  @override
  String get videoDetailGrammar => 'Ngữ pháp';

  @override
  String get videoDetailSpeed => 'Tốc độ';

  @override
  String get videoDetailStartPractice => 'Bắt đầu luyện tập →';

  @override
  String get authGenericError => 'Có lỗi xảy ra';

  @override
  String get loginTitle => 'Đăng nhập vào Vocabik';

  @override
  String get continueWithGoogle => 'Tiếp tục với Google';

  @override
  String get continueWithFacebook => 'Tiếp tục với Facebook';

  @override
  String get emailInvalid => 'Email không hợp lệ';

  @override
  String get passwordMinLength => 'Mật khẩu phải từ 6 ký tự';

  @override
  String get forgotPassword => 'Quên mật khẩu? →';

  @override
  String get actionLogin => 'Đăng nhập';

  @override
  String get noAccount => 'Chưa có tài khoản? ';

  @override
  String get signUpFreeAction => 'Đăng ký miễn phí →';

  @override
  String get progressYourProgress => 'Tiến độ của bạn';

  @override
  String get progressWeeklyXP => 'XP hàng tuần';

  @override
  String get progressAreasToImprove => 'Cần cải thiện';

  @override
  String get progressLearningHistory => 'Lịch sử học tập';
}
