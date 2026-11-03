# 📝 Báo Cáo Code Review: Tính Năng Sign-Out (Vocabik)

Đóng vai trò là Senior Flutter Performance Engineer & Tech Lead, dưới đây là báo cáo Code Review cho tính năng **Sign-Out (Đăng xuất)**. 

---

## 1. 🔴 CRITICAL (Lỗi Hiệu Năng & UX Nghiêm Trọng)

### 1.1. Silent Failure & Thiếu Loading Feedback trên UI (Main Thread / UX)
**Vấn đề:** 
Khi người dùng bấm "Xác nhận" đăng xuất, `AuthBloc` emit state `status: AuthStatus.loading`, sau đó gọi API, và cuối cùng emit `success` (chuyển sang `unauthenticated`) hoặc `failure`. Tuy nhiên:
- UI (`AccountTabContent`) **không hề có cơ chế hiển thị Loading** (chặn tương tác) khi gọi API. Điều này khiến người dùng tưởng app bị treo nếu mạng chậm.
- Nếu xảy ra lỗi (ví dụ API timeout), `AuthBloc` emit `AuthStatus.failure` nhưng `BlocListener` tại `AccountTabContent` **chỉ lắng nghe state `unauthenticated`** và bỏ qua mọi state khác. 

**Vị trí:** 
- [account_tab_content.dart](file:///d:/App/vocabik_app/lib/features/profile/presentation/widgets/account_tab_content.dart#L18-L23)

**Code đề xuất tối ưu (UI):**
```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state.status == AuthStatus.loading) {
      // Hiện loading overlay / dialog
      DialogUtils.showLoading(context);
    } else {
      // Ẩn loading khi xử lý xong (dù thành công hay lỗi)
      DialogUtils.hideLoading(context);
      
      if (state.status == AuthStatus.unauthenticated) {
        context.go('/login');
      } else if (state.status == AuthStatus.failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.errorMessage ?? 'Đăng xuất thất bại')),
        );
      }
    }
  },
  child: // ...
```

### 1.2. Nguy cơ Blocking Network Thread do thiếu Timeout & CancelToken (API Performance)
**Vấn đề:** 
Request POST `/auth/sign-out` có thể bị treo vô thời hạn nếu mạng chập chờn do không có timeout cục bộ (chỉ phụ thuộc vào global config của Dio) và không hỗ trợ `CancelToken`. Thêm nữa, Đăng xuất là một thao tác cần xử lý nhanh, không thể để treo ứng dụng.

**Vị trí:** 
- [auth_remote_data_source.dart](file:///d:/App/vocabik_app/lib/features/auth/data/data_sources/auth_remote_data_source.dart#L35-L40)

**Giải pháp:**
Truyền thêm cấu hình `Options(sendTimeout: const Duration(seconds: 3), receiveTimeout: const Duration(seconds: 3))` để ép buộc API trả về lỗi nhanh chóng nếu kết nối kém, tránh block luồng chờ quá lâu.

---

## 2. 🟠 WARNING (Cảnh Báo Tối Ưu Hiệu Năng)

### 2.1. Nuốt lỗi (Swallowing Exception) ở Remote Data Source (Kiến Trúc)
**Vấn đề:** 
Hàm `signOut()` tại `AuthRemoteDataSourceImpl` dùng `try-catch` và cố tình bỏ qua exception. Dù ý đồ là "ép xóa token local kể cả khi gọi API xịt", nhưng việc nuốt exception ở tầng Data Source phá vỡ nguyên tắc phân chia trách nhiệm (Single Responsibility). Repository sẽ không bao giờ biết được API thực sự bị lỗi hay không để xử lý logging hoặc retry logic.

**Vị trí:**
- [auth_remote_data_source.dart](file:///d:/App/vocabik_app/lib/features/auth/data/data_sources/auth_remote_data_source.dart#L35-L41)

**Giải pháp:** 
Data Source nên throw lỗi. Còn việc "vẫn xóa token local" nên được đưa lên tầng `AuthRepositoryImpl`.
```dart
// Tại AuthRemoteDataSourceImpl
@override
Future<void> signOut() async {
  await _dio.post(
    '/auth/sign-out',
    options: Options(receiveTimeout: const Duration(seconds: 3)), // Fast fail
  );
}

// Tại AuthRepositoryImpl
@override
Future<Either<Failure, void>> signOut() async {
  try {
    try {
      await _remoteDataSource.signOut();
    } catch (e) {
      // Ghi log lỗi từ API nhưng VẪN TIẾP TỤC xóa local token
      debugPrint('Logout API failed: $e');
    }
    await _localDataSource.clear();
    return right(null);
  } catch (e) {
    return left(const ServerFailure('Lỗi thiết bị: Không thể xóa dữ liệu'));
  }
}
```

### 2.2. Thiếu Debouncing/Droppable cho Event Đăng Xuất (Concurrency Performance)
**Vấn đề:** 
`LogoutRequested` được đăng ký qua `on<LogoutRequested>(_onLogoutRequested);`. Nếu người dùng thao tác spam (vd: thiết bị lag và bấm liên tục nút Xác nhận), Bloc sẽ xử lý nhiều event gọi API liên tục.

**Vị trí:**
- [auth_bloc.dart](file:///d:/App/vocabik_app/lib/features/auth/presentation/bloc/auth_bloc.dart#L27)

**Giải pháp:**
Sử dụng package `bloc_concurrency` để drop các event đến sau nếu event đầu đang xử lý.
```dart
import 'package:bloc_concurrency/bloc_concurrency.dart';

on<LogoutRequested>(
  _onLogoutRequested,
  transformer: droppable(),
);
```

---

## 3. 🟡 OPTIMIZATION (Đề Xuất Cải Tiến Cấu Trúc)

### 3.1. Tối Ưu Phân Bổ Bộ Nhớ với Dialog (Memory Performance)
**Vấn đề:** 
`_showLogoutConfirmationDialog` khởi tạo các Text Widget và TextStyle phức tạp như `GoogleFonts.nunito` trực tiếp trong function builder của dialog. Mỗi lần pop-up mở, hệ thống lại phải build và tính toán bộ nhớ lại cho một widget tree ẩn không cần thiết.

**Vị trí:** 
- [account_tab_content.dart](file:///d:/App/vocabik_app/lib/features/profile/presentation/widgets/account_tab_content.dart#L55-L104)

**Giải pháp:** 
Tách toàn bộ `AlertDialog` này ra thành một class `StatelessWidget` độc lập (ví dụ `LogoutConfirmationDialog`), và gọi nó qua `showDialog(context: context, builder: (_) => const LogoutConfirmationDialog());`. Sử dụng `const` ở các vị trí không thay đổi sẽ giảm overhead build cho Flutter Render Tree.
