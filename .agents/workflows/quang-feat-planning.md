---
description: Khởi tạo quy trình lập kế hoạch tính năng (Feature Planning). Yêu cầu AI phân rã cấu trúc thư mục theo Data, Domain, Presentation và xác định State Management trước khi code.
---

Đóng vai là một Chuyên gia Kỹ sư Phần mềm và Lập trình viên Flutter. Hãy giúp tôi lập kế hoạch triển khai chi tiết cho một tính năng mới trong ứng dụng Vocabik. 

Ứng dụng của chúng tôi đang tuân thủ nghiêm ngặt kiến trúc "Feature-first Clean Architecture", quản lý state bằng BLoC/Cubit, sử dụng GetIt cho Dependency Injection và tuân theo Vocabik Design System.


📋 YÊU CẦU LÊN KẾ HOẠCH (PLANNING REQUIREMENTS):
Vui lòng KHÔNG bắt đầu viết code ngay. Hãy phân tích và tạo một tài liệu kế hoạch triển khai (Implementation Plan) bao gồm các phần sau:

1. Phân tích Kiến trúc (Architecture Breakdown): 
   - Phân tích cách chia thư mục cho feature này (trong thư mục lib/features/[feature_name]).

2. Data Layer:
   - Cấu trúc Models (kèm phương thức fromJson/toJson nếu cần).
   - Remote/Local Data Sources (định nghĩa các API endpoints hoặc bảng database cục bộ).
   - Data Repository Implementations.

3. Domain Layer:
   - Các Entities cốt lõi.
   - Abstract Repositories (Interfaces).
   - Use Cases (nếu độ phức tạp của logic đòi hỏi).

4. Presentation Layer:
   - Phân tích State Management: Định nghĩa các States và Events cho BLoC/Cubit.
   - UI Components: Danh sách các Màn hình (Screens) và các Widgets dùng chung cần thiết kế, đảm bảo tuân thủ Design System hiện tại.

5. Cấu hình & Tích hợp (Config & Integration):
   - Các module cần đăng ký Dependency Injection (GetIt).
   - Routing cần thêm vào (GoRouter).

6. Các câu hỏi mở (Open Questions):
   - Đặt câu hỏi cho tôi nếu có bất kỳ điểm mù, sự mâu thuẫn hoặc thiết sót nào trong yêu cầu trước khi bắt tay vào làm.

7. Với bất kỳ yêu cầu liên quan đến giao diện, hãy luôn luôn đọc bản thiết kế đã chốt tại documents\Vocabik Mobile.dc.html

Hãy bắt đầu bằng việc đọc lướt qua mã nguồn hiện tại của dự án để nắm bối cảnh, sau đó trình bày bản kế hoạch dưới định dạng Markdown dễ nhìn. Tôi chưa cần triển khai gì cả.