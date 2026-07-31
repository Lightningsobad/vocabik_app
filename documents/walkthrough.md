# Walkthrough: Khởi tạo Khung Ứng Dụng Vocabik

Tài liệu này ghi lại chi tiết các bước đã hoàn thành trong việc khởi tạo **Khung ứng dụng (App Skeleton)** dự án Vocabik Mobile App và kết quả kiểm thử xác minh.

---

## 1. Các Công Việc Đã Hoàn Thành

### 1.1 Khởi tạo Kiến trúc Cốt lõi (Core Architecture)
- Thiết lập file entry point [lib/main.dart](file:///d:/App/vocabik_app/lib/main.dart) với Widget chính `VocabikApp` hỗ trợ Material 3 và `MaterialApp.router`.
- Xây dựng hệ thống điều hướng dạng khai báo (Declarative Routing) tại [lib/core/routes/app_router.dart](file:///d:/App/vocabik_app/lib/core/routes/app_router.dart) sử dụng `go_router`:
  - Route `/`: Màn hình Splash (`PlaceholderScreen`)
  - Route `/login`: Màn hình Đăng nhập
  - Route `/home`: Màn hình Trang chủ
  - Route `/player`: Màn hình Phát video & Làm bài tập
- Cấu hình hệ thống Quản lý Phụ thuộc (Dependency Injection) tại [lib/core/di/injection.dart](file:///d:/App/vocabik_app/lib/core/di/injection.dart) kết hợp `get_it` và `injectable`.

### 1.2 Tổ chức Thư mục theo Feature-first Clean Architecture
Đã phân chia thư mục chuẩn hóa trong `lib/`:
```text
lib/
├── core/
│   ├── di/             # Injection container configuration
│   ├── routes/         # GoRouter configuration
│   ├── errors/         # Core exception/failure definitions
│   ├── network/        # API Client / Dio setup
│   └── utils/          # Utility functions and constants
├── features/           # Feature modules (auth, player, discover, progress)
└── main.dart           # App entrypoint
```

### 1.3 Chuẩn hóa & Khắc phục Lỗi Bộ kiểm thử (Widget Test)
Đã hoàn thiện file [test/widget_test.dart](file:///d:/App/vocabik_app/test/widget_test.dart):
1. **Sửa lỗi Constructor**: Thay thế `MyApp()` bằng `VocabikApp()`.
2. **Cập nhật Test Assertion**: Xử lý việc `PlaceholderScreen` hiển thị tiêu đề `"Splash Screen"` tại cả `AppBar` và `body` bằng cách sử dụng `findsNWidgets(2)`.

---

## 2. Kết quả Xác minh (Verification Results)

### Kiểm thử Tự động (Automated Test Execution)
Đã chạy lệnh kiểm thử `flutter test` thành công 100%:

```text
00:00 +0: loading D:/App/vocabik_app/test/widget_test.dart
00:00 +0: App load smoke test
00:00 +1: All tests passed!
```

### Trạng thái Bộ Khung (App Skeleton Status)
- [x] Khởi tạo dự án Flutter thành công.
- [x] Cấu hình `VocabikApp` làm Root Widget.
- [x] Cấu hình GoRouter với các route cơ bản.
- [x] Cấu hình GetIt + Injectable cho DI.
- [x] Bộ kiểm thử Smoke Test hoạt động mượt mà không có lỗi.
