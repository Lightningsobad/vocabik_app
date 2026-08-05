# Báo Cáo Đánh Giá Mã Nguồn (Code Review Report) - Tính Năng Chuyển Đổi Ngôn Ngữ

**Người đánh giá:** Chuyên gia Kỹ sư Phần mềm & Tech Lead
**Mục tiêu:** Rà soát tính năng Chuyển đổi ngôn ngữ (Language Switching) dựa trên tiêu chuẩn "Feature-first Clean Architecture", BLoC/Cubit, UI/UX Design System và tối ưu hiệu năng.

---

## 🔴 Cấp bách (Blocker)

### 1. Tính năng chưa được tích hợp toàn hệ thống (Incomplete Integration)
**Vấn đề:**
Tính năng chuyển đổi ngôn ngữ chưa được áp dụng đồng bộ cho toàn bộ hệ thống. Hiện tại, chỉ có thanh điều hướng (bottom navigation) phản hồi với việc thay đổi ngôn ngữ. Các màn hình khác trong ứng dụng, điển hình như màn hình Profile, nội dung văn bản (text) bên trong vẫn giữ nguyên và không cập nhật theo ngôn ngữ mới được chọn. Đây là một lỗ hổng lớn vì tính năng Localization chưa mang lại giá trị thực tế cho người dùng trên toàn app.

**Đề xuất sửa đổi:**
Cần rà soát lại toàn bộ các UI Widget và Screen trong ứng dụng (như `ProfileScreen`, `HomeScreen`...). Đảm bảo rằng tất cả các chuỗi văn bản (hardcoded string) được thay thế bằng các key từ file ngôn ngữ (ví dụ: `AppLocalizations.of(context)!.profileTitle`) và các màn hình này cần lắng nghe sự thay đổi state của `LocalizationCubit` (nếu ngôn ngữ thay đổi thì cây Widget cần được rebuild).

### 2. Quản lý trạng thái và Xử lý lỗi (State Management & Error Handling)
**Vấn đề:** 
`LocalizationCubit` hiện tại không có cơ chế bắt lỗi (try-catch) khi gọi các UseCase (vốn có thể throw Exception từ `SharedPreferences`). Hơn nữa, `LocalizationState` chỉ chứa `currentLocale` mà không có các trạng thái cơ bản (Loading, Success, Failure), khiến UI không thể phản hồi khi có lỗi hoặc đang xử lý.

**Đoạn code hiện tại (`lib/shared/localization/cubit/localization_cubit.dart`):**
```dart
  Future<void> changeLanguage(String languageCode) async {
    await _saveLanguageUseCase.call(languageCode);
    emit(LocalizationState(Locale(languageCode)));
  }
```

**Đề xuất sửa đổi:**
Thêm trạng thái vào `LocalizationState` và sử dụng `try-catch` trong Cubit.
```dart
// localization_state.dart
enum LocalizationStatus { initial, loading, success, failure }

class LocalizationState extends Equatable {
  final Locale currentLocale;
  final LocalizationStatus status;
  final String? errorMessage;

  const LocalizationState({
    required this.currentLocale,
    this.status = LocalizationStatus.initial,
    this.errorMessage,
  });

  LocalizationState copyWith({
    Locale? currentLocale,
    LocalizationStatus? status,
    String? errorMessage,
  }) {
    return LocalizationState(
      currentLocale: currentLocale ?? this.currentLocale,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [currentLocale, status, errorMessage];
}

// localization_cubit.dart
  Future<void> changeLanguage(String languageCode) async {
    try {
      emit(state.copyWith(status: LocalizationStatus.loading));
      await _saveLanguageUseCase.call(languageCode);
      emit(state.copyWith(
        currentLocale: Locale(languageCode),
        status: LocalizationStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LocalizationStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
```

---

## 🟡 Cảnh báo (Warning)

### 1. Hiệu năng & Tối ưu hóa (Performance) - Rebuild UI không cần thiết
**Vấn đề:** 
Trong `AppHeader`, việc sử dụng `context.watch<LocalizationCubit>()` ở cấp cao nhất của hàm `build` sẽ làm toàn bộ widget `AppHeader` (bao gồm cả Logo, StatBadge) bị render lại mỗi khi ngôn ngữ thay đổi. 

**Đoạn code hiện tại (`lib/shared/presentation/widgets/header/app_header.dart`):**
```dart
    final currentLang = context.watch<LocalizationCubit>().state.currentLocale.languageCode;
```

**Đề xuất sửa đổi:**
Sử dụng `context.select` hoặc bọc riêng nút bấm ngôn ngữ bằng `BlocBuilder` / `BlocSelector` để chỉ rebuild đúng phần UI cần thiết.
```dart
    // Thay vì watch toàn bộ state, chỉ select languageCode
    final currentLang = context.select(
      (LocalizationCubit cubit) => cubit.state.currentLocale.languageCode,
    );
```

### 2. Hiệu năng & Tối ưu hóa - Khởi tạo Object trong hàm `build`
**Vấn đề:** 
`NumberFormat.decimalPattern()` được khởi tạo bên trong hàm `build()`. Điều này tạo ra một instance mới mỗi lần `AppHeader` rebuild, gây lãng phí bộ nhớ không cần thiết.

**Đoạn code hiện tại:**
```dart
  @override
  Widget build(BuildContext context) {
    // Sử dụng NumberFormat để định dạng số, ví dụ 1,240
    final format = NumberFormat.decimalPattern();
```

**Đề xuất sửa đổi:**
Di chuyển `format` ra ngoài class (như một hằng số toàn cục) hoặc biến static, hoặc cache lại.
```dart
  static final _numberFormat = NumberFormat.decimalPattern();

  @override
  Widget build(BuildContext context) {
    // Sử dụng _numberFormat.format(xp) ở dưới
```

### 3. UI/UX & Design System - Thiếu `BounceWrapper`
**Vấn đề:** 
Theo chuẩn thiết kế của Vocabik, các tương tác nút bấm nên sử dụng `BounceWrapper` để có hiệu ứng nhấn. Tuy nhiên, Logo ứng dụng đang sử dụng `GestureDetector` thuần túy.

**Đoạn code hiện tại:**
```dart
                GestureDetector(
                  onTap: onHomeTap,
                  behavior: HitTestBehavior.opaque,
                  child: const Row(
```

**Đề xuất sửa đổi:**
Thay thế `GestureDetector` bằng `BounceWrapper`.
```dart
                BounceWrapper(
                  onTap: onHomeTap,
                  child: const Row(
```

---

## 🟢 Gợi ý (Suggestion)

### 1. Code Quality & Clean Code - Dọn dẹp Code thừa
**Vấn đề:** 
Trong `AppHeader`, các parameters `currentLanguageCode` và `onLanguageTap` đã được comment là Deprecated do logic đã được đưa vào Cubit, nhưng vẫn còn tồn tại trong hàm tạo (constructor). Điều này làm rối cấu trúc API của Widget.

**Đoạn code hiện tại:**
```dart
  final String? currentLanguageCode; // Deprecated, will read from Cubit
  final VoidCallback? onLanguageTap; // Deprecated, handled internally
```

**Đề xuất sửa đổi:**
Nên xóa bỏ hoàn toàn các parameter này khỏi constructor của `AppHeader` vì widget đã tự quản lý state qua `context.read/watch`.


