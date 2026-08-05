---
description: Khởi tạo quy trình Code Review cho một tính năng. Yêu cầu AI kiểm tra tính tuân thủ Clean Architecture, hiệu suất BLoC, Design System và tìm ra các lỗi tiềm ẩn.
---

Đóng vai là một Chuyên gia Kỹ sư Phần mềm và Trưởng nhóm Kỹ thuật (Tech Lead) cho dự án Flutter. Hãy giúp tôi thực hiện Code Review toàn diện cho một tính năng vừa được code xong trong ứng dụng Vocabik.

Ứng dụng của chúng tôi yêu cầu tuân thủ nghiêm ngặt: "Feature-first Clean Architecture", quản lý state bằng BLoC/Cubit, sử dụng GetIt cho Dependency Injection và tuân theo Vocabik Design System.

Chi tiết có thể xem plan đã chốt tại documents\Vocabik_Architecture_SAD.md và thiết kế UI tại documents\Vocabik Mobile.dc.html

📋 YÊU CẦU REVIEW (REVIEW REQUIREMENTS):
Hãy rà soát kỹ lưỡng các mã nguồn liên quan đến tính năng này và tạo một Báo cáo Đánh giá (Review Report) tập trung vào các khía cạnh sau:

1. Kiến trúc (Architecture Compliance): 
   - Có sự rò rỉ logic (logic bleeding) giữa các tầng không? (VD: Presentation layer có gọi trực tiếp API hay xử lý logic nghiệp vụ phức tạp không?).
   - Các Repository interfaces có được đặt đúng ở Domain layer và implement ở Data layer không?

2. Quản lý Trạng thái (State Management - BLoC/Cubit):
   - Các State có bao phủ đủ các trường hợp không? (Loading, Success, Failure, Empty).
   - Đã tách biệt logic UI và Business logic triệt để chưa?

3. UI/UX & Design System:
   - Các Widget có tuân thủ Vocabik Design System (màu sắc, typography 'Nunito', khoảng cách) không?
   - Các tương tác nút bấm có sử dụng `BounceWrapper` như quy định không?
   - Mã nguồn UI có bị phình to (god widget) cần phải tách nhỏ thành các component độc lập không?

4. Hiệu năng & Tối ưu hóa (Performance & Optimization):
   - Đã sử dụng tối đa từ khóa `const` cho các Widget để tránh rebuild chưa?
   - Các danh sách dài có sử dụng `ListView.builder` thay vì `ListView` thông thường hoặc `Column` không?
   - Có nguy cơ rò rỉ bộ nhớ (Memory Leaks) không? (Các Controllers, Streams, Timers có được `dispose()` đúng cách không?).
   - BlocBuilder có sử dụng `buildWhen` (hoặc `context.select`) để ngăn chặn việc render lại UI không cần thiết không?
   - Có tác vụ nặng nào đang chặn Main Thread (UI Thread) cần phải chuyển sang Isolate/compute không?
   - Tập trung kiểm tra xem có điều gì khiến hiệu năng khởi động app (thời gian khởi động app) bị ảnh hưởng không và đề xuất cách tối ưu hơn.


5. Xử lý Lỗi & Cạnh biên (Error Handling & Edge Cases):
   - Các ngoại lệ (Exceptions) từ Data layer có được bắt và chuyển đổi an toàn thành State lỗi (Failure State) cho UI hiển thị không?
   - Đã xử lý các kịch bản mất mạng (offline) hay dữ liệu rỗng (empty state) chưa?

6. Chất lượng Code (Code Quality & Clean Code):
   - Có đoạn code nào vi phạm nguyên tắc SOLID và DRY không?
   - Tên biến, hàm, class có rõ nghĩa và đúng chuẩn Dart (camelCase, PascalCase) không?

🚨 ĐỊNH DẠNG ĐẦU RA (OUTPUT FORMAT):
Phân loại các nhận xét theo mức độ nghiêm trọng:
- 🔴 Cấp bách (Blocker): Lỗi nghiêm trọng, sai kiến trúc, rò rỉ bộ nhớ, crash app (BẮT BUỘC SỬA).
- 🟡 Cảnh báo (Warning): Các vấn đề về hiệu năng (thiếu const, rebuild thừa), code bốc mùi (code smell).
- 🟢 Gợi ý (Suggestion): Cải thiện code ngắn gọn hơn, tái sử dụng tốt hơn.

*Lưu ý: Với mỗi vấn đề được chỉ ra, hãy trích dẫn đoạn code hiện tại và cung cấp đoạn code đề xuất (snippet) để sửa nó.*

Hãy đọc các file trong thư mục tính năng này và cung cấp báo cáo đánh giá.
Xuất thành 1 file báo cáo tại documents.