**Rà soát Google Play / Google services — Vocabik — 15/10/2026**

**Kết luận cập nhật: bản đầu dành cho người trưởng thành từ 18 tuổi, miễn phí; chưa nên gửi production cho đến khi xử lý các lỗi report/block, privacy/đồng ý điều khoản và hoàn tất kiểm chứng phát hành.** Families không còn là điểm chặn theo phạm vi mới, với điều kiện sản phẩm và khai báo thực tế nhất quán với đối tượng người lớn.

Phạm vi sản phẩm đã được người dùng cập nhật: **người trưởng thành 18+, không bán nội dung trả phí**. Báo cáo này thay thế đánh giá Families dựa trên giả định “mọi độ tuổi” trước đó. Thiếu Play Billing không phải lỗi của bản phát hành này.

Phạm vi: repository `D:/App/vocabik_app`, HEAD `b919532`, working tree sạch ở lần audit đầu; lần cập nhật 18+ đã có thay đổi chưa commit ở Terms/localization do công việc khác, được giữ nguyên; kiểm kê 744 file tracked, 422 file Dart trong lib ngoài localization sinh tự động. Đã tìm xuyên mã nguồn, đọc các luồng rủi ro, native Android, dependencies, CI, legal VI/EN, tài liệu API và website public. Đây là audit theo rủi ro trên toàn cấu trúc dự án, không phải chứng nhận từng dòng mã. Không có source backend, quyền Play Console, cấu hình Firebase/OAuth production hoặc hồ sơ cấp phép nội dung; chưa chạy AAB mới trên thiết bị. Không sửa mã ứng dụng hay gửi yêu cầu xóa/report/block thật.

**1. Cần hoàn tất — Chuyển phạm vi phát hành thành người trưởng thành 18+, miễn phí.**

