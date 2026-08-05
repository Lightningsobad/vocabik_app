# Báo cáo UI Code Review: Màn hình Preferences Tab (Tùy chỉnh)

Dựa trên các tiêu chuẩn của **Vocabik Design System**, dưới đây là báo cáo đánh giá chi tiết mã nguồn giao diện của màn hình Preferences Tab (`preferences_tab_content.dart` và các widget phụ trợ).

---

## 🔴 Lỗi Layout/UX (Blocker - Cần sửa ngay)

### 1. Hardcode giá trị kích thước, khoảng cách và bo góc
Mã nguồn đang vi phạm quy định của Design System về việc không được hardcode các con số (Khoảng cách, tỷ lệ). Các giá trị `16.0`, `12.0`, `24.0` đang được dùng trực tiếp thay vì thông qua các file quy chuẩn như `app_spacing.dart` hoặc class hằng số.

**Vị trí:** `SettingSectionCard`, `SettingToggleButton`, `SettingListTile`, `preferences_tab_content.dart`
```dart
// Code hiện tại:
padding: const EdgeInsets.symmetric(horizontal: 16.0),
borderRadius: BorderRadius.circular(24.0),

// Đề xuất sửa:
padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
borderRadius: BorderRadius.circular(AppRadius.xl), // Thay bằng hằng số trong theme
```

### 2. Hardcode màu sắc ngoài hệ thống Theme
Mặc dù đã sử dụng `AppColorsExtension`, nhưng vẫn còn sót lại việc sử dụng trực tiếp các màu tĩnh, không hỗ trợ tốt cho Dark Mode và vi phạm Design System.

**Vị trí 1:** BoxShadow trong `SettingSectionCard` & `SettingListTile`
```dart
// Code hiện tại:
color: Colors.black.withOpacity(0.03),

// Đề xuất sửa:
color: colors.shadow.withOpacity(0.03), // Hoặc sử dụng Theme.of(context).shadowColor
```

**Vị trí 2:** Icon trong `PreferencesTabContent`
```dart
// Code hiện tại:
trailing: const Icon(Icons.chevron_right, color: Colors.grey),

// Đề xuất sửa:
trailing: Icon(Icons.chevron_right, color: Theme.of(context).extension<AppColorsExtension>()!.textSecondary),
```

### 3. Rủi ro tràn màn hình (Overflow) trên các thiết bị nhỏ hoặc khi tăng Text Scaling
Trong `_PreferencesTabContentView`, `Column` được sử dụng để chứa các cài đặt nhưng không được bọc trong `SingleChildScrollView` hoặc dùng `ListView`. Nếu thêm nhiều cài đặt hoặc người dùng phóng to font chữ hệ thống, chắc chắn sẽ bị lỗi Bottom Overflow.

**Vị trí:** `_PreferencesTabContentView` trong `preferences_tab_content.dart`
```dart
// Code hiện tại:
return Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  child: Column(
    children: [ ... ],
  ),
);

// Đề xuất sửa:
return ListView(
  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
  children: [ ... ],
);
```

---

## 🟡 Cảnh báo (Warning)

### 1. Không tận dụng TextTheme của hệ thống
Các widget đang tự khai báo `GoogleFonts.nunito(...)` ở nhiều nơi. Theo Design System, *font Nunito nên được áp dụng cho toàn bộ hệ thống* thông qua `ThemeData`. Việc khai báo rải rác làm code dài và khó quản lý sự đồng nhất.

**Vị trí:** `SettingSectionCard`, `SettingToggleButton`, `SettingListTile`
```dart
// Code hiện tại:
Text(
  title,
  style: GoogleFonts.nunito(
    color: colors.textPrimary,
    fontWeight: FontWeight.w700,
    fontSize: 16.0,
  ),
)

// Đề xuất sửa:
Text(
  title,
  style: Theme.of(context).textTheme.titleMedium?.copyWith(
    color: colors.textPrimary,
    fontWeight: FontWeight.w700,
  ),
)
```

### 2. Kích thước vùng chạm (Touch target) chưa đạt chuẩn 48x48
Trong `SettingToggleButton`, thuộc tính `padding` là `symmetric(vertical: 12.0)`. Kết hợp với kích thước font 14, tổng chiều cao chỉ khoảng 38-40px, nhỏ hơn tiêu chuẩn 48x48 của nền tảng di động.

**Đề xuất sửa:**
Thiết lập `minHeight` cho container hoặc tăng padding dọc.
```dart
// Đề xuất sửa cho Box/Container trong SettingToggleButton:
constraints: const BoxConstraints(minHeight: 48.0),
```

---


**Kết luận:**
Màn hình đã đáp ứng cơ bản việc chia Widget tái sử dụng và tích hợp Theme/L10n. Tuy nhiên, cần khắc phục ngay lỗi Layout (dùng ListView thay cho Column) và loại bỏ hoàn toàn các Hardcode value (Kích thước, Màu sắc) để đảm bảo ứng dụng đồng bộ 100% với Vocabik Design System.
