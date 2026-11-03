# Rà soát Google Play và Google services — Vocabik — 20/10/2026

**Kết luận: còn rủi ro cần xử lý trước khi gửi production.** Các vấn đề chính nằm ở privacy, báo cáo nội dung, xử lý kết quả report/block, xác nhận xóa tài khoản và một số nút chức năng chưa hoàn thiện. Những phần backend, dữ liệu thực tế, quyền nội dung và Play Console chưa kiểm chứng được không được coi là đã đạt.

Người dùng xác nhận trong lần rà soát này: **bản phát hành dành cho người từ 13 tuổi trở lên**. Phạm vi này thay thế giả định 18+ trong báo cáo 15/10. Client hiện không có luồng thanh toán; đánh giá Billing dựa trên hành vi đó.

**Phạm vi và phương pháp**

- HEAD `4288eeb`; working tree sạch khi bắt đầu; kiểm kê 749 file tracked, trong đó 481 file Dart trên toàn repository. Rà soát theo rủi ro xuyên các nhóm chức năng, cấu hình Android, dependencies, lưu trữ/network, Firebase, auth/legal, moderation, video/bài tập, notification, CI và tài liệu API. Không phải chứng nhận từng dòng mã hoặc mọi ảnh/video trên server.
- Đọc lại mã hiện tại và đối chiếu các phát hiện cũ; tra chính sách Google chính thức ngày 20/10/2026; GET các trang public; chạy analyzer, toàn bộ test ở thư mục `test/`, và các test audit bổ sung bằng fake/mock.
- Không có mã backend, quyền Play Console/Firebase production, hồ sơ cấp phép hoặc catalog nội dung đầy đủ. Không gửi email, không tạo/xóa tài khoản thật, không report/block người dùng thật, không publish app. Chưa thực hiện kiểm thử thiết bị/WebView/network capture.
- Không sửa mã ứng dụng. Báo cáo và bằng chứng kiểm thử được tạo riêng.

**1. Cao — Privacy trong app còn thiếu thông tin và chưa đồng bộ với website**

Bằng chứng: [privacy EN](D:/App/vocabik_app/lib/l10n/app_en.arb:408), bản VI tương ứng cùng số dòng. Nội dung đã sửa cách gọi crash logs thành dữ liệu định danh giả liên kết tài khoản, nhưng chưa mô tả thời gian/tiêu chí lưu giữ, định danh thiết bị/SDK, thông tin hồ sơ hiển thị cho người khác, và cơ chế thu thập của nội dung nhúng. Mục Cookies ở EN hiện chỉ nói token và crash logs.

[AuthBloc](D:/App/vocabik_app/lib/features/auth/presentation/bloc/auth_bloc.dart:56) gửi user ID, tier, CEFR tới Analytics/Crashlytics. [Analytics](D:/App/vocabik_app/lib/core/services/analytics_service.dart:219) còn hỗ trợ sự kiện tìm kiếm, tiến độ, lưu từ và tương tác. Privacy cần phản ánh tập dữ liệu thực sự được gửi, không chỉ tên/email.

