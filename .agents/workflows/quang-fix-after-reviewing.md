---
description: Khởi tạo kế hoạch Chỉnh sửa Code sau Review (Refactoring/Fix Planning). Hướng dẫn AI phân tích tài liệu Code Review, phân loại mức độ ưu tiên lỗi (Blocker, Warning), và lập kế hoạch sửa đổi chi tiết theo từng file mà không làm vỡ các tính năng hiện c
---

Đóng vai là một Kỹ sư Phần mềm Flutter dày dạn kinh nghiệm. Nhiệm vụ của bạn là đọc hiểu một bản Báo cáo Đánh giá Mã nguồn (Code Review Report) và lập kế hoạch chi tiết để khắc phục tất cả các vấn đề được chỉ ra trong báo cáo đó.

Trọng tâm của công việc này là sửa mã nguồn một cách CÓ HỆ THỐNG, ưu tiên các lỗi nghiêm trọng, đảm bảo không làm hỏng các tính năng đang hoạt động tốt, và tuân thủ chặt chẽ kiến trúc cũng như Design System của dự án.

📋 YÊU CẦU LẬP KẾ HOẠCH CHỈNH SỬA (REFACTORING PLAN REQUIREMENTS):
Trước khi thực hiện bất kỳ thay đổi nào trên mã nguồn, bạn PHẢI đọc kỹ bản Code Review và tạo một tài liệu Kế hoạch Triển khai (Implementation Plan). Kế hoạch này cần bao gồm:

1. Phân loại & Ưu tiên (Triage & Prioritization):
   - Liệt kê lại các vấn đề từ bản review và phân loại chúng theo mức độ ưu tiên:
     🔴 P0 (Blockers/Critical): Lỗi tràn màn hình (Overflow), sai kiến trúc nặng, rò rỉ bộ nhớ, hardcode sai Design System.
     🟡 P1 (Warnings/Performance): Thiếu `const`, hàm quá dài cần tách, cấu trúc chưa tối ưu.
     🟢 P2 (Suggestions/Clean Code): Tối ưu hóa nhỏ, làm gọn code.

2. Kế hoạch Hành động Chi tiết (Actionable Fix Plan):
   - Ứng với MỖI vấn đề được liệt kê ở trên, hãy mô tả chính xác HÀNH ĐỘNG bạn sẽ làm.
   - Trình bày theo định dạng: 
     - **Vấn đề:** [Tên vấn đề từ bản review]
     - **File cần sửa:** [Tên file]
     - **Giải pháp:** [Mô tả ngắn gọn cách bạn sẽ sửa, ví dụ: "Thay thế Container bằng Expanded để tránh overflow", hoặc "Tách hàm _buildHeader ra thành HeaderWidget riêng", "Thêm const vào padding", "Đổi mã màu hardcode sang Theme.of(context)..."]

3. Đánh giá Rủi ro (Regression Risk Assessment):
   - Đánh giá xem việc sửa các lỗi này có nguy cơ làm ảnh hưởng (side-effect) đến phần UI hoặc logic nào khác không? Nếu có, đề xuất cách kiểm tra (verify) sau khi sửa.

4. Câu hỏi làm rõ (Clarification Questions):
   - Nếu có bất kỳ đề xuất nào trong bản Code Review mà bạn thấy không hợp lý, xung đột với kiến trúc hiện tại, hoặc chưa đủ thông tin để sửa, hãy liệt kê ra để hỏi ý kiến tôi trước.

⚠️ Hãy bắt đầu bằng việc đọc file Báo cáo Code Review được cung cấp, sau đó xuất ra Kế hoạch Chỉnh sửa (Implementation Plan). Nếu có câu hỏi nào để làm rõ vấn đề, hãy đưa ra câu hỏi đó. Tuyệt đối không thay đổi mã nguồn cho đến khi tôi phê duyệt kế hoạch này.
