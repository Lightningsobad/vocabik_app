# Fix Light Theme Seek Bar Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Thêm token màu cho thanh seek bar vào `AppColorsExtension`, loại bỏ hoàn toàn các check `isDark` rải rác trong widget và sửa lỗi mất hiển thị thanh seek bar ở chế độ Light theme trên màn hình bài tập.

**Architecture:** Mở rộng `AppColorsExtension` với các token ngữ nghĩa: `videoSeekBarTrack`, `videoSeekBarProgress`, `videoSeekBarDotInactive`, `videoSeekBarDotActive`, `videoSeekBarDotBorder`. Widget `ExerciseCustomSeekBar` tiêu thụ trực tiếp từ theme, không chứa logic check theme thủ công (`isDark`).

**Tech Stack:** Flutter, Dart, Flutter Test

**Spec:** Yêu cầu người dùng:
- Lựa chọn 2: Dùng `colors.primaryAccent` cho cả 2 theme (Light và Dark).
- Loại bỏ hoàn toàn các code liên quan đến check `isDark` rải rác trong widget.
- Bổ sung các mã màu hiển thị cho 2 theme light và dark vào file cấu hình màu sắc chung (`app_colors.dart`).

## Global Constraints
- Không dùng `Theme.of(context).brightness` hoặc `isDark` trong widget `ExerciseCustomSeekBar`.
- Giữ nguyên interface của `ExerciseCustomSeekBar` đối với `CustomVideoControls`.
- Sử dụng đầy đủ `copyWith` và `lerp` trong `AppColorsExtension` theo đúng kiến trúc của codebase.

## Review Focus
1. Màu sắc của track, progress bar và dots phải tương phản tốt trên nền trắng (`surfaceCard = #FFFFFF`) ở Light Theme.
2. Màu sắc trên Dark Theme phải giữ nguyên vẻ thẩm mỹ cao, progress bar sử dụng `primaryAccent` (`#00E5CC`).
3. Widget `ExerciseCustomSeekBar` không còn bất kỳ hardcoded color nào (`Colors.white`, `Colors.black`).

---

### Task 1: Bổ sung các token màu cho Seek Bar vào `AppColorsExtension`

**Files:**
- Modify: `lib/shared/theme/app_colors.dart`

- [ ] **Step 1: Khai báo các field mới trong `AppColorsExtension`**
  - `videoSeekBarTrack`
  - `videoSeekBarProgress`
  - `videoSeekBarDotInactive`
  - `videoSeekBarDotActive`
  - `videoSeekBarDotBorder`

- [ ] **Step 2: Cập nhật constructor, `copyWith`, và `lerp`**

- [ ] **Step 3: Cung cấp giá trị màu cho `light` và `dark`**
  - `light`:
    - `videoSeekBarTrack: Color(0xFFE2E2EA)`
    - `videoSeekBarProgress: Color(0xFF0891B2)`
    - `videoSeekBarDotInactive: Color(0xFF9E9EB8)`
    - `videoSeekBarDotActive: Color(0xFFFFFFFF)`
    - `videoSeekBarDotBorder: Color(0x26000000)`
  - `dark`:
    - `videoSeekBarTrack: Color(0x59FFFFFF)`
    - `videoSeekBarProgress: Color(0xFF00E5CC)`
    - `videoSeekBarDotInactive: Color(0x80FFFFFF)`
    - `videoSeekBarDotActive: Color(0xFFFFFFFF)`
    - `videoSeekBarDotBorder: Color(0x4D000000)`

- [ ] **Step 4: Chạy test hiện tại để đảm bảo không gãy compile**
  Run: `flutter test test/features/exercise/exercise_landscape_layout_test.dart`
  Expected: PASS

---

### Task 2: Tạo Widget Test cho ExerciseCustomSeekBar

**Files:**
- Create: `test/features/exercise/presentation/widgets/exercise_custom_seek_bar_test.dart`

- [ ] **Step 1: Viết test cho ExerciseCustomSeekBar ở cả Light Theme và Dark Theme**
  - Kiểm tra thanh ray có màu `colors.videoSeekBarTrack`.
  - Kiểm tra thanh tiến trình đã phát có màu `colors.videoSeekBarProgress`.
  - Kiểm tra các chấm điểm dừng có màu tương ứng từ `AppColorsExtension`.

- [ ] **Step 2: Chạy test để xác nhận test thất bại trên code hiện tại**
  Run: `flutter test test/features/exercise/presentation/widgets/exercise_custom_seek_bar_test.dart`
  Expected: FAIL

---

### Task 3: Cập nhật `ExerciseCustomSeekBar` dùng màu từ theme, loại bỏ hardcode và `isDark`

**Files:**
- Modify: `lib/features/exercise/presentation/widgets/exercise_custom_seek_bar.dart`

- [ ] **Step 1: Cập nhật code trong `ExerciseCustomSeekBar.build`**
  - Đọc các màu từ `colors.videoSeekBarTrack`, `colors.videoSeekBarProgress`, `colors.videoSeekBarDotInactive`, `colors.videoSeekBarDotActive`, `colors.videoSeekBarDotBorder`, `colors.cardShadowColor`.
  - Xóa bỏ mọi giá trị `Colors.white` và `Colors.black`.
  - Tuyệt đối không thêm check `isDark`.

- [ ] **Step 2: Chạy widget test để xác nhận test vượt qua**
  Run: `flutter test test/features/exercise/presentation/widgets/exercise_custom_seek_bar_test.dart`
  Expected: PASS

- [ ] **Step 3: Chạy toàn bộ test của feature exercise**
  Run: `flutter test test/features/exercise/`
  Expected: All PASS