GET trực tiếp ngày 20/10: [privacy web](https://vocabik.com/privacy), [terms web](https://vocabik.com/terms), [deletion web](https://vocabik.com/delete-account) đều **HTTP 200**. Privacy/Terms web vẫn mang ngày 18/05/2026; privacy web có retention tổng quát nhưng chưa mô tả Firebase/YouTube và phạm vi 13+ như mobile. Terms web chưa có phần chấp thuận YouTube Terms như mobile. Đây là nội dung cần đồng bộ, không phải kết luận URL bị hỏng.

**Đề nghị:** lập data inventory với backend, bổ sung retention/deletion, các bên xử lý, dữ liệu công khai, device identifiers, nội dung nhúng/cookies/quảng cáo nếu có; xuất bản cùng nội dung VI/EN/web và cập nhật phiên bản legal khi thay đổi có ý nghĩa. Google yêu cầu privacy mô tả đúng việc xử lý dữ liệu và chính sách lưu giữ/xóa. [User Data policy](https://support.google.com/googleplay/android-developer/answer/10144311?hl=en-GB). YouTube có yêu cầu disclosure riêng cho nội dung bên thứ ba và công nghệ lưu thông tin trên thiết bị. [YouTube III.A](https://developers.google.com/youtube/terms/developer-policies).

**2. Cao — Chưa thấy cơ chế báo cáo video/bài học trong app**

[VideoDetailContentView](D:/App/vocabik_app/lib/features/video_detail/presentation/widgets/video_detail_content_view.dart:34) hiển thị video, phản ứng, bắt đầu học và chia sẻ nhưng không có thao tác báo cáo nội dung. Tìm xuyên video detail/exercise không thấy handler báo cáo. Luồng đang có gọi [ReportUserDialog](D:/App/vocabik_app/lib/shared/presentation/widgets/dialogs/report_user_dialog.dart:93) với `targetType: 'user'`; API docs đã liệt kê hỗ trợ `video` tại [mobile-ugc-report-block-api.md](D:/App/vocabik_app/documents/mobile-ugc-report-block-api.md:37).

**Đánh giá:** thiếu đường báo cáo nội dung là quan sát xác nhận ở client. Mức rủi ro policy là suy luận từ việc app hiển thị UGC YouTube cho người dùng 13+; chưa phát hiện một video production cụ thể vi phạm. Nút report người dùng không giúp báo một video/đoạn dịch không phù hợp. Google áp dụng yêu cầu kiểm duyệt UGC cả với client truy cập nền tảng UGC. [UGC policy](https://support.google.com/googleplay/android-developer/answer/9876937?hl=en).

**Đề nghị:** thêm “Báo cáo nội dung” ở video/bài học với ID video/bài tập, lý do, chi tiết; gửi đúng API và đưa vào hàng đợi kiểm duyệt có người xử lý. Kiểm nội dung, lời bài hát, thumbnail và bản dịch phù hợp 13–17; xác minh cơ chế gỡ nội dung/ẩn đề xuất sau xử lý. Cần thử phản hồi thành công, bị từ chối, lỗi mạng và kết quả xuất hiện trong hệ thống moderation.

**3. Vừa — Report/block báo thành công khi nghiệp vụ thất bại; đã tái hiện bằng test**

[ModerationRepositoryImpl](D:/App/vocabik_app/lib/features/moderation/data/repositories/moderation_repository_impl.dart:34) luôn trả `Right(response)` cho report và tương tự ở block/unblock, không kiểm tra `response.success`. UI dùng nhánh Right để thông báo thành công và loại người bị chặn khỏi danh sách. [Remote datasource](D:/App/vocabik_app/lib/features/moderation/data/datasources/moderation_remote_data_source.dart:32) còn tự tạo success khi body không phải JSON object; [response model](D:/App/vocabik_app/lib/features/moderation/data/models/report_response_model.dart:16) mặc định true nếu thiếu trường.

Hai test giả lập `success:false` đều tái hiện sai nhánh. Tài liệu hiện mô tả lỗi bằng HTTP 4xx; **chưa chứng minh production trả HTTP 2xx/success:false**. Vì vậy đây là lỗi xử lý phản hồi có điều kiện, không khẳng định mọi report/block hiện đều thất bại.

**Đề nghị:** xác nhận hợp đồng API, kiểm tra trạng thái nghiệp vụ và schema; chỉ báo thành công khi phản hồi hợp lệ. Kiểm backend thực sự chặn tương tác/thách đấu/push từ tài khoản bị chặn, không chỉ ẩn tile ở client. Liên quan đến hiệu lực của cơ chế bảo vệ UGC theo chính sách nêu ở mục 2.

**4. Vừa — Hộp thoại xóa tài khoản thay đổi mật khẩu; đã tái hiện bằng widget test**

[DeleteAccountConfirmationDialog](D:/App/vocabik_app/lib/features/profile/presentation/widgets/delete_account_confirmation_dialog.dart:157), cả nhánh submit ở dòng 181, gọi `passwordController.text.trim()`. Register/login giữ nguyên mật khẩu và [PasswordInput](D:/App/vocabik_app/lib/features/auth/presentation/models/password_input.dart:10) không cấm khoảng trắng đầu/cuối.

Test nhập ` password123 ` vào hộp thoại và bấm xác nhận cho thấy giá trị gửi đến cubit thành `password123`. Nếu backend chấp nhận mật khẩu gốc có khoảng trắng, người dùng đăng nhập được nhưng không thể xác nhận xóa bằng mật khẩu đúng.

**Đề nghị:** truyền nguyên văn password ở cả hai nhánh; kiểm tài khoản email có khoảng trắng và Google không có password. Google yêu cầu đường xóa tài khoản hoạt động và dữ liệu liên quan được xử lý theo chính sách công bố. [Account deletion](https://support.google.com/googleplay/android-developer/answer/13327111?hl=en).

**5. Vừa — Nút chia sẻ hiện chưa thực hiện chức năng**

[Nút chia sẻ bài học](D:/App/vocabik_app/lib/features/video_detail/presentation/widgets/video_detail_content_view.dart:235) có `onPressed` rỗng. [ScoreCardShareSection](D:/App/vocabik_app/lib/features/exercise/presentation/widgets/score_card_share_section.dart:78) có các thao tác chia sẻ mạng xã hội chỉ hiện thông báo tính năng đang phát triển. Copy link là chức năng riêng và đã có xử lý.

**Đề nghị:** triển khai share sheet thực sự hoặc bỏ các nút chưa hoàn thiện khỏi bản phát hành; không quảng bá chúng trong listing. Đây là rủi ro chất lượng có thể bị phát hiện khi review, không phải bằng chứng toàn bộ app không hoạt động. [Functionality policy](https://support.google.com/googleplay/android-developer/answer/9898783?hl=en).

**Các điều kiện cần xác minh trước production**

| Hạng mục | Bằng chứng hiện tại | Việc cần hoàn tất |
| --- | --- | --- |
| Xóa dữ liệu backend | Client có `DELETE /auth/me`, dọn token/user cache và sign out. [API docs](D:/App/vocabik_app/documents/mobile-account-deletion-api.md:15) mô tả soft delete, thay tên/email, xóa password, thu hồi phiên và một số liên kết. Trang deletion cam kết xóa cả history/XP/streak/notebook/avatar. | Dùng tài khoản test có đủ dữ liệu để kiểm DB, storage, provider mapping, telemetry và backup. Chứng minh không chỉ khóa tài khoản; đồng bộ ngoại lệ retention và thời hạn. Reset Analytics trên client không tự chứng minh dữ liệu đã upload bị xóa. Xác minh mailbox thực sự nhận và xử lý yêu cầu trong thời hạn công bố. Tài liệu thiếu chi tiết không chứng minh backend chưa làm. |
| Đối tượng 13+ | App Terms/Privacy/notice xác nhận 13+; người dùng đã chốt cùng phạm vi. Website chưa đồng bộ. | Chọn nhóm 13–15, 16–17, 18+ nếu đều là đối tượng thực tế; trả lời IARC theo nội dung và tương tác thật. Xác định quốc gia phát hành. Google lưu ý 13–15 và 16–17 vẫn có thể thuộc nhóm trẻ em tại một số nơi; không coi 13+ là miễn mọi nghĩa vụ Families. Nút “Tôi 13+” không phải neutral age screen nếu chính sách áp dụng đòi hỏi loại màn đó. Không có kết luận bắt buộc thu giấy tờ/ngày sinh cho mọi app 13+. [Target audience](https://support.google.com/googleplay/android-developer/answer/9867159?hl=en). |
| Firebase/consent/Advertising ID | [main.dart](D:/App/vocabik_app/lib/main.dart:32) khởi tạo SDK trước UI; [FIAM](D:/App/vocabik_app/lib/core/services/notification/in_app_messaging_service.dart:24) bật collection; Crashlytics bật ở release. Manifest nguồn không tắt Analytics/AAID/ad personalization. | Chốt mục đích và thị trường; kiểm request fresh install, trước/sau đồng ý và từ chối. Khi cần consent trước thu thập, phải chặn SDK trước thời điểm đó; legal notice sau login không tự điều khiển collection. Có `AD_ID` không tự là vi phạm, cũng không chứng minh app đang hiển thị ads. Nếu không dùng AAID/ads personalization thì tắt collection tương ứng và kiểm permission cuối. [Firebase controls](https://firebase.google.com/docs/analytics/android/configure-data-collection). |
| YouTube playback và ads | Iframe chính thức; có origin app ID, pointer events, custom controls dưới player và min constraints 200×200. Chưa thấy xử lý lifecycle pause ở màn exercise. | Thử release trên thiết bị: Home/khóa máy/đổi route, quảng cáo, seek, màn nhỏ/landscape/bàn phím. Đo viewport WebView thực; không suy từ unit test constraints rằng mọi bố cục đều đạt. Xác minh player identity/referrer, không che điều khiển/quảng cáo hay phát nền ngoài màn hình. [YouTube minimum functionality](https://developers.google.com/youtube/terms/required-minimum-functionality). |
| Bản quyền nội dung | [Exercise datasource](D:/App/vocabik_app/lib/features/exercise/data/datasources/exercise_remote_datasource.dart:43) lấy bài tập và bản dịch từ backend; client không cho biết pipeline tạo transcript. | Lưu hồ sơ nguồn/quyền video, transcript/lời bài hát, bản dịch, audio, hình và screenshot quảng bá. Nhúng video public không tự cấp quyền sao chép/chuyển thể mọi nội dung. Không tìm thấy hồ sơ trong repository không đồng nghĩa đã vi phạm. [Intellectual Property](https://support.google.com/googleplay/android-developer/answer/9888072?hl=en). |

**Data safety: không thể khai “không thu thập dữ liệu”**

Đây là inventory để đối chiếu, chưa phải câu trả lời Console đã chốt. Phải tính cả SDK; dữ liệu “collected” và “shared” cần xét riêng theo mục đích/quan hệ service provider, không tự đánh dấu mọi dữ liệu gửi Firebase là shared. [Data safety guidance](https://support.google.com/googleplay/android-developer/answer/10787469?hl=en-GB), [Firebase disclosure](https://firebase.google.com/docs/android/play-data-disclosure).

| Dữ liệu/luồng | Căn cứ | Việc cần khai đúng |
| --- | --- | --- |
| Tên, email, user ID | Auth/profile; ID gắn Analytics/Crashlytics | Loại thông tin cá nhân, mục đích quản lý tài khoản/cá nhân hóa/analytics; trường nào công khai. |
| Learning progress, điểm, lịch sử, từ lưu, tương tác, tìm kiếm | Exercise/progress/notebook/reactions và analytics events | App activity và mục đích; xác minh sự kiện/trường thực sự gửi. |
| Report reason/details, quan hệ bạn bè/thách đấu | Moderation/challenge APIs | Nội dung người dùng, hoạt động/tương tác và xử lý an toàn; xem report có thể chứa PII. |
| Crash/diagnostics/device metadata | Crashlytics | App info/performance và liên kết tài khoản; retention. |
| Installation/FCM/measurement/advertising identifiers | Firebase và dependency manifests | Device or other IDs theo cấu hình cuối; không bỏ sót chỉ vì không có AdMob. |
| Vị trí suy ra từ IP | Có thể do Analytics/backend xử lý | Xác minh loại vị trí và mục đích; không có GPS permission không đủ để kết luận không xử lý vị trí. |
| YouTube/thumbnail/avatar/font requests | Iframe, ảnh từ URL, Google Fonts | Xác định các bên nhận request và dữ liệu, kể cả trong WebView. |

**Hồ sơ Play Console và phát hành**

- Điền Privacy URL hoạt động và Account deletion URL; đồng bộ Data safety, Ads, Advertising ID, Target audience và IARC với bản cuối. Miễn phí không đồng nghĩa không quảng cáo: cần kiểm quảng cáo YouTube/chiến dịch FIAM trước khi khai Ads.
- Chưa thấy luồng bán nội dung số hoặc external checkout đang hoạt động trong client; không ghi thiếu Play Billing là lỗi của bản hiện tại. Nếu bổ sung monetization, phải đánh giá lại theo [Payments policy](https://support.google.com/googleplay/android-developer/answer/9858738?hl=en).
- App access: chuẩn bị tài khoản demo ổn định đã verify, truy cập mọi tính năng; hướng dẫn bằng tiếng Anh, không phụ thuộc OTP dùng một lần. Thử Google Sign-In với certificate Play App Signing của bản cài từ Play. [Review access requirements](https://support.google.com/googleplay/android-developer/answer/15748846?hl=en).
- Nếu tài khoản developer cá nhân thuộc diện mới sau 13/11/2023, kiểm yêu cầu closed testing ít nhất 12 tester liên tục 14 ngày và xin production access. Chưa biết loại/ngày tạo account của dự án. [Testing requirements](https://support.google.com/googleplay/android-developer/answer/14151465?hl=en-GB).
- Listing/screenshot chỉ thể hiện chức năng đã hoàn thiện, phù hợp nhóm tuổi; không gây hiểu nhầm là app chính thức của Google/YouTube. [Metadata](https://support.google.com/googleplay/android-developer/answer/9898842?hl=en).

**Kỹ thuật Android**

- Manifest nguồn: Internet, Notifications, Vibrate. Không tìm thấy yêu cầu SMS, contacts, GPS, mic/camera, broad storage hoặc accessibility trong manifest app; không thấy TLS bypass trong client. API chính dùng HTTPS và token được lưu bằng secure storage.
- Đã đọc **manifest protobuf trực tiếp từ AAB vừa build**, không chỉ dựa vào merged manifest cũ ngày 07–08/10. Bản mới vẫn có `AD_ID`, `ACCESS_ADSERVICES_AD_ID`, attribution, network state, wake lock, biometric/fingerprint và FCM. Không có thuộc tính `debuggable` trong application. Permission biometric do dependency không tự chứng minh app đang thu dữ liệu sinh trắc.
- AAB xác nhận package `com.snapsofts.vocabik.yt`, min SDK **24**, target API **36**. Google yêu cầu app mobile mới/update target API 36 từ 31/08/2026. [Target API](https://support.google.com/googleplay/android-developer/answer/11926878?hl=en-TJ).
- AGP 8.11.1, NDK 28.2.13676358. **10/10 thư viện ELF 64-bit** trong AAB (arm64-v8a/x86_64: libapp, libflutter, librive_native, libdartjni, libdatastore_shared_counter) có LOAD segment alignment tối thiểu 16 KB và offset/vaddr phù hợp 16 KB. Đây mới là kiểm tra tĩnh ELF; chưa kiểm ZIP alignment của APK do Play tạo hoặc chạy thiết bị/emulator 16 KB. [16 KB guidance](https://developer.android.com/guide/practices/page-sizes).
- Có `android/key.properties` tại thời điểm kiểm tra và guard chống fallback debug ngoài trường hợp override test. Không đọc/in giá trị mật khẩu ký. CI hiện phân phối APK qua Firebase App Distribution, không thay cho kiểm thử qua Google Play.

**Các điểm cũ đã cải thiện, không ghi lại thành lỗi còn tồn tại**

- `AuthUtils.isCurrentSelf` đã ưu tiên kết quả so sánh stable ID; hai test audit với người khác tên `Alice`/`You` đều pass.
- Login/register đã có legal notice 13+ cùng links; có legal consent screen/version, router cho mở Terms/Privacy trong onboarding. Màn verify/CEFR đã có thao tác xóa tài khoản. Không còn kết luận thiếu hoàn toàn đường consent/legal như báo cáo cũ.
- Privacy đã bỏ cách mô tả crash logs là ẩn danh hoàn toàn; ngày legal mobile cập nhật 15/10/2026. Vẫn cần bổ sung các mục còn thiếu ở phát hiện 1.
- Có API report/block, danh sách người bị chặn, xóa tài khoản trong app và URL xóa public; Google logo SVG, player origin/kích thước, secure token storage và giới hạn nhiều log vào debug đã được triển khai.

**Kết quả kiểm chứng lần này**

- `flutter analyze --no-pub`: **No issues found**, exit 0, 68,4 giây. [Log](D:/App/vocabik_app/build/policy_audit_2026_10_20/analyze.log).
- `flutter test --no-pub --reporter expanded`: **206 tests passed**, exit 0, khoảng 34 giây trong runner. [Log](D:/App/vocabik_app/build/policy_audit_2026_10_20/tests.log).
- Test audit bổ sung: **2 pass, 3 fail đúng tại hành vi cần sửa**. Hai test stable ID pass; report false, block false và password whitespace fail. Không phải lỗi compilation, không gọi API production. [Mã test](D:/App/vocabik_app/build/policy_audit_2026_10_20/regressions_test.dart), [log](D:/App/vocabik_app/build/policy_audit_2026_10_20/regressions.log). File trong build có thể mất sau `flutter clean`.
- Ba trang legal/deletion public đều HTTP 200 sau kiểm tra ngoài sandbox; lỗi DNS của lượt sandbox không được dùng để kết luận website không hoạt động.
- `flutter build appbundle --release --no-pub`: **thành công**, exit 0; Gradle 439 giây. [Log](D:/App/vocabik_app/build/policy_audit_2026_10_20/appbundle.log). [AAB](D:/App/vocabik_app/build/app/outputs/bundle/release/app-release.aab) có 86.611.370 bytes, SHA-256 `c0e0d77e5ae73e5dadacb2f507ae37f80962d4136dc622b56e083de727100a53`. `keytool -printcert -jarfile` đọc được chứng thư `CN=snapsoft`, không phải tên chứng thư Android Debug mặc định; chưa đối chiếu upload certificate trong Play Console.
- [Kết quả manifest/ELF từ AAB](D:/App/vocabik_app/build/policy_audit_2026_10_20/bundle_alignment.json), [script kiểm tra](D:/App/vocabik_app/build/policy_audit_2026_10_20/check_bundle.py). Không coi build thành công và ELF pass là chứng nhận app đã đáp ứng mọi yêu cầu của Google Play. Chưa upload AAB hoặc chạy pre-launch report.

**Thứ tự xử lý đề nghị:** hoàn thiện privacy/data inventory và report nội dung → sửa false-success moderation, password deletion và nút chia sẻ → nghiệm thu xóa dữ liệu/moderation/content 13+ ở backend → hoàn tất khai báo Console và hồ sơ bản quyền → kiểm AAB cuối trên Play internal testing/16 KB/pre-launch report. Chỉ kết luận sẵn sàng gửi production khi các mục kiểm chứng còn thiếu đã có bằng chứng.
