**Rà soát Google Play và Google services — Vocabik — 09/10/2026**

**Kết luận: chưa nên gửi bản hiện tại để xét duyệt production.** Có lỗi xác nhận được ở báo cáo người dùng, URL xóa tài khoản và nội dung privacy; đồng thời còn vấn đề tích hợp YouTube. Đợt sửa sau audit 08/10 đã cải thiện nhiều điểm nhưng chưa giải quyết đầy đủ yêu cầu phát hành.

Phạm vi: repository `D:\App\vocabik_app`, HEAD `637dcc9`, working tree sạch khi bắt đầu. Đã kiểm kê cấu trúc, dependencies, native Android, cấu hình build/CI, tìm xuyên mã nguồn và đọc các luồng rủi ro: auth, hồ sơ, legal, API, lưu trữ, telemetry, thông báo, YouTube/bài tập, leaderboard, bạn bè, nội dung học tập. Đối chiếu chính sách Google đang công bố tại ngày kiểm tra. Đây là audit theo rủi ro, không phải chứng nhận từng dòng mã hay đảm bảo Google sẽ duyệt.

Chưa có quyền xem backend, Play Console, cấu hình Firebase/OAuth production hoặc giấy phép nội dung. Chưa chạy app trên thiết bị hoặc tạo AAB mới. Merged manifest release sẵn có được ghi ngày 08/10/2026; APK release sẵn có ngày 16/09/2026, vì vậy không dùng APK cũ để khẳng định trạng thái bản phát hành hiện tại.

**1. Cao — Báo cáo người dùng báo thành công nhưng không gửi báo cáo; chưa có chặn người dùng.**