- Người dùng đã chốt bản đầu dành cho người trưởng thành từ 18 tuổi, thay cho phạm vi “mọi độ tuổi” trước đây. Đây là phạm vi đánh giá hiện tại; không coi app là mixed audience theo giả định cũ.
- Lần rà soát lại chưa tìm thấy tuyên bố 18+ hoặc cơ chế xác nhận tuổi trong client; Terms VI/EN hiện chưa nêu đối tượng trưởng thành. Chưa có quyền xem store listing/Console nên chưa xác nhận cấu hình phát hành đã đổi.
- Google yêu cầu khai đúng đối tượng thực tế. Chọn duy nhất “18 and over”; cân nhắc bật “Restrict Minor Access”. Tính năng này hạn chế người Google xác định dưới 18 tìm/tải app, nhưng không chặn sử dụng của người đã cài. IARC vẫn phải trả lời theo nội dung thực tế, không tự gán rating nội dung 18+. [Target audience guidance](https://support.google.com/googleplay/android-developer/answer/9867159?hl=en).
- **Đề nghị triển khai:** mô tả Vocabik là công cụ học tiếng Anh cho người trưởng thành; đồng bộ Terms, onboarding, website, ảnh và mô tả cửa hàng. Không quảng bá “mọi độ tuổi” hoặc chủ đích nhắm trẻ em trong khi khai 18+. Rà soát cách xử lý tài khoản dưới tuổi đã có và các kênh cài ngoài Play nếu có.
- **Phân biệt yêu cầu với đề xuất:** không có căn cứ từ audit này để bắt buộc app học tiếng Anh phải thu ngày sinh đầy đủ, giấy tờ tùy thân hoặc làm age gate chỉ vì chọn 18+. Cách xác nhận/giới hạn tuổi cần theo thị trường và tính năng thực tế, tránh thu thêm dữ liệu không cần thiết. Ngưỡng trưởng thành theo luật địa phương vẫn cần xem xét ở các nước phát hành.
- **Nghiệm thu:** kiểm cấu hình Console, listing, Terms VI/EN/web và các đường đăng ký Google/email theo cùng phạm vi; ghi nhận quyết định dùng Restrict Minor Access. Chưa coi đổi phạm vi trên giấy là đã hoàn tất cấu hình.

**2. Đánh giá lại — Families không còn là điểm chặn theo đối tượng đã chốt; dữ liệu và YouTube vẫn cần kiểm.**

- Hai phát hiện Families của bản audit trước dựa trên yêu cầu “mọi độ tuổi”. Với sản phẩm thực sự dành cho người trưởng thành và khai báo chính xác, không yêu cầu xây luồng trẻ em, parental controls hay self-designation YouTube child-directed chỉ để phát hành bản đầu. Nếu nội dung/marketing thực tế vẫn hướng trẻ em hoặc phạm vi thay đổi, phải đánh giá lại. [Target audience guidance](https://support.google.com/googleplay/android-developer/answer/9867159?hl=en).
- [main.dart:32](D:/App/vocabik_app/lib/main.dart:32) khởi tạo Firebase trước UI; [in_app_messaging_service.dart:24](D:/App/vocabik_app/lib/core/services/notification/in_app_messaging_service.dart:24) bật collection; [crashlytics_service.dart:50](D:/App/vocabik_app/lib/core/services/crashlytics_service.dart:50) bật ở release/profile. Đây không tự thân là lỗi Families đối với bản 18+; vẫn phải khai đúng dữ liệu và đáp ứng disclosure/consent khi áp dụng.
- Manifest nguồn không có cấu hình tắt Analytics Advertising ID/ad personalization. Merged release ngày 08/10 có `AD_ID`, `ACCESS_ADSERVICES_AD_ID`, `ACCESS_ADSERVICES_ATTRIBUTION`; artifact cũ chưa chứng minh request của bản cuối. **Không coi có AD_ID là vi phạm chỉ vì app miễn phí hoặc dành cho người lớn.** Chốt mục đích sử dụng và khai Advertising ID/Data safety đúng; nếu không cần thì nên tắt collection và loại quyền không dùng. [Firebase collection controls](https://firebase.google.com/docs/analytics/android/configure-data-collection).
- YouTube vẫn cần consent/privacy, kiểm quảng cáo, nội dung, quyền sử dụng và playback. Đối tượng người lớn không miễn các chính sách nội dung chung. Không kết luận iframe không có quảng cáo chỉ vì app không thu tiền.
- **Nghiệm thu:** kiểm request từ fresh install, merged manifest AAB cuối, cấu hình SDK/Firebase và nội dung nhúng. Phần này là việc xác minh/kê khai dữ liệu, không phải kết luận đã ghi nhận AAID truyền trái phép.

**3. Cao, đã tái hiện — Người khác tên “You” hoặc trùng tên có thể mất đường report/block.**

- [auth_utils.dart:41](D:/App/vocabik_app/lib/core/utils/auth_utils.dart:41) chỉ trả true khi ID trùng; khi hai ID khác nhau vẫn tiếp tục xét tên. Dòng 46 coi tên `You` là chính mình; dòng 73 coi trùng displayName là chính mình.
- Ví dụ: người đăng nhập ID `me`, tên `Alice`; người khác ID `other`, tên `Alice` hoặc `You` đều bị `isCurrentSelf()` trả true. [shared_leaderboard_tile.dart:200](D:/App/vocabik_app/lib/shared/presentation/widgets/leaderboard/shared_leaderboard_tile.dart:200) bỏ tương tác; [user_action_bottom_sheet.dart:32](D:/App/vocabik_app/lib/features/moderation/presentation/widgets/user_action_bottom_sheet.dart:32), report dialog và block dialog cũng chặn mở.
- Hai test tái hiện đều thất bại với `Expected false / Actual true`. Đây là lỗi client xác nhận được, không phụ thuộc server có kiểm duyệt hay không. Google yêu cầu cơ chế report/block hữu hiệu theo loại UGC. [UGC policy](https://support.google.com/googleplay/android-developer/answer/9876937?hl=en).
- **Sửa:** dùng stable user ID; nếu có đủ hai ID thì trả kết quả so sánh ngay. Không dùng nhãn hiển thị/chuỗi “You” làm căn cứ cấm moderation. Không dùng displayName thay target ID.
- **Nghiệm thu:** hai người trùng tên và người tên `You` vẫn mở report/block; bản thân vẫn không tự báo cáo/chặn được.

**4. Cao — Privacy trong app và trên web chưa phản ánh đầy đủ việc xử lý dữ liệu.**

- [app_vi.arb:412](D:/App/vocabik_app/lib/l10n/app_vi.arb:412) gọi log lỗi là “ẩn danh”, nhưng [auth_bloc.dart:56](D:/App/vocabik_app/lib/features/auth/presentation/bloc/auth_bloc.dart:56) gắn user ID vào Analytics/Crashlytics, cùng tier và CEFR. Đây là dữ liệu liên kết tài khoản/pseudonymous, không phải ẩn danh hoàn toàn.
- Các mục tại [app_en.arb:405](D:/App/vocabik_app/lib/l10n/app_en.arb:405) và bản VI thiếu mô tả retention, các định danh SDK và thông tin công khai của hồ sơ; chưa nêu phạm vi người dùng trưởng thành. Mục Cookies của EN chưa mô tả thực chất cookies/nội dung nhúng. Ngày legal vẫn 15/06/2026.
- Đã GET trực tiếp: [privacy web](https://vocabik.com/privacy) **200**, [deletion web](https://vocabik.com/delete-account) **200**, `/privacy-policy` **404**. URL privacy thực tế được footer website liên kết là `/privacy`; **không kết luận website thiếu privacy** và chưa biết URL đang khai trên Console.
- Bản web `/privacy` ngày 18/05/2026 nói chung về usage/device/log data và có retention, nhưng chưa giải thích Firebase/Analytics/YouTube như app. Bản web và app cần cùng mô tả một hệ thống thực tế. `/terms` cũng hoạt động nhưng chưa đồng bộ nội dung YouTube và hành vi cấm với bản mobile.
- Google yêu cầu privacy đầy đủ, công khai và nhất quán với dữ liệu thực tế, gồm lưu giữ/xóa. [User Data policy](https://support.google.com/googleplay/android-developer/answer/10144311?hl=en).
- **Sửa:** cập nhật VI/EN/web từ data inventory đã xác nhận; sửa “ẩn danh”, đồng bộ phạm vi 18+, bổ sung nhà cung cấp, nội dung nhúng, retention/deletion/contact và cập nhật ngày. Đưa URL hoạt động `/privacy` vào Console sau khi nội dung đã hoàn thiện.

**5. Cao — Luồng Google lần đầu có thể bỏ qua chấp thuận legal; router còn chặn trang legal trong onboarding.**

- [login_screen.dart:107](D:/App/vocabik_app/lib/features/auth/presentation/screens/login_screen.dart:107) gọi Google auth trực tiếp, không có thông báo/link Terms/Privacy trên màn login. Client gọi `/auth/google/mobile`, dùng chung cho signup/signin; user model/router không có trạng thái chấp thuận legal. Cần xác nhận hành vi tạo mới của backend bằng tài khoản test chưa từng đăng ký.
- Màn register có lời thông báo legal, nhưng không bảo vệ được đường Google trên màn login.
- [app_router.dart:109](D:/App/vocabik_app/lib/core/routes/app_router.dart:109) ép tài khoản chưa verify sang `/verify-email`; dòng 119 ép người chưa chọn/skip CEFR sang onboarding, kể cả đang mở legal. Allowlist legal chỉ có tác dụng ở nhánh chưa đăng nhập.
- YouTube yêu cầu chấp thuận privacy trước sử dụng chức năng API client; UGC yêu cầu chấp thuận điều khoản trước tạo nội dung. OAuth consent của Google không thay cho điều khoản riêng của app. [YouTube policies III.A](https://developers.google.com/youtube/terms/developer-policies), [UGC](https://support.google.com/googleplay/android-developer/answer/9876937?hl=en).
- **Sửa:** hiển thị và ghi nhận chấp thuận trên mọi đường tạo tài khoản; đồng bộ điều kiện sử dụng cho người trưởng thành; cho phép legal và đường yêu cầu xóa hoạt động trong onboarding. Không mặc định rằng mọi analytics đều cần một popup giống nhau.
- **Nghiệm thu:** Google lần đầu, email chưa verify, chưa chọn CEFR và tài khoản cũ sau cập nhật legal.

**6. Vừa, đã tái hiện bằng phản hồi giả lập — Report/block bỏ qua `success: false`.**

- [moderation_repository_impl.dart:34](D:/App/vocabik_app/lib/features/moderation/data/repositories/moderation_repository_impl.dart:34), dòng 48/62 trả `Right(response)` mà không kiểm tra `success`. UI coi nhánh Right là thành công.
- [report_response_model.dart:16](D:/App/vocabik_app/lib/features/moderation/data/models/report_response_model.dart:16) mặc định success=true khi thiếu trường; [moderation_remote_data_source.dart:32](D:/App/vocabik_app/lib/features/moderation/data/datasources/moderation_remote_data_source.dart:32) còn tự tạo success nếu response không phải JSON object.
- Hai test với response model `success:false` xác nhận repository vẫn trả Right. API docs hiện mô tả lỗi bằng HTTP 4xx; chưa có bằng chứng production trả HTTP 2xx/success:false. Vì thế đây là lỗi xử lý phản hồi với điều kiện cụ thể, không kết luận mọi báo cáo hiện bị mất.
- **Sửa:** kiểm tra schema và trạng thái nghiệp vụ; chỉ báo đã tiếp nhận/chặn sau xác nhận hợp lệ. Thử server trả false, body rỗng/sai định dạng, 4xx, mất mạng và thành công; xác minh report xuất hiện trong hệ thống kiểm duyệt, block chặn tương tác/FCM ở server.

**7. Vừa — Xóa tài khoản thay đổi mật khẩu bằng `trim()`.**

- [delete_account_confirmation_dialog.dart:157](D:/App/vocabik_app/lib/features/profile/presentation/widgets/delete_account_confirmation_dialog.dart:157), dòng 181 cắt khoảng trắng đầu/cuối mật khẩu. Register/login gửi mật khẩu nguyên bản; [password_input.dart:10](D:/App/vocabik_app/lib/features/auth/presentation/models/password_input.dart:10) không cấm khoảng trắng.
- Nếu backend chấp nhận mật khẩu có khoảng trắng đầu/cuối, người dùng đăng nhập được nhưng xác nhận xóa sẽ luôn sai mật khẩu. Đây là rủi ro có điều kiện, chưa thử tài khoản production.
- **Sửa:** gửi nguyên văn password; chỉ trim các trường phù hợp như reason. Test mật khẩu có khoảng trắng và tài khoản Google không có password.

**8. Cần xác minh trước phát hành — Cam kết xóa toàn bộ dữ liệu chưa có bằng chứng backend tương ứng.**

- Luồng client đã gọi `DELETE /auth/me`, xóa local tokens, sign out provider và reset tracking qua `SessionExpired`. Nút xóa đã có trong Account.
- Tuy nhiên [mobile-account-deletion-api.md:15](D:/App/vocabik_app/documents/mobile-account-deletion-api.md:15) mô tả `deletedAt`, đổi tên/email, xóa password, thu hồi session và gỡ liên kết xã hội; chưa mô tả rõ xóa learning history/XP/notebook/avatar/provider links/telemetry và backup.
- [Trang xóa tài khoản](https://vocabik.com/delete-account) lại cam kết xóa vĩnh viễn dữ liệu học, hồ sơ và bạn bè, xử lý email trong 48 giờ làm việc. Tài liệu không chứng minh backend thiếu chức năng; cũng không đủ để chứng nhận đã thực hiện cam kết. Soft delete kết hợp xóa/ẩn danh không thể đảo ngược có thể là một phần giải pháp; chỉ đổi email vẫn còn ID liên kết không tự chứng minh đã ẩn danh.
- **Nghiệm thu:** dùng tài khoản test có đủ dữ liệu, kiểm DB/storage/SDK/backups và thu hồi toàn bộ phiên sau xóa; kiểm mailbox public thật sự nhận/xử lý yêu cầu ngoài app; công bố rõ ngoại lệ retention có căn cứ. [Account deletion requirements](https://support.google.com/googleplay/android-developer/answer/13327111?hl=en).

**Data safety và hồ sơ Console cần hoàn tất**

Không thể khai “không thu thập dữ liệu”. Bảng dưới là inventory sơ bộ cần xác nhận với backend/SDK; không phải bộ câu trả lời Console đã duyệt. Data safety phải tính cả SDK; collected và shared cần xét riêng, bao gồm ngoại lệ service provider. [Data safety guidance](https://support.google.com/googleplay/android-developer/answer/10787469?hl=en), [Firebase disclosure](https://firebase.google.com/docs/android/play-data-disclosure).

| Nhóm | Bằng chứng / việc cần đối chiếu |
| --- | --- |
| Tên, email, user ID | Đăng ký, Google auth, profile; ID gửi Analytics/Crashlytics. |
| Hoạt động / nội dung người dùng | Tiến độ, điểm, từ đã lưu, phản ứng, bạn bè, báo cáo và chi tiết report. Xác định loại dữ liệu/mục đích chính xác. |
| Crash / diagnostics | Crashlytics, stack trace, custom keys, device metadata. |
| Device/other IDs | Firebase installations/FCM, measurement, AAID theo cấu hình; kiểm bản cuối sau khi chốt cấu hình collection. |
| Vị trí suy ra từ IP | Kiểm Analytics/backend; không xin GPS không có nghĩa không xử lý approximate location. |
| Nội dung/ảnh từ bên thứ ba | YouTube, thumbnail, avatar URL, Google Fonts; kiểm request và cookies. |
| Phạm vi tuổi | Bản đầu 18+; kiểm điều kiện sử dụng và cách xử lý tài khoản không đáp ứng phạm vi, nếu có. Không khai không thu thập dữ liệu chỉ vì không nhắm trẻ em. |

- Target audience: chọn duy nhất “18 and over” theo phạm vi đã chốt; rà soát tùy chọn Restrict Minor Access. IARC đánh giá nội dung và tương tác thực tế, độc lập với lựa chọn tuổi mục tiêu.
- Không bán nội dung: **không yêu cầu thêm Play Billing**. **Đã xác nhận mô tả Premium/refund được bỏ khỏi Terms VI/EN và widget legal trong working tree hiện tại**; mục 5 hiện là chấm dứt tài khoản. Không còn ghi đây là việc chưa xử lý. Nếu sau này đổi mô hình, kiểm lại [Payments](https://support.google.com/googleplay/android-developer/answer/9858738?hl=en).
- Miễn phí không đồng nghĩa không có quảng cáo: xác minh ads trong YouTube và chiến dịch In-App Messaging trước khai Ads. Không suy chỉ từ permission `AD_ID` rằng app đang hiển thị ads.
- Cung cấp tài khoản review truy cập đầy đủ, đã verify email và hướng dẫn tiếng Anh; thử Google Sign-In với certificate **Play App Signing**. [App access](https://support.google.com/googleplay/android-developer/answer/15748846?hl=en).
- Kiểm yêu cầu production-access/testing theo loại và ngày tạo developer account; chưa truy cập Console nên chưa xác định nghĩa vụ cụ thể. [Testing requirements](https://support.google.com/googleplay/android-developer/answer/14151465?hl=en).

**YouTube, bản quyền và phát hành kỹ thuật**

| Mục | Kết quả |
| --- | --- |
| YouTube identity | Đã có origin `https://com.snapsofts.vocabik.yt`; dependency 6.0.2 dùng origin làm baseUrl. Cần kiểm request WebView thật ở release. [Identity rules](https://developers.google.com/youtube/terms/required-minimum-functionality). |
| Viewport | Đã có min 200×200 trong widget; test hiện kiểm constraints, chưa đo CSS viewport thật. Kiểm màn nhỏ, landscape, bàn phím. [Iframe minimum size](https://developers.google.com/youtube/iframe_api_reference?hl=en). |
| Playback | Controls nằm dưới player, pointer không bị chặn. Chưa thấy lifecycle pause ở app; cần thử Home/lock/đổi route và quảng cáo, không khẳng định đã có phát nền trái phép. |
| Bản quyền | Client dùng iframe chính thức; transcript/bản dịch/bài tập lấy backend. Chưa có source pipeline hay hồ sơ quyền video/text/audio/assets nên chưa chứng nhận quyền sử dụng. “Video public” không tự cấp mọi quyền sao chép/chuyển thể. [Intellectual Property](https://support.google.com/googleplay/android-developer/answer/9888072?hl=en). |
| Permissions / transport | Manifest nguồn chỉ Internet, Notifications, Vibrate; chưa thấy SMS/Contacts/GPS/camera/mic/broad storage/accessibility/TLS bypass. SDK bổ sung permissions nên phải kiểm merged manifest cuối. API chính HTTPS. |
| Target API | Flutter SDK cục bộ target/compile 36; Gradle dùng giá trị Flutter; merged release cũ cũng target 36. Đáp ứng ngưỡng hiện hành trong cấu hình, cần xác nhận AAB. [Target API từ 31/08/2026](https://support.google.com/googleplay/android-developer/answer/11926878?hl=en-EN). |
| 16 KB / 64-bit | AGP 8.11.1, NDK 28.2.13676358; chưa kiểm ELF/ZIP/RELRO các native libraries của AAB cuối hoặc chạy thiết bị 16 KB. Phiên bản toolchain không đủ chứng minh mọi .so đạt. [16 KB guidance](https://developer.android.com/guide/practices/page-sizes). |
| Signing / artifact | Có guard chặn release thiếu signing trừ khi bật override test. Máy chưa có `android/key.properties`, chưa có AAB; APK release sẵn có ngày 16/09 không đại diện HEAD hiện tại. CI hiện phát APK qua Firebase App Distribution. Đây là việc chuẩn bị release, không tự thân là vi phạm policy. |

**Các sửa đổi cũ đã xác nhận trong client**

Đã có API report/block và danh sách người bị chặn; có nút/API xóa tài khoản; URL deletion public đã 200; Google logo đã dùng SVG thay chữ G; origin/kích thước player đã bổ sung; log payload notification đã giới hạn debug; token dùng secure storage; release có signing guard. Những cải thiện này không xóa các lỗi cụ thể và các điều kiện chưa kiểm chứng ở trên.

**Kết quả kiểm tra ngày 15/10/2026 và phạm vi tái rà soát**

- Kết quả analyze/test/HTTP bên dưới được thực hiện ở lượt audit đầu cùng ngày. Lượt cập nhật 18+ đối chiếu lại chính sách Google, git diff Terms/localization, mã self-ID/moderation, privacy, login/router và password deletion; không chạy lại test hoặc GET website. Các đoạn mã lỗi không thay đổi; thay đổi mới chỉ có legal/localization. Kết quả test cũ không được hiểu là xác nhận toàn bộ working tree mới đã được kiểm thử lại.

- `flutter analyze --no-pub`: **No issues found**, exit 0, 187,6 giây. Lần trong sandbox không tiến triển đã dừng; lần thành công chạy với quyền truy cập SDK/cache ngoài workspace.
- **115 test có sẵn liên quan đều pass**, exit 0: auth, profile, moderation, AuthUtils, auth interceptor, Analytics, Crashlytics, notification router, report dialog, YouTube viewport và landscape header. [Log](D:/App/vocabik_app/build/policy_audit_tests_2026_10_15.log).
- **4 kiểm thử audit bổ sung đều tái hiện lỗi**, exit 1: hai tình huống nhận diện sai người dùng và hai tình huống bỏ qua success=false. Đây là test viết để kỳ vọng hành vi đúng, không phải bốn lỗi build. [Test tái hiện](D:/App/vocabik_app/build/policy_audit_2026_10_15_test.dart), [log](D:/App/vocabik_app/build/policy_audit_regressions_2026_10_15.log). Các file build này là bằng chứng tạm, có thể mất khi chạy clean.
- Test dùng fake/mock, không chứng minh moderation/xóa dữ liệu production hay hoạt động WebView thực tế. Chưa chạy toàn bộ suite, pre-launch report hoặc kiểm thử thiết bị.
- HTTP GET public: `/delete-account` 200, `/privacy` 200, `/terms` 200, `/privacy-policy` 404. Không gửi email hoặc thực hiện mutation production.

**Thứ tự hoàn tất trước upload:** đồng bộ phạm vi 18+ trong sản phẩm/Terms/website/listing/Console → sửa self-ID/report-block và password deletion → hoàn thiện privacy/consent → nghiệm thu xóa dữ liệu và moderation backend → kiểm nội dung/quyền sử dụng → Data safety/Advertising ID/Ads/App access → AAB ký đúng, kiểm 16 KB và Play pre-launch report. Không yêu cầu tích hợp Billing hoặc xây trải nghiệm trẻ em cho bản đầu đã chốt. Quyết định duyệt cuối cùng thuộc Google; các phần Console/backend chưa kiểm không được coi là đã đạt.

