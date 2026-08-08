---
description: Lập kế hoạch toàn diện cho một tính năng mới (Full Feature Planning). Yêu cầu AI phân tích luồng nghiệp vụ, tích hợp API, kiến trúc Clean Architecture, và phân rã UI chi tiết trước khi code.
---

Đóng vai là một Chuyên gia Kỹ sư Phần mềm và Kỹ sư Front-end Flutter. Hãy giúp tôi lập kế hoạch triển khai toàn diện cho một tính năng mới trong ứng dụng Vocabik. 

Ứng dụng của chúng tôi tuân thủ nghiêm ngặt "Feature-first Clean Architecture", quản lý state bằng BLoC/Cubit, sử dụng GetIt cho Dependency Injection và tuân theo Vocabik Design System (Theme, Typography, L10n).

⚠️ YÊU CẦU BẮT BUỘC: 
KHÔNG bắt đầu viết code ngay. Hãy đọc file `documents/ui_ux_design_system.md` và `documents\Vocabik Mobile.dc.html` (hoặc thiết kế đính kèm) để nắm rõ bối cảnh. Sau đó, lập Kế hoạch Triển khai (Implementation Plan) theo các phần sau:

### 1. Phân tích Luồng Nghiệp vụ (Business Flow Analysis)
- Phân tích luồng hoạt động của người dùng từ khi bắt đầu đến khi kết thúc tính năng.
- Xác định các "Happy path" (luồng thành công) và "Edge cases" (trường hợp ngoại lệ, lỗi).

### 2. Kế hoạch Tích hợp Bên thứ ba & Data Layer (API/3rd Party Integration)
- **API Endpoints / Dịch vụ:** Liệt kê các API, Firebase, hoặc SDK bên thứ ba sẽ gọi. 
- **Data Models:** Xác định cấu trúc Model (kèm phương thức `fromJson`/`toJson`). Có cần các mapper để chuyển đổi từ DTO (Data Transfer Object) sang Entity không?
- **Error Handling:** Lên kế hoạch xử lý lỗi từ API (ví dụ: Timeout, 401 Unauthorized, 500 Server Error) và cách ánh xạ thành thông báo cho người dùng.
- **Local Storage/Cache:** Tính năng này có cần lưu cache dữ liệu offline không? (nếu có, dùng gì?).

### 3. Phân rã Kiến trúc & Logic (Domain & State Management)
- **Entities & Use Cases:** Cần định nghĩa những core Entity nào? Có cần tách Use Case không hay chỉ gọi thẳng Repository?
- **State Management (BLoC/Cubit):** 
  - Liệt kê các Trạng thái (States) có thể xảy ra (Ví dụ: `Initial`, `Loading`, `Success(data)`, `Error(message)`).
  - Liệt kê các Sự kiện (Events) hoặc Hàm (Methods) tương tác từ UI.

### 4. Kế hoạch Xây dựng Giao diện (UI Implementation Plan)
- **Layout Breakdown:** Phân rã màn hình từ ngoài vào trong. Đánh giá nguy cơ tràn màn hình (Overflow) và cách phòng tránh (ví dụ: `SingleChildScrollView`, `Expanded`).
- **Componentization:** Những Widget nào có thể tái sử dụng từ `lib/shared/presentation/widgets/`? Những thành phần nào cần tách thành Widget con độc lập để tránh "God Widget"?
- **Design System Compliance:**
  - **Màu sắc & Spacing:** Không hard-code. Phải sử dụng từ `Theme.of(context).colorScheme` và `app_spacing.dart`.
  - **Tương tác:** Các nút bấm, thẻ có được bọc bởi `BounceWrapper` chưa?
- **Localization (L10n):** Tuyệt đối không hard-code Text. Liệt kê danh sách các "key" đa ngôn ngữ dự kiến thêm vào `app_en.arb` và `app_vi.arb`.
- **Tối ưu Hiệu năng:** 
  - Xác định vị trí đặt BlocBuilder/Consumer để phạm vi rebuild là nhỏ nhất.
  - Tận dụng tối đa từ khóa `const` cho các UI tĩnh.

### 5. Cấu hình & Tích hợp (Config & Routing)
- Đăng ký Dependency Injection (GetIt) cho các lớp: Datasource, Repository, UseCase (nếu có), và BLoC/Cubit.
- Bổ sung định tuyến (Routing) trong GoRouter (nếu đây là màn hình mới).

### 6. Yêu cầu bổ sung
- Chạy lệnh flutter analyze để kiểm tra mã nguồn còn đang có vấn đề ở đâu
- (Tùy chọn) Chạy lệnh flutter gen-l10n nếu cần thiết để tự sinh mã đa ngôn ngữ

### 7. Câu hỏi làm rõ (Open Questions)
- Vui lòng đặt câu hỏi lại cho tôi nếu có điểm mù về API request/response, thiết kế UI thiếu trạng thái (Empty/Loading), hoặc mâu thuẫn yêu cầu trước khi bắt tay vào code.

Hãy trình bày bản kế hoạch dưới định dạng Markdown dễ nhìn. Tôi chưa cần triển khai gì cả, chỉ cần kế hoạch.