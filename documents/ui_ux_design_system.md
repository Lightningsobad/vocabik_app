# Vocabik UI/UX Design System

Tài liệu này định nghĩa các quy tắc chuẩn mực về UI/UX cho toàn bộ hệ thống ứng dụng Vocabik.

## 1. Typography (Kiểu chữ)
- **Font chữ áp dụng mọi thành phần hiển thị chữ trong app:** Sử dụng font **Nunito** (từ Google Fonts) cho toàn bộ hệ thống.

## 2. Interactions (Hiệu ứng tương tác)
- **Nút bấm (Buttons) & Chọn Tab:** Các hiệu ứng khi người dùng tương tác (nhấn nút, chuyển/chọn tab) phải được đồng bộ thống nhất trên toàn hệ thống.
- **Thành phần sử dụng:** Bắt buộc bọc các widget có tương tác bằng [BounceWrapper](file:///d:/App/vocabik_app/lib/shared/presentation/widgets/interactions/bounce_wrapper.dart) để tạo hiệu ứng nảy (bounce) mượt mà và đồng nhất.

## 3. Màu sắc & Trạng thái (Colors & States)
- **Màu chủ đạo (Primary Color):** `0xFF06B6D4` (Cyan) - Giữ nguyên không đổi ở cả hai chế độ.
- **Trạng thái Tab được chọn (Selected Tab):** Sử dụng màu `0xFF06B6D4` làm màu nổi bật.
- **Trạng thái Nút bấm (Button):** Các nút bấm chính (Primary buttons) sử dụng màu nền `0xFF06B6D4`.

## 4. Input Fields (Ô nhập liệu)
- **Trạng thái Focus (Khi được chọn/nhập liệu):** Viền (border) của các ô nhập liệu (TextField, TextFormField) phải chuyển sang màu `0xFF06B6D4` khi người dùng nhấn vào để bắt đầu nhập liệu ở cả Dark và Light Mode.

## 5. Theme & Chế độ Sáng/Tối (Light/Dark Mode)
Việc chuyển đổi giữa Light Mode và Dark Mode phải đảm bảo tính thống nhất (consistency) trên toàn bộ ứng dụng, sử dụng bộ màu ngữ nghĩa (semantic colors) thay vì màu tĩnh (static colors):

- **Light Mode (Mặc định):**
  - **Màu nền (Background):** `0xFFFFFFFF` (Trắng)
  - **Màu thẻ (Surface/Card):** `0xFFF8FAFC` (Trắng xám nhạt)
  - **Màu chữ chính (Text Primary):** `0xFF13131F` (Đen)
  - **Màu chữ phụ (Text Secondary):** `0xFF64748B` (Xám)
  - **Viền (Border):** `0xFFE2E8F0`

- **Dark Mode:**
  - **Màu nền (Background):** `0xFF0B0F19` (Xanh đen đậm)
  - **Màu thẻ (Surface/Card):** `0xFF1E293B` (Xanh xám đậm - slate 800)
  - **Màu chữ chính (Text Primary):** `0xFFF8FAFC` (Trắng sáng)
  - **Màu chữ phụ (Text Secondary):** `0xFF94A3B8` (Xám nhạt)
  - **Viền (Border):** `0xFF334155`

**Nguyên tắc chuyển đổi:**
- Các thành phần có tính tương tác cao (Nút bấm chính, Progress bar, Icon nổi bật, Focus border) luôn giữ màu chủ đạo Cyan `0xFF06B6D4`.
- Sử dụng hiệu ứng chuyển đổi mượt mà (smooth transition) giữa các theme.
- Đảm bảo độ tương phản (contrast) của chữ trên nền ở cả hai chế độ.
