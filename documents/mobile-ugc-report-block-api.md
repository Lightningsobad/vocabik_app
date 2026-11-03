# Tài liệu Tích hợp API Báo cáo & Chặn (UGC Report & Block API)

Tài liệu này đặc tả chi tiết các API phục vụ tính năng **Báo cáo nội dung vi phạm (Report)** và **Chặn người dùng (Block)**, nhằm đáp ứng đầy đủ **Chính sách nội dung do người dùng tạo (User-Generated Content - UGC Policy)** của Google Play Store.

---

## 1. Tổng quan Chính sách UGC của Google Play

Bất kỳ ứng dụng nào cho phép người dùng tạo nội dung mà người dùng khác có thể nhìn thấy (như Tên hiển thị, Lớp học, Bình luận, Bạn bè, Bảng xếp hạng) bắt buộc phải có:
1. **Nút Báo cáo (Report):** Cho phép người dùng báo cáo nội dung hoặc hành vi vi phạm.
2. **Nút Chặn (Block):** Cho phép người dùng chặn người dùng quấy rối/xúc phạm.
3. **Cơ chế phản hồi & kiểm duyệt:** Thông báo rõ cho người dùng báo cáo sẽ được xem xét và xử lý trong vòng **24 giờ**.
4. **Điều khoản sử dụng:** Nêu rõ không khoan nhượng đối với hành vi phản cảm hoặc người dùng lạm dụng.

---

## 2. Danh sách API

---

### 2.1. Báo cáo nội dung / người dùng vi phạm (Report)

Gửi báo cáo khi phát hiện người dùng có tên/ảnh không phù hợp, lớp học vi phạm, hoặc hành vi quấy rối.

- **Method**: `POST`
- **Path**: `/api/v1/reports`
- **Headers**:
  ```http
  Authorization: Bearer <accessToken>
  Content-Type: application/json
  ```

#### Request Body (JSON)

| Trường | Kiểu | Bắt buộc | Giá trị hợp lệ / Mô tả |
| :--- | :--- | :--- | :--- |
| `targetType` | `string` | **Có** | Loại đối tượng bị báo cáo. Một trong các giá trị:<br>- `user` (Báo cáo người dùng)<br>- `classroom` (Báo cáo lớp học)<br>- `comment` (Báo cáo bình luận/trao đổi)<br>- `video` (Báo cáo video gợi ý)<br>- `other` (Khác) |
| `targetId` | `string` | **Có** | ID (UUID hoặc chuỗi định danh) của đối tượng bị báo cáo (ví dụ: `userId`, `classroomId`). |
| `reason` | `string` | **Có** | Phân loại vi phạm. Một trong các giá trị:<br>- `spam`: Quảng cáo, tin rác<br>- `harassment`: Quấy rối, đe dọa, xúc phạm<br>- `inappropriate_content`: Nội dung không lành mạnh, bạo lực, 18+<br>- `hate_speech`: Ngôn từ thù hận, phân biệt đối xử<br>- `other`: Lý do khác |
| `details` | `string` | Không | Mô tả bổ sung chi tiết vi phạm (tối đa 1000 ký tự). |

##### Ví dụ Request Body:
```json
{
  "targetType": "user",
  "targetId": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "reason": "harassment",
  "details": "Người dùng này liên tục gửi lời mời và dùng tên xúc phạm người khác."
}
```

#### Response Success (HTTP 201 Created)
```json
{
  "success": true,
  "reportId": "8f3b2e1a-4c5d-6e7f-8a9b-0c1d2e3f4a5b",
  "message": "Báo cáo của bạn đã được tiếp nhận. Đội ngũ kiểm duyệt sẽ xử lý trong vòng 24 giờ."
}
```

#### Response Errors:
- **HTTP 400 Bad Request**: Dữ liệu không hợp lệ hoặc người dùng cố gắng tự báo cáo chính mình (`CANNOT_REPORT_SELF`).
- **HTTP 401 Unauthorized**: Thiếu Access Token hoặc token hết hạn.

---

### 2.2. Chặn người dùng (Block User)

Chặn một người dùng khác. Hệ thống sẽ tự động gỡ kết bạn (nếu có) và ngăn chặn mọi tương tác.

- **Method**: `POST`
- **Path**: `/api/v1/users/{targetUserId}/block`
- **Headers**:
  ```http
  Authorization: Bearer <accessToken>
  ```

#### Path Parameters:
| Tham số | Kiểu | Mô tả |
| :--- | :--- | :--- |
| `targetUserId` | `string` (UUID) | ID của người dùng cần chặn. |

#### Response Success (HTTP 200 OK)
```json
{
  "success": true,
  "targetUserId": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "message": "Đã chặn người dùng thành công."
}
```

#### Response Errors:
- **HTTP 400 Bad Request**: Cố gắng tự chặn chính mình (`CANNOT_BLOCK_SELF`).
- **HTTP 404 Not Found**: Người dùng cần chặn không tồn tại hoặc đã bị xóa.

---

### 2.3. Bỏ chặn người dùng (Unblock User)

Gỡ bỏ trạng thái chặn để có thể tương tác lại.

- **Method**: `DELETE`
- **Path**: `/api/v1/users/{targetUserId}/block`
- **Headers**:
  ```http
  Authorization: Bearer <accessToken>
  ```

#### Response Success (HTTP 200 OK)
```json
{
  "success": true,
  "targetUserId": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "message": "Đã bỏ chặn người dùng."
}
```

---

### 2.4. Lấy danh sách người dùng đã chặn (List Blocked Users)

Dùng để hiển thị trong màn hình *Cài đặt > Danh sách người dùng đã chặn*.

- **Method**: `GET`
- **Path**: `/api/v1/users/blocked`
- **Headers**:
  ```http
  Authorization: Bearer <accessToken>
  ```

#### Response Success (HTTP 200 OK)
```json
[
  {
    "userId": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "displayName": "User Bị Chặn",
    "blockedAt": "2026-10-14T08:30:00.000Z"
  }
]
```

---

## 3. Luồng Giao diện Đề xuất trên Mobile App (UI/UX)

### 3.1. Nút Menu Báo cáo / Chặn (More Options `...`)
- Trên các màn hình hiển thị nội dung người khác:
  - Trang cá nhân của bạn học / thành viên lớp học.
  - Thẻ lớp học của người khác tạo.
  - Danh sách bạn bè.
- Hiển thị nút biểu tượng **ba chấm (`...`)** hoặc **Lá cờ (Flag)**:
  - Bấm vào mở Menu / ActionSheet gồm 2 tùy chọn:
    1. **Báo cáo người dùng / nội dung này** (Màu cam/vàng).
    2. **Chặn người dùng này** (Màu đỏ).

### 3.2. Hộp thoại Báo cáo (Report Bottom Sheet / Dialog)
1. **Tiêu đề:** "Báo cáo vi phạm"
2. **Chọn lý do (Radio buttons):**
   - [ ] Quảng cáo hoặc thư rác (`spam`)
   - [ ] Quấy rối hoặc bắt nạt (`harassment`)
   - [ ] Nội dung không phù hợp / 18+ (`inappropriate_content`)
   - [ ] Phát ngôn thù địch (`hate_speech`)
   - [ ] Khác (`other`)
3. **Mô tả thêm (TextInput - Không bắt buộc):** "Nhập chi tiết về vi phạm..."
4. **Nút bấm:** "Gửi báo cáo"
5. **Thông báo sau khi gửi:**
   - Hiển thị Alert hoặc Snackbar:
     > *"Cảm ơn bạn đã gửi báo cáo. Chúng tôi sẽ xem xét và xử lý vi phạm trong vòng 24 giờ."*
   - Sau khi báo cáo thành công, hiển thị thêm hộp thoại gợi ý:
     > *"Bạn có muốn chặn người dùng này luôn không? Bạn sẽ không còn nhìn thấy hoạt động của họ nữa."* -> Có nút **"Chặn"** và **"Để sau"**.

### 3.3. Xử lý UI tức thì khi Chặn (Optimistic UI)
- Khi người dùng nhấn **Chặn**:
  - Gọi API `POST /api/v1/users/{targetUserId}/block`.
  - Ẩn ngay lập tức người dùng hoặc nội dung đó khỏi màn hình hiện tại (xóa khỏi danh sách bạn bè, ẩn profile).
  - Hiển thị Toast: *"Đã chặn người dùng này."*

### 3.4. Màn hình quản lý chặn
- Trong *Cài đặt (Settings)* thêm mục: **"Người dùng đã chặn"**.
- Hiển thị danh sách từ API `GET /api/v1/users/blocked`, mỗi dòng có nút **"Bỏ chặn"** (gọi `DELETE /api/v1/users/{targetUserId}/block`).

---

## 4. Danh sách Kiểm tra cho Google Play Review (UGC Checklist)

Khi nộp app lên Google Play Console, reviewer sẽ kiểm tra các yếu tố sau:

1. [x] **Có cơ chế báo cáo in-app:** Nút báo cáo có dễ tìm thấy không? (Có).
2. [x] **Có cơ chế chặn in-app:** Có thể chặn người dùng vi phạm không? (Có).
3. [x] **Cam kết phản hồi trong 24h:** Có thông báo rõ ràng cho người dùng rằng báo cáo sẽ được xử lý trong vòng 24 giờ không? (Có, được trả về từ API và hiển thị trên UI).
4. [x] **Điều khoản dịch vụ (Terms):** Đảm bảo liên kết đến trang điều khoản có nêu rõ quy chuẩn cấm nội dung phản cảm (`https://vocabik.com/terms`).
