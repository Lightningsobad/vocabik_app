---
description: Kiểm toán Cấu hình Build & Thư viện (Dependency & Build Audit). Đánh giá tính chính xác, phát hiện xung đột và tối ưu hóa các file cấu hình hệ thống (pubspec.yaml, build.gradle, AndroidManifest.xml, Podfile) chuẩn bị cho môi trường Release.
---

Đóng vai là một Chuyên gia DevOps và Kỹ sư Nền tảng (Platform Engineer) chuyên sâu về hệ sinh thái Flutter, Android và iOS. Hãy giúp tôi thực hiện Kiểm toán Cấu hình Build và Thư viện (Config & Dependency Audit) cho ứng dụng di động Vocabik.

Mục tiêu của đợt review này là đảm bảo các file cấu hình hệ thống (pubspec.yaml, build.gradle, Podfile...) được thiết lập CHÍNH XÁC, KHÔNG CÓ XUNG ĐỘT, VÀ TỐI ƯU NHẤT để chuẩn bị cho việc đóng gói (release).

🎯 BỐI CẢNH KIỂM TOÁN (AUDIT CONTEXT):
- Nền tảng đích: Android và iOS.
- Các file cần tập trung phân tích: `pubspec.yaml`, `android/app/build.gradle`, `android/build.gradle`, `android/app/src/main/AndroidManifest.xml`, và `ios/Podfile`.

📋 YÊU CẦU KIỂM TOÁN (AUDIT REQUIREMENTS):
Vui lòng đọc kỹ các file cấu hình được cung cấp và xuất Báo cáo Kiểm toán tập trung vào 4 tiêu chí sau:

1. Xung đột Thư viện & Phiên bản (Dependency Conflicts & Versioning):
   - Trong `pubspec.yaml`: Có thư viện nào đang để phiên bản quá lỏng lẻo (VD: `any` hoặc thiếu dấu mũ `^`) dễ gây rủi ro khi update không?
   - Có sự bất đồng bộ hoặc xung đột tiềm ẩn giữa các thư viện core không? (VD: xung đột phiên bản của `firebase_core` với các module firebase khác, hoặc xung đột các thư viện liên quan đến Google Play Services).
   - Phiên bản Kotlin (ext.kotlin_version) và Gradle plugin có tương thích với nhau và với phiên bản Flutter hiện hành không?

2. Sự đúng đắn của Cấu hình Build (Build Configuration Correctness):
   - Trong `android/app/build.gradle`: Các thông số `compileSdkVersion`, `minSdkVersion`, `targetSdkVersion` có đạt chuẩn mới nhất (hoặc ít nhất đáp ứng yêu cầu của Google Play Store) chưa?
   - Có cần phải kích hoạt `multiDexEnabled true` dựa trên số lượng thư viện hiện có không?
   - Application ID và Namespace đã được cấu hình nhất quán chưa?

3. Tối ưu hóa & Kích thước Ứng dụng (Optimization & App Size):
   - Trong `pubspec.yaml`: Có thư viện nào có vẻ như không cần thiết hoặc có thể thay thế bằng giải pháp native của Flutter để giảm dung lượng app không?
   - Trong cấu hình Android: Tính năng thu gọn mã (minifyEnabled/R8) và ProGuard rules đã được thiết lập đúng cho bản `release` chưa để tối ưu dung lượng APK/AAB?

4. Quyền truy cập & Bảo mật (Permissions & Security):
   - Rà soát `AndroidManifest.xml` (và `Info.plist` nếu có): Có khai báo quyền (permissions) nào thừa thãi, không khớp với danh sách thư viện đang dùng (dễ bị reject khi lên Store) không?

🚨 ĐỊNH DẠNG ĐẦU RA (OUTPUT FORMAT):
Phân loại các vấn đề tìm thấy theo mức độ:
- 🔴 Lỗi Build / Blockers (Cấp bách): Xung đột phiên bản chắc chắn gây lỗi build, thông số SDK quá cũ không thể lên Store (BẮT BUỘC SỬA - Kèm code sửa đổi).
- 🟡 Cảnh báo rủi ro (Warning): Thư viện dùng bản lỏng lẻo, cấu hình chưa bật R8/ProGuard cho release, thiếu MultiDex (Kèm cấu hình đề xuất).
- 🟢 Tối ưu hóa (Suggestion): Loại bỏ thư viện thừa, cập nhật lên version mới hơn, dọn dẹp file cấu hình.

Hãy phân tích các file cấu hình dự án của tôi và cung cấp báo cáo.
