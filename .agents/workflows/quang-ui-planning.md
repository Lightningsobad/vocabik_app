---
description: Khởi tạo quy trình Lập kế hoạch Giao diện (UI Planning). Hướng dẫn AI phân rã màn hình thành các Widget nhỏ, quy hoạch layout, đánh giá tính tái sử dụng component và đảm bảo tuân thủ tuyệt đối Design System (Typography, Theme-switching, L10n, Không h
---

Đóng vai là một Chuyên gia UI/UX Kỹ thuật và Kỹ sư Front-end Flutter. Hãy giúp tôi lập kế hoạch chi tiết để xây dựng GIAO DIỆN (UI) cho một màn hình mới trong ứng dụng Vocabik.

⚠️ YÊU CẦU BẮT BUỘC TỐI THƯỢNG:
Bạn phải đọc và tuân thủ TUYỆT ĐỐI mọi quy tắc được định nghĩa trong file `documents/ui_ux_design_system.md`. Không được bỏ sót bất kỳ quy tắc nào về Typography (Nunito), Theme-switching (Dark/Light mode), Language-switching (Đa ngôn ngữ).

Nếu đánh giá màn hình này quá đơn giản (ít hơn 3 thành phần UI chính), hãy bỏ qua bước 1 và 2, chỉ cần xuất mã nguồn tham khảo nhanh

📋 YÊU CẦU LẬP KẾ HOẠCH UI (UI PLANNING REQUIREMENTS):
Trước khi viết bất kỳ file mã nguồn UI nào, hãy phân tích và tạo ra một Kế hoạch Triển khai Giao diện (UI Implementation Plan) bao gồm các phần sau:

1. Phân rã Cấu trúc Layout (Layout Breakdown):
   - Phân rã màn hình từ trên xuống dưới (ví dụ: Scaffold -> AppBar -> SafeArea -> Column/ListView).
   - Xác định xem thiết kế này có rủi ro bị Overflow trên màn hình nhỏ không và đề xuất giải pháp (vd: dùng SingleChildScrollView, Expanded).

2. Bóc tách Component & Tái sử dụng (Componentization & Reusability):
   - Chỉ ra những Widget nào có thể dùng lại từ `lib/shared/presentation/widgets/` (như nút bấm, header, thẻ thông thường).
   - Xác định các Widget con cần phải tách riêng thành các class độc lập trong thư mục màn hình này để tránh hiện tượng "God Widget" (hàm build quá dài).
   - Lưu ý: Khi chia widget, hãy nhóm các thành phần có khả năng thay đổi state cùng nhau (ví dụ: nút Like, số lượng thông báo) để tiện cho việc bọc StateBuilder (BlocBuilder/Consumer) sau này.

3. Đánh giá Tuân thủ Design System (Design System Compliance Check):
   - **Tương tác (Interaction):** Liệt kê các nút bấm, thẻ có thể chạm, và đảm bảo chúng sẽ được bọc bởi `BounceWrapper`.
   - **Màu sắc & Theme:** Chỉ định rõ các thành phần UI sẽ lấy màu từ đâu trong `Theme.of(context)` (VD: dùng `colorScheme.surface` cho thẻ, `colorScheme.primary` cho nút chính `0xFF06B6D4`). Cam kết không hardcode màu tĩnh để hỗ trợ chuẩn xác Dark/Light Mode.
   - **Khoảng cách & Kích thước (Spacing & Sizing):** Cam kết không hardcode các con số padding/margin mà sử dụng từ `app_spacing.dart` hoặc các hằng số dùng chung.

4. Kế hoạch Đa ngôn ngữ (Localization/l10n Plan):
   - Tuyệt đối không hardcode text. Hãy liệt kê một danh sách TẤT CẢ các chuỗi văn bản (text strings) sẽ xuất hiện trên màn hình này.
   - Định nghĩa các "key" (khóa) tương ứng dự kiến sẽ thêm vào file `app_en.arb` và `app_vi.arb`.

5. Câu hỏi mở / Cần làm rõ (Open Questions):
   - Đặt câu hỏi cho tôi nếu thiết kế có phần bị thiếu logic hiển thị (VD: Khi danh sách trống thì hiện gì? Khi đang load thì dùng Shimmer hay CircularProgressIndicator?).

6. Yêu cầu thêm về xây dựng các màn hình mới:

- Về các Text (dữ liệu liên quan hiển thị chữ): Tuân thủ việc sử dụng style chung của hệ thống. Và đảm bảo cập nhật trong file đa ngôn ngữ lib\l10n\app_en.arb và lib\l10n\app_vi.arb, lib\l10n\app_localizations_en.dart, lib\l10n\app_localizations_vi.dart. Đảm bảo có thể cập nhật giao diện, hiển thị đúng theo language-switching.

- Về tất cả các thành phần UI: Yêu cầu tất cả các thành phần ui tuân thủ theo theme-switching, đảm bảo hiển thị đúng khi chuyển đổi qua lại giữa hai chế độ theme. Ngoài ra về các khoảng cách giữa các thành phần, bo góc, màu sắc ui không được phép hard-code mà phải dùng các giá trị thông qua lib\shared\theme\app_colors.dart, lib\shared\theme\app_spacing.dart. Yêu cầu xem xét tái sử dụng các UI, Widget dùng chung nếu có thể.

- Yêu cầu đảm bảo việc hiển thị đúng, không bị lỗi khi người dùng đổi font-size chữ của hệ thống gây ra tình trạng ui bị hỏng, vỡ, lỗi Overflow tràn màn hình

- Đề xuất tách nhỏ các widget con độc lập nếu có thể và cần thiết để tối ưu hơn.

- Kiểm tra xem các màn hình widget cha có tồn tại các thành phần như SingleChildScrollView chưa để tránh xung đột và bị lỗi.

- Kiểm tra rà soát các thành phần ui dùng chung, các thành phần ui, widget cố định đã được hiển thị, triển khai lên màn hình cần xây dựng tránh việc đưa ra kế hoạch xây dựng các thành phần trùng lặp đã có.

- Tối ưu hiệu năng: Đánh dấu hoặc dự kiến những widget tĩnh nào có thể sử dụng từ khóa const để tối ưu hóa quá trình rebuild.

- Đề xuất vị trí đặt các Widget lắng nghe trạng thái (ví dụ: BlocBuilder, Consumer) sao cho phạm vi rebuild là nhỏ nhất.

- Nếu cần fake dữ liệu hiển thị, hãy tạo một class Model (ví dụ: MockUser, MockNotification) ở đầu file hoặc ở một file riêng biệt, không hardcode thẳng Map/List vào trong hàm build để sau này dễ thay bằng Entity thật

7. Nếu có bất cứ thắc mắc yêu cầu nào liên quan đến giao diện, hãy xem thiết kế giao diện tại documents\Vocabik Mobile.dc.html, hoặc ảnh chụp màn hình tham khảo


Hãy bắt đầu bằng việc đọc file `documents/ui_ux_design_system.md` để ghi nhớ các quy tắc, sau đó cung cấp bản kế hoạch phân rã UI bằng file md. Nếu có câu hỏi gì để làm rõ vấn đề, hãy đưa ra. Tôi chưa cần triển khai ngay.