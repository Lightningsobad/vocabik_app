---
description: Kiểm toán Chuyên sâu: Hiệu năng & Lỗi Tiềm ẩn. Rà soát toàn bộ dự án để phát hiện rò rỉ bộ nhớ (Memory Leaks), nguyên nhân gây giật lag (UI Jank), các nút thắt làm chậm thời gian khởi động app, và lỗi Race Condition/Crash ngầm.
---

Đóng vai là một Chuyên gia Kiến trúc Phần mềm (Software Architect) và Chuyên gia Tối ưu Hiệu năng (Performance Tuning Expert) với nhiều năm kinh nghiệm phát triển Flutter. Hãy giúp tôi thực hiện Kiểm toán Sâu toàn bộ mã nguồn (Deep Codebase Audit) cho ứng dụng di động Vocabik.

Mục tiêu cốt lõi của đợt rà soát này KHÔNG PHẢI là soi lỗi UI hay syntax nhỏ lẻ, mà là tìm ra những LỖI NGUY HIỂM TIỀM TẨN (Hidden Bugs) và CÁC NÚT THẮT CỔ CHAI (Bottlenecks) ảnh hưởng trực tiếp đến HIỆU NĂNG KHỞI ĐỘNG (App Startup Time) và ĐỘ MƯỢT MÀ KHI CHẠY (Runtime Smoothness).

🎯 BỐI CẢNH KIỂM TOÁN (AUDIT CONTEXT):
- Ứng dụng: Vocabik (Sử dụng Clean Architecture, BLoC/Cubit, GetIt).
- Trọng tâm: Tối ưu thời gian khởi động (Startup Time), loại bỏ độ trễ (Jank/Stutter), và ngăn chặn rò rỉ bộ nhớ (Memory Leaks), crash ngầm.

📋 YÊU CẦU KIỂM TOÁN CHI TIẾT (AUDIT REQUIREMENTS):
Vui lòng rà soát cấu trúc mã nguồn, luồng khởi tạo và các module chính của dự án. Trình bày Báo cáo Kiểm toán tập trung vào 4 nhóm vấn đề sống còn sau:

1. Tối ưu Thời gian Khởi động (App Startup Performance):
   - Quá trình `main()` và `runApp()` có đang bị "nghẽn" bởi các tác vụ đồng bộ (`await`) quá nặng không? (VD: Khởi tạo database quá lâu, gọi API chặn luồng, hoặc setup Dependency Injection (GetIt) chưa tối ưu).
   - Đề xuất giải pháp Lazy Initialization (chỉ khởi tạo khi cần) hoặc dùng `Isolate`/`compute` cho các tác vụ khởi động nặng để trả màn hình Splash nhanh nhất có thể.

2. Độ mượt mà & Hiệu năng Render (Runtime Smoothness & UI Jank):
   - Tìm kiếm các vòng lặp nặng, các hàm xử lý dữ liệu phức tạp (như parse JSON cục lớn, mã hóa/giải mã) đang chạy trực tiếp trên Main Thread (UI Thread) gây giật lag (frame drop/jank). Đề xuất chuyển chúng sang Isolate.
   - Có sự lạm dụng `setState` hay BlocBuilder cấp cao nhất (top-level) gây ra việc Rebuild toàn bộ màn hình một cách không cần thiết khi có một thay đổi nhỏ không?
   - Rà soát các logic Animation hoặc Scroll (ListView/GridView): Chúng có nguy cơ gây rớt khung hình (drop frames) không? (Có dùng `const` triệt để chưa? Có tải ảnh dung lượng quá lớn không cache không?).

3. Rò rỉ Bộ nhớ & Quản lý Tài nguyên (Memory Leaks & Resource Management):
   - Rà soát toàn bộ các `StatefulWidget`, `Cubit`/`Bloc`: Các `StreamSubscription`, `Timer`, `AnimationController`, `TextEditingController`, `FocusNode` có được `dispose()` hoặc `close()` hoàn toàn khi màn hình bị hủy không?
   - Có việc lưu giữ tham chiếu (reference) tĩnh (static/global variables) đến `BuildContext` gây rò rỉ bộ nhớ màn hình không?

4. Lỗi Nguy hiểm Tiềm ẩn & Ngoại lệ không được bắt (Hidden Bugs & Uncaught Exceptions):
   - Luồng kết nối mạng (Network layer): Có trường hợp nào gọi API nhưng không cấu hình `timeout`, hoặc không xử lý triệt để khối `catch` (bỏ sót ngoại lệ) dẫn đến crash app đột ngột (Silent Crash) hoặc treo màn hình (Infinite Loading) không?
   - Xử lý đồng thời (Concurrency): Có kịch bản Race Condition nào khi nhiều sự kiện BLoC được bắn ra cùng lúc (vd: user bấm nút liên tục) mà không có cơ chế chặn (như `droppable`, `restartable` của `bloc_concurrency`) không?

🚨 ĐỊNH DẠNG ĐẦU RA (OUTPUT FORMAT):
Phân loại các rủi ro theo mức độ đe dọa đến hệ thống:
- 🔴 BÁO ĐỘNG ĐỎ (Critical / Fatal Bugs): Các lỗi chắc chắn gây Memory Leak, Crash app, hoặc đứng máy (Treo UI). (BẮT BUỘC SỬA NGAY - Kèm giải pháp chi tiết).
- 🟠 CẢNH BÁO HIỆU NĂNG (Performance Bottlenecks): Các đoạn code làm chậm quá trình khởi động hoặc gây giật lag màn hình (Jank). (Kèm code tối ưu bằng Isolate/Lazy/Const).
- 🟡 Rủi ro Tiềm ẩn (Edge Cases): Lỗi Race condition, thiếu timeout, thiếu xử lý lỗi mạng.

Hãy rà soát dự án và xuất báo cáo kiểm toán sâu.
