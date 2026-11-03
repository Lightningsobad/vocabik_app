# Tài liệu Tích hợp API Mobile Social Login (Google & Facebook)

Tài liệu đặc tả các API xác thực mạng xã hội (Native Social Login) dành cho Mobile App trên hệ thống Vocabik.

---

## 1. Tổng quan cơ chế xác thực

- **Web OAuth (`/api/v1/auth/google`, `/api/v1/auth/facebook`)**: Dành riêng cho Web Browser, sử dụng cơ chế Authorization Code Flow, Cookie Session và 302 Redirect về domain `vocabik.com`.
- **Mobile Native Social Login**: Mobile App sử dụng Native SDK để lấy token (`idToken` đối với Google, `accessToken` đối với Facebook), sau đó gửi trực tiếp lên API Backend để nhận về JSON chứa `accessToken` và `refreshToken`.

---

## 2. Danh sách API

### 2.1. Đăng nhập với Google (Mobile)

Xác thực người dùng thông qua Google ID Token (JWT) được cấp từ Google Sign-In SDK trên Mobile.

- **Method**: `POST`
- **Path**: `/api/v1/auth/google/mobile`
- **Headers**:
  ```http
  Content-Type: application/json
  x-client-type: mobile
  ```

#### Request Body
| Trường | Kiểu | Bắt buộc | Mô tả |
| :--- | :--- | :---: | :--- |
| `idToken` | `string` | **Có** | Chuỗi OpenID Connect ID Token từ Google Sign-In SDK. |
| `anonymousSessionId` | `string` | Không | UUID của phiên nặc danh (nếu cần merge tiến độ học trước khi đăng nhập). |

*Ví dụ Request Body:*
```json
{
  "idToken": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjY0NmQ2Zj...",
  "anonymousSessionId": "550e8400-e29b-41d4-a716-446655440000"
}
```

#### Response Success (HTTP 200 OK)
```json
{
  "id": "c1f76d90-3b91-49fa-9dbb-65dfb12e3e60",
  "email": "user@gmail.com",
  "displayName": "Nguyen Van A",
  "tier": "free",
  "emailVerified": true,
  "tokens": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "84d59f33b1e95267a1491d90479133b384c2f4628ef4045fbc5f778a3c82d49e"
  }
}
```

#### Response Errors
- **HTTP 400 Bad Request** (Thiếu email từ tài khoản Google hoặc thiếu `idToken`):
  ```json
  {
    "error": {
      "code": "AUTH_OAUTH_EMAIL_MISSING",
      "message": "Google account did not provide an email address."
    }
  }
  ```
- **HTTP 401 Unauthorized** (ID Token không hợp lệ, hết hạn hoặc sai chữ ký):
  ```json
  {
    "error": {
      "code": "AUTH_SOCIAL_TOKEN_INVALID",
      "message": "Invalid or expired Google ID token."
    }
  }
  ```

---

### 2.2. Đăng nhập với Facebook (Mobile)

Xác thực người dùng thông qua Access Token được cấp từ Facebook Login SDK trên Mobile.

- **Method**: `POST`
- **Path**: `/api/v1/auth/facebook/mobile`
- **Headers**:
  ```http
  Content-Type: application/json
  x-client-type: mobile
  ```

#### Request Body
| Trường | Kiểu | Bắt buộc | Mô tả |
| :--- | :--- | :---: | :--- |
| `accessToken` | `string` | **Có** | Chuỗi User Access Token từ Facebook SDK. |
| `anonymousSessionId` | `string` | Không | UUID của phiên nặc danh (nếu cần merge tiến độ học trước khi đăng nhập). |

*Ví dụ Request Body:*
```json
{
  "accessToken": "EAABsbCS1iHgBA...",
  "anonymousSessionId": "550e8400-e29b-41d4-a716-446655440000"
}
```

#### Response Success (HTTP 200 OK)
```json
{
  "id": "c1f76d90-3b91-49fa-9dbb-65dfb12e3e60",
  "email": "user@facebook.com",
  "displayName": "Nguyen Van A",
  "tier": "free",
  "emailVerified": true,
  "tokens": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "84d59f33b1e95267a1491d90479133b384c2f4628ef4045fbc5f778a3c82d49e"
  }
}
```

#### Response Errors
- **HTTP 400 Bad Request** (Thiếu email từ tài khoản Facebook hoặc thiếu `accessToken`):
  ```json
  {
    "error": {
      "code": "AUTH_OAUTH_EMAIL_MISSING",
      "message": "Facebook account did not provide an email address."
    }
  }
  ```
- **HTTP 401 Unauthorized** (Access Token không hợp lệ hoặc đã bị thu hồi):
  ```json
  {
    "error": {
      "code": "AUTH_SOCIAL_TOKEN_INVALID",
      "message": "Invalid or expired Facebook access token."
    }
  }
  ```

---

## 3. Hướng dẫn sử dụng Token sau khi đăng nhập

### 3.1. Gọi các API yêu cầu xác thực
Gửi `accessToken` vào HTTP Header:
```http
Authorization: Bearer <accessToken>
```

### 3.2. Làm mới Token khi `accessToken` hết hạn
Khi API trả về `401 Unauthorized`, Mobile App sử dụng `refreshToken` để lấy cặp token mới:

- **Method**: `POST`
- **Path**: `/api/v1/auth/refresh`
- **Headers**:
  ```http
  Content-Type: application/json
  x-client-type: mobile
  ```
- **Request Body**:
  ```json
  {
    "refreshToken": "84d59f33b1e95267a1491d90479133b384c2f4628ef4045fbc5f778a3c82d49e"
  }
  ```
- **Response Success (HTTP 200 OK)**:
  ```json
  {
    "userId": "c1f76d90-3b91-49fa-9dbb-65dfb12e3e60",
    "email": "user@gmail.com",
    "role": "user",
    "displayName": "Nguyen Van A",
    "tokens": {
      "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "refreshToken": "b3e94411f2a8716298acb41290479133b384c2f4628ef4045fbc5f778a3c82d4"
    }
  }
  ```
