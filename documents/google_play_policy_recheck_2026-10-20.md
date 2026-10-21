# Kiểm tra lại Google Play — 20/10/2026

**Kết luận: nên xử lý hai rủi ro cao về privacy và báo cáo nội dung trước khi gửi production.** Không có cơ sở để cam kết Google sẽ duyệt hoặc kết luận mọi mục chưa kiểm chứng đều là vi phạm.

## Phạm vi và bằng chứng

- HEAD lúc bắt đầu: `0281187`, working tree sạch. So với commit `4288eeb` của báo cáo trước, chỉ thay đổi báo cáo và version thành `1.0.0+2`; mã ứng dụng không đổi.
- Kiểm tra lại manifest/build config, dependency, khởi tạo SDK, analytics/crash reporting, auth và lưu trữ/network, legal/router, report/block, xóa tài khoản, video/player, bài tập và chia sẻ. Quét các dấu hiệu quyền nhạy cảm, TLS bypass, thanh toán ngoài ứng dụng. Đây là rà soát theo rủi ro trên toàn repo, không phải kiểm chứng từng dòng hoặc toàn bộ nội dung production.
- Đối chiếu trang chính sách chính thức ngày 20/10/2026. GET trực tiếp `https://vocabik.com/privacy`, `/terms`, `/delete-account`: cả ba HTTP 200. Lỗi DNS trong sandbox không phải bằng chứng website hỏng.
- Chạy lại `flutter test --no-pub build/policy_audit_2026_10_20/regressions_test.dart --reporter expanded`: **2 pass, 3 fail**, xác nhận lại report/block false-success và password whitespace. Test dùng fake, không tác động tài khoản thật. Lượt sandbox không có kết quả đã dừng; kết quả trên là lượt chạy ngoài sandbox.
- Không sửa mã app; không chạy lại toàn bộ test/analyzer, không build AAB mới trong lượt này. Manifest build đang có ghi versionCode 2, targetSdk 36; không coi file build sẵn là xác minh AAB sẽ upload. Kết quả build/ELF trong báo cáo trước chỉ là bằng chứng của lượt trước.
- Không có mã backend, Play Console, hồ sơ cấp phép nội dung hoặc kiểm thử thiết bị thật. Đánh giá đối tượng 13+ dựa trên nội dung legal hiện tại của app, chưa xác minh lựa chọn trong Console.

## Phát hiện cần xử lý

### 1. Cao — Privacy chưa phản ánh đầy đủ việc xử lý dữ liệu

`lib/l10n/app_en.arb:408–420` thiếu thời gian/tiêu chí lưu giữ và mô tả cụ thể định danh SDK/thiết bị, dữ liệu hiển thị công khai, cookies/công nghệ tương tự của nội dung nhúng. `lib/features/auth/presentation/bloc/auth_bloc.dart:56` gắn user ID với Analytics/Crashlytics, kèm tier/CEFR. `lib/core/services/analytics_service.dart:219` hỗ trợ gửi từ khóa tìm kiếm. Website privacy vẫn đề ngày 18/05/2026, có retention tổng quát nhưng không mô tả Firebase/YouTube; Terms web cũng chưa có chấp thuận YouTube Terms như mobile.

**Hành động:** lập inventory dữ liệu thực tế với backend/SDK; thống nhất privacy VI/EN/web, mô tả bên xử lý, retention/deletion, dữ liệu công khai, nội dung nhúng và quảng cáo nếu có. Điền Data safety theo bản phát hành thực tế; không khai “không thu thập dữ liệu”. Firebase là bên xử lý không tự động có nghĩa mọi trường đều phải khai là “shared”; cần xét ngoại lệ service provider.

Nguồn: [Google Play User Data](https://support.google.com/googleplay/android-developer/answer/10144311?hl=en), [YouTube Developer Policies III.A](https://developers.google.com/youtube/terms/developer-policies).

### 2. Cao — Thiếu đường báo cáo nội dung video/bài học

Tìm toàn bộ nơi gọi `submitReport`/`ReportUserDialog` chỉ thấy luồng báo cáo người dùng. `lib/features/video_detail/presentation/widgets/video_detail_content_view.dart` và các màn exercise chưa có đường báo cáo video/bản dịch/bài tập. API docs đã mô tả target video nhưng client chưa nối UI.

Google áp dụng UGC policy cả với client hướng người dùng đến nền tảng UGC. Với video YouTube trong Vocabik, thiếu báo cáo nội dung là rủi ro đáng xử lý. Đây là đánh giá phạm vi áp dụng policy, không phải bằng chứng có video production cụ thể vi phạm.

**Hành động:** thêm báo cáo gắn ID video/bài tập, lý do, chi tiết; kiểm backend nhận report, có người xử lý và cơ chế gỡ/ẩn nội dung. Kiểm nội dung phù hợp nhóm tuổi thật, không chỉ báo cáo người dùng.

Nguồn: [UGC policy](https://support.google.com/googleplay/android-developer/answer/9876937?hl=en).

### 3. Vừa — Report/block có thể báo thành công sai

`lib/features/moderation/data/repositories/moderation_repository_impl.dart:34` trả `Right` mà không kiểm `response.success`; block tương tự. Datasource còn tạo success nếu body không phải object. UI report dùng nhánh Right để hiện thông báo thành công. Hai test với `success:false` đều fail như dự đoán.

**Hành động:** thống nhất hợp đồng API, kiểm schema và business status trước khi báo thành công. Chưa chứng minh production thực tế trả HTTP 2xx/success:false; không kết luận mọi report/block đều hỏng.

### 4. Vừa — Xác nhận xóa tài khoản làm thay đổi password

`lib/features/profile/presentation/widgets/delete_account_confirmation_dialog.dart:157` và `:181` gọi `.trim()` trong khi validation password cho phép khoảng trắng. Widget test nhập ` password123 ` gửi thành `password123`.

**Hành động:** giữ nguyên mật khẩu ở hai nhánh submit, kiểm tài khoản email và OAuth. Ảnh hưởng đến tài khoản có mật khẩu chứa khoảng trắng nếu backend chấp nhận loại password đó.

### 5. Thấp đến vừa — Nút chia sẻ chưa hoàn thiện

`lib/features/video_detail/presentation/widgets/video_detail_content_view.dart:235` có handler rỗng; một số nút ở score card chỉ báo đang phát triển. Hoàn thiện hoặc ẩn khỏi release và không quảng bá chức năng chưa dùng được. Chưa có bằng chứng lỗi này riêng lẻ khiến toàn app không đáp ứng yêu cầu chức năng.

## Điều kiện cần nghiệm thu trước production

| Mục | Bằng chứng và việc cần làm |
| --- | --- |
| Xóa dữ liệu thật | Client có `DELETE /auth/me` và dọn local session. `documents/mobile-account-deletion-api.md:15` mô tả soft delete, sửa PII và xóa một số liên kết; chưa chứng minh xóa history, notebook, avatar, provider mapping, FCM, telemetry/backups. Web cam kết xóa vĩnh viễn nhiều loại dữ liệu, xóa trong app ngay và email trong 48 giờ làm việc. Kiểm bằng tài khoản test và bằng chứng DB/storage, đồng bộ retention. Thiếu mã backend không đủ để khẳng định backend vi phạm. |
| SDK và consent | Firebase khởi tạo trước UI; FIAM bật collection tại `lib/core/services/notification/in_app_messaging_service.dart:24`; Crashlytics bật ngoài debug. Manifest build có AD_ID. Kiểm traffic fresh install và mục đích/địa bàn; nếu cần consent trước thu thập phải gate SDK trước đó. Không mặc định mọi analytics đều cần cùng một popup consent, hoặc có AD_ID đồng nghĩa có quảng cáo. |
| Nhóm tuổi | Legal ghi 13+. Đối chiếu Target audience, IARC, quốc gia, nội dung và tương tác. Không coi 13+ là tự động miễn toàn bộ yêu cầu bảo vệ trẻ em ở mọi thị trường. |
| YouTube và quyền nội dung | Dùng iframe chính thức, custom controls ở ngoài player. Thử Home/khóa màn hình/đổi route, quảng cáo, referrer, viewport thực và orientation. Lưu hồ sơ quyền video, transcript/lời bài hát, bản dịch, ảnh và nội dung listing; video public không tự cấp quyền sao chép/chuyển thể. Không thấy hồ sơ trong repo không đồng nghĩa đã vi phạm bản quyền. |
| Kỹ thuật và Console | Source dùng HTTPS, secure storage; chưa thấy SMS/contacts/GPS/mic/camera, broad storage hoặc TLS bypass. Kiểm manifest của AAB cuối, API target, ký upload, 16 KB trên APK/thiết bị; Google Sign-In với Play App Signing. Hoàn tất Data safety/Ads/Advertising ID/App access và tài khoản review hoạt động; closed testing nếu account thuộc diện áp dụng. |
| Thanh toán | Chưa thấy luồng checkout/bán nội dung số hoạt động; không ghi thiếu Play Billing là vi phạm của bản hiện tại. Rà soát lại nếu mở bán. |

Nguồn đối chiếu: [Account deletion](https://support.google.com/googleplay/android-developer/answer/13327111?hl=en), [Target audience](https://support.google.com/googleplay/android-developer/answer/9867159?hl=en), [Intellectual property](https://support.google.com/googleplay/android-developer/answer/9888072?hl=en), [Target API](https://developer.android.com/google/play/requirements/target-sdk).

**Ưu tiên:** hoàn thiện privacy và báo cáo nội dung → sửa false-success/password → nghiệm thu xóa dữ liệu, moderation và quyền nội dung → kiểm bản release cuối cùng trên Play internal testing và hoàn thiện Console.
