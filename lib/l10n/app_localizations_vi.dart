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
  String get actionDailyChallenge => 'Thử thách ngày';

  @override
  String get profileChangePhoto => 'Đổi ảnh';

  @override
  String get profileYourName => 'Tên của bạn';

  @override
  String get profileUpdateSuccess => 'Cập nhật tên thành công!';

  @override
  String get actionSave => 'Lưu';

  @override
  String get actionEdit => 'Chỉnh sửa';

  @override
  String get profileEmail => 'Email: ';

  @override
  String get profileReadOnly => ' (chỉ xem)';

  @override
  String profileMemberSince(String date) {
    return 'Thành viên từ: $date';
  }

  @override
  String get profileLoadError => 'Không thể tải thông tin hồ sơ.';

  @override
  String get profileRetry => 'Thử lại';

  @override
  String get profileDefaultUser => 'Người dùng';

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
  String get languageVietnamese => 'Vietnamese';

  @override
  String get languageEnglish => 'English';

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
  String get securityTab_sessionEmpty => 'Không có phiên hoạt động nào';

  @override
  String get securityTab_sessionRetry => 'Thử lại';

  @override
  String get securityTab_sessionLoadError =>
      'Không thể tải danh sách phiên đăng nhập.';

  @override
  String securityTab_sessionShowMore(int count) {
    return 'Xem thêm ($count)';
  }

  @override
  String get securityTab_sessionShowLess => 'Thu gọn';

  @override
  String get action_show => 'Hiện';

  @override
  String get action_hide => 'Ẩn';

  @override
  String get homeDailyPickTitle => 'Tuyển chọn cho bạn hôm nay';

  @override
  String get homeRecommendedTitle => 'CŨNG DÀNH CHO BẠN';

  @override
  String get homeAll => 'Tất cả';

  @override
  String get homeDailyChallenge => 'Daily Challenge hôm nay';

  @override
  String get homeTrending => 'Trending tuần này';

  @override
  String get homeViewAll => 'Xem tất cả →';

  @override
  String get homeRecentlyAdded => 'Mới thêm';

  @override
  String get homeLibrary => 'Thư viện';

  @override
  String get homePrivacyPolicy => 'Chính sách bảo mật';

  @override
  String get homeTerms => 'Điều khoản';

  @override
  String homePracticed(String count) {
    return '$count đã luyện';
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
  String get genreMusic => 'Âm nhạc';

  @override
  String get genreVlog => 'Vlog';

  @override
  String get genreNews => 'Tin tức';

  @override
  String get genreEducation => 'Giáo dục';

  @override
  String get genreEntertainment => 'Giải trí';

  @override
  String get genreTedTalks => 'TED Talks';

  @override
  String get genreNewsEnglish => 'Tin tức Tiếng Anh';

  @override
  String get genreOther => 'Khác';

  @override
  String get exerciseTypeMc => 'Trắc nghiệm';

  @override
  String get exerciseTypeFreeText => 'Điền từ';

  @override
  String get exerciseTypeSentenceReorder => 'Sắp xếp câu';

  @override
  String get discoverTrendingTitle => 'Trending';

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
  String get emailHint => 'Email của bạn';

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
  String get alreadyHaveAccountPrompt => 'Đã có tài khoản? ';

  @override
  String get loginActionLink => 'Đăng nhập →';

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
  String get resendEmail => 'Gửi lại email';

  @override
  String get iHaveVerified => 'Tôi đã xác thực → tiếp tục';

  @override
  String get spamCheckTip => 'Không thấy email? Kiểm tra thư mục Spam.';

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
  String get emptyVideos => 'Không có video nào';

  @override
  String get videoDetailBack => 'Quay lại';

  @override
  String get videoDetailMultipleChoice => 'Trắc nghiệm';

  @override
  String get videoDetailExerciseType => 'Dạng bài';

  @override
  String get videoDetailFillBlank => 'Điền từ';

  @override
  String get videoDetailTypeTheAnswer => 'Tự gõ đáp án';

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
  String videoDetailBlanksCount(int count) {
    return '$count chỗ trống';
  }

  @override
  String get videoDetailLength => 'Độ dài';

  @override
  String get videoDetailShareThis => 'Chia sẻ bài này';

  @override
  String get videoDetailLastAttempt => 'Lần trước';

  @override
  String get authGenericError => 'Có lỗi xảy ra';

  @override
  String get loginTitle => 'Đăng nhập vào Vocabik';

  @override
  String get continueWithGoogle => 'Tiếp tục với Google';

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
  String get progressWeeklyXP => 'XP theo tuần';

  @override
  String get progressAreasToImprove => 'Điểm cần cải thiện';

  @override
  String get progressLearningHistory => 'Lịch sử học tập';

  @override
  String get progressAchievements => 'Thành tích';

  @override
  String get progressLeaderboard => 'Xếp hạng';

  @override
  String get progressDayStreak => 'ngày streak';

  @override
  String get progressXP => 'XP';

  @override
  String get progressExercisesDone => 'bài đã làm';

  @override
  String get progressAccuracy => 'độ chính xác';

  @override
  String get progress30DayStreak => 'Streak 30 ngày';

  @override
  String progressStreakFreezeCount(int count) {
    return 'Streak Freeze: $count còn lại';
  }

  @override
  String progressXpRatio(int current, int max) {
    return '$current / $max XP';
  }

  @override
  String progressNextLevel(String title) {
    return '→ Tiếp theo: $title';
  }

  @override
  String get progressMaxLevelReached => 'Đã đạt cấp độ cao nhất! 🎉';

  @override
  String get progressNoAreasToImprove => 'Chưa có dữ liệu lỗi cần cải thiện';

  @override
  String progressPracticeTarget(String category) {
    return 'Luyện tập $category →';
  }

  @override
  String get progressNoLearningHistory => 'Chưa có lịch sử làm bài gần đây';

  @override
  String get progressDateToday => 'Hôm nay';

  @override
  String get progressDateYesterday => 'Hôm qua';

  @override
  String get exerciseTitle => 'ĐANG LUYỆN';

  @override
  String get exerciseCorrect => 'Chính xác!';

  @override
  String get exerciseCorrectAwesome => 'Tuyệt vời!';

  @override
  String get exerciseCorrectSpotOn => 'Chuẩn xác!';

  @override
  String get exerciseAlmost => 'Gần đúng!';

  @override
  String get exerciseHint => '💡 Gợi ý';

  @override
  String get exerciseContinue => 'Tiếp tục →';

  @override
  String get exerciseCheck => 'Kiểm tra';

  @override
  String get exercisePlayingVideo => 'Đang phát video...';

  @override
  String get exerciseCompleted => 'Hoàn thành bài tập!';

  @override
  String get viewVietnameseTranslation => 'Xem dịch tiếng Việt';

  @override
  String get hideVietnameseTranslation => 'Ẩn dịch tiếng Việt';

  @override
  String get nameCannotBeEmpty => 'Tên không được để trống';

  @override
  String get termsText => 'Điều khoản';

  @override
  String get securityText => 'Bảo mật';

  @override
  String get signUpTermsPrefix => 'Bằng cách đăng ký, bạn đồng ý ';

  @override
  String get signUpTermsAnd => ' & ';

  @override
  String get verifySuccessRedirect =>
      'Xác thực thành công. Đang chuyển hướng...';

  @override
  String get verifyFailed => 'Xác thực thất bại';

  @override
  String get updateFailed => 'Cập nhật thất bại';

  @override
  String get invalidToken => 'Token không hợp lệ hoặc đã hết hạn.';

  @override
  String get networkError => 'Không có kết nối mạng. Vui lòng kiểm tra lại.';

  @override
  String get serverError => 'Lỗi máy chủ, vui lòng thử lại sau.';

  @override
  String get exerciseTypeAnswerHint => 'Gõ đáp án...';

  @override
  String get exercisePleaseEnterAnswer => 'Vui lòng nhập đáp án';

  @override
  String exerciseAlmostCorrect(String answer) {
    return 'Gần đúng — đáp án là \"$answer\".';
  }

  @override
  String get userAlreadyExists => 'Tài khoản đã tồn tại.';

  @override
  String get resultWhatWentWrong => 'Sai ở đâu?';

  @override
  String get resultShare => 'Chia sẻ';

  @override
  String get resultInstagram => 'Instagram';

  @override
  String get resultCopy => 'Sao chép';

  @override
  String get resultChallengeFriend => 'Thách bạn bè';

  @override
  String get resultNextSuggestedExercise => 'Bài tiếp theo gợi ý →';

  @override
  String get resultPracticeAgain => 'Luyện lại';

  @override
  String get resultBackToLibrary => 'Về thư viện';

  @override
  String get resultXpEarned => 'XP nhận được';

  @override
  String get resultDayStreak => 'ngày liên tiếp';

  @override
  String resultNewBadge(String level) {
    return 'Huy hiệu mới: First $level!';
  }

  @override
  String resultCompletedFirstExercise(String level) {
    return 'Hoàn thành bài $level đầu tiên';
  }

  @override
  String resultCorrectCount(int count) {
    return '$count đúng';
  }

  @override
  String resultWrongCount(int count) {
    return '$count sai';
  }

  @override
  String get resultFeatureInDevelopment => 'Tính năng đang phát triển';

  @override
  String get resultScoreCardError => 'Không thể tải Score Card';

  @override
  String get resultNoInternetScoreCard => 'Không có kết nối mạng để tạo thẻ';

  @override
  String get resultCopiedToClipboard => 'Đã sao chép vào bộ nhớ tạm!';

  @override
  String get resultProgressSavedSuccess => 'Đã lưu tiến độ làm bài!';

  @override
  String get resultProgressSaveError => 'Không thể đồng bộ tiến độ';

  @override
  String get resultProgressRetry => 'Thử lại';

  @override
  String get termsOfServiceTitle => 'Điều khoản dịch vụ';

  @override
  String get privacyPolicyTitle => 'Chính sách bảo mật';

  @override
  String legalLastUpdated(String date) {
    return 'Cập nhật lần cuối: $date';
  }

  @override
  String get legalLastUpdatedDefaultDate => '15/06/2026';

  @override
  String get tosSection1Title => '1. Chấp nhận điều khoản';

  @override
  String get tosSection1Content =>
      'Bằng cách sử dụng Vocabik, bạn đồng ý với các điều khoản này, Điều khoản Dịch vụ của YouTube (https://www.youtube.com/t/terms) và Chính sách Quyền riêng tư của Google (https://policies.google.com/privacy).';

  @override
  String get tosSection2Title => '2. Tài khoản người dùng';

  @override
  String get tosSection2Content =>
      'Bạn chịu trách nhiệm bảo mật thông tin đăng nhập của mình.';

  @override
  String get tosSection3Title => '3. Sử dụng dịch vụ & Quy tắc cộng đồng';

  @override
  String get tosSection3Content =>
      'Không sử dụng dịch vụ cho mục đích bất hợp pháp, vi phạm Điều khoản YouTube, đăng tải nội dung phản cảm hoặc quấy rối người khác. Vocabik kiên quyết không dung thứ đối với hành vi lạm dụng và nội dung phản cảm.';

  @override
  String get tosSection4Title => '4. Nội dung & sở hữu trí tuệ';

  @override
  String get tosSection4Content =>
      'Nội dung video thuộc về chủ sở hữu gốc trên YouTube; Vocabik chỉ tạo bài tập học tập.';

  @override
  String get tosSection5Title => '5. Thanh toán & hoàn tiền';

  @override
  String get tosSection5Content =>
      'Gói Premium có thể hủy bất cứ lúc nào; hoàn tiền trong 7 ngày cho gói năm.';

  @override
  String get tosSection6Title => '6. Chấm dứt tài khoản';

  @override
  String get tosSection6Content =>
      'Tài khoản vi phạm điều khoản, có hành vi lạm dụng hoặc tạo nội dung phản cảm có thể bị khóa hoặc chấm dứt ngay lập tức.';

  @override
  String get tosContact => 'Liên hệ: support@vocabik.com';

  @override
  String get privacySummaryTitle => 'Tóm tắt:';

  @override
  String get privacySummaryContent =>
      'Chúng tôi thu thập email, tên hiển thị và dữ liệu học tập để cung cấp dịch vụ. Chúng tôi không bán dữ liệu của bạn.';

  @override
  String get privacySection1Title => '1. Thông tin chúng tôi thu thập';

  @override
  String get privacySection1Content =>
      'Email, tên hiển thị, mã định danh tài khoản và dữ liệu học tập (tiến độ, điểm số, từ vựng đã lưu) để cá nhân hóa trải nghiệm.';

  @override
  String get privacySection2Title => '2. Cách sử dụng thông tin';

  @override
  String get privacySection2Content =>
      'Cung cấp dịch vụ học tập, gợi ý video phù hợp, theo dõi tiến độ, bảng xếp hạng và gửi nhắc nhở streak (nếu bạn bật).';

  @override
  String get privacySection3Title => '3. Dịch vụ bên thứ ba';

  @override
  String get privacySection3Content =>
      'Google Sign-In, YouTube API Services, Firebase (chẩn đoán lỗi Crashlytics, Cloud Messaging, In-App Messaging) và Google Analytics. Khi dùng tính năng YouTube, bạn cũng tuân thủ Chính sách Quyền riêng tư của Google (https://policies.google.com/privacy).';

  @override
  String get privacySection4Title => '4. Chẩn đoán & Dữ liệu kỹ thuật';

  @override
  String get privacySection4Content =>
      'Chúng tôi lưu trữ token xác thực bảo mật và nhật ký lỗi chẩn đoán ẩn danh để cải thiện độ ổn định của ứng dụng.';

  @override
  String get privacySection5Title => '5. Quyền của bạn & Yêu cầu xóa dữ liệu';

  @override
  String get privacySection5Content =>
      'Bạn có thể gửi yêu cầu xóa tài khoản hoặc tra cứu dữ liệu bất cứ lúc nào tại https://vocabik.com/delete-account hoặc qua email privacy@vocabik.com.';

  @override
  String get privacySection6Title => '6. Bảo mật dữ liệu';

  @override
  String get privacySection6Content =>
      'Dữ liệu được mã hóa khi truyền tải qua HTTPS và lưu trữ trên hạ tầng bảo mật.';

  @override
  String get privacyContact => 'Liên hệ: privacy@vocabik.com';

  @override
  String get forgotPasswordHeading => 'Quên mật khẩu?';

  @override
  String get forgotPasswordSubtitle =>
      'Nhập email, chúng tôi sẽ gửi link đặt lại.';

  @override
  String get backToLogin => 'Quay lại đăng nhập';

  @override
  String get sendResetLink => 'Gửi link đặt lại →';

  @override
  String get resetPasswordHeading => 'Đặt mật khẩu mới';

  @override
  String get newPasswordHint => 'Mật khẩu mới';

  @override
  String get confirmPasswordHint => 'Xác nhận mật khẩu';

  @override
  String get resetPasswordAction => 'Đặt lại mật khẩu →';

  @override
  String get passwordsDoNotMatch => 'Mật khẩu xác nhận không khớp';

  @override
  String get emailSentSuccess => 'Link đặt lại mật khẩu đã được gửi đến email.';

  @override
  String get resetPasswordSuccess =>
      'Mật khẩu đã được cập nhật thành công. Vui lòng đăng nhập lại.';

  @override
  String get achievementsYourAchievements => 'Thành tích của bạn';

  @override
  String achievementsBadgesUnlocked(int count, int total) {
    return '$count / $total badges đã mở khóa';
  }

  @override
  String get achievementsUnlockedHeader => 'ĐÃ MỞ KHÓA';

  @override
  String get achievementsLockedHeader => 'CHƯA MỞ KHÓA';

  @override
  String get achievementsEmpty => 'Chưa có thành tích nào.';

  @override
  String get achievementsFilterAll => 'Tất cả';

  @override
  String get achievementsFilterExercise => 'Bài tập';

  @override
  String get achievementsFilterStreak => 'Streak';

  @override
  String get achievementsFilterProficiency => 'Trình độ';

  @override
  String get achievementsFilterDiversity => 'Đa dạng';

  @override
  String get achievementsFilterVocabulary => 'Từ vựng';

  @override
  String get achievementsFilterSpeed => 'Tốc độ';

  @override
  String get achievementsFilterGeneral => 'Chung';

  @override
  String get achievementsFilterMilestones => 'Cột mốc';

  @override
  String get achievementsFilterGenre => 'Thể loại';

  @override
  String get dailyChallengeTitle => 'Daily Challenge';

  @override
  String get dailyChallengeJoinNow => 'Tham gia ngay! →';

  @override
  String get dailyChallengeTopToday => 'Top hôm nay';

  @override
  String dailyChallengeStreakDays(int count) {
    return 'Bạn đã tham gia $count ngày liên tiếp!';
  }

  @override
  String get dailyChallengeStreakKeep =>
      'Tham gia hôm nay để duy trì chuỗi ngày!';

  @override
  String dailyChallengeParticipants(String count) {
    return '$count đang tham gia';
  }

  @override
  String get dailyChallengeNoParticipants =>
      'Chưa có ai tham gia hôm nay. Hãy là người đầu tiên!';

  @override
  String get dailyChallengeNotConfigured => 'Chưa có thử thách nào cho hôm nay';

  @override
  String get xpLeaderboardTitle => 'Bảng xếp hạng XP';

  @override
  String xpLeaderboardResetsIn(String time) {
    return 'Làm mới sau: $time';
  }

  @override
  String xpLeaderboardResetsInDays(int days) {
    return 'Làm mới sau: $days ngày';
  }

  @override
  String xpLeaderboardResetsInHours(int hours) {
    return 'Làm mới sau: $hours giờ';
  }

  @override
  String xpLeaderboardResetsInMinutes(int minutes) {
    return 'Làm mới sau: $minutes phút';
  }

  @override
  String get xpLeaderboardResettingSoon => 'Sắp làm mới';

  @override
  String get xpLeaderboardFilterThisWeek => 'Tuần này';

  @override
  String get xpLeaderboardFilterLastWeek => 'Tuần trước';

  @override
  String get xpLeaderboardFilterThisMonth => 'Tháng này';

  @override
  String get xpLeaderboardFilterGlobal => 'Toàn cầu';

  @override
  String get xpLeaderboardFilterFriends => 'Bạn bè';

  @override
  String get xpLeaderboardYourRank => 'Hạng của bạn';

  @override
  String get xpLeaderboardEmpty => 'Chưa có dữ liệu bảng xếp hạng';

  @override
  String get challengeFriendTitle => 'Thách đấu bạn bè';

  @override
  String get challengeFriendSubtitle =>
      'Chọn bạn bè để cùng làm bài tập này. Điểm cao hơn sẽ chiến thắng.';

  @override
  String get challengeSearchFriendsHint => 'Tìm kiếm bạn bè...';

  @override
  String get challengeFriendsSection => 'BẠN BÈ TRÊN VOCABIK';

  @override
  String get challengePickAtLeastOne => 'Chọn ít nhất 1';

  @override
  String challengeSelectedCount(int count) {
    return 'Đã chọn $count';
  }

  @override
  String get challengeSend => 'Gửi lời thách đấu';

  @override
  String challengeSendWithCount(int count) {
    return 'Gửi lời thách đấu ($count) →';
  }

  @override
  String challengeBlanksCount(int count) {
    return '$count chỗ trống';
  }

  @override
  String get challengeNoFriendsFound => 'Không tìm thấy bạn bè nào';

  @override
  String get challengeLoadingFriends => 'Đang tải danh sách bạn bè...';

  @override
  String get challengeLoadFriendsError => 'Không thể tải danh sách bạn bè';

  @override
  String get challengeCreateLinkError => 'Không thể tạo liên kết thách đấu';

  @override
  String get challengeSentTitle => 'Đã gửi lời thách đấu!';

  @override
  String challengeSentSubtitleSingle(int score, String title, String friend) {
    return 'Điểm $score% của bạn trong bài “$title” đã được gửi tới $friend.';
  }

  @override
  String challengeSentSubtitleMultiple(int score, String title, int count) {
    return 'Điểm $score% của bạn trong bài “$title” đã được gửi tới $count người bạn.';
  }

  @override
  String get challengeInfo24HoursTitle => 'Họ có 24 giờ để phản hồi';

  @override
  String get challengeInfo24HoursDesc =>
      'Nếu hết thời gian, bạn sẽ mặc định chiến thắng.';

  @override
  String get challengeInfoNotifiedTitle => 'Bạn sẽ nhận được thông báo';

  @override
  String get challengeInfoNotifiedDesc =>
      'Ngay khi có người hoàn thành bài tập thách đấu.';

  @override
  String get challengeInfoWinXpTitle => 'Chiến thắng nhận +50 XP';

  @override
  String get challengeInfoWinXpDesc =>
      'Vượt điểm đối thủ để giành chiến thắng.';

  @override
  String get challengeCopyLink => 'Sao chép link thách đấu';

  @override
  String get challengeViewLeaderboard => 'Xem bảng xếp hạng →';

  @override
  String get challengeLinkCopied =>
      'Đã sao chép liên kết thách đấu vào bộ nhớ tạm!';

  @override
  String get notebookTitle => 'Sổ từ vựng';

  @override
  String wordsCount(int count) {
    return '$count từ';
  }

  @override
  String get searchWordsPlaceholder => 'Tìm kiếm từ vựng...';

  @override
  String get tabList => 'Danh sách';

  @override
  String get tabFlashcard => 'Thẻ ghi nhớ';

  @override
  String get tapToFlip => 'Chạm để lật';

  @override
  String get reviewAgain => 'Ôn lại';

  @override
  String get gotIt => 'Đã thuộc';

  @override
  String get emptyNotebook => 'Chưa có từ vựng nào được lưu.';

  @override
  String get noSearchResults => 'Không tìm thấy từ vựng phù hợp.';

  @override
  String get reviewFinishedTitle => 'Đã hoàn thành!';

  @override
  String get reviewFinishedDesc => 'Bạn đã ôn tập xong tất cả các thẻ từ vựng.';

  @override
  String get reportUserTitle => 'Báo cáo người dùng';

  @override
  String reportUserSubtitle(String userName) {
    return 'Chọn lý do báo cáo tài khoản “$userName”:';
  }

  @override
  String get reportReasonInappropriateName =>
      'Tên hiển thị không phù hợp hoặc phản cảm';

  @override
  String get reportReasonInappropriateAvatar =>
      'Ảnh đại diện vi phạm quy chuẩn cộng đồng';

  @override
  String get reportReasonHarassmentOrCheating =>
      'Hành vi quấy rối hoặc gian lận';

  @override
  String get reportReasonSpamOrAd => 'Spam hoặc nội dung quảng cáo';

  @override
  String get reportUserSubmit => 'Gửi báo cáo';

  @override
  String get reportUserSuccessMessage =>
      'Cảm ơn bạn. Báo cáo đã được tiếp nhận và chuyển tới đội ngũ kiểm duyệt.';
}
