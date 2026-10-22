# Kiểm tra Google Play trước phát hành — 21/10/2026

**Kết luận: nên xử lý privacy và nghiệm thu các điều kiện bên dưới trước khi gửi production.** Có một rủi ro cao xác nhận từ nội dung hiện tại (privacy chưa đầy đủ/đồng bộ), hai lỗi chức năng mức vừa đã tái hiện, và những rủi ro tác động cao chưa thể kết luận nếu không có backend, hồ sơ nội dung và Play Console. Không có căn cứ cam kết Google sẽ duyệt hoặc gọi mọi mục chưa kiểm chứng là vi phạm.

## Phạm vi và bằng chứng

- HEAD `0e45ff4`; working tree sạch lúc bắt đầu; 759 file tracked. Rà soát theo rủi ro xuyên cấu hình Android, dependencies, khởi tạo SDK, auth/legal, lưu trữ/network, profile/xóa tài khoản, moderation, video/bài tập, chia sẻ/deep link, notification, tài liệu API và CI. Đây không phải kiểm chứng từng dòng, toàn bộ catalog production hoặc kiểm toán backend.
- Đọc mã hiện tại và so sánh với mốc `0281187` của báo cáo trước: app đã bổ sung báo cáo nội dung và chia sẻ. Không lặp lại các phát hiện đã hết hiệu lực.
- Đối chiếu nguồn Google chính thức ngày 21/10/2026. GET trực tiếp `/privacy`, `/terms`, `/delete-account` trên `https://vocabik.com`: cả ba HTTP 200. Bản HTML được lưu ở `build/policy_audit_2026_10_21/`. Lỗi DNS ở lượt sandbox không phải bằng chứng website hỏng; lượt ngoài sandbox thành công.
- Các test liên quan cộng test audit có sẵn: **46 pass, 3 fail**. Ba fail là report rejection, block rejection và giữ nguyên khoảng trắng mật khẩu xóa tài khoản; dùng fake/mock, không tác động người dùng thật. Log: `build/policy_audit_2026_10_21/tests.log`; nguồn test audit: `build/policy_audit_2026_10_20/regressions_test.dart`.
- Toàn bộ test hiện có trong `test/`: **221 pass, 1 fail**. Test fail tìm kiểu widget cũ sau refactor dialog, mô tả bên dưới. Log: `build/policy_audit_2026_10_21/full_tests.log`.
- Kiểm tra tĩnh `dart analyze lib test packages`: **No issues found**, exit 0; log `build/policy_audit_2026_10_21/analyze_dart.log`. Dùng Dart analyzer trực tiếp sau khi `flutter analyze --no-pub` không trả kết quả và đã dừng; không báo lệnh Flutter analyze là pass. Cache audio sinh ra bởi test đã chuyển vào thư mục bằng chứng trong `build/`.
- OCR không chạy được vì chưa cấu hình LLM endpoint; không dùng kết quả OCR làm bằng chứng. Rà soát thủ công tiếp tục độc lập.
- Không sửa mã ứng dụng, không gửi report/xóa tài khoản thật, không publish. Chưa có quyền Play Console, mã backend, kiểm thử thiết bị/network capture, catalog đầy đủ hoặc hồ sơ cấp phép. Chưa build AAB mới trong lượt này.

## 1. Cao — Privacy trong app thiếu retention và chưa đồng bộ web

**Đã xác nhận:** `lib/l10n/app_en.arb:435–447` và bản VI tương ứng không nêu thời gian/tiêu chí lưu giữ dữ liệu. Mô tả SDK chỉ ở mức tên dịch vụ, chưa đủ chi tiết về định danh SDK/thiết bị và công nghệ thu thập của YouTube nhúng. Website privacy đề ngày 18/05/2026, có retention tổng quát nhưng không nêu Firebase/YouTube. Terms web chưa có chấp thuận YouTube Terms như mobile. Không phải ngày cũ tự nó là vi phạm; vấn đề là phạm vi disclosure khác nhau.

Mã thực tế gắn user ID vào Analytics/Crashlytics và thêm tier/CEFR (`lib/features/auth/presentation/bloc/auth_bloc.dart:56`). Crashlytics bật collection ngoài debug (`lib/core/services/crashlytics_service.dart:47`); FIAM bật automatic collection lúc khởi tạo (`lib/core/services/notification/in_app_messaging_service.dart:24`); Firebase/notifications được khởi tạo trước UI trong `lib/main.dart`. Analytics service còn hỗ trợ search, tiến độ, nội dung và từ vựng; cần đối chiếu nơi gọi/traffic để xác nhận trường thực gửi, không coi mọi phương thức hỗ trợ đều đang được sử dụng.

**Cần làm:** lập inventory với backend/SDK; thống nhất privacy VI/EN/web về dữ liệu, mục đích, bên xử lý, dữ liệu hồ sơ/bảng xếp hạng được người khác nhìn thấy, retention/deletion và nội dung nhúng. Nếu cần consent theo loại dữ liệu/mục đích/thị trường, chặn collection tương ứng trước consent; màn chấp thuận legal sau đăng nhập hiện không chặn được SDK khởi tạo từ đầu.

Google yêu cầu privacy mô tả đúng xử lý dữ liệu, bao gồm chính sách lưu giữ/xóa: [User Data](https://support.google.com/googleplay/android-developer/answer/10144311?hl=en). YouTube có yêu cầu disclosure về bên thứ ba, quảng cáo nếu có, cookies/công nghệ tương tự: [Developer Policies III.A](https://developers.google.com/youtube/terms/developer-policies).

**Data safety chưa được kiểm chứng:** phải điền theo bản release thực tế. Không khai “không thu thập dữ liệu” khi app và SDK có thu thập. Phân loại dữ liệu gửi cho service provider theo định nghĩa/ngoại lệ của form; không tự động đánh đồng mọi xử lý bởi Firebase với “shared”. Cần kiểm cả email, user ID, tiến độ, app interactions, diagnostics và identifiers thực tế.

## 2. Vừa — Báo cáo/chặn có thể báo thành công sai

**Đã tái hiện:** `lib/features/moderation/data/repositories/moderation_repository_impl.dart:34`, `:48`, `:62` trả `Right(response)` mà không kiểm `response.success`. Datasource còn mặc định thành công khi body không phải object (`lib/features/moderation/data/datasources/moderation_remote_data_source.dart:32`); model mặc định `success: true` khi thiếu trường. UI `ReportContentDialog` dùng nhánh Right để đóng dialog và hiện thông báo thành công, kể cả phản hồi `success: false`.

Hai test giả lập report/block bị từ chối đều fail. Chưa chứng minh production có trả HTTP 2xx với `success: false`; không kết luận mọi report/block đều hỏng.

**Cần làm:** thống nhất hợp đồng API, kiểm schema/business status và chỉ hiện thành công khi server xác nhận. Thử end-to-end việc report vào hàng đợi kiểm duyệt và block chặn tương tác/challenge/push thật, không chỉ ẩn giao diện. Google yêu cầu moderation UGC hoạt động hiệu quả và liên tục: [UGC policy](https://support.google.com/googleplay/android-developer/answer/9876937?hl=en).

**Đã cải thiện:** nút báo cáo video hiện có ở `video_detail_content_view.dart:81` và bài tập ở `exercise_screen.dart:132`, đều gửi `targetType: 'video'`. Phát hiện “thiếu đường báo cáo video/bài học” trong báo cáo cũ không còn đúng ở client hiện tại. Quy trình tiếp nhận/xử lý/gỡ nội dung phía server vẫn cần nghiệm thu.

## 3. Vừa — Xác nhận xóa tài khoản làm thay đổi mật khẩu

**Đã tái hiện:** `lib/features/profile/presentation/widgets/delete_account_confirmation_dialog.dart:157` và `:181` gọi `_passwordController.text.trim()`. Validator `lib/features/auth/presentation/models/password_input.dart:10` cho phép khoảng trắng. Test nhập ` password123 ` cho thấy cubit nhận `password123`.

**Tác động:** nếu backend chấp nhận mật khẩu có khoảng trắng đầu/cuối, người dùng có thể không xác nhận xóa được bằng mật khẩu đúng. Đây là lỗi có điều kiện, chưa phải bằng chứng mọi tài khoản không xóa được.

**Cần làm:** giữ nguyên mật khẩu ở cả nhánh Enter và nút xác nhận; thử tài khoản email/password và Google OAuth. Nguồn: [Account deletion requirements](https://support.google.com/googleplay/android-developer/answer/13327111?hl=en).

## Các điều kiện có tác động cao cần xác minh trước production

| Nhóm | Bằng chứng hiện có và tiêu chí nghiệm thu |
| --- | --- |
| Xóa dữ liệu backend | Client đã gọi `DELETE /auth/me` và dọn local session. `documents/mobile-account-deletion-api.md:15` mô tả soft delete, sửa PII, xóa password và một số liên kết; chưa chứng minh xử lý toàn bộ history, notebook, avatar, OAuth mapping, FCM, telemetry/backups. Web cam kết xóa vĩnh viễn nhiều loại dữ liệu, ngay trong app và trong 48 giờ làm việc qua email. Dùng tài khoản test để đối chiếu DB/storage, thu hồi mọi phiên và thực hiện cam kết retention. Soft delete không tự động là vi phạm nếu dữ liệu thực được xóa/ẩn danh phù hợp; riêng vô hiệu hóa tài khoản không đủ. |
| Quyền sử dụng nội dung | Video public trên YouTube không tự cấp quyền sao chép transcript, lời bài hát, bản dịch, thumbnail hoặc ảnh vào bài tập/listing. Repo có luồng lấy bài tập/bản dịch từ API nhưng không có bằng chứng nguồn và giấy phép đầy đủ. Cần hồ sơ provenance/quyền cho catalog và assets, đặc biệt nhạc/phim. Thiếu hồ sơ trong repo chưa chứng minh đã vi phạm. |
| YouTube player | Dùng iframe player, custom controls ở ngoài vùng phát, source có constraints tối thiểu 200×200. Không thấy code tải riêng audio/video YouTube. Cần thử trên thiết bị: Home/khóa màn hình/đổi route, ads, logo/link, referrer/origin, viewport và orientation. `showControls: false` riêng nó không đủ để kết luận vi phạm. Chưa có kiểm chứng runtime rằng playback luôn dừng khi player không còn được nhìn thấy. |
| Nhóm tuổi và catalog | Legal hiện ghi 13+. Đây là thông tin từ mã hiện tại, chưa xác minh cấu hình Console. Đối chiếu Target audience, IARC, quốc gia, nội dung video/lời bài hát/bản dịch và các tương tác giữa người dùng. Cần quy trình moderation cho người dùng vị thành niên; chữ 13+ không tự chứng minh toàn bộ catalog phù hợp. |
| SDK/Advertising ID | Manifest release build cũ có AD_ID, attribution/ads services, network/wake lock và biometric từ dependencies. AD_ID không tự chứng minh đang hiển thị quảng cáo. Cần kiểm merged manifest/AAB cuối, SDK data collection và khai Advertising ID/Ads/Data safety theo hành vi thật. Loại các quyền/thu thập không sử dụng sau khi xác nhận dependency. |
| Bản release/Console | AAB đang có được build ngày 20/10, trước thay đổi mới; không dùng làm chứng nhận bản sắp upload. Source dùng `flutter.targetSdkVersion`, manifest build cũ ghi 36. Kiểm lại AAB cuối có target API phù hợp, release signing, native libs/16 KB, Play App Signing SHA cho Google login, assetlinks, App access và tài khoản reviewer hoạt động. Hoàn tất test track/điều kiện tài khoản nếu Console yêu cầu. |

Chính sách liên quan: [User Data/account deletion](https://support.google.com/googleplay/android-developer/answer/10144311?hl=en), [Intellectual Property](https://support.google.com/googleplay/android-developer/answer/9888072?hl=en), [YouTube Developer Policies](https://developers.google.com/youtube/terms/developer-policies). Trang Android hiện quy định app mới/update từ 31/08/2026 target **API 36+** cho điện thoại: [Target API](https://developer.android.com/google/play/requirements/target-sdk). Kiểm tương thích native theo hướng dẫn [16 KB page sizes](https://developer.android.com/guide/practices/page-sizes); không suy ra đạt chỉ từ phiên bản NDK/Flutter.

## Những điểm chưa thấy dấu hiệu rủi ro cao trong mã hiện tại

- API chính dùng HTTPS; token lưu bằng secure storage; quét source không thấy TLS bypass hay yêu cầu SMS, contacts, location, microphone/camera, broad storage, accessibility hoặc cài APK.
- Chưa thấy luồng checkout/bán nội dung số hoạt động hay SDK Play Billing trong dependency hiện tại. Không coi thiếu Billing là vi phạm ở bản hiện tại. Nếu bật premium/subscription cần đánh giá lại cơ chế thanh toán và ngoại lệ áp dụng.
- Chia sẻ bài học và score card hiện đã có triển khai, thay thế handler rỗng cũ. Luồng ảnh score card tạo URL trên cùng API backend; không xác nhận một lỗi gửi token sang host ngoài từ luồng hiện tại.
- Chưa thấy luồng AI sinh nội dung trực tiếp cho người dùng trong client. Chưa có mã backend để phân loại các chức năng AI phía server nếu có.

## Test suite cần cập nhật

`test/core/utils/auth_utils_test.dart:395` vẫn tìm `ReportUserDialog`, trong khi `ReportUserDialog.show()` hiện gọi `ReportContentDialog.show()` và mở widget mới. Failure xác nhận assertion không còn khớp cấu trúc widget; chưa chứng minh chức năng báo cáo người dùng khác bị chặn. Cần sửa assertion theo hành vi và giữ kiểm tra người dùng trùng tên/được đặt tên “You”. Đây là mục chất lượng kiểm thử, không phải phát hiện policy riêng.

## Thứ tự xử lý

1. Hoàn thiện và thống nhất privacy/data inventory; chuẩn bị Data safety tương ứng.
2. Sửa false-success moderation và giữ nguyên mật khẩu xóa tài khoản; chạy lại các test audit đang fail.
3. Nghiệm thu xóa dữ liệu, moderation và quyền sử dụng catalog với backend; kiểm player trên thiết bị.
4. Build AAB từ commit cuối, thử qua Play internal testing/pre-launch report và hoàn tất Console.

Các tài liệu và log này hỗ trợ quyết định phát hành; chưa thay thế bằng chứng runtime/backend hoặc kết quả duyệt Google Play.
