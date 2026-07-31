# Kế hoạch Triển khai: Khung ứng dụng (App Skeleton) Vocabik

Tài liệu này chi tiết hóa kế hoạch triển khai xây dựng **Khung ứng dụng (App Skeleton)** cho dự án Vocabik Mobile App, dựa trên **Architecture Software Architecture Document (SAD)**.

---

## 1. Mục tiêu Triển khai

Xây dựng bộ khung ứng dụng vững chắc, chuẩn hóa và dễ mở rộng cho toàn bộ team phát triển Vocabik Mobile App với các thành phần cốt lõi:
1. **Kiến trúc Clean Architecture theo Feature (Feature-first)**: Phân tách rõ ràng giữa `core/`, `features/` và `shared/`.
2. **Quản lý trạng thái (State Management)**: Tích hợp `flutter_bloc` / `cubit` sẵn sàng cho business logic.
3. **Điều hướng (Declarative Routing)**: Tích hợp `go_router` hỗ trợ điều hướng dạng khai báo và sẵn sàng cho Deep-linking.
4. **Quản lý phụ thuộc (Dependency Injection)**: Sử dụng `get_it` kết hợp `injectable` để tự động hóa DI container.
5. **Bộ kiểm thử tự động (Testing)**: Khởi tạo Smoke Widget Test đảm bảo khung app khởi chạy mượt mà không có lỗi.

---

## 2. Chi tiết Cấu trúc & Tệp tin Thành phần

### Core Component (`lib/core/`)
Chứa các module cơ sở dùng chung cho toàn bộ ứng dụng:

- **[NEW / UPDATE] [injection.dart](file:///d:/App/vocabik_app/lib/core/di/injection.dart)**: Cấu hình `get_it` và `@InjectableInit` khởi tạo container DI.
- **[NEW / UPDATE] [app_router.dart](file:///d:/App/vocabik_app/lib/core/routes/app_router.dart)**: Cấu hình `GoRouter` định nghĩa tuyến đường ban đầu (`/`, `/login`, `/home`, `/player`) và các `PlaceholderScreen`.
- **[PLANNED] `lib/core/network/`**: Tích hợp Dio client, Interceptors xử lý JWT token và refresh token.
- **[PLANNED] `lib/core/errors/`**: Phân loại Exceptions & Failures chuẩn hóa.
- **[PLANNED] `lib/core/utils/`**: Các hàm tiện ích, định nghĩa hằng số hệ thống.

### Features Layer (`lib/features/`)
Khởi tạo cấu trúc các tính năng chính theo chuẩn Clean Architecture:
- `features/auth/` (Data, Domain, Presentation)
- `features/player/` (Video sync, Time-sync, Fill-in-the-blanks)
- `features/discover/` (Playlist, Khám phá)
- `features/progress/` (Lịch sử, Streak, Leaderboard)

### Main Application Entrypoint (`lib/main.dart`)
- **[MODIFY] [main.dart](file:///d:/App/vocabik_app/lib/main.dart)**: 
  - Khởi tạo `WidgetsFlutterBinding.ensureInitialized()`.
  - Gọi `configureDependencies()` khởi tạo DI container.
  - Render `VocabikApp` sử dụng `MaterialApp.router` liên kết với `appRouter`.

### Automated Testing (`test/widget_test.dart`)
- **[MODIFY] [widget_test.dart](file:///d:/App/vocabik_app/test/widget_test.dart)**:
  - Khởi chạy Smoke Test cho `VocabikApp`.
  - Đảm bảo widget test vượt qua verification mà không bị lỗi thiếu constructor hoặc sai đếm widget.

---

## 3. Quy trình Kiểm thử & Xác minh (Verification Plan)

### Automated Tests
- Chạy toàn bộ test suite bằng câu lệnh CLI:
  ```bash
  flutter test
  ```
- Kết quả mong muốn: `All tests passed!` mà không có lỗi biên dịch hoặc lỗi runtime expectation.

### Manual Verification
- Khởi chạy ứng dụng trên thiết bị mô phỏng (Emulator/Simulator):
  ```bash
  flutter run
  ```
- Xác nhận màn hình Splash hiển thị đúng theo tuyến đường `/`.
