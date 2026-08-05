# Kế hoạch Triển khai UI - Tab Security (Profile Screen)

Dựa trên yêu cầu từ `documents/ui_ux_design_system.md`, bản thiết kế giao diện (Vocabik Mobile.dc.html) và cấu trúc hiện tại của màn hình Profile (`profile_screen.dart`), dưới đây là kế hoạch chi tiết để xây dựng UI cho **Tab Security**.

## 1. Phân rã Cấu trúc Layout (Layout Breakdown)

**Vị trí:** Widget `SecurityTabContent` sẽ được hiển thị khi người dùng chọn tab thứ 4 (index = 3) trong `SharedSegmentedTabBar` tại `ProfileScreen`.

**Cấu trúc Tree dự kiến:**
```text
SecurityTabContent (Chỉ chứa Column, không cần SingleChildScrollView vì cha là ProfileScreen đã bọc ScrollView rồi)
└── Padding (horizontal: AppSpacing.lg)
    └── Column (crossAxisAlignment: start)
        ├── Text: "Current password" (Label)
        ├── SizedBox (height: AppSpacing.sm)
        ├── PasswordInputWidget (Mật khẩu hiện tại)
        ├── SizedBox (height: AppSpacing.lg)
        ├── Text: "New password" (Label)
        ├── SizedBox (height: AppSpacing.sm)
        ├── PasswordInputWidget (Mật khẩu mới)
        ├── SizedBox (height: AppSpacing.lg2)
        ├── PrimaryButtonWidget (Nút "Update" trải dài toàn màn hình, màu Cyan)
        ├── SizedBox (height: AppSpacing.xl / 24.0)
        └── ActiveSessionsCard (Thẻ chứa danh sách các phiên đăng nhập)
            └── Container (Bo góc AppRadius.lg, màu nền Surface, border nhẹ)
                └── Padding (all: AppSpacing.lg)
                    └── Column
                        ├── Text: "Active sessions" (Title)
                        ├── SizedBox (height: AppSpacing.md)
                        ├── SessionItemWidget (Session 1: Chrome)
                        └── SessionItemWidget (Session 2: Safari)
```

**Đánh giá rủi ro Overflow:**
Vì toàn bộ `ProfileScreen` đã được bọc bởi `SingleChildScrollView` (như đã thấy trong file `profile_screen.dart` dòng 30), nội dung của tab Security có thể mở rộng thoải mái xuống dưới mà không bị lỗi Overflow trên các thiết bị màn hình nhỏ. Khi người dùng thay đổi font-size hệ thống, các `Text` có thể phình to, nhưng do layout sử dụng `Column` và `SizedBox` thay vì fix cứng `height`, UI sẽ tự động co giãn theo chiều dọc một cách an toàn.

## 2. Bóc tách Component & Tái sử dụng (Componentization & Reusability)

Để tránh hiện tượng "God Widget" (file quá dài), chúng ta sẽ tách thành các Widget con nằm cùng thư mục `lib/features/profile/presentation/widgets/`:

*   **`SecurityTabContent`**: Widget gốc, dùng để điều phối UI.
*   **`PasswordInputWidget`**: (Nên xem xét đặt trong `lib/shared/presentation/widgets/inputs/` nếu có thể dùng chung cho màn hình Đăng nhập/Đăng ký sau này).
    *   **Nhiệm vụ**: Chứa `TextFormField`, có nút (Text button) "Show"/"Hide" ở đuôi (suffix), tự động chuyển đổi thuộc tính `obscureText`.
*   **`ActiveSessionsCard`**: Widget hiển thị khối danh sách các phiên đăng nhập.
*   **`SessionItemWidget`**: Một dòng hiển thị thông tin về 1 phiên (Icon thiết bị/trình duyệt, Tên thiết bị, Hệ điều hành, Thời gian).

*Có tái sử dụng Widget từ shared không?*
*   Sử dụng **`BounceWrapper`** từ `lib/shared/presentation/widgets/interactions/bounce_wrapper.dart` cho nút "Update" và nút "Show/Hide" để tạo hiệu ứng nảy chuẩn hệ thống.

