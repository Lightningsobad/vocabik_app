---
description:  Code Review cho một tính năng mới. Trọng tâm đánh giá cách tổ chức code, phân chia cấu trúc thư mục (Clean Architecture), tính phân tách trách nhiệm (Separation of Concerns), và mức độ module hóa của UI, Logic, và Tương tác Bên thứ ba.
---

Đóng vai là một Chuyên gia Kiến trúc Phần mềm (Software Architect) và Tech Lead Flutter. Hãy giúp tôi đánh giá và rà soát mã nguồn (Code Review) cho TÍNH NĂNG MỚI vừa được xây dựng trong ứng dụng Vocabik.

Mục tiêu cốt lõi của đợt review này là **CÁCH TỔ CHỨC CODE (CODE ORGANIZATION & ARCHITECTURAL STRUCTURE)**. Đảm bảo tính năng được tổ chức mạch lạc, dễ mở rộng, tuân thủ nguyên tắc SOLID, Clean Architecture và không để xảy ra hiện tượng code bị rối (Spaghetti Code) hay các lớp vi phạm trách nhiệm của nhau.

---

📋 CÁC TIÊU CHÍ REVIEW TỔ CHỨC MÃ NGUỒN:

### 1. Tổ chức Phân tầng Kiến trúc (Feature-first Clean Architecture)
- **Cấu trúc thư mục tính năng (`lib/features/[feature_name]/`):**
  - Đã phân chia đúng 3 tầng: `presentation/`, `domain/`, `data/` chưa?
  - Có hiện tượng "rò rỉ ranh giới" (Leak of Abstraction) giữa các tầng không? (Ví dụ: Tầng Presentation hoặc Domain import trực tiếp Data Source / DTO Model / thư viện bên thứ 3 của tầng Data).
- **Trách nhiệm tầng Domain (Domain Layer Purity):**
  - **Entities:** Có hoàn toàn độc lập với framework/API không? (Entity KHÔNG được chứa `fromJson`/`toJson` hoặc phụ thuộc vào package bên thứ 3).
  - **UseCases & Repositories Interface:** Định nghĩa hợp đồng (Interface) có rõ ràng, đúng chuẩn Single Responsibility (mỗi UseCase chỉ giải quyết 1 luồng nghiệp vụ) không?
- **Trách nhiệm tầng Data:**
  - Có tách bạch rõ ràng giữa **Data Source** (gọi API/DB thô), **Data Model/DTO** (kèm `fromJson`/`toJson` và mapper `toDomain()`), và **Repository Implementation** (nơi gom dữ liệu và xử lý lỗi) không?

### 2. Tổ chức Tầng Giao diện (UI & Presentation Architecture)
- **Phân rã Component & Tránh "God Widget":**
  - Màn hình chính (`..._screen.dart`) có bị quá dài (> 250-300 dòng) không?
  - Các khối UI con đã được bóc tách thành các class Widget độc lập (trong thư mục `presentation/widgets/`) chưa, hay vẫn đang lạm dụng viết hàm trả về widget dạng `Widget _buildSomething()` ngay trong class chính?
- **Tách biệt UI và Business Logic:**
  - Widget có chỉ đóng vai trò "nguồn phát sự kiện" (dispatch event) và "hiển thị dữ liệu" (render state) không? Tuyệt đối không được viết logic tính toán, parse dữ liệu, hay gọi API trực tiếp trong hàm `build()`.
- **Tổ chức Hằng số, Theme & Đa ngôn ngữ (L10n):**
  - Màu sắc, khoảng cách, icon có được gọi từ Design System (`AppColors`, `AppSpacing`, `Theme.of(context)`) thay vì hard-code giá trị thô không?
  - Tất cả các chuỗi text có được tổ chức key và đưa vào file `.arb` đa ngôn ngữ đầy đủ không?

### 3. Tổ chức Logic & State Management (BLoC/Cubit Structure)
- **Cấu trúc State & Event:**
  - Các file `..._bloc.dart`, `..._event.dart`, `..._state.dart` (hoặc `..._cubit.dart`) có được tổ chức chuẩn hóa, đặt tên tường minh, rõ nghĩa không?
  - State có được thiết kế theo dạng sealed classes/freezed hoặc Equatable để kiểm soát rõ các trạng thái: `Initial`, `Loading`, `Success(data)`, `Failure(message)` không?
- **Quy mô BLoC (Tránh "God BLoC"):**
  - Một BLoC/Cubit có đang gánh quá nhiều trách nhiệm của nhiều flow khác nhau không? Có cần tách nhỏ thành các sub-blocs cho từng phần việc riêng biệt không?

### 4. Tổ chức Tương tác Bên thứ ba & Dependency Injection (3rd-Party & DI)
- **Trừu tượng hóa dịch vụ bên thứ 3 (Decoupling & Abstraction):**
  - Mã nguồn có bị phụ thuộc dính chặt vào một SDK bên thứ 3 cụ thể không? Đã có lớp bọc (Adapter/Service Wrapper) để sau này dễ dàng đổi SDK hoặc viết Unit Test Mock chưa?
- **Cấu trúc Xử lý Lỗi (Error & Exception Mapping):**
  - Các Exception từ bên thứ 3 (DioException, FirebaseException, v.v.) có được bắt ở Datasource và chuyển đổi (map) thành các Domain `Failure` có ý nghĩa trước khi đẩy lên Presentation không?
- **Đăng ký Dependency Injection (GetIt):**
  - Việc đăng ký DI (Factory / LazySingleton / Singleton) có được đặt đúng chỗ và gom nhóm ngăn nắp (theo từng feature hoặc service module) không?

### 5. Chuẩn mực Mã nguồn & Đặt tên (Clean Code & Naming Conventions)
- Quy chuẩn đặt tên file (`snake_case`), tên class (`PascalCase`), tên biến/hàm (`camelCase`) có đồng nhất với toàn dự án không?
- Đã dọn dẹp sạch sẽ các đoạn code thừa, code comment không dùng, hoặc các hàm `print()` / debug logs chưa?

---

🚨 ĐỊNH DẠNG BÁO CÁO REVIEW:

Trình bày báo cáo theo cấu trúc Markdown rõ ràng:

1. 📂 **Đánh giá Cấu trúc Thư mục & Phân tầng (Architecture Audit):** Nhận xét về độ chuẩn của Clean Architecture và ranh giới giữa các tầng.
2. ⚠️ **Các Vị Trí Vi Phạm Tổ Chức Code (Refactoring Needed):**
   - **Vấn đề phát hiện:** (Chỉ rõ file, hàm, hoặc class vi phạm).
   - **Lý do vi phạm:** (Ví dụ: Logic lẫn vào UI, Entity chứa `fromJson`, hàm build quá dài, thiếu Interface, v.v.).
   - **Đề xuất tái cấu trúc (Refactored Code / Structure):** Cung cấp cấu trúc hoặc đoạn code mẫu sau khi đã tổ chức lại chuẩn chỉnh.
3. ✅ **Bảng Tóm Tắt Khuyến Nghị:** Liệt kê các hành động cụ thể cần làm để hoàn thiện tổ chức code trước khi merge.

Hãy bắt đầu đọc mã nguồn của tính năng mới và đưa ra bản Code Review chi tiết theo các tiêu chí trên.
