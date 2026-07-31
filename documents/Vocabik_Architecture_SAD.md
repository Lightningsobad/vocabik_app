# Kiến trúc Giải pháp & Triển khai - Vocabik Mobile App

Tài liệu này định nghĩa các quyết định kỹ thuật, bộ công cụ (Tech Stack) và tiêu chuẩn kiến trúc cho dự án Vocabik Mobile App, dựa trên các yêu cầu từ thiết kế UI/UX và thảo luận cùng team. Tài liệu này đóng vai trò là "kim chỉ nam" cho team lập trình (Dev Team) bắt đầu triển khai.

## 1. Kiến trúc Tổng thể (Core Architecture) & State Management

*   **Kiến trúc Thư mục:** **Feature-first Clean Architecture**.
    *   Mỗi tính năng (Feature như Auth, Player, Leaderboard) sẽ đóng gói toàn bộ Data, Domain, và Presentation của nó. Điều này giúp dễ dàng mở rộng và scale team.
*   **Quản lý Trạng thái (State Management):** **BLoC / Cubit**.
    *   Sử dụng `flutter_bloc` để tách biệt hoàn toàn Business Logic ra khỏi UI. Phù hợp cho tính logic phức tạp của màn hình Player (đồng bộ thời gian, tính điểm, streak).
*   **Routing & Navigation:** **GoRouter**.
    *   Quản lý điều hướng theo dạng declarative routing, hỗ trợ tối đa cho Deep-linking (để mở bài tập từ Bot/Telegram).
*   **Nền tảng mục tiêu (Target Platform):** **100% Mobile (iOS & Android)**. Không cần tính toán responsive cho Web hay Tablet ở giai đoạn này.

### Đề xuất Cấu trúc Thư mục (Directory Structure)

Dựa trên **Feature-first Clean Architecture**, dự án sẽ phân chia thư mục theo từng tính năng độc lập, giúp code dễ scale, dễ test và giảm conflict khi nhiều devs làm việc song song. Cấu trúc cơ bản trong `lib/` như sau:

```text
lib/
├── core/                   # Cốt lõi của app, dùng chung toàn cục
│   ├── network/            # Cấu hình API client (Dio), Interceptors
│   ├── routes/             # Cấu hình GoRouter (app_router.dart)
│   ├── errors/             # Xử lý Error, Exceptions, Failures
│   └── utils/              # Các hàm tiện ích, Constants
├── features/               # Các tính năng chính (Feature-first)
│   ├── auth/               # Đăng nhập, Đăng ký, Quên mật khẩu
│   │   ├── data/           # Models, Data Sources (API/Local), Repositories Impl
│   │   ├── domain/         # Entities, Use cases, Repositories Interfaces
│   │   └── presentation/   # Screens, Widgets, BLoC/Cubit của riêng Auth
│   ├── player/             # Màn hình phát video & Điền từ (Fill-blank)
│   ├── discover/           # Khám phá, Playlist
│   ├── progress/           # Tiến độ, Lịch sử, Leaderboard
│   └── classroom/          # (v2.0) Lớp học, Bài tập giao
├── shared/                 # Các widgets, logic dùng chung giữa nhiều features
└── main.dart               # Entry point khởi chạy app
```

*Ghi chú:* Design System (Màu sắc, Typography, Buttons...) sẽ được tách ra thành một package nội bộ nằm ở `packages/vocabik_ui` để UI được quản lý tập trung và độc lập với business logic.

## 2. Xử lý Video & Audio (Media Engine)

*   **Nguồn Video:** Video từ YouTube, nhưng mobile app sẽ nhận direct stream link (HLS/MP4) hoặc YouTube embed qua **API Backend**. Client không xử lý cào dữ liệu trực tiếp.
*   **Đồng bộ dữ liệu (Time-sync):** Dữ liệu JSON chứa kịch bản, lời bài hát, các khoảng trống (blanks), từ vựng sẽ được **fetch trọn gói 1 lần** (One-time fetch) trước khi vào màn hình Player.
*   **Audio/Video Versions (Speed/Pitch):** Mọi tác vụ xử lý audio đa phiên bản (tốc độ nhanh/chậm, beat) sẽ do **Backend xử lý 100%**. Mobile app chỉ đóng vai trò phát media tương ứng.

## 3. Khả năng Ngoại tuyến (Offline Capabilities)

*   **Online-only:** App yêu cầu kết nối mạng (Network-dependent). **Không hỗ trợ offline**. Mọi dữ liệu (lịch sử, sổ từ vựng) đều gọi trực tiếp qua API khi cần thiết.

## 4. Xác thực & Giao tiếp Dữ liệu (Auth & Communication)

*   **Social Authentication:** Tích hợp **Google, Apple ID, Facebook** (sử dụng Firebase Auth làm cầu nối, hoặc custom backend OAuth2 tùy hệ thống backend).
*   **Cập nhật Dữ liệu (Real-time):** Sử dụng chiến lược **Pull-to-refresh & Polling** khi tải trang (Đặc biệt cho Leaderboard, Tiến độ). Không dùng WebSockets để giảm tải hạ tầng giai đoạn MVP.
*   **Deep-linking & Bot Integration:** App sẽ hứng Universal Link / App Links (ví dụ: `vocabik.com/assignment/123`) qua **GoRouter**. Khi user bấm link từ Bot Telegram/Messenger, app tự động parse ID và bật thẳng vào màn hình làm bài tập.

## 5. Thanh toán & Phân quyền (Monetization)

*   **In-App Purchase / Subscription:** Tích hợp **RevenueCat** (`purchases_flutter`) để quản lý các gói Premium (Tháng/Năm) tự động đồng bộ receipt giữa Apple App Store và Google Play.
*   **Kiểm soát Giới hạn (Paywall):** Quản lý đếm lượt làm bài (Daily limit), kiểm tra Premium hoàn toàn trên **Backend 100%** nhằm đảm bảo bảo mật và chống hack/cheat (app chỉ nhận cờ `can_play: true/false`).

## 6. Giao diện & Gamification (UI/UX)

*   **Design System:** Tách giao diện thành một internal package riêng (`vocabik_ui`). Chứa các widget dùng chung, màu sắc, typography (Glassmorphism, Dark/Light mode).
*   **Gamification & Animation:**
    *   Sử dụng thư viện **Rive / Lottie** cho các hoạt ảnh phức tạp (Badge unlock, Streak lửa cháy, Confetti).
    *   Tích hợp **Haptic Feedback** (bộ rung phản hồi xúc giác) bằng thư viện `haptic_feedback` hoặc native API cho các tương tác gõ phím, đúng/sai, nhận thưởng.

## 7. Bảo mật & Analytics (Security & Analytics)

*   **Bảo vệ Nội dung (DRM):**
    *   Sử dụng thư viện chặn quay/chụp màn hình (Ví dụ: `flutter_windowmanager` FLAG_SECURE cho Android và ScreenShield/logic xoá View cho iOS).
*   **Analytics (Bổ sung ngầm định):** Tích hợp Firebase Analytics / Crashlytics để tracking các event quan trọng (Play Video, Unlock Badge, Mua Premium).

## 8. Các Tiêu Chuẩn Kỹ Thuật Bổ Sung

Dựa trên quá trình chốt giải pháp, các tiêu chuẩn sau sẽ được áp dụng:

*   **Quản lý Phụ thuộc (Dependency Injection):** Sử dụng `get_it` kết hợp với `injectable` để hỗ trợ tự động generate code, đáp ứng đúng chuẩn Clean Architecture.
*   **Quản lý Môi trường (Environments):** Thiết lập Native Flavors (Android ProductFlavors, iOS Schemes) kết hợp với package `flutter_flavorizr` để cấu hình tự động. Sử dụng tham số `--dart-define` để truyền các biến môi trường nhạy cảm (API Keys, Secrets) an toàn.
*   **Lưu trữ Dữ liệu Cục bộ (Local Storage):**
    *   Sử dụng `flutter_secure_storage` để lưu các dữ liệu nhạy cảm (Access Token, Refresh Token).
    *   Sử dụng `shared_preferences` để lưu các tùy chọn đơn giản (Cấu hình app, Settings, Theme).
*   **Đa ngôn ngữ (i18n / l10n):** Sử dụng `flutter_localizations` (bộ công cụ mặc định của Flutter với file `.arb`).
*   **Thông báo Đẩy (Push Notifications):** Tích hợp **Firebase Cloud Messaging (FCM)**.
*   **Kiểm thử (Testing Strategy):** Áp dụng chiến lược Test mức 3 (Toàn diện):
    *   Unit Test: Bắt buộc cho toàn bộ logic ở tầng `domain` (Entities, UseCases) và `data` (Repositories).
    *   Widget Test: Kiểm thử UI cho các components dùng chung trong internal package `vocabik_ui`.
    *   Integration Test: Đảm bảo luồng người dùng cốt lõi hoạt động xuyên suốt (Ví dụ: Đăng nhập -> Chọn bài -> Làm bài -> Nhận điểm).
*   **CI/CD Pipeline:** Sử dụng **GitHub Actions** để thiết lập luồng tự động kiểm tra code, chạy test và build bản cài (APK/IPA).

---

## 9. Các Quyết Định Chờ (Pending Decisions) & Ghi Chú

*   **Audio/Video Player package:** Đang chờ quyết định từ team Backend. Phụ thuộc vào việc Backend sẽ trả về direct link HLS/MP4 (sẽ dùng `video_player` / `media_kit`) hay trả về cấu hình nhúng YouTube iframe (sẽ dùng `youtube_player_iframe`).
*   **Analytics:** Chốt sử dụng **Firebase Analytics** và **Firebase Crashlytics** làm bộ công cụ tracking chính, không sử dụng thêm công cụ bên thứ 3 nào khác.