- [report_user_dialog.dart:126](D:/App/vocabik_app/lib/shared/presentation/widgets/dialogs/report_user_dialog.dart:126): nút gửi chỉ `pop()` và hiện SnackBar. Không có API, callback, hàng đợi hay lưu trữ báo cáo. Lý do đã chọn không được gửi; dialog chỉ nhận tên, không nhận ID người bị báo cáo.
- [shared_leaderboard_tile.dart:193](D:/App/vocabik_app/lib/shared/presentation/widgets/leaderboard/shared_leaderboard_tile.dart:193) mở dialog này từ người dùng khác. [app_vi.arb:615](D:/App/vocabik_app/lib/l10n/app_vi.arb:615) khẳng định báo cáo đã được chuyển tới kiểm duyệt dù code không thực hiện.
- Client cho chỉnh `displayName`, render tên/avatar trên leaderboard và có luồng thách đấu bạn bè. Không tìm thấy chức năng block trong client; backend kiểm duyệt chưa được kiểm chứng. Theo chính sách UGC, cần cơ chế báo cáo/kiểm duyệt thực sự và blocking phù hợp phạm vi công khai hoặc tương tác 1:1. [Google Play UGC](https://support.google.com/googleplay/android-developer/answer/9876937?hl=en).
- Sửa: truyền `userId`, lý do và ngữ cảnh đến hệ thống tiếp nhận, chỉ báo thành công khi nhận xác nhận; có lỗi/retry; triển khai chặn và xử lý ở backend để ngăn tương tác/thông báo tiếp theo. Nếu chưa triển khai được, cân nhắc bỏ toàn bộ tính năng công khai/tương tác liên quan trong bản đầu, thay vì chỉ bỏ nút report.
- Nghiệm thu: tạo báo cáo bằng tài khoản test và thấy bản ghi trong hệ thống moderation; mất mạng không báo thành công; người bị chặn không tiếp tục gửi thách đấu. Test dialog hiện tại chỉ kiểm tra giao diện/SnackBar, không chứng minh báo cáo được tiếp nhận.

**2. Cao — URL xóa tài khoản trong app trả 404; đường yêu cầu trong app khó tìm.**

- [app_vi.arb:407](D:/App/vocabik_app/lib/l10n/app_vi.arb:407) và bản EN dẫn tới `https://vocabik.com/delete-account`. HTTP GET trực tiếp ngoài sandbox ngày 09/10 trả **404 Not Found**. Đây là kết quả kiểm tra URL cụ thể tại thời điểm audit.
- [account_tab_content.dart:40](D:/App/vocabik_app/lib/features/profile/presentation/widgets/account_tab_content.dart:40) hiện chỉ còn đăng xuất; nút xóa cũ đã bị bỏ. Trong Privacy Policy có link xóa bấm được và email liên hệ bấm được, vì vậy không kết luận app hoàn toàn không có đường yêu cầu. Tuy nhiên link web đang lỗi, mục tài khoản không dẫn tới yêu cầu xóa, và chưa xác minh quy trình tiếp nhận email.
- Router còn chuyển người chưa xác minh email/chưa hoàn thành CEFR ra khỏi các trang legal: [app_router.dart:106](D:/App/vocabik_app/lib/core/routes/app_router.dart:106). Cần để legal và yêu cầu xóa truy cập được trong các trạng thái này.
- Google yêu cầu đường yêu cầu xóa dễ tìm trong app và tài nguyên web bên ngoài; không bắt buộc phải có API xóa tự động tức thì. [Account deletion requirements](https://support.google.com/googleplay/android-developer/answer/13327111?hl=en).
- Sửa: thêm mục “Yêu cầu xóa tài khoản” trong Settings dẫn tới trang hoạt động hoặc quy trình hỗ trợ rõ ràng; sửa URL công khai, ghi tên Vocabik/nhà phát triển, dữ liệu xóa/giữ, thời gian xử lý và cách xác minh. Đồng bộ URL trên Play Console.
- Nghiệm thu: người đã gỡ app vẫn yêu cầu được; kiểm thử một yêu cầu thật bằng tài khoản test, xử lý dữ liệu liên quan và thu hồi phiên. Chưa gửi email hoặc yêu cầu xóa thật trong audit này.

**3. Cao — Privacy Policy thiếu thông tin và bản VI mô tả sai tính ẩn danh.**

- [app_vi.arb:405](D:/App/vocabik_app/lib/l10n/app_vi.arb:405) vẫn mô tả “nhật ký lỗi chẩn đoán ẩn danh”. [auth_bloc.dart:56](D:/App/vocabik_app/lib/features/auth/presentation/bloc/auth_bloc.dart:56) gắn `user.id` vào Analytics và Crashlytics, kèm tier và CEFR. Bản EN đã đổi sang “pseudonymous”; bản VI chưa đồng bộ.
- Các mục privacy tại [app_en.arb:394](D:/App/vocabik_app/lib/l10n/app_en.arb:394) chưa giải thích chính sách lưu giữ/xóa, dữ liệu kỹ thuật/định danh SDK và cách xử lý đầy đủ. Tiêu đề Cookies không có nội dung thực chất về cookies hoặc lưu trữ của nội dung nhúng. Ngày cập nhật vẫn 15/06/2026 dù nội dung đã thay đổi.
- Google yêu cầu privacy phản ánh thực tế xử lý dữ liệu, gồm chính sách retention/deletion. [User Data](https://support.google.com/googleplay/android-developer/answer/10144311?hl=en). Với player YouTube, cần bổ sung disclosure về nội dung bên thứ ba, quảng cáo và cookies/công nghệ tương tự theo hành vi thực tế. [YouTube Developer Policies III.A](https://developers.google.com/youtube/terms/developer-policies).
- Kiểm tra thử `https://vocabik.com/privacy-policy` cũng trả **404**. Đây là URL kiểm tra theo tên route client, chưa biết URL nào thực sự được khai trên Console; không kết luận website không có privacy ở mọi đường dẫn.
- Sửa: viết lại VI/EN và bản web dựa trên data inventory/backend thực tế; nêu dữ liệu gắn tài khoản, dữ liệu SDK, mục đích, bên xử lý, phạm vi công khai trên bảng xếp hạng, lưu giữ/xóa và contact. Không tự đặt thời hạn mà hệ thống chưa đáp ứng.

**4. Cao — Luồng Google ở màn đăng nhập có thể bỏ qua đồng ý legal.**

- [login_screen.dart:98](D:/App/vocabik_app/lib/features/auth/presentation/screens/login_screen.dart:98) cho “Continue with Google” trực tiếp, không có thông báo chấp thuận hay link Terms/Privacy trên màn này. `LoginCubit` gọi cùng Google mobile auth dùng cho đăng ký; sau thành công vào app. User model/router không có bước kiểm tra phiên bản legal đã đồng ý.
- Màn đăng ký có thông báo Terms/Privacy tại [register_screen.dart:219](D:/App/vocabik_app/lib/features/auth/presentation/screens/register_screen.dart:219), nhưng đường đăng nhập Google không phải đi qua đó. Cần xác minh backend có tạo tài khoản lần đầu qua endpoint này; client hiện cho phép đi tiếp mà không có bước legal riêng.
- YouTube yêu cầu người dùng đồng ý privacy trước khi dùng chức năng API client; UGC cũng yêu cầu chấp thuận điều khoản trước khi tạo nội dung. Đây không phải kết luận rằng mọi Analytics đều bắt buộc có popup consent riêng.
- Sửa: làm rõ sự đồng ý trên cả hai đường, chặn chức năng cần điều khoản cho đến khi người dùng chấp thuận; nên ghi nhận phiên bản legal. OAuth consent của Google không thay cho điều khoản riêng của Vocabik. Nghiệm thu bằng tài khoản Google lần đầu chưa từng đăng ký web.

**5. Cao — Player YouTube chưa truyền định danh app vào origin/base URL.**

- [exercise_screen.dart:116](D:/App/vocabik_app/lib/features/exercise/presentation/screens/exercise_screen.dart:116) không cấu hình `origin`.
- Đã đọc dependency được resolve `youtube_player_iframe 6.0.2`: `YoutubePlayerParams.origin` mặc định null; `YoutubePlayerController.init()` dòng 269 chọn `params.origin ?? params.host`; host mặc định là `https://www.youtube-nocookie.com`, sau đó gọi `loadHtmlString(..., baseUrl: ...)`. Không tìm thấy bước lấy Android app ID để thay giá trị này.
- YouTube yêu cầu embedded player nhận diện API client qua Referer; WebView cần base URL/header phù hợp, với định dạng app identifier khi cung cấp rõ ràng. [Required Minimum Functionality — API Client Identity](https://developers.google.com/youtube/terms/required-minimum-functionality).
- Sửa: cấu hình định danh phù hợp cho từng platform; với Android hiện tại cần đối chiếu `https://com.snapsofts.vocabik.yt`. Kiểm chứng request thật trong WebView release. Có rủi ro giảm chức năng/từ chối playback; chưa tái hiện lỗi playback trên thiết bị nên không khẳng định hiện mọi video đều lỗi.

**6. Vừa — Player có thể nhỏ hơn viewport tối thiểu của YouTube.**

- [exercise_video_player_widget.dart:27](D:/App/vocabik_app/lib/features/exercise/presentation/widgets/exercise_video_player_widget.dart:27) cố định 16:9, không có min height. [exercise_screen.dart:310](D:/App/vocabik_app/lib/features/exercise/presentation/screens/exercise_screen.dart:310) landscape chỉ dành 5/11 chiều rộng, còn trừ padding ngang 20.
- Suy ra từ layout: portrait rộng 320 cho player 320×180; landscape có 800 chiều rộng khả dụng cho player khoảng 343.6×193.3. HTML của dependency dùng viewport `width=device-width, initial-scale=1.0`. Cần đo viewport CSS thực tế trên máy; không dùng số pixel vật lý màn hình để bỏ qua giới hạn này.
- YouTube yêu cầu viewport tối thiểu 200×200. [Embedded player size](https://developers.google.com/youtube/terms/required-minimum-functionality).
- Sửa layout cho màn nhỏ/landscape/bàn phím, đo viewport thực tế; giữ đủ vùng video và điều khiển. Kiểm tra riêng Home/lock screen/đổi route và quảng cáo: app không có handler pause theo lifecycle, dependency quan sát metrics nhưng không thấy handler lifecycle pause. Đây là mục kiểm thử chưa xác nhận phát nền, không phải bằng chứng app đã phát nền trái phép.

**7. Vừa — Log thông báo còn chứa dữ liệu người dùng ở release.**

- [fcm_service.dart:146](D:/App/vocabik_app/lib/core/services/notification/fcm_service.dart:146), dòng 182/191 ghi toàn bộ payload; [notification_router_handler.dart:56](D:/App/vocabik_app/lib/core/services/notification/notification_router_handler.dart:56) cũng ghi toàn bộ `data`, không bọc `kDebugMode`.
- Payload có các trường tên người thách đấu/avatar/video. `debugPrint` không tự bị loại ở release. Đây là rủi ro tối thiểu hóa dữ liệu và log chẩn đoán, không chứng minh đã có bên thứ ba lấy dữ liệu hoặc Google chắc chắn từ chối.
- Sửa: chỉ ghi type/mã sự kiện không nhạy cảm hoặc giới hạn debug; lọc dữ liệu trước khi ghi log/crash. Lỗi lộ Authorization trực tiếp trong profile ở audit cũ đã được sửa, không lặp lại kết luận cũ.

**8. Vừa — Nút Google dùng chữ G tự vẽ.**

- [login_screen.dart:100](D:/App/vocabik_app/lib/features/auth/presentation/screens/login_screen.dart:100) và [register_screen.dart:135](D:/App/vocabik_app/lib/features/auth/presentation/screens/register_screen.dart:135) render `Text('G')`, font Nunito, màu xanh đơn.
- Google Sign-In yêu cầu biểu tượng G chuẩn; hướng dẫn không cho dùng phiên bản đơn sắc/tự tạo. Thay bằng asset/nút chính thức, kiểm tra cả dark/light. Đây là vấn đề Google Identity branding, phân biệt với kết luận vi phạm Google Play. [Google Sign-In branding](https://developers.google.com/identity/branding-guidelines).

**Các điểm đã được sửa so với báo cáo 08/10**

| Phát hiện cũ | Tình trạng hiện tại |
| --- | --- |
| Authorization token trong lỗi update profile | Đã bỏ header khỏi thông báo 401, trả lỗi chung. |
| Deep link in token; social login in email | Deep link chỉ in scheme/host/path trong debug; các log social auth được giới hạn debug và đã bỏ email. |
| Token lưu SharedPreferences | Đã dùng FlutterSecureStorage, có migration và xóa key cũ. Cần kiểm thử upgrade/backup/logout trên thiết bị. |
| Custom controls che player, chặn pointer | Controls đã chuyển xuống dưới, pointer dùng `initial`. `showControls: false` là tham số hợp lệ, không tự coi là lỗi. |
| Thiếu link YouTube Terms/Google Privacy | Đã bổ sung VI/EN và widget biến URL thành link bấm được. |
| Terms thiếu quy định hành vi | Đã có nội dung cấm abuse/harassment; hệ thống report/block vẫn chưa hoàn thiện. |
| Release âm thầm ký debug | Đã có Gradle guard chặn assemble/bundle/package release khi thiếu signing; chỉ cho test debug signing nếu chủ động bật property. |
| Export/change password/avatar chưa làm | Đã bỏ các nút placeholder liên quan khỏi UI đang rà soát. Việc bỏ nút xóa tài khoản không tự hoàn tất yêu cầu account deletion. |

**Data safety và SDK — cần chốt trước khi gửi Console**

Không thể khai app “không thu thập dữ liệu”. Dữ liệu đi đến backend và SDK phải được đối chiếu theo phiên bản/cấu hình phát hành. “Collected” và “shared” là hai khái niệm khác nhau; dữ liệu gửi nhà cung cấp dịch vụ không tự động luôn phải đánh dấu shared, cần xét định nghĩa/ngoại lệ của biểu mẫu. [Data safety guidance](https://support.google.com/googleplay/android-developer/answer/10787469?hl=en), [Firebase disclosure](https://firebase.google.com/docs/android/play-data-disclosure).

| Nhóm cần đối chiếu | Bằng chứng và phạm vi |
| --- | --- |
| Tên, email, user ID | Auth/profile; user ID gắn Analytics/Crashlytics. |
| Hoạt động trong app | Tiến độ, điểm/XP, câu trả lời, từ đã lưu, phản ứng video; navigation observer và SDK tự động. Không mặc định mọi hàm analytics được định nghĩa đều đã được gọi. |
| Crash logs/diagnostics | Crashlytics bật ở release, nhận stack trace/custom keys và trạng thái thiết bị theo SDK. |
| Device/other IDs | Firebase installations, FCM, measurement/AD_ID tùy cấu hình. |
| Nội dung nhúng/ảnh ngoài | YouTube iframe/thumbnail, avatar URL, Google Fonts; kiểm kê request, cookies và metadata thực tế. |
| Ảnh, mua hàng | Chưa thấy upload ảnh hoặc checkout hoạt động; không khai theo tên dependency/asset mà phải theo luồng thực sự. |

- Merged manifest release 08/10 có `com.google.android.gms.permission.AD_ID`, `ACCESS_ADSERVICES_AD_ID`, `ACCESS_ADSERVICES_ATTRIBUTION`. Merger report truy về measurement/ads-identifier SDK. Manifest nguồn không ghi các quyền này trực tiếp. Cần kiểm bản release cuối và trả lời Advertising ID chính xác; nếu không cần thì vô hiệu hóa chức năng tương ứng và loại quyền phù hợp. Có permission không tự chứng minh app hiển thị quảng cáo.
- [in_app_messaging_service.dart:24](D:/App/vocabik_app/lib/core/services/notification/in_app_messaging_service.dart:24) bật collection khi startup; Crashlytics bật ngoài debug. Cần xác định disclosure/consent theo dữ liệu, đối tượng và thị trường. Chưa có căn cứ kết luận mọi collection này đều bắt buộc popup theo Play.
- Thu thập vị trí suy ra từ IP có thể phát sinh ở dịch vụ dù app không xin GPS; cần đối chiếu hướng dẫn Analytics, không chỉ nhìn permissions.

**Các điều kiện ngoài client chưa xác minh**

| Mục | Việc cần hoàn tất |
| --- | --- |
| Độ tuổi/Families | Xác định audience thực tế. Nếu có trẻ em/unknown-age, đánh giá lại AD_ID, SDK, YouTube, nội dung và tương tác bạn bè. Chưa thấy age gate hoặc cấu hình theo tuổi; không tự suy rằng app giáo dục bắt buộc dành cho trẻ em. [Families](https://support.google.com/googleplay/android-developer/answer/9893335?hl=en). |
| Premium/Billing | Chưa thấy checkout, link Polar hay SDK Play Billing hoạt động. Terms vẫn có Premium/refund. Không kết luận đã vi phạm Payments; khi bán nội dung/chức năng số cần Play Billing hoặc chương trình ngoại lệ thực sự áp dụng, đồng thời sửa legal theo sản phẩm phát hành. [Payments](https://support.google.com/googleplay/android-developer/answer/9858738?hl=en). |
| Bản quyền và nguồn nội dung | Kiểm tra quyền video, transcript, bản dịch, bài tập, âm thanh, hình và store listing. Nhúng player chính thức không tự cấp quyền sao chép transcript hoặc tải media ở backend. Chưa có bằng chứng vi phạm, cũng chưa có hồ sơ cấp phép. [Intellectual Property](https://support.google.com/googleplay/android-developer/answer/9888072?hl=en). |
| App access | App yêu cầu login/email verified/CEFR. Cung cấp tài khoản review đã xác minh, dùng lại được và hướng dẫn tiếng Anh; Google Sign-In hoạt động với certificate Play App Signing. [Review access](https://support.google.com/googleplay/android-developer/answer/15748846?hl=en). |
| Console/store listing | Privacy URL công khai, deletion URL hoạt động, Data safety, Ads, Advertising ID, target audience, IARC, thông tin developer, production-access/testing theo loại tài khoản; screenshots/mô tả đúng tính năng. Chưa truy cập Console nên không đánh dấu các mục này là đã sai. |
| Backend | Kiểm duyệt/report/block, xóa dữ liệu/retention, authorization, thu hồi session/FCM, dữ liệu công khai trên leaderboard và pipeline nhập nội dung cần audit riêng bằng source/config và tài khoản test. |

**Điều kiện kỹ thuật phát hành**

- Manifest chính chỉ xin Internet, Notifications và Vibrate; chưa thấy SMS/contacts/location/camera/mic/broad-storage/Accessibility hay QUERY_ALL_PACKAGES. SDK thêm quyền như đã ghi trên; kiểm merged manifest cuối mới là căn cứ phát hành.
- API chính dùng HTTPS; không thấy code bỏ qua xác thực TLS trong client đã rà soát.
- Flutter SDK cục bộ đặt target/compile API **36**, merged release cũng target **36**. Phù hợp yêu cầu app mới/update từ 31/08/2026. [Target API](https://support.google.com/googleplay/android-developer/answer/11926878?hl=en).
- AGP **8.11.1**, NDK **28.2.13676358** thuận lợi cho 16 KB nhưng không chứng minh mọi `.so` đều tương thích. Cần kiểm AAB/split APK cuối, 64-bit, ELF/ZIP alignment và chạy trên môi trường 16 KB. Tài liệu hiện hành nêu yêu cầu hỗ trợ 16 KB cho app target 35+ và mốc chặn update 01/02/2027; không suy rộng mốc update thành miễn kiểm tra app mới. [16 KB guidance](https://developer.android.com/guide/practices/page-sizes).
- Máy chưa có `android/key.properties`, chưa có AAB. CI hiện build APK để Firebase App Distribution, có analyze/tests; cần tạo AAB ký upload key đúng và xác minh versionCode/certificate trước upload Play. Việc thiếu AAB hiện tại là công việc phát hành, không phải tự thân vi phạm nội dung.

**Kết quả kiểm tra tự động**

- `flutter analyze --no-pub`: **No issues found**, exit 0, 143,6 giây. Lần chạy trong sandbox không tiến triển; đã dừng và chạy lại với quyền truy cập cache/lock Flutter SDK ngoài workspace.
- **63 test liên quan đều pass**, exit 0: auth (gồm migration secure storage), profile, auth interceptor, Analytics, Crashlytics, report dialog và layout header bài tập.
- Lệnh test: `flutter test --no-pub test/features/auth test/features/profile test/core/network/auth_interceptor_test.dart test/core/services/analytics_service_test.dart test/core/services/crashlytics_service_test.dart test/shared/presentation/widgets/dialogs/report_user_dialog_test.dart test/features/exercise/exercise_landscape_layout_test.dart`.
- Test có cảnh báo SVG `unhandled element <filter/>`, không làm fail. Test report chỉ xác nhận dialog/SnackBar; test landscape chỉ kiểm header, không đo viewport WebView. Không dùng kết quả pass để phủ nhận các phát hiện trên.
- Không chạy toàn bộ suite; tránh test công cụ sinh lại ảnh branding vì mục tiêu lần này là audit. Không thêm hoặc sửa test/mã ứng dụng.
- Đã kiểm tra 19 liên kết file/dòng trong báo cáo tồn tại. Sau kiểm tra, working tree chỉ có báo cáo này là file mới.

Các kiểm tra trên không thay thế kiểm thử xóa tài khoản, moderation, WebView, bản AAB trên thiết bị và xét duyệt Google Play.

**Thứ tự xử lý đề nghị:** report/block thực sự → URL và đường yêu cầu xóa tài khoản → privacy VI/EN/web và legal consent → YouTube identity/kích thước/runtime → Data safety/audience/Billing/giấy phép → AAB và kiểm thử trên thiết bị/Play pre-launch report.

Audit này chỉ thêm báo cáo, không sửa mã ứng dụng, không gửi dữ liệu người dùng hoặc đăng bản phát hành.
