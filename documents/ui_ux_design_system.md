# Vocabik UI/UX Design System

Tài liệu này định nghĩa các quy tắc chuẩn mực về UI/UX cho toàn bộ hệ thống ứng dụng Vocabik.

## 1. Typography (Kiểu chữ)

- **Font chữ áp dụng mọi thành phần hiển thị chữ trong app:** Sử dụng font tại lib\shared\theme\app_text_style.dart cho chữ trong toàn bộ hệ thống

## 2. Interactions & Hiệu ứng (Interactions & Effects)

- **Nút bấm (Buttons) & Chọn Tab:** Các hiệu ứng khi người dùng tương tác (nhấn nút, chuyển/chọn tab) phải được đồng bộ thống nhất trên toàn hệ thống.
- **Thành phần sử dụng:** Bắt buộc bọc các widget có tương tác bằng [BounceWrapper](file:///d:/App/vocabik_app/lib/shared/presentation/widgets/interactions/bounce_wrapper.dart) để tạo hiệu ứng nảy (bounce) mượt mà và đồng nhất.
- **Phong cách thiết kế phẳng (Flat Design):** Không sử dụng hiệu ứng đổ bóng (Box Shadows) cho các Card/Container. Loại bỏ hiệu ứng kính mờ (Glassmorphism / BackdropFilter) để đảm bảo hiệu năng và tính tối giản, sắc nét của giao diện.

## 3. Màu sắc & Trạng thái (Colors & States)

### Primary Accent & Nút bấm (Button):
- **Light Mode:** Màu nền nút & viền: `#0891B2`, màu chữ/icon trong nút: `#FFFFFF`. Hình dạng bo góc viên thuốc (Pill shape - `BorderRadius.circular(999)`).
- **Dark Mode:** Màu nền nút & viền: `#00E5CC`, màu chữ/icon trong nút: `#0D0D1A`. Hình dạng bo góc viên thuốc (Pill shape - `BorderRadius.circular(999)`).

### Tab Segmented ([SharedSegmentedTabBar](file:///d:/App/vocabik_app/lib/shared/presentation/widgets/shared_segmented_tab_bar.dart)):
- **Light Mode:**
  - Tab chưa chọn: Màu nền `#F5F5FA` (hòa vào màu nền app), màu viền `#E8E8ED`, màu chữ `#4B4B63`.
  - Tab được chọn: Màu nền & viền `#0891B2`, màu chữ `#FFFFFF`.
- **Dark Mode:**
  - Tab chưa chọn: Màu nền `#20203B`, màu viền `#303047`, màu chữ `#A6A6BF`.
  - Tab được chọn: Màu nền & viền `#00E5CC`, màu chữ `#0D0D1A`.

### Bottom Navigation Bar ([CustomBottomNavigationBar](file:///d:/App/vocabik_app/lib/features/main_shell/presentation/widgets/custom_bottom_navigation_bar.dart)):
- **Light Mode:** Chưa chọn `#6D6D87`, Đã chọn `#088FB0`.
- **Dark Mode:** Chưa chọn `#8585A1`, Đã chọn `#00E6CB`.

### App Bar & Thẻ (Cards):
- **Light Mode:** Màu nền `#FFFFFF`, màu viền `#F0F0F2`, màu chữ tiêu đề trong thẻ `#13131F`.
- **Dark Mode:** Màu nền `#1A1A2E`, màu viền `#2A2A3D`, màu chữ tiêu đề trong thẻ `#F5F5FA`.

### Ô nhập liệu (Input Fields):
- **Trạng thái Focus:** Viền (border) chuyển sang màu `primaryAccent` (`#0891B2` ở Light Mode, `#00E5CC` ở Dark Mode).

### Đường phân cách (Dividers):
- Sử dụng màu `borderSubtle` (`#F0F0F2` ở Light Mode, `#2A2A3D` ở Dark Mode).

## 4. Theme & Chế độ Sáng/Tối (Light/Dark Mode)

Việc chuyển đổi giữa Light Mode và Dark Mode phải đảm bảo tính thống nhất (consistency) trên toàn bộ ứng dụng, sử dụng bộ màu ngữ nghĩa (semantic colors) từ `Theme.of(context).extension<AppColorsExtension>()!`:

- **Light Mode (Mặc định):**
  - **Màu nền tổng thể (Background):** `#F5F5FA`
  - **Màu thẻ & App Bar (Surface/Card):** `#FFFFFF`
  - **Màu chữ chính (Text Primary):** `#13131F`
  - **Màu chữ phụ (Text Secondary):** `#6D6D87`
  - **Viền & Phân cách (Border/Divider):** `#F0F0F2`

- **Dark Mode:**
  - **Màu nền tổng thể (Background):** `#0D0D1A`
  - **Màu thẻ & App Bar (Surface/Card):** `#1A1A2E`
  - **Màu chữ chính (Text Primary):** `#F5F5FA`
  - **Màu chữ phụ (Text Secondary):** `#8585A1`
  - **Viền & Phân cách (Border/Divider):** `#2A2A3D`

- **Màu sắc trạng thái & gamification (Dùng chung):**
  - **Streak:** `0xFFF59E0B`
  - **Premium:** `0xFF8B5CF6`
  - **Danger/Error:** `0xFFE23E54` (Light) / `0xFFFF5C72` (Dark)

## 5. Quy tắc Code Clean & Ngăn chặn Hardcode Màu (Code Guidelines)

> [!CAUTION]
> **CẤM HARDCODE MÃ MÀU TRONG WIDGET:**
> - Tuyệt đối không khai báo mã màu tĩnh như `Color(0xFF...)` hoặc dùng `AppColors.accent` trực tiếp trong các widget UI.
> - Bắt buộc phải lấy màu từ `AppColorsExtension` thông qua:
>   ```dart
>   final colors = Theme.of(context).extension<AppColorsExtension>()!;
>   ```
> - Điều này đảm bảo giao diện luôn tự động thích ứng chuẩn xác khi người dùng chuyển đổi giữa Light Mode và Dark Mode.

## 6. Ngôn ngữ & Chế độ English/Vietnamese

- Các tên bài hát, thể loại, tên nghệ sĩ, album, quốc gia, lời bài hát (lyrics) được hiển thị bằng tiếng Anh ở cả hai chế độ ngôn ngữ.