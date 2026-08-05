# UI Implementation Plan: Màn hình Tích hợp (Bot Integration)

Tài liệu này trình bày kế hoạch chi tiết để xây dựng UI màn hình **Tích hợp** theo đúng các chuẩn mực đã quy định trong `ui_ux_design_system.md` và luồng quy trình của Vocabik.

## 1. Phân rã Cấu trúc Layout (Layout Breakdown)

Dựa trên luồng người dùng, màn hình này xuất hiện khi ấn vào "Bot Integration" từ `PreferencesTabContent` hoặc `ProfileActionGrid`. Màn hình này **vẫn giữ nguyên App Header và Bottom Navigation Bar** của ứng dụng, do đó nó sẽ không tự bọc thêm `Scaffold` hay `AppBar` riêng mà sẽ hoạt động như một thành phần nội dung (Content View) được chèn vào hoặc điều hướng thông qua Nested Navigator.

Cấu trúc nội dung màn hình sẽ được phân rã như sau:

- **`IntegrationContentView`** (hoặc `IntegrationScreen` tùy cấu trúc navigation)
  - `SafeArea` (chỉ áp dụng nếu cần thiết cho phần dưới)
  - `SingleChildScrollView` (với `BouncingScrollPhysics`) để tránh rủi ro Overflow trên các màn hình nhỏ. Thêm padding-bottom tương đối dài (vd: 88px) để không bị che bởi Bottom Navigation Bar.
  - `Column` (crossAxisAlignment: start) chứa:
    - Tiêu đề màn hình: "Tích hợp" (Text).
    - Card 1: Cấu hình Telegram Bot.
    - Card 2: Cấu hình Zalo OA.

## 2. Bóc tách Component & Tái sử dụng (Componentization & Reusability)

### Các Widget tái sử dụng (Shared Widgets)
- **`PrimaryButton`** (`lib/shared/presentation/widgets/buttons/primary_button.dart`): Nút "Kết nối Telegram Bot".
- **`BounceWrapper`** (`lib/shared/presentation/widgets/interactions/bounce_wrapper.dart`): Bọc các thành phần có thể tương tác (dropdown chọn giờ/cấp độ).

### Các Widget độc lập cần tạo mới (Internal Componentization)
Để tránh hiện tượng "God Widget", màn hình này sẽ được tách các thành phần con thành các file độc lập trong thư mục `lib/features/profile/presentation/widgets/integration/`:
- **`IntegrationPlatformCard`**: Thẻ bọc ngoài cho từng nền tảng.
- **`IntegrationStatusIndicator`**: Hiển thị trạng thái. Khi "Đã kết nối", dấu chấm có màu xanh lá (`colors.success` hoặc tương đương).
- **`DropdownSelector`**: Nút chọn "Thời gian" và "Level". Tạm thời chỉ hiển thị UI tĩnh.

## 3. State Management (Quản lý trạng thái) & Tối ưu hóa

- **IntegrationCubit**: Tạo một `IntegrationCubit` (nằm trong `lib/features/profile/presentation/cubit/` hoặc `shared`) để quản lý State trạng thái kết nối tài khoản (VD: `isTelegramConnected`, `isZaloConnected`).
- **Tối ưu Rebuild**: UI Card sẽ được bọc bởi `BlocBuilder<IntegrationCubit, ...>` để chỉ vẽ lại Card tương ứng khi trạng thái kết nối thay đổi, không vẽ lại cả màn hình.
- **Trạng thái Nút bấm**: Khi State là "Đã kết nối", nút "Kết nối Telegram Bot" sẽ chuyển thành nút **"Hủy kết nối"**.
  - **Thiết kế Nút Hủy**: Sử dụng tông màu cảnh báo (màu đỏ nhạt cho nền, chữ đỏ) để phân biệt rõ ràng với PrimaryButton.

## 4. Xử lý Font chữ to (Accessibility & Text Scaling)

- **Các Dropdown (Thời gian & Level)**: Thay vì dùng `Row` tĩnh cứng ngắc, sẽ sử dụng `Wrap` (hoặc `LayoutBuilder` để linh hoạt chuyển sang `Column`) đảm bảo khi chữ quá to, khối "Level" sẽ tự động rớt xuống dòng dưới mà không gây lỗi RenderFlex Overflow.
- **Văn bản mô tả (Description)**: Cho phép text tự do rớt dòng (không giới hạn `maxLines`) để người dùng có thể đọc trọn vẹn văn bản dù font chữ có to đến đâu. Các component Card không fix cứng `height`.

## 5. Thiết kế UI đặc thù (Design Specifics)

Dựa trên file mockup `Vocabik Mobile.dc.html`, các thẻ icon sẽ được vẽ tĩnh như sau:
- **Telegram Icon**: Khối bo tròn `borderRadius: 12`, nền màu `#229ED9`, hiển thị một Icon máy bay giấy màu trắng bên trong.
- **Zalo Icon**: Khối bo tròn `borderRadius: 12`, nền màu `#0068FF`, chứa một Text chữ "Z" (font-weight: 900) màu trắng cỡ 18px.

## 6. Đánh giá Tuân thủ Design System (Design System Compliance Check)

- **Tương tác**: Mọi thao tác nhấn đều bọc `BounceWrapper`.
- **Màu sắc**: Dùng `colors.background`, `colors.surface`, `colors.borderSubtle`, `colors.textPrimary`, `colors.textSecondary`.
- **Typography**: `GoogleFonts.nunito`.
- **Khoảng cách**: `AppSpacing` & `AppRadius`.

## 7. Kế hoạch Đa ngôn ngữ (Localization/l10n Plan)

Cần bổ sung các chuỗi mới vào `app_vi.arb` và `app_en.arb`:

- `"integrationScreenTitle": "Tích hợp"`
- `"integrationTelegramTitle": "Telegram Bot"`
- `"integrationTelegramDesc": "Nhận bài tập mỗi sáng qua Telegram"`
- `"integrationZaloTitle": "Zalo OA"`
- `"integrationZaloDesc": "Cấu trúc tương tự Telegram"`
- `"statusNotConnected": "Chưa kết nối"`
- `"statusConnected": "Đã kết nối"`
- `"instructionConnectLabel": "1. Nhấn \"Kết nối\" bên dưới"`
- `"instructionStartLabel": "2. Nhấn Start trong Telegram"`
- `"instructionAutoConnectLabel": "3. Bot tự kết nối tài khoản"`
- `"timeToReceiveLabel": "Thời gian nhận bài"`
- `"levelLabel": "Level"`
- `"connectTelegramBtn": "Kết nối Telegram Bot →"`
- `"disconnectTelegramBtn": "Hủy kết nối"`
