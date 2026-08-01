---
description: Kiểm toán Giao diện Toàn hệ thống (System-wide UI Audit). Đánh giá tính nhất quán UI/UX trên tất cả các màn hình, phát hiện code UI bị lặp lại, kiểm tra tích hợp Theme toàn cục và đề xuất gom nhóm các Shared Components.
---

Đóng vai là một Chuyên gia Kiến trúc Front-end (Front-end Architect) và Chuyên gia UI/UX Kỹ thuật. Hãy giúp tôi thực hiện Kiểm toán Giao diện Toàn hệ thống (System-wide UI Audit) cho ứng dụng di động Vocabik.

Mục tiêu của đợt review này KHÔNG PHẢI là soi chi tiết logic của một tính năng cụ thể, mà là đánh giá "Bức tranh lớn" về cách UI được tổ chức, tính nhất quán trên toàn bộ các màn hình, và khả năng tái sử dụng component.

🎯 BỐI CẢNH KIỂM TOÁN (AUDIT CONTEXT):
- Mục tiêu: Rà soát toàn bộ các thư mục UI (các file trong `presentation/screens` và `shared/presentation/widgets`).
- Yêu cầu cốt lõi: Ứng dụng phải tuân thủ tuyệt đối [Vocabik Design System] (dùng màu Cyan 0xFF06B6D4 làm chủ đạo, font Nunito, và có hiệu ứng chuyển đổi mượt mà giữa Light/Dark mode). Chi tiết tại documents\ui_ux_design_system.md
Và thiết kế chốt tại documents\Vocabik Mobile.dc.html

📋 YÊU CẦU KIỂM TOÁN HỆ THỐNG (SYSTEM AUDIT REQUIREMENTS):
Vui lòng phân tích cấu trúc mã nguồn UI của toàn bộ dự án và cung cấp Báo cáo Kiểm toán tập trung vào 4 trụ cột sau:

1. Tính nhất quán toàn cục (Cross-Screen Consistency):
   - Có sự sai lệch nào về việc sử dụng Theme giữa các màn hình khác nhau không? (VD: Màn hình A dùng Theme chuẩn, nhưng màn hình B lại tự hardcode màu sắc, font chữ, hoặc kích thước khoảng cách).
   - Trải nghiệm Dark/Light mode có được áp dụng đồng bộ trên tất cả các màn hình chưa? Việc chuyển đổi (transition) giữa 2 mode có đảm bảo mượt mà (smooth) theo nguyên tắc thiết kế không?

2. Khả năng tái sử dụng & Cấu trúc Component (Reusability & Componentization):
   - Có các đoạn mã UI (nút bấm, card, app bar, dialog) nào đang bị copy-paste (lặp lại) giữa nhiều màn hình không? 
   - Đề xuất những Widget cụ thể nào cần được tách ra và đẩy vào thư mục `lib/shared/presentation/widgets/` để dùng chung cho toàn hệ thống.

3. Khả năng thích ứng & Bố cục hệ thống (System-wide Responsiveness):
   - Các khuôn mẫu bố cục (Layout templates như Scaffold, SafeArea, BottomNavigationBar) có được sử dụng chuẩn mực trên mọi màn hình không?
   - Có kịch bản nào gây tràn màn hình (Overflow) mang tính hệ thống khi chạy trên các thiết bị màn hình rất nhỏ hoặc màn hình gập không?

4. Trải nghiệm Chuyển cảnh & Micro-UX toàn cục (Global Transitions & Micro-UX):
   - Hiệu ứng `BounceWrapper` có được áp dụng ĐỒNG LOẠT cho TẤT CẢ các điểm chạm (touch targets) trên toàn app không, hay bị bỏ sót ở một số màn hình?
   - Các hiệu ứng chuyển trang (Page Transitions) thông qua hệ thống Routing (GoRouter) có mượt mà và đồng nhất không?

🚨 ĐỊNH DẠNG ĐẦU RA (OUTPUT FORMAT):
Báo cáo kiểm toán cần chia làm các phần:
- 🔴 Lỗ hổng Hệ thống (Systematic Blockers): Các lỗi nghiêm trọng lặp đi lặp lại trên nhiều màn hình (VD: Không dùng Theme chung, lỗi Overflow hàng loạt).
- 🟡 Cơ hội Tái sử dụng (Refactor/Reusability Opportunities): Danh sách các component cần được gom chung lại (kèm ví dụ code).
- 🟢 Đánh giá tổng quan (Overall Health): Điểm số hoặc nhận xét tổng quan về "sức khỏe" UI của toàn dự án.

Hãy rà soát toàn bộ các màn hình hiện có và cung cấp báo cáo kiểm toán hệ thống. Tôi chưa cần triển khai gì cả.
Hãy xuất báo cáo vào một file tại documents.
