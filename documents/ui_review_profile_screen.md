# UI Code Review: Màn hình Profile

Dưới đây là báo cáo **UI Code Review** cho màn hình Profile (gồm `profile_screen.dart`, `profile_action_grid.dart`, `profile_tab_bar.dart` và `user_profile_section.dart`) dựa trên các tiêu chí của Vocabik Design System:

## 🔴 Lỗi Layout/UX (Blocker - Bắt buộc sửa)

### 1. Vi phạm Design System (Sử dụng sai Font chữ và Hardcode màu sắc)
*   **Vấn đề:** Rất nhiều widget đang sử dụng `GoogleFonts.inter` thay vì font `Nunito` theo quy định của dự án. Bên cạnh đó, có một số chỗ đang hardcode màu tĩnh (như `Colors.red`, `Colors.white`, `AppColors.accent`) thay vì đọc từ `Theme.of(context)` khiến Dark Mode có thể hiển thị sai hoặc không đồng nhất.
*   **Vị trí:**
    *   `ProfileActionGrid`: Dòng 99, 123 (dùng Inter), dòng 117 (`Colors.red`), dòng 124 (`Colors.white`).
    *   `ProfileTabBar`: Dòng 52 (dùng Inter), dòng 43/46 (`AppColors.accent`), dòng 54 (`Colors.white`).
    *   `UserProfileSection`: Dòng 92, 107, 126, 148, 152, 159, 163, 170 (dùng Inter).
*   **Cách khắc phục:** Đổi toàn bộ về `GoogleFonts.nunito` (hoặc tốt nhất là dùng `Theme.of(context).textTheme`). Thay màu tĩnh bằng màu từ `colorScheme` hoặc `AppColorsExtension`.

```dart
// Code hiện tại (profile_action_grid.dart - dòng 97-104)
Text(
  data.title,
  style: GoogleFonts.inter( // ❌ LỖI: Dùng sai font
    color: colors.textPrimary,
    fontWeight: FontWeight.w700,
    fontSize: 14.0,
  ),
)

// Code đề xuất
Text(
  data.title,
  style: GoogleFonts.nunito( // ✅ ĐÚNG chuẩn Design System
    color: colors.textPrimary,
    fontWeight: FontWeight.w700,
    fontSize: 14.0,
  ),
)
```

```dart
// Code hiện tại (profile_action_grid.dart - dòng 115-120)
decoration: const BoxDecoration(
  color: Colors.red, // ❌ LỖI: Hardcode màu sắc
  shape: BoxShape.circle,
),

// Code đề xuất
decoration: BoxDecoration(
  color: Theme.of(context).colorScheme.error, // ✅ Dùng semantic color từ Theme
  shape: BoxShape.circle,
),
```

### 2. Vùng chạm (Touch Targets) quá nhỏ
*   **Vấn đề:** Nút "Change photo" và các Tab item có padding chiều dọc (`vertical: 10.0`). Kết hợp với kích thước text, tổng chiều cao chỉ khoảng 34-35px. Điều này vi phạm tiêu chuẩn UX di động (tối thiểu 48x48 logical pixels).
*   **Vị trí:** `ProfileTabBar` (dòng 41), `UserProfileSection` (dòng 84).
*   **Cách khắc phục:** Tăng padding vertical hoặc set `minHeight`.

```dart
// Code đề xuất cho UserProfileSection
Container(
  constraints: const BoxConstraints(minHeight: 48.0), // ✅ Đảm bảo touch target >= 48px
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  alignment: Alignment.center,
  decoration: BoxDecoration(/* ... */),
  child: Text('Change photo', /* ... */),
)
```

---

## 🟡 Cảnh báo (Warning)

### 1. Rủi ro Overflow Text khi Text Scaling
*   **Vấn đề:** `ProfileActionGrid` (dòng 50) fix cứng `height: 56.0` cho mỗi ô Grid. Nếu người dùng chỉnh font chữ hệ thống to lên (Text Scaling), nội dung bên trong có nguy cơ bị tràn (Overflow) ra khỏi container.
*   **Cách khắc phục:** Thay vì fix cứng `height`, nên để container tự nở theo chiều dọc hoặc dùng `minHeight`.

```dart
// Code hiện tại (profile_action_grid.dart - dòng 48-51)
SizedBox(
  width: itemWidth,
  height: 56.0, // ⚠️ Nguy cơ overflow
  child: _ActionGridItem(data: item),
);

// Code đề xuất
Container(
  width: itemWidth,
  constraints: const BoxConstraints(minHeight: 56.0), // ✅ An toàn với Text Scaling
  child: _ActionGridItem(data: item),
);
```

### 2. Khởi tạo Object trong hàm `build()`
*   **Vấn đề:** Các danh sách cấu hình như `items` trong `ProfileActionGrid` (dòng 27) và `tabs` trong `ProfileTabBar` (dòng 20) đang được khai báo lại mỗi lần hàm `build()` chạy.
*   **Cách khắc phục:** Đưa các biến hằng/cấu hình tĩnh này ra ngoài hàm `build()` hoặc khai báo làm thuộc tính `final` của Widget.

---

## 🟢 Đề xuất (Suggestion)

### 1. Tối ưu code Layout của Action Grid
Thay vì dùng `LayoutBuilder` và tính toán Width toán học bằng tay kèm `Wrap` (điều này khá cồng kềnh), bạn có thể dùng `GridView.builder` với `shrinkWrap: true` và `physics: NeverScrollableScrollPhysics()` hoặc dùng `SliverGrid` ở widget cha để code gọn gàng và tối ưu hiệu năng tính toán layout hơn.

### 2. Chuyển đổi trạng thái Animation mượt mà hơn
Trong `ProfileTabBar`, widget `AnimatedContainer` đang được dùng để animiate border/background, nhưng màu chữ của thẻ `Text` sẽ bị đổi đột ngột. Bạn nên bọc widget `Text` bằng `AnimatedDefaultTextStyle` để hiệu ứng chuyển màu chữ khi tab từ trạng thái "Inactive" sang "Active" diễn ra mượt mà và đồng bộ với background.
