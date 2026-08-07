# Code Review Report: Tính năng Login

Dưới đây là Báo cáo Đánh giá (Review Report) toàn diện cho tính năng Login của dự án Vocabik, dựa trên tiêu chuẩn "Feature-first Clean Architecture", BLoC/Cubit, và Vocabik Design System.

---

## 🔴 Cấp bách (Blocker)
*Hiện tại không có vấn đề nghiêm trọng nào dẫn đến crash app, rò rỉ bộ nhớ hoặc vi phạm nghiêm trọng về phân tầng kiến trúc.*
(Việc dispose `TextEditingController` đã được thực hiện đúng chuẩn, và các layer Domain/Data được phân chia hợp lý).

---

## 🟡 Cảnh báo (Warning)

### 1. Vi phạm Vocabik Design System (Thiếu `BounceWrapper`)
**Vấn đề:** Theo Design System, các tương tác nút bấm cần sử dụng `BounceWrapper`. Hiện tại `ElevatedButton`, `OutlinedButton`, và `TextButton` ở màn hình `LoginScreen` đang dùng kiểu mặc định của Material, thiếu hiệu ứng bounce.
**Đoạn code hiện tại (`login_screen.dart`):**
```dart
ElevatedButton(
  onPressed: state is AuthLoading ? null : () { ... },
  child: const Text('Đăng nhập'),
)
```
**Đề xuất sửa (Snippet):** Thay thế bằng một Component dùng chung hoặc bọc trong `BounceWrapper`:
```dart
BounceWrapper(
  onTap: state is AuthLoading ? null : () {
    context.read<AuthBloc>().add(LoginRequested(...));
  },
  child: Container(
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Center(
      child: state is AuthLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text('Đăng nhập', style: TextStyle(color: Colors.white)),
    ),
  ),
)
```
*(Thực hiện tương tự cho các nút Social Login và nút Quên mật khẩu).*

### 2. Xử lý Lỗi (Error Handling Smell)
**Vấn đề:** Trong `AuthBloc`, việc bắt ngoại lệ bằng `catch (e)` rồi biến đổi chuỗi `.replaceAll('Exception: ', '')` là không an toàn, rất dễ bị sai lệch khi Data Layer ném ra các lỗi khác nhau, và không hỗ trợ Đa ngôn ngữ (L10n).
**Đoạn code hiện tại (`auth_bloc.dart`):**
```dart
catch (e) {
  emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
}
```
**Đề xuất sửa:** Data layer nên map exception thành một class `Failure` cụ thể (ví dụ: `ServerFailure`, `NetworkFailure`), hoặc sử dụng gói chức năng như `fpdart`/`dartz` (dùng `Either`).
Tối giản ở tầng Bloc:
```dart
catch (e) {
  if (e is NetworkException) {
    emit(const AuthFailure('Không có kết nối mạng. Vui lòng kiểm tra lại.'));
  } else if (e is InvalidCredentialsException) {
    emit(const AuthFailure('Email hoặc mật khẩu không đúng.'));
  } else {
    emit(const AuthFailure('Đã xảy ra lỗi không xác định.'));
  }
}
```

### 3. Mã nguồn UI phình to (God Widget) & Vi phạm DRY
**Vấn đề:** Màn hình `LoginView` dài gần 250 dòng do chứa toàn bộ form đăng nhập và các nút Social. Đặc biệt, hai nút Google và Facebook bị lặp lại cấu trúc UI. Ngoài ra, việc không có validate input (chuỗi rỗng, sai định dạng email) trước khi gửi event lên Bloc sẽ gây gọi API lãng phí.
**Đoạn code hiện tại (`login_screen.dart`):**
```dart
OutlinedButton.icon(
  icon: const Text('G', ...),
  label: Text('Tiếp tục với Google', ...),
  // Lặp lại với Facebook...
```
**Đề xuất sửa:** Tách nút Social ra widget riêng.
```dart
class SocialLoginButton extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback onTap;

  const SocialLoginButton({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Return the BounceWrapper + Button UI here
  }
}
```
Nên tách form thành các Widget nhỏ như `_LoginForm` và `_SocialAuthSection` để `LoginView` dễ đọc hơn.

---

## 🟢 Gợi ý (Suggestion)

### 1. Tối ưu Rebuild UI với `buildWhen` trong `BlocConsumer`
**Vấn đề:** Hiện tại `BlocConsumer` bọc toàn bộ body. Khi nhận được trạng thái `AuthSuccess` (chỉ cần chuyển màn hình) hoặc `AuthFailure` (chỉ cần hiện SnackBar), phần `builder` vẫn bị gọi và render lại UI không cần thiết.
**Đoạn code đề xuất (`login_screen.dart`):**
```dart
body: BlocConsumer<AuthBloc, AuthState>(
  listener: (context, state) { ... },
  buildWhen: (previous, current) {
    // Chỉ render lại UI khi trạng thái loading thay đổi (để xoay vòng)
    return current is AuthLoading || previous is AuthLoading; 
  },
  builder: (context, state) { ... }
)
```

### 2. Sử dụng Typography từ Design System
**Vấn đề:** Các kiểu chữ đang dùng `TextStyle` tĩnh được hard-code.
**Đoạn code hiện tại (`login_screen.dart`):**
```dart
const Text('Đăng nhập vào Vocabik', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
```
**Đề xuất sửa:** Dùng TextTheme chuẩn của ứng dụng để tự động kế thừa font 'Nunito'.
```dart
Text(
  'Đăng nhập vào Vocabik',
  textAlign: TextAlign.center,
  style: Theme.of(context).textTheme.titleLarge?.copyWith(
    fontWeight: FontWeight.bold,
  ),
),
```

### 3. Tách biệt `LoginEvent` và State
Để dễ dàng cho việc validate, nên tạo thêm trạng thái báo lỗi cho từng field trong State hoặc sử dụng Formz package nếu project có yêu cầu validation form phức tạp, thay vì truyền thẳng raw data `_emailController.text` vào event `LoginRequested`.
