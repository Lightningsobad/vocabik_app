### 📋 BÁO CÁO ĐÁNH GIÁ (REVIEW REPORT): Tính năng chuyển đổi Darkmode-Lightmode

---

#### 1. Kiến trúc (Architecture Compliance)

🔴 **Cấp bách (Blocker): Rò rỉ logic (Logic Bleeding) tại `ThemeCubit`**
- **Vấn đề**: `ThemeCubit` (thuộc Presentation/State Management Layer) đang chứa trực tiếp đối tượng `SharedPreferences` (thuộc Data Layer). Điều này vi phạm nguyên tắc Dependency Rule của Clean Architecture. Cubit không nên biết về chi tiết lưu trữ vật lý của nền tảng (như SharedPreferences, Hive hay SQLite).
- **Code hiện tại** (`lib/shared/theme/cubit/theme_cubit.dart`):
  ```dart
  class ThemeCubit extends Cubit<ThemeMode> {
    static const String _themeKey = 'theme_mode';
    final SharedPreferences prefs;

    ThemeCubit({required this.prefs}) : super(ThemeMode.system) {
      _loadTheme();
    }
    // ...
  }
  ```
- **Đề xuất sửa đổi**: Tạo một `ThemeRepository` ở Domain Layer và `ThemeRepositoryImpl` ở Data Layer. Tiêm `ThemeRepository` vào `ThemeCubit`.
  ```dart
  // domain/repositories/theme_repository.dart
  abstract class ThemeRepository {
    Future<ThemeMode> getThemeMode();
    Future<void> saveThemeMode(ThemeMode mode);
  }

  // presentation/cubit/theme_cubit.dart
  class ThemeCubit extends Cubit<ThemeMode> {
    final ThemeRepository _themeRepository;

    ThemeCubit({required ThemeRepository themeRepository}) 
        : _themeRepository = themeRepository, 
          super(ThemeMode.system) {
      _loadTheme();
    }

    Future<void> _loadTheme() async {
      final theme = await _themeRepository.getThemeMode();
      emit(theme);
    }

    Future<void> toggleTheme() async {
      final newTheme = (state == ThemeMode.light || state == ThemeMode.system) 
          ? ThemeMode.dark 
          : ThemeMode.light;
      emit(newTheme);
      await _themeRepository.saveThemeMode(newTheme);
    }
  }
  ```

#### 2. Quản lý Trạng thái (State Management - BLoC/Cubit)

🟡 **Cảnh báo (Warning): Xử lý bất đồng bộ trong `toggleTheme`**
- **Vấn đề**: `prefs.setString` là một thao tác bất đồng bộ (trả về `Future<bool>`), nhưng hàm `toggleTheme` hiện tại là hàm đồng bộ (void) và không `await` thao tác này. Nếu quá trình lưu xuống đĩa thất bại, State ở UI đã đổi nhưng lần mở app sau sẽ bị sai lệch.
- **Code hiện tại**:
  ```dart
  void toggleTheme() {
    if (state == ThemeMode.light || state == ThemeMode.system) {
      emit(ThemeMode.dark);
      prefs.setString(_themeKey, 'dark'); // Không có await
    } 
    // ...
  }
  ```
- **Đề xuất sửa đổi**: Như đoạn mã đề xuất ở phần 1, nên đổi `toggleTheme` thành `Future<void>`, có chứa khối `try-catch` để xử lý nếu việc lưu thất bại.

#### 3. UI/UX & Design System

🟡 **Cảnh báo (Warning): Không sử dụng `BounceWrapper` cho nút bấm**
- **Vấn đề**: Các nút tròn ở Header (`HeaderCircleButton`) đang sử dụng `InkWell` mặc định thay vì component `BounceWrapper` theo chuẩn của Vocabik Design System.
- **Code hiện tại** (`lib/shared/presentation/widgets/header/header_circle_button.dart`):
  ```dart
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      // ...
  ```
- **Đề xuất sửa đổi**: Bao bọc nút bằng `BounceWrapper` và gỡ bỏ `InkWell` để tạo hiệu ứng nảy đồng nhất.
  ```dart
  return BounceWrapper(
    onTap: onTap,
    child: Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.surfaceCard, 
        border: Border.all(color: colors.borderSubtle), 
      ),
      // ...
  ```

🟡 **Cảnh báo (Warning): Hardcode Typography thay vì dùng Google Fonts 'Nunito'**
- **Vấn đề**: File `header_circle_button.dart` đang gán cứng `fontFamily: 'Display'` không đúng với chuẩn font chữ Nunito đã được định nghĩa.
- **Code hiện tại**:
  ```dart
  fontFamily: 'Display',
  ```
- **Đề xuất sửa đổi**: Sử dụng `GoogleFonts.nunito` (giống như cách đã dùng trong `MainShellScreen`).
  ```dart
  style: GoogleFonts.nunito(
    fontSize: 12,
    fontWeight: FontWeight.w800,
    color: colors.textSecondary,
  ),
  ```

#### 4. Chất lượng Code (Code Quality & Clean Code)

🟢 **Gợi ý (Suggestion): Loại bỏ Hardcode String Literals**
- **Vấn đề**: Các chuỗi `'light'`, `'dark'` đang bị lặp lại nhiều lần trong file `theme_cubit.dart`.
- **Code hiện tại**:
  ```dart
  if (themeString == 'light') { ... } else if (themeString == 'dark') { ... }
  ```
- **Đề xuất sửa đổi**: Đưa chúng vào constants hoặc extensions của `ThemeMode`.
  ```dart
  const String _lightModeVal = 'light';
  const String _darkModeVal = 'dark';
  // ...
  if (themeString == _lightModeVal) { emit(ThemeMode.light); }
  ```

---
**Tổng kết:** Tính năng hoạt động được nhưng đang vi phạm kiến trúc (Blocker) ở việc truyền thẳng `SharedPreferences` vào `ThemeCubit`. Cần tái cấu trúc lại logic lưu trữ này thành `ThemeRepository` để tuân thủ **Feature-first Clean Architecture** và thay `InkWell` bằng `BounceWrapper` để tuân thủ Design System.
