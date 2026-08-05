# 📊 Báo cáo Code Review UI: Subscription Tab

**File:** `lib/features/profile/presentation/widgets/subscription_tab_content.dart`
**Trọng tâm:** Tính nhất quán với Design System, Bố cục (Layout), Hiệu năng Render, và Trải nghiệm Tương tác (UX).

Dưới đây là chi tiết các vấn đề được phát hiện trong quá trình rà soát mã nguồn màn hình Subcription, kết hợp cùng các đánh giá bổ sung từ bạn.

---

## 🔴 1. Lỗi Layout/UX (Blocker - Cần sửa ngay)

### 1.1. Hard-code các giá trị về Padding, Border Radius và TextStyles
Code hiện tại đang sử dụng rất nhiều con số tĩnh thay vì tận dụng hằng số từ Design System (`AppSpacing`, `AppRadius`, `textTheme`).
- **Lý do lỗi:** Việc này phá vỡ tính đồng nhất của hệ thống giao diện, khiến ứng dụng khó bảo trì và không thích ứng tốt nếu sau này đổi Design System.
- **Dòng code có vấn đề:**
  ```dart
  padding: const EdgeInsets.all(20.0), // Hard-code khoảng cách
  borderRadius: BorderRadius.circular(20.0), // Hard-code bo góc thẻ
  borderRadius: BorderRadius.circular(12.0), // Hard-code bo góc icon
  
  // Hard-code text style thay vì dùng Theme.of(context).textTheme
  style: GoogleFonts.nunito(
    color: colors.textPrimary,
    fontSize: 24.0,
    fontWeight: FontWeight.w900,
  ),
  ```
- **Đề xuất sửa lỗi:** Thay thế bằng các hằng số quy chuẩn như `AppRadius.lg`, `AppSpacing.md`, sử dụng `Theme.of(context).textTheme.titleLarge?.copyWith(...)`.

### 1.2. Sai Icon Free Plan so với bản thiết kế
- **Lý do lỗi:** Đang sử dụng icon không chính xác (Sparkles) thay vì icon đã được chốt trong thiết kế.
- **Dòng code có vấn đề:**
  ```dart
  child: const Icon(
    LucideIcons.sparkles,
    color: Colors.white,
    size: 22.0,
  ),
  ```
- **Đề xuất sửa lỗi:** Đổi lại icon cho đúng với file thiết kế.

### 1.3. Nút "Nâng lên Premium" thiếu mũi tên và bị lệch dọc
- **Lý do lỗi:** Theo như đánh giá, mũi tên bên trong button Upgrade đang hiển thị không đúng so với thiết kế (nằm lệch xuống dưới thay vì ở giữa theo chiều dọc). Ngoài ra, trong code hiện tại, widget text đang đứng độc lập và hoàn toàn thiếu icon mũi tên này.
- **Dòng code có vấn đề:**
  ```dart
  child: Text(
    l10n.subscriptionUpgradeBtn,
    style: GoogleFonts.nunito(...)
  ) // Chưa có icon mũi tên bên cạnh
  ```
- **Đề xuất sửa lỗi:** Dùng `Row` kết hợp với `CrossAxisAlignment.center` để bọc cả chữ và icon mũi tên, giúp nội dung được căn giữa tuyệt đối theo chiều dọc.

---

## 🟡 2. Cảnh báo (Warning)

### 2.1. Hard-code màu sắc thay vì gọi biến từ Theme
- **Lý do cảnh báo:** Một số màu sắc đang được gán cứng mã Hex, dù đó chính là màu Primary của dự án hoặc màu có thể được hệ thống hóa.
- **Dòng code có vấn đề:**
  ```dart
  color: const Color(0xFF06B6D4), // Background của Icon badge
  color: const Color(0xFFA854F7), // Background của nút Premium
  ```
- **Đề xuất sửa lỗi:** Dùng `colors.primary` cho Cyan, và xem xét bổ sung màu Premium `#A854F7` vào `AppColorsExtension` thay vì fix cứng.

### 2.2. Sử dụng SizedBox với giá trị cứng tĩnh
- **Lý do cảnh báo:** Các khoảng cách giữa các phần tử đang dùng giá trị số thực `(12.0, 14.0, 20.0)` thay vì hằng số từ `AppSpacing`.
- **Dòng code có vấn đề:**
  ```dart
  const SizedBox(width: 12.0),
  const SizedBox(height: 14.0),
  const SizedBox(height: 20.0),
  ```
- **Đề xuất sửa lỗi:** Sử dụng `SizedBox(width: AppSpacing.md)`, `SizedBox(height: AppSpacing.lg)`.

---

## 🟢 3. Đề xuất (Suggestion - Nên làm để code sạch hơn)

### 3.1. Tách nhỏ Widget (Extract Widgets)
- **Lý do đề xuất:** File `subscription_tab_content.dart` đang giữ toàn bộ UI của "Free Plan Card". Nếu sau này thêm các gói Premium, hàm `build()` sẽ biến thành God Widget.
- **Đề xuất:** Tách thành các widget con độc lập như: `CurrentPlanCard()`, `PremiumUpgradeButton()`...

### 3.2. Cải thiện Khả năng tương thích Font chữ
- Thay vì bọc tĩnh từng widget với `GoogleFonts.nunito(...)`, hãy lấy base Text Theme từ hệ thống, nhằm kế thừa khả năng scale Text Settings (tăng giảm cỡ chữ) của hệ điều hành mà không làm vỡ layout.

---
**📌 Tổng kết:** Các vấn đề bạn chỉ ra đều rất chính xác. Cần ưu tiên làm sạch (refactor) lại các giá trị tĩnh (Hard-code) về đúng Design System, đồng thời fix lại phần icon & mũi tên trong button sớm để đảm bảo thiết kế được áp dụng đúng chuẩn.
