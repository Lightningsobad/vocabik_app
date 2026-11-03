---
description: Code Review cho một tính năng mới. Trọng tâm kiểm tra hiệu năng render UI, tối ưu CPU/Main Thread trong logic, và hiệu quả xử lý dữ liệu/bộ nhớ từ API và SDK bên thứ ba.
---

Đóng vai là một Senior Flutter Performance Engineer & Tech Lead Reviewer. Hãy giúp tôi đánh giá và rà soát mã nguồn (Code Review) cho TÍNH NĂNG MỚI vừa được triển khai trong ứng dụng Vocabik.

Trọng tâm cốt lõi của buổi Review này là **HIỆU NĂNG XỬ LÝ (PROCESSING & RENDERING PERFORMANCE)**, đảm bảo tính năng không gây giật lag (Jank), không rò rỉ bộ nhớ (Memory Leak), và không làm chậm ứng dụng khi tương tác với API/Bên thứ ba.

Ứng dụng tuân thủ: Clean Architecture, BLoC/Cubit, GetIt DI, và Vocabik Design System.

---

📋 CHI TIẾT CÁC HẠNG MỤC REVIEW HIỆU NĂNG:

### 1. Hiệu năng Dựng & Render Giao diện (UI & Layout Performance)
- **Tái Rebuild dư thừa (Over-Rebuilding):** 
  - Phạm vi bọc `BlocBuilder`, `BlocConsumer`, hoặc `ValueListenableBuilder` có đủ nhỏ chưa? Có bị rebuild cả cây Widget cha khi chỉ một thành phần nhỏ thay đổi không?
  - Đã tận dụng tối đa từ khóa `const` ở các sub-widgets và constructor chưa?
- **Nút thắt Layout (Expensive Layout Operations):**
  - Có lạm dụng các Widget tính toán layout đắt đỏ như `IntrinsicHeight`, `IntrinsicWidth`, hoặc lồng quá nhiều `SingleChildScrollView` gây suy giảm fps không?
  - Với các danh sách (List/Grid) dữ liệu lớn, đã dùng `ListView.builder` / `GridView.builder` thay cho `ListView(children: ...)` chưa?
- **Tài nguyên hình ảnh & Đồ họa:**
  - Ảnh/SVG lấy từ mạng hoặc tài nguyên cục bộ có được cache đúng cách và định kích thước (memCacheWidth/memCacheHeight) phù hợp để tránh tràn RAM không?
  - Đã dùng `RepaintBoundary` cho các Widget chuyển động/animation phức tạp chưa?

### 2. Hiệu năng Xử lý Logic & Quản lý Bộ nhớ (Logic & Memory Performance)
- **Nghẽn Main Thread (UI Thread Blocking):**
  - Có tác vụ tính toán CPU nặng nào (như sort/filter danh sách hàng ngàn phần tử, mã hóa/giải mã, xử lý văn bản lớn) đang chạy trực tiếp trên Main Thread không? Đã dùng `compute` hoặc `Isolate` chưa?
- **Rò rỉ Bộ nhớ (Memory & Resource Leaks):**
  - Tất cả các controller (`ScrollController`, `TextEditingController`, `AnimationController`), `FocusNode`, `Timer`, và `StreamSubscription` trong các StatefulWidget hoặc Cubit/BLoC đã được `dispose()` / `close()` / `cancel()` triệt để chưa?
- **Tối ưu Sự kiện & Concurrency (Event Debouncing/Throttling):**
  - Khi người dùng tương tác nhanh (như gõ tìm kiếm, bấm nút liên tục), đã dùng `debounce`, `throttle` hoặc transformer (`droppable`, `restartable` từ `bloc_concurrency`) để chặn xử lý trùng lặp chưa?

### 3. Hiệu năng Tương tác API & Bên Thứ Ba (API & 3rd Party Performance)
- **Parse Payload nặng (JSON Deserialization):**
  - Khi nhận response dữ liệu lớn từ API bên thứ 3, việc parse JSON (`fromJson`) có gây khựng UI không? Đã tách việc parse sang Isolate chưa?
- **Yêu cầu Mạng dư thừa (Redundant Network Calls):**
  - API có bị gọi lại vô lý khi chuyển tab/rebuild màn hình không? Đã có cơ chế cache trong bộ nhớ (In-memory Cache / Repository Cache) để tránh gọi API trùng lặp trong thời gian ngắn chưa?
- **Quản lý Kết nối & Failure Resilience:**
  - Yêu cầu API có cấu hình `connectTimeout` và `receiveTimeout` rõ ràng chưa?
  - Đã có cơ chế hủy request (`CancelToken` trên Dio) khi người dùng thoát màn hình trước khi API trả về kết quả chưa?
  - Khi API bên thứ ba gặp sự cố (Rate Limit, 500, Timeout), ứng dụng có rơi vào vòng lặp tải vô tận (Infinite Loading) hay không?

---

🚨 ĐỊNH DẠNG BÁO CÁO REVIEW:

Trình bày kết quả theo các cấp độ nghiêm trọng:

1. 🔴 **CRITICAL (Lỗi Hiệu Năng Nghiêm Trọng):** Các vị trí gây đơ/khựng UI (Main Thread freeze), rò rỉ bộ nhớ chắc chắn xảy ra (Un-disposed streams/controllers), hoặc gọi API lặp vô tận. *(Kèm đoạn code bị lỗi & code đề xuất tối ưu)*
2. 🟠 **WARNING (Cảnh Báo Tối Ưu Hiệu Năng):** Rebuild diện rộng, thiếu `const`, parse JSON nặng trên UI Thread, thiếu debounce input. *(Kèm giải pháp khắc phục)*
3. 🟡 **OPTIMIZATION (Đề Xuất Cải Tiến Cấu Trúc):** Đề xuất bóc tách widget để thu nhỏ scope rebuild, sử dụng RepaintBoundary, hoặc thêm cache nhẹ.

Hãy bắt đầu đọc mã nguồn của tính năng mới và đưa ra Báo cáo Code Review chi tiết theo các tiêu chí trên.