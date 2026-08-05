# UI Code Review Report: Security Tab
**Người review:** Lập trình viên AI (Technical UI/UX Expert)
**Mục tiêu:** Màn hình / Tab Bảo mật (Security Tab) - Vocabik App

Dưới đây là báo cáo đánh giá chi tiết UI Code Review cho các file liên quan đến Security Tab.

---

### 🔴 Lỗi Layout/UX (Blocker)

**1. Hardcode màu sắc vi phạm Design System**
*   **File:** `lib/features/profile/presentation/widgets/security_tab_content.dart`
*   **Vấn đề:** Các widget đang bị gán cứng (hardcode) mã màu HEX (Cyan và Trắng) cho nút "Cập nhật". Điều này phá vỡ khả năng đổi theme (Light/Dark mode) và không tuân thủ Design System.
*   **Code cũ:**
    ```dart
    decoration: BoxDecoration(
      color: const Color(0xFF06B6D4), // Cyan
      borderRadius: BorderRadius.circular(AppRadius.lg),
    ),
    // ...
    color: const Color(0xFFFFFFFF), // White
    ```
*   **Code sửa lỗi:** Cần sử dụng các thuộc tính màu từ `AppColorsExtension` (ví dụ `colors.primary` hoặc `Theme.of(context).primaryColor`).
    ```dart
    decoration: BoxDecoration(
      color: colors.primary, // Hoặc tương đương trong AppColorsExtension
      borderRadius: BorderRadius.circular(AppRadius.lg),
    ),
    // ...
    color: colors.surfaceCard, // Hoặc màu chữ dùng riêng trên nền primary
    ```

**2. Hardcode màu sắc trong Input Widget**
*   **File:** `lib/shared/presentation/widgets/inputs/password_input_widget.dart`
*   **Vấn đề:** Hardcode màu Cyan cho con trỏ (cursor) và viền khi focus.
*   **Code cũ:**
    ```dart
    cursorColor: const Color(0xFF06B6D4),
    // ...
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: const BorderSide(color: Color(0xFF06B6D4), width: 2.0),
    ),
    ```
*   **Code sửa lỗi:** Sửa lại dùng màu từ theme:
    ```dart
    cursorColor: colors.primary, // Hoặc một màu brand/accent từ theme
    // ...
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(color: colors.primary, width: 2.0),
    ),
    ```

---

### 🟡 Cảnh báo (Warning)

**1. Dùng sai Token hệ thống và Hardcode Spacing**
*   **File:** `lib/features/profile/presentation/widgets/security_tab_content.dart`
*   **Vấn đề:** Dùng giá trị `AppRadius.xl` (bo góc) làm giá trị cho chiều cao (Spacing) của `SizedBox`. Đây là việc dùng sai mục đích của Design Token.
*   **Code cũ:**
    ```dart
    const SizedBox(height: AppRadius.xl), // or just use a fixed double like 24.0...
    ```
*   **Code sửa lỗi:** Nên thêm hằng số `xl` (hoặc xxl) vào `AppSpacing` thay vì lấy nhầm class `AppRadius`.
    ```dart
    const SizedBox(height: AppSpacing.xl), // Nếu đã định nghĩa AppSpacing.xl
    ```
*   **File:** `lib/features/profile/presentation/widgets/active_sessions_card.dart`
*   **Vấn đề:** Đang fix cứng `const SizedBox(height: 16.0);`. Nên đổi thành `const SizedBox(height: AppSpacing.lg);`.
*   **File:** `lib/features/profile/presentation/widgets/session_item_widget.dart`
*   **Vấn đề:** Đang fix cứng `const SizedBox(height: 4.0);`. Nên đổi thành `const SizedBox(height: AppSpacing.xs);` (nếu có).

**2. Rủi ro tràn màn hình (Overflow) khi mở bàn phím**
*   **File:** `lib/features/profile/presentation/widgets/security_tab_content.dart`
*   **Vấn đề:** Nội dung form có các trường nhập liệu (PasswordInputWidget), nếu màn hình hiện tại chưa được bọc bởi một widget hỗ trợ cuộn (`SingleChildScrollView` hoặc list view), khi người dùng focus vào ô nhập liệu và bàn phím (keyboard) bật lên, nó sẽ gây ra lỗi *Bottom Overflowed by X pixels*.
*   **Khắc phục:** Hãy đảm bảo parent widget (ví dụ: `profile_screen.dart` hoặc chính tab này) chứa `SingleChildScrollView`.

---

### 🟢 Đề xuất (Suggestion)

**1. Tối ưu cấu trúc Widget (Tránh Code Lặp / God Widget)**
*   Nút bấm "Update" trong file `security_tab_content.dart` được viết trực tiếp (inline). Do đây là một nút chức năng chính (Primary Button), UI/UX sẽ rất dễ mất đồng bộ nếu sau này muốn thêm hiệu ứng Loading (hiển thị CircularProgressIndicator bên trong) hoặc disable nút.
*   **Khắc phục:** Nên tách thành một shared widget tên là `PrimaryButton`.
    ```dart
    // Thay vì code cả cụm BounceWrapper > Container > Text, chỉ cần gọi:
    PrimaryButton(
      text: l10n.securityTab_updateButton,
      onPressed: () { /* TODO */ },
    )
    ```

**2. Tận dụng TextTheme thay vì định nghĩa lại GoogleFonts nhiều lần**
*   Ở các file như `session_item_widget.dart` hay `security_tab_content.dart`, `GoogleFonts.nunito(...)` đang được gọi lặp lại. Thay vào đó, hãy config `TextTheme` một lần ở cấu hình Theme của app, sau đó tái sử dụng:
    ```dart
    // Thay thế:
    style: GoogleFonts.nunito(color: colors.textPrimary, fontSize: 16.0, fontWeight: FontWeight.bold)
    
    // Bằng:
    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: colors.textPrimary)
    ```
    Điều này sẽ giúp đồng bộ kích thước chữ theo hệ thống thay đổi font của điện thoại (Accessibility - Text Scaling).
