---
description: Rà soát mã nguồn Giao diện (UI Code Review). Đánh giá tính nhất quán với Design System, cấu trúc Widget, tối ưu hiệu năng render (const) và phát hiện lỗi tràn màn hình (Overflow).
---

Đóng vai là một Chuyên gia UI/UX Kỹ thuật (Technical UI/UX Expert) và Lập trình viên Flutter Front-end. Hãy giúp tôi thực hiện UI Code Review cho một màn hình (Screen) được code xong trong ứng dụng Vocabik.

Trọng tâm của lần review này là ĐỘ CHÍNH XÁC VỚI DESIGN SYSTEM, BỐ CỤC (LAYOUT), HIỆU NĂNG RENDER và TRẢI NGHIỆM TƯƠNG TÁC (UX).

Tài liệu ui/ux design system: documents\ui_ux_design_system.md và bản thiết kế các màn hình đã chốt tại documents\Vocabik Mobile.dc.html

📋 YÊU CẦU UI REVIEW (UI REVIEW REQUIREMENTS):
Vui lòng đọc các file mã nguồn giao diện được cung cấp và đánh giá chi tiết dựa trên các tiêu chí sau:

1. Tính nhất quán với Design System (Vocabik Design System):
   - Mã nguồn có ĐANG HARDCODE màu sắc, font chữ không? Mọi thành phần phải sử dụng Theme (ví dụ: `Theme.of(context).colorScheme.primary`, `textTheme.bodyLarge`).
   - Font chữ có đúng là 'Nunito' như quy định không?
   - Các khoảng cách (Padding/Margin) và độ bo góc (BorderRadius) có đang sử dụng các hằng số quy chuẩn của dự án không?

2. Bố cục & Khả năng thích ứng (Layout & Responsiveness):
   - Có rủi ro bị lỗi Overflow (tràn màn hình) trên các thiết bị màn hình nhỏ (ví dụ: iPhone SE) không?
   - Có lạm dụng việc fix cứng chiều cao/chiều rộng (`height`, `width`) thay vì dùng `Expanded`, `Flexible` hoặc các tỷ lệ tương đối không?
   - Đã sử dụng `SafeArea` đúng chỗ để tránh các vùng "tai thỏ" (notch) hoặc thanh điều hướng của hệ điều hành chưa?
   - Bố cục có đáp ứng tốt khi người dùng thay đổi kích thước font chữ (Text Scaling) trong cài đặt hệ điều hành không?

3. Trải nghiệm Tương tác (Interaction & Micro-UX):
   - Tất cả các vùng có thể bấm (Buttons, Cards, ListTiles) có được bọc bởi `BounceWrapper` (hiệu ứng nảy đặc trưng của dự án) không?
   - Kích thước vùng chạm (Touch targets) có đủ lớn (tối thiểu 48x48 logical pixels) theo chuẩn UX di động không?
   - Có trạng thái trực quan nào bị thiếu khi tải dữ liệu (Shimmer/Loading) hoặc danh sách trống (Empty State) không?

4. Cấu trúc Widget & Hiệu năng UI (Widget Composition & UI Performance):
   - Hàm `build()` có đang quá dài (God Widget) cần phải Extract ra thành các StatelessWidgets nhỏ hơn không?
   - Từ khóa `const` có được sử dụng TRIỆT ĐỂ cho các Widget không thay đổi để tối ưu hóa quá trình vẽ (render) không?
   - Các danh sách dài có sử dụng `ListView.builder` / `GridView.builder` để lazy-load UI không?
   - Tập trung kiểm tra xem có điều gì khiến hiệu năng khởi động app (thời gian khởi động app) bị ảnh hưởng không và đề xuất cách tối ưu hơn.

🚨 ĐỊNH DẠNG ĐẦU RA (OUTPUT FORMAT):
Phân loại các nhận xét theo mức độ nghiêm trọng:
- 🔴 Lỗi Layout/UX (Blocker): Tràn màn hình (Overflow), hardcode màu/font không theo chuẩn, vùng chạm quá nhỏ (BẮT BUỘC SỬA).
- 🟡 Cảnh báo (Warning): Thiếu từ khóa `const`, hàm build quá dài, quên dùng `SafeArea`.
- 🟢 Đề xuất (Suggestion): Cải thiện code UI ngắn gọn hơn, animation mượt hơn.

*Lưu ý: Luôn trích dẫn dòng code UI đang có vấn đề và cung cấp đoạn code (snippet) đã sửa lỗi.*

Hãy đọc mã nguồn giao diện của màn hình này và cung cấp báo cáo đánh giá UI.
