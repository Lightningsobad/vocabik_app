# Vocabik Mobile API Documentation — Progress & Gamification

Tài liệu đặc tả API cho ứng dụng Mobile (iOS / Android / React Native / Flutter) để tích hợp màn hình **Tiến độ học tập & Gamification (Progress Dashboard)**.

---

## 1. Tổng Quan & Xác Thực

- **Base URL**: `https://<api-domain>/api/v1`
- **Môi trường Dev/Staging**: `http://localhost:3001/api/v1`
- **Authentication**: JWT Bearer Token trong header `Authorization` hoặc `Cookie` (web session).
- **Header chuẩn**:
  ```http
  Authorization: Bearer <user_access_token>
  Content-Type: application/json
  ```

---

## 2. API Endpoints

### 2.1. `GET /api/v1/progress/summary` (Màn hình chính Tiến độ)

Lấy toàn bộ dữ liệu tổng hợp cho màn hình Progress: Chuỗi ngày (Streak), Cấp độ danh hiệu (Level Title & XP), Biểu đồ XP 4 tuần gần nhất và Thống kê tổng quan.

#### Yêu cầu:
- **Method**: `GET`
- **Path**: `/api/v1/progress/summary`
- **Auth**: Yêu cầu đăng nhập (`Bearer <token>`)

#### Phản hồi thành công (`200 OK`):
```json
{
  "streak": {
    "currentStreak": 12,
    "longestStreak": 12,
    "freezeActive": false,
    "freezeCount": 1,
    "heatmap30Days": [
      false, false, true, true, true, false, true,
      true, true, true, false, true, true, true,
      true, true, true, true, true, true, false,
      true, true, true, true, true, true, true, true, true
    ]
  },
  "level": {
    "level": "B1",
    "currentTitle": "Fluent Challenger",
    "nextTitle": "Master Listener",
    "currentXpInLevel": 240,
    "xpRequiredForNextLevel": 3000,
    "totalXp": 2240,
    "progressPct": 8,
    "remainingXp": 2760
  },
  "weeklyXp": [
    { "label": "T1", "xp": 120 },
    { "label": "T2", "xp": 280 },
    { "label": "T3", "xp": 340 },
    { "label": "T4", "xp": 500 }
  ],
  "stats": {
    "exercisesCompleted": 74,
    "accuracyPct": 78
  }
}
```

#### Chi tiết các trường (Field Descriptions):

| Khối | Trường | Kiểu dữ liệu | Mô tả |
| :--- | :--- | :--- | :--- |
| **`streak`** | `currentStreak` | `number` | Số ngày liên tiếp đang giữ streak (ví dụ: `12` ngày). |
| | `longestStreak` | `number` | Chuỗi streak dài nhất người dùng từng đạt được. |
| | `freezeActive` | `boolean` | `true` nếu hôm nay streak đang được bảo vệ bởi Streak Freeze. |
| | `freezeCount` | `number` | Số lượt Streak Freeze còn lại (`1` cho gói Premium, `0` cho Free). |
| | `heatmap30Days` | `boolean[]` | Mảng 30 phần tử boolean tương ứng 30 ngày gần nhất (từ 29 ngày trước đến hôm nay). `true` nghĩa là có học ít nhất 1 bài. |
| **`level`** | `level` | `string` | Trình độ CEFR của user (`A1`, `A2`, `B1`, `B2`, `C1`). |
| | `currentTitle` | `string` | Danh hiệu hiện tại dựa trên tổng XP: `Beginner`, `Explorer`, `Fluent Challenger`, `Master Listener`. |
| | `nextTitle` | `string \| null` | Danh hiệu tiếp theo (`null` nếu đã đạt cấp cao nhất). |
| | `currentXpInLevel`| `number` | Số XP kiếm được tính từ mốc bắt đầu của danh hiệu hiện tại. |
| | `xpRequiredForNextLevel` | `number` | Tổng số XP cần có giữa cấp hiện tại và cấp tiếp theo. |
| | `totalXp` | `number` | Tổng số XP tích lũy toàn thời gian của người dùng. |
| | `progressPct` | `number` | Phần trăm thanh tiến độ (0 - 100) để vẽ ProgressBar. |
| | `remainingXp` | `number` | Số XP còn thiếu để thăng cấp danh hiệu kế tiếp. |
| **`weeklyXp`**| `weeklyXp` | `Array<{ label: string, xp: number }>` | 4 cột biểu đồ XP theo tuần (T1: 4 tuần trước, ..., T4: tuần hiện tại). |
| **`stats`** | `exercisesCompleted` | `number` | Tổng số bài tập video đã hoàn thành. |
| | `accuracyPct` | `number \| null` | Tỉ lệ trả lời chính xác trung bình (0 - 100). `null` nếu chưa làm bài nào. |

