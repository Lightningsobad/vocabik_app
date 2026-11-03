# Tài liệu Tích hợp API Xóa tài khoản (User Account Deletion API)

Tài liệu này đặc tả chi tiết API xóa tài khoản người dùng (`DELETE /api/v1/auth/me`) nhằm đáp ứng **chính sách bắt buộc của Google Play (Data Safety & In-App Account Deletion Policy)** cho ứng dụng di động Vocabik.

---

## 1. Tổng quan & Cơ chế hoạt động

- **Chính sách Google Play:** Mọi ứng dụng có tính năng đăng ký/đăng nhập đều bắt buộc phải cung cấp tính năng xóa tài khoản ngay bên trong ứng dụng và một đường dẫn web (URL) để yêu cầu xóa dữ liệu bên ngoài ứng dụng.
- **Xác thực:** Request yêu cầu Access Token hợp lệ của tài khoản cần xóa (`Authorization: Bearer <accessToken>`).
- **Xác nhận danh tính:**
  - Nếu tài khoản đăng ký bằng **Email/Mật khẩu**: Người dùng cần nhập lại mật khẩu hiện tại trong trường `password` để bảo vệ an toàn.
  - Nếu tài khoản đăng ký bằng **Google / Facebook (OAuth)**: Không có mật khẩu, request không cần gửi trường `password` (chỉ cần gửi xác nhận).
- **Phía Backend khi thực thi:**
  1. Đánh dấu `deletedAt = now()` và đổi `role = 'user'`.
  2. Ẩn danh hóa thông tin cá nhân (PII): `displayName` chuyển thành `Deleted User`, `email` được scramble thành dạng `deleted_<id>_<timestamp>@deleted.vocabik.com` để giải phóng email gốc (cho phép người dùng đăng ký lại sau này nếu muốn) và bảo mật dữ liệu.
  3. Xóa mật khẩu đã lưu (`passwordHash = null`).
  4. Thu hồi (`revoked_at = now()`) **tất cả** các phiên đăng nhập đang hoạt động trên mọi thiết bị.
  5. Xóa bỏ các liên kết bạn bè (`friendships`), mã mời (`friend_invite_links`), bot Telegram/Zalo (`bot_links`), tư cách thành viên lớp học (`classroom_members`).

---

## 2. Đặc tả API

### Endpoint: Xóa tài khoản người dùng

- **Method**: `DELETE`
- **Path**: `/api/v1/auth/me`
- **Headers**:
  ```http
  Authorization: Bearer <accessToken>
  Content-Type: application/json
  ```

#### Request Body (JSON)

| Trường | Kiểu | Bắt buộc | Mô tả |
| :--- | :--- | :--- | :--- |
| `password` | `string` | **Có** (đối với tài khoản Email/Password); **Không** (đối với tài khoản Social Google/Facebook) | Mật khẩu hiện tại của tài khoản để xác thực danh tính. |
| `reason` | `string` | Không | Lý do người dùng muốn xóa tài khoản (tối đa 500 ký tự) phục vụ thống kê cải thiện sản phẩm. |

##### Ví dụ Request Body (Tài khoản Email/Password):
```json
{
  "password": "mySecurePassword123!",
  "reason": "Không còn nhu cầu học tiếng Anh"
}
```

##### Ví dụ Request Body (Tài khoản Google / Facebook):
```json
{
  "reason": "Chuyển sang thiết bị khác"
}
```
*(Hoặc gửi body rỗng `{}`)*

---

#### Response Success (HTTP 200 OK)

Trả về khi tài khoản đã được xóa và các phiên đăng nhập bị thu hồi thành công:
```json
{
  "success": true,
  "message": "Tài khoản và dữ liệu liên quan đã được xóa thành công."
}
```

---

#### Response Errors

| HTTP Status | Error Code | Mô tả | Xử lý trên Mobile UI |
| :--- | :--- | :--- | :--- |
| **400 Bad Request** | `AUTH_PASSWORD_REQUIRED` | Tài khoản email/mật khẩu nhưng không gửi trường `password`. | Hiển thị input yêu cầu người dùng nhập mật khẩu. |
| **400 Bad Request** | `AUTH_INVALID_PASSWORD` | Mật khẩu nhập vào không chính xác. | Báo lỗi "Mật khẩu không chính xác, vui lòng thử lại." |
| **401 Unauthorized** | `AUTH_UNAUTHENTICATED` | Token hết hạn hoặc tài khoản không tồn tại / đã bị xóa trước đó. | Chuyển hướng người dùng về màn hình Đăng nhập. |

---

## 3. Hướng dẫn Triển khai Giao diện Mobile (UI/UX)

1. **Vị trí nút Xóa tài khoản:**
   - Đặt tại: *Màn hình Cá nhân (Profile) > Cài đặt (Settings) > Tài khoản (Account)*.
   - Thường đặt ở cuối cùng trang với màu đỏ (Danger styling): **"Xóa tài khoản"**.

2. **Hộp thoại xác nhận (Confirmation Dialog):**
   - Tiêu đề: **"Xóa tài khoản của bạn?"**
   - Nội dung cảnh báo:
     > *"Hành động này không thể hoàn tác. Toàn bộ tiến trình học, điểm số XP, chuỗi ngày học Streak, sổ từ vựng cá nhân và danh sách bạn bè của bạn sẽ bị xóa vĩnh viễn."*
   - Nếu tài khoản có mật khẩu: Hiển thị trường `TextInput` (kiểu password) yêu cầu nhập mật khẩu.
   - Có 2 nút: **"Hủy"** và **"Xác nhận xóa tài khoản"** (màu đỏ).

3. **Xử lý sau khi gọi API thành công:**
   - Xóa toàn bộ Token (Access Token, Refresh Token) trong bộ nhớ an toàn của thiết bị (`EncryptedSharedPreferences` trên Android / `Keychain` trên iOS).
   - Xóa sạch local database, SQLite, hoặc cache của app.
   - Hiển thị Toast / Alert: *"Tài khoản của bạn đã được xóa thành công."*
   - Chuyển hướng (Reset Navigation Stack) về màn hình Welcome / Đăng nhập.

---

## 4. Khai báo trên Google Play Console (Data Safety)

Khi gửi bản phát hành lên Google Play Console, bạn cần điền thông tin sau trong mục **Nội dung ứng dụng (App content) > An toàn dữ liệu (Data safety)**:

1. **Does your app allow users to create an account?** -> Chọn **Yes**.
2. **Do you provide a way for users to request that their account and data be deleted?** -> Chọn **Yes**.
3. **Where can users request account deletion?**
   - Chọn cả 2 tùy chọn:
     - [x] **Within the app**
     - [x] **From a web link**
4. **Delete account URL (Đường dẫn web yêu cầu xóa tài khoản):**
   ```text
   https://vocabik.com/delete-account
   ```
   *(Trang này đã được tạo sẵn trên hệ thống Vocabik với đầy đủ hướng dẫn theo quy định của Google).*
