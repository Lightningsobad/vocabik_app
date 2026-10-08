**Rà soát Google Play / Google policies — Vocabik — 08/10/2026**

**Kết luận: chưa nên nộp bản hiện tại để xét duyệt production.** Có lỗi xác định được ở chức năng xóa tài khoản, công bố dữ liệu, lộ thông tin xác thực, cùng rủi ro đáng kể ở cách tích hợp YouTube. Những mục phụ thuộc backend, Play Console, độ tuổi và mô hình kinh doanh được ghi riêng là cần xác minh, không coi là vi phạm đã chứng minh.

Phạm vi: repository `D:\App\vocabik_app`, commit `f734595`, working tree sạch trước khi thêm báo cáo. Kiểm kê cấu trúc dự án, dependencies, Android manifests/Gradle/CI, tìm kiếm xuyên mã nguồn và đọc các luồng liên quan: đăng ký/đăng nhập, hồ sơ, dữ liệu cục bộ, API, telemetry, thông báo, bài tập/YouTube, bảng xếp hạng/bạn bè, legal. Đây là audit tĩnh theo rủi ro; không phải chứng nhận từng dòng mã đều an toàn.

Đã kiểm tra thêm APK release sẵn có ngày **16/09/2026**, merged manifest release cùng thời điểm và merged manifest debug ngày **07/10/2026**. APK release cũ không đại diện đầy đủ cho mã nguồn hiện tại. Chưa có AAB mới, chưa kiểm thử trực tiếp trên thiết bị, chưa truy cập Play Console hoặc mã nguồn backend. Công cụ web không đọc được trang chủ vocabik.com; điều này không chứng minh website bị lỗi hay không tồn tại.

**Các vấn đề cần ưu tiên trước khi nộp**

**1. Cao — Xóa tài khoản chưa hoạt động.**

- Bằng chứng: [account_tab_content.dart:59](D:/App/vocabik_app/lib/features/profile/presentation/widgets/account_tab_content.dart:59): nút xóa vĩnh viễn chỉ chứa TODO. `AuthRemoteDataSource` và `ProfileRemoteDataSource` hiện không có luồng gửi yêu cầu xóa tài khoản.
- App cho tạo tài khoản qua email và Google. Google Play yêu cầu có đường yêu cầu xóa trong app và một tài nguyên web bên ngoài app; dữ liệu liên quan phải được xử lý khi xóa, với ngoại lệ lưu giữ được công bố rõ. [Account deletion requirements](https://support.google.com/googleplay/android-developer/answer/13327111?hl=en).
- Cần triển khai yêu cầu xóa thực sự, xác thực người yêu cầu, thông báo trạng thái/thời hạn, thu hồi phiên và xử lý dữ liệu backend. Có thể dùng quy trình yêu cầu xóa thủ công nếu đáp ứng chính sách; không bắt buộc phải xóa tức thì bằng một API tự động.
- Cần cung cấp URL yêu cầu xóa công khai trong Play Console. Chưa xác minh được URL hiện có; không kết luận website chưa triển khai.
- Tiêu chí nghiệm thu: tài khoản test có thể yêu cầu xóa qua cả hai đường; xác nhận dữ liệu nào xóa, dữ liệu nào giữ và lý do; thử lại đăng nhập/phiên cũ sau khi hoàn tất.

**2. Cao — Privacy Policy chưa phản ánh dữ liệu và khả năng thực tế.**

- [app_en.arb:399](D:/App/vocabik_app/lib/l10n/app_en.arb:399) và bản tiếng Việt tương ứng chỉ mô tả ngắn email/tên/dữ liệu học. Chính sách thiếu nội dung cụ thể về lưu giữ/xóa; danh sách dịch vụ không mô tả đầy đủ Crashlytics, FCM, In-App Messaging và các định danh liên quan.
- [app_en.arb:405](D:/App/vocabik_app/lib/l10n/app_en.arb:405) gọi analytics là ẩn danh, nhưng [auth_bloc.dart:56](D:/App/vocabik_app/lib/features/auth/presentation/bloc/auth_bloc.dart:56) gắn `user.id` vào Analytics và Crashlytics. Dữ liệu gắn mã tài khoản không nên mô tả đơn giản là hoàn toàn ẩn danh.
- [app_en.arb:407](D:/App/vocabik_app/lib/l10n/app_en.arb:407) hứa xóa/xuất dữ liệu trong Settings, nhưng cả hai thao tác đang TODO. Đây là mâu thuẫn xác định từ code.
- Google yêu cầu privacy policy chính xác, mô tả cách xử lý dữ liệu và có chính sách lưu giữ/xóa; URL trên Play Console phải công khai và truy cập được. [User Data policy](https://support.google.com/googleplay/android-developer/answer/10144311?hl=en).
- Cần viết lại cả VI/EN dựa trên backend và SDK thực tế, đồng bộ bản web, bỏ cam kết chưa làm được. Không điền thời hạn lưu giữ giả định khi backend chưa xác nhận.

**3. Cao — Authorization token bị đưa vào log và UI khi cập nhật hồ sơ lỗi.**

- [profile_remote_data_source.dart:40](D:/App/vocabik_app/lib/features/profile/data/data_sources/profile_remote_data_source.dart:40) lấy nguyên header Authorization khi HTTP 401, in ra và nhúng vào `ServerException`.
- Repository chuyển nguyên message sang failure; Cubit chuyển sang state; [user_profile_section.dart:120](D:/App/vocabik_app/lib/features/profile/presentation/widgets/user_profile_section.dart:120) hiển thị message trong SnackBar. Có thể tái hiện khi 401 thực sự đi tới data source sau xử lý interceptor.
- [deep_link_service.dart:48](D:/App/vocabik_app/lib/core/services/deep_link_service.dart:48) còn in toàn bộ URI chứa token xác minh/reset mật khẩu. `fcm_service.dart` in registration token/message data; social auth và login/register in email.
- Các lệnh này không được bảo vệ toàn bộ bằng `kDebugMode`. Đã xác minh trong Flutter SDK cục bộ rằng `debugPrint` vẫn có thể ghi console ở release.
- Cần loại bỏ token/password/email khỏi log và lỗi hiển thị; dùng mã lỗi chung, redact dữ liệu trước khi gửi telemetry. Không khẳng định các log này đã bị bên thứ ba truy cập, hoặc token 401 vẫn còn dùng được.
- Đây là rủi ro xử lý dữ liệu xác thực cần sửa trước phát hành; nguyên tắc bảo vệ dữ liệu được nêu trong [User Data policy](https://support.google.com/googleplay/android-developer/answer/10144311?hl=en).

**4. Cao — YouTube player bị chặn tương tác và có lớp UI phủ lên.**

- [exercise_screen.dart:113](D:/App/vocabik_app/lib/features/exercise/presentation/screens/exercise_screen.dart:113) dùng `showControls: false`, `showFullscreenButton: false`, `pointerEvents: PointerEvents.none`.
- [exercise_video_player_widget.dart:33](D:/App/vocabik_app/lib/features/exercise/presentation/widgets/exercise_video_player_widget.dart:33) dùng `controlsBuilder`; đã kiểm tra thư viện được resolve, builder thực sự nằm trong Stack trên WebView. `custom_video_controls.dart` có GestureDetector phủ player, thanh tua luôn hiện, tên video và nút riêng.
- Điểm rủi ro là chặn cả thao tác với UI/link/quảng cáo YouTube và khả năng che nội dung/branding. Không kết luận `showControls: false` riêng lẻ là vi phạm: đó là tham số API hợp lệ. Google có hướng dẫn cho phép overlay điều khiển nếu không xung đột UI của player. [YouTube policy guidance](https://developers.google.com/youtube/terms/developer-policies-guide), [Required Minimum Functionality](https://developers.google.com/youtube/terms/required-minimum-functionality).
- Cần bỏ chặn pointer toàn bộ, giữ các tương tác bắt buộc của YouTube, đưa các điều khiển bài tập ra ngoài vùng player. Kiểm thử video có quảng cáo, end screen, lỗi, đổi hướng, màn hình nhỏ và app chạy nền; kiểm tra kích thước player cùng origin/referrer nhận diện app. Chưa chứng minh app đang tải video lậu hay chặn quảng cáo bằng network.
- Đây trước hết là rủi ro YouTube API/Terms; không phải mọi vấn đề YouTube đều tự động tương đương một lỗi Google Play đã được kết luận.

**5. Cao — Nội dung legal thiếu liên kết bắt buộc của YouTube.**

- [app_en.arb:388](D:/App/vocabik_app/lib/l10n/app_en.arb:388) chỉ nói không vi phạm YouTube ToS. Các widget legal hiện render Text thường; không có link YouTube Terms hoặc Google Privacy Policy trong nội dung app.
- Cần bổ sung link và lời chấp thuận YouTube Terms, link Google Privacy Policy, công bố nội dung bên thứ ba/cookies theo cách nhúng thực tế; rà soát đường đồng ý privacy cho cả email lẫn Google sign-in. [YouTube Developer Policies, III.A](https://developers.google.com/youtube/terms/developer-policies).
- Không đồng nhất Google Sign-In với quyền truy cập dữ liệu YouTube riêng tư: mã hiện đọc ID token đăng nhập, chưa thấy xin YouTube OAuth scopes.

**6. Cao nếu dữ liệu hiện công khai — Thiếu cơ chế xử lý nội dung người dùng trên leaderboard/bạn bè.**

- Người dùng sửa `displayName` qua [profile_remote_data_source.dart:25](D:/App/vocabik_app/lib/features/profile/data/data_sources/profile_remote_data_source.dart:25); [xp_leaderboard_list.dart:117](D:/App/vocabik_app/lib/features/leaderboard/presentation/widgets/xp_leaderboard_list.dart:117) render tên và avatar của người khác. Luồng bạn bè/thách đấu cũng có nội dung nhận diện người gửi.
- Không tìm thấy UI/API report hoặc block trong client, và Terms chưa có quy định cụ thể về nội dung phản cảm/quấy rối. Backend moderation chưa được kiểm tra.
- Nếu tên/avatar do người dùng đóng góp thực sự hiển thị cho người khác, cần đánh giá là UGC, bổ sung kiểm duyệt và công cụ báo cáo/chặn phù hợp phạm vi tương tác. App không cần có chat mới phát sinh rủi ro UGC. [User Generated Content policy](https://support.google.com/googleplay/android-developer/answer/9876937?hl=en).
- Xác minh contract/backend trước khi chốt mức ảnh hưởng: avatar có thể do hệ thống cung cấp; tên hiển thị có thể đã được kiểm duyệt. Những điều đó chưa có bằng chứng trong repo.

**Các rủi ro mức vừa / điều kiện phát hành**

| Mục | Bằng chứng | Việc cần làm |
| --- | --- | --- |
| Token trong SharedPreferences | [auth_local_data_source.dart:30](D:/App/vocabik_app/lib/features/auth/data/data_sources/auth_local_data_source.dart:30) lưu access/refresh token bằng `setString`; dependency secure storage chưa được dùng tại đây. | Chuyển token sang lưu trữ bảo mật và rà soát backup/restore. SharedPreferences nằm trong sandbox ứng dụng, không mặc định công khai; đây là điểm tăng cường an toàn, không tự nó chứng minh Play sẽ từ chối. |
| Chức năng hiển thị nhưng chưa làm | Export data, đổi password ở [security_tab_content.dart:55](D:/App/vocabik_app/lib/features/profile/presentation/widgets/security_tab_content.dart:55), đổi avatar là TODO. | Hoàn thiện hoặc ẩn khỏi bản đầu. Xóa tài khoản vẫn phải có cách yêu cầu hoạt động, không chỉ ẩn nút. |
| Release fallback debug signing | [build.gradle.kts:55](D:/App/vocabik_app/android/app/build.gradle.kts:55) fallback sang debug; hiện máy không có `android/key.properties`. | Cho build phát hành thất bại nếu thiếu cấu hình ký; dùng upload key/Play App Signing và kiểm tra certificate của AAB cuối. APK cũ verify chữ ký thành công, DN `CN=snapsoft`; không gọi APK cũ là ký debug. |
| Pipeline chỉ tạo APK | `.github/workflows/app_distribution.yml` phục vụ Firebase App Distribution. | Bổ sung bước tạo AAB cho lần phát hành Play mới; kiểm tra versionCode, signed bundle và cấu hình Google Sign-In với chứng chỉ Play. Pipeline test hiện tại không phải bằng chứng đã sẵn sàng upload Play. |
| Quyền từ SDK | Merged manifest debug 07/10 chứa `AD_ID`, `ACCESS_ADSERVICES_AD_ID`, `ACCESS_ADSERVICES_ATTRIBUTION`; merger report truy về Google measurement SDK. | Kiểm tra manifest release cuối, khai báo Advertising ID đúng. Nếu không cần chức năng quảng cáo/đo lường quảng cáo thì tắt collection liên quan và loại permission phù hợp. Có permission không tự chứng minh có quảng cáo hiển thị. |
| Thu thập tự động | Crashlytics bật ngoài debug; In-App Messaging gọi `setAutomaticDataCollectionEnabled(true)` lúc khởi động. | Công bố và lựa chọn cơ chế consent phù hợp dữ liệu/đối tượng/thị trường. Không coi mọi Analytics đều bắt buộc có popup consent riêng theo Play; prominent disclosure phụ thuộc hành vi và kỳ vọng người dùng. |

**Data safety — danh sách cần đối chiếu, chưa phải bản khai cuối**

Không thể khai app “không thu thập dữ liệu” với luồng hiện tại. Cần đối chiếu tài liệu SDK và backend, bao gồm việc dữ liệu được thu thập, chia sẻ, lưu giữ và có tùy chọn hay không. Firebase nhận dữ liệu không tự động có nghĩa mọi trường đều phải đánh dấu “shared”: còn phụ thuộc định nghĩa và ngoại lệ service provider của biểu mẫu. [Firebase data disclosure](https://firebase.google.com/docs/android/play-data-disclosure).

| Nhóm dữ liệu dự kiến | Căn cứ trong app | Nội dung cần xác minh |
| --- | --- | --- |
| Tên, email, user ID | Register/login, user model, cập nhật hồ sơ; Analytics/Crashlytics gắn user ID. | Mục đích quản lý tài khoản; phạm vi hiện công khai; backend lưu bao lâu. |
| Hoạt động học | `/progress`, điểm/XP, từ đã lưu, bài tập; Analytics tự động và screen observer. | App interactions/other user-generated content theo trường thực tế. Không coi mọi method analytics được định nghĩa là đã được gọi. |
| Crash logs/diagnostics | Crashlytics bật ở release. | Thiết bị, stack traces, breadcrumbs; lọc thông tin nhạy cảm trong message. |
| Device/other IDs | FCM/Firebase installations/measurement; AD_ID được merge. | Giá trị SDK thực sự gửi và các tùy chọn collection cuối. |
| Thông tin từ YouTube/WebView | Player iframe và thumbnail bên ngoài. | Cookies, IP/device/network data, third-party content/ads và xử lý của YouTube. |
| Ảnh/avatar | Leaderboard nhận/render avatar URL. | Người dùng có upload thật không; nguồn Google/backend/system; không tự khai “photo upload” chỉ vì UI hiển thị ảnh. |
| Lịch sử mua hàng | Chỉ thấy tier và nội dung legal Premium/Polar. | Chưa có checkout hiện hành; xác minh backend và mô hình bản phát hành. |

SDK Analytics có thể phát sinh các loại dữ liệu khác theo cấu hình. Không suy ra rằng toàn bộ app không thu thập vị trí chỉ vì không xin GPS; cần kiểm tra cả dữ liệu suy ra từ IP và cách Google hướng dẫn khai báo SDK.

**Các mục chưa thể kết luận chỉ từ repository**

1. **Độ tuổi/Families:** chưa thấy age gate hay cấu hình riêng cho trẻ em. Nếu nhắm trẻ em, hoặc có nhóm trẻ em trong audience, cần kiểm tra lại SDK, advertising identifiers, nội dung YouTube và cơ chế bảo vệ phù hợp. Chọn độ tuổi phản ánh đúng sản phẩm, không dùng nhãn 13+ để né nghĩa vụ. [Families policies](https://support.google.com/googleplay/android-developer/answer/9893335?hl=en).
2. **Premium/Billing:** repo hiện chưa có checkout hoặc luồng dẫn tới Polar; chỉ có câu trong legal và trường tier. Chưa có cơ sở kết luận đã vi phạm Payments. Khi bán quyền truy cập nội dung/chức năng số trong app, dùng Play Billing hoặc chương trình ngoại lệ thực sự phù hợp khu vực và đã đáp ứng điều kiện. [Payments policy](https://support.google.com/googleplay/android-developer/answer/9858738?hl=en).
3. **Bản quyền:** cần kiểm tra nguồn video, transcript/bản dịch/bài tập, icon, âm thanh và hình trong store listing. Nhúng player chính thức không tự động giải quyết quyền đối với bản sao transcript hoặc media được lấy riêng ở backend. Repo chưa cho thấy quy trình tạo nội dung backend nên không kết luận vi phạm bản quyền. [Intellectual Property policy](https://support.google.com/googleplay/android-developer/answer/9888072?hl=en).
4. **App access:** router bắt đăng nhập và xác minh email. Cần cung cấp tài khoản reviewer hoạt động, đã xác minh, dùng lại được và hướng dẫn tiếng Anh để truy cập đầy đủ tính năng. Chưa kiểm tra cấu hình App access trên Console. [Sign-in details for review](https://support.google.com/googleplay/android-developer/answer/15748846?hl=en).
5. **Play Console:** kiểm tra Data safety, Advertising ID, Ads, Content rating/IARC, Target audience, privacy URL, deletion URL, thông tin nhà phát triển và các yêu cầu testing áp dụng cho tài khoản. Chưa biết loại/ngày tạo tài khoản, không khẳng định một ngưỡng closed testing cụ thể áp dụng.

**Những kiểm tra đã có kết quả tốt và giới hạn của chúng**

- `flutter analyze --no-pub`: **No issues found**, exit 0, 210,7 giây. Lần đầu bị kẹt ở quyền ghi lock của Flutter SDK ngoài workspace; đã dừng và chạy lại bằng cơ chế cấp quyền. Không chạy unit/widget test trong audit này và chưa chạy kiểm thử UI trên thiết bị; analyzer không xác nhận tuân thủ policy.
- API backend cấu hình HTTPS; không thấy code bỏ qua kiểm tra TLS hay custom HTTP plaintext cho API chính.
- Manifest chính không yêu cầu SMS, contacts, location, camera, microphone, broad storage, Accessibility hoặc query toàn bộ ứng dụng. Vẫn phải kiểm manifest sau merge; danh sách quyền từ SDK ở trên là ví dụ.
- Cả Flutter SDK đang dùng và APK release cũ đều target API 36. Phù hợp yêu cầu app mới/update áp dụng từ 31/08/2026, nếu không xét các ngoại lệ/gia hạn. [Target API requirements](https://support.google.com/googleplay/android-developer/answer/11926878?hl=en).
- APK release cũ có `arm64-v8a`, `armeabi-v7a`, `x86_64`; `apksigner verify` thành công.
- `zipalign -c -P 16 4` trả exit 0 trên APK release cũ. Cả 10 thư viện `.so` của arm64/x86_64 có PT_LOAD alignment ít nhất 16384 byte. Đây là kiểm tra alignment, không thay cho chạy trên thiết bị 16 KB và kiểm AAB/split APK cuối. Tham chiếu [Android 16 KB guidance](https://developer.android.com/guide/practices/page-sizes); trang hiện có mốc 01/02/2027 cho chặn update không hỗ trợ, không nên dùng lại máy móc mốc cũ năm 2025.
- File có tên `client_secret_...json` được track thực chất có cấu trúc installed OAuth client với client ID/project/auth URLs, không có trường `client_secret` trong file đã xem. Không coi tên file hoặc Firebase client API key là bằng chứng lộ private key.
- Privacy/Terms có đường mở ở màn đăng ký và trong app. Nội dung vẫn cần sửa như các phát hiện trên.

**Thứ tự xử lý đề nghị:** hoàn thiện yêu cầu xóa tài khoản → loại bỏ token khỏi lỗi/log → cập nhật privacy/YouTube legal → sửa tương tác player → xác minh UGC/độ tuổi/Billing → chốt Data safety và URL → tạo AAB ký đúng → chạy kiểm thử thực tế/Play pre-launch report. Chưa sửa mã ứng dụng trong lần rà soát này.