## 3. Đánh giá Tuân thủ Design System (Design System Compliance Check)

*   **Typography:** Sử dụng `GoogleFonts.nunito` hoặc lấy từ `Theme.of(context).textTheme`. Text label dùng chữ thường hoặc Medium, Text trong button dùng Bold/Black.
*   **Tương tác (Interaction):**
    *   Nút **Update** và nút Text **Show/Hide** sẽ được bọc bởi `BounceWrapper`.
*   **Màu sắc & Theme (KHÔNG HARDCODE):**
    *   Dùng `Theme.of(context).extension<AppColorsExtension>()!` để lấy màu hệ thống.
    *   Nền `ActiveSessionsCard`: dùng `colors.surface`.
    *   Nút "Update" và trạng thái Focus của ô nhập mật khẩu: Dùng màu Cyan cố định `0xFF06B6D4` (như trong Document quy định).
    *   Màu viền (Border) ô input ở trạng thái bình thường: `colors.border`.
    *   Màu chữ chung: `colors.textPrimary` cho tiêu đề/label, `colors.textSecondary` cho thời gian/mô tả nhỏ.
    *   **Màu chữ trong Primary Button:** Bắt buộc sử dụng màu trắng tĩnh (`0xFFFFFFFF`). Do nền của nút Update luôn là màu Cyan cố định ở cả 2 theme, màu chữ bên trong cũng phải được set tĩnh (trắng) cùng với độ đậm (Bold/Black) để luôn đảm bảo tính tương phản và hiển thị đúng bất chấp việc chuyển đổi theme.
*   **Khoảng cách & Kích thước (Spacing & Sizing):**
    *   Sử dụng `AppSpacing.sm`, `AppSpacing.md`, `AppSpacing.lg` cho padding và margin.
    *   Bo góc input và button sử dụng `AppRadius.md` hoặc `AppRadius.lg`.

## 4. Kế hoạch Đa ngôn ngữ (Localization/l10n Plan)

Tất cả các text sẽ được định nghĩa key trong `app_en.arb` và `app_vi.arb`. Tuyệt đối không hardcode.

**Các key dự kiến thêm vào l10n:**
*   `"securityTab_currentPasswordLabel"`: "Current password" (EN) / "Mật khẩu hiện tại" (VI)
*   `"securityTab_newPasswordLabel"`: "New password" (EN) / "Mật khẩu mới" (VI)
*   `"securityTab_updateButton"`: "Update" (EN) / "Cập nhật" (VI)
*   `"securityTab_activeSessionsTitle"`: "Active sessions" (EN) / "Phiên hoạt động" (VI)
*   `"action_show"`: "Show" (EN) / "Hiện" (VI)
*   `"action_hide"`: "Hide" (EN) / "Ẩn" (VI)

*(Lưu ý: "Now" hay "2h ago" thường sẽ do thư viện format thời gian như `timeago` xử lý kèm locale, nhưng nếu cần tĩnh tạm thời có thể thêm key).*

## 5. Quyết định Triển khai (Đã xác nhận)

Dựa trên phản hồi, chúng tôi sẽ code UI theo các quyết định sau:

1.  **Chức năng "New password"**: Tuân thủ thiết kế, chỉ dùng 1 ô nhập mật khẩu mới (không cần ô xác nhận).
2.  **Dữ liệu Active Sessions**: Khởi tạo bằng dữ liệu giả (mock data) đầy đủ (Icon, Text, Time) để bạn có thể dễ dàng kiểm tra tính chính xác của UI.
3.  **Xử lý trạng thái nút Update**: Sẽ không làm UI loading vào lúc này, phần này sẽ được cập nhật ở bước tích hợp Logic sau.
4.  **Kiểm tra tính hợp lệ (Validation)**: Chuẩn bị sẵn bộ khung Validation (thuộc tính `validator` và `errorText`) với dòng chữ mẫu "Mật khẩu phải dài hơn 8 ký tự" màu đỏ dưới ô nhập liệu để sẵn sàng cho các yêu cầu nghiệp vụ tương lai.