---

### 2.2. Quy Tắc Phân Bậc Danh Hiệu (Gamification Level Titles)

Hệ thống phân bậc chuẩn hoá 4 cấp độ:

| Mức XP tối thiểu | Danh hiệu (Level Title) | Cấp độ tiếp theo |
| :--- | :--- | :--- |
| **0 XP** | **Beginner** | Explorer (500 XP) |
| **500 XP** | **Explorer** | Fluent Challenger (2,000 XP) |
| **2,000 XP** | **Fluent Challenger** | Master Listener (5,000 XP) |
| **5,000 XP** | **Master Listener** | *(Max Level)* |

#### Công thức tính hiển thị:
- **Tiêu đề Card**: `B1 — Fluent Challenger` (hoặc `Fluent Challenger`)
- **Số XP hiển thị**: `{currentXpInLevel} / {xpRequiredForNextLevel} XP` (ví dụ: `240 / 3,000 XP`)
- **Thanh Progress Bar**: `progressPct` %
- **Dòng gợi ý tiếp theo**:
  - Nếu có `nextTitle`: `→ Tiếp theo: {nextTitle} (cần thêm {remainingXp} XP)`
  - Nếu max cấp: `Đã đạt cấp độ cao nhất! 🎉`

---

### 2.3. `GET /api/v1/progress/history` (Lịch sử làm bài gần đây)

Lấy danh sách 50 bài học gần nhất người dùng đã hoàn thành.

#### Yêu cầu:
- **Method**: `GET`
- **Path**: `/api/v1/progress/history`

#### Phản hồi (`200 OK`):
```json
{
  "items": [
    {
      "videoTitle": "Ordering Food at a Restaurant",
      "cefrLevel": "B1",
      "accuracyScore": 85,
      "completedAt": "2026-06-04T10:30:00.000Z"
    },
    {
      "videoTitle": "Daily Commute English",
      "cefrLevel": "A2",
      "accuracyScore": 92,
      "completedAt": "2026-06-03T14:15:00.000Z"
    }
  ]
}
```

---

### 2.4. `GET /api/v1/progress/error-insights` (Điểm cần cải thiện / Weak Points)

Lấy phân tích các lỗi ngữ pháp thường gặp và tỉ lệ chính xác theo chủ đề.

#### Phản hồi (`200 OK`):
```json
{
  "state": "ok",
  "categories": [
    { "category": "Prepositions", "accuracyPct": 45, "errorCount": 12 },
    { "category": "Articles", "accuracyPct": 62, "errorCount": 8 },
    { "category": "Phrasal verbs", "accuracyPct": 71, "errorCount": 5 }
  ],
  "trend": [
    { "weekLabel": "T1", "accuracyPct": 55 },
    { "weekLabel": "T2", "accuracyPct": 68 },
    { "weekLabel": "T3", "accuracyPct": 74 },
    { "weekLabel": "T4", "accuracyPct": 78 }
  ]
}
```
*Ghi chú: Nếu chưa có đủ dữ liệu, `state` trả về `"insufficient_data"` hoặc `"no_tagged_data"`.*

---





## 4. Mã Lỗi & Xử Lý Ngoại Lệ (Error Handling)

| HTTP Status | Nguyên nhân | Hướng xử lý cho Mobile App |
| :--- | :--- | :--- |
| **`401 Unauthorized`** | Token hết hạn hoặc chưa đăng nhập | Điều hướng người dùng về màn hình Login (`/login`). |
| **`400 Bad Request`** | Sai định dạng payload (ví dụ `completed_at` không phải ISO-8601) | Kiểm tra lại dữ liệu trước khi gửi. |
| **`500 Internal Server Error`** | Lỗi hệ thống server | Hiển thị Toast thông báo lỗi mạng hoặc thử lại sau. |
