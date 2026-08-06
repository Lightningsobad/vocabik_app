# Báo cáo Đánh giá Mã nguồn Giao diện (UI Code Review) - Màn hình Home

Dựa trên tiêu chuẩn của Design System và các best practices về hiệu năng & UX trên Flutter, dưới đây là đánh giá chi tiết cho màn hình Home (`lib/features/home/presentation`) của ứng dụng Vocabik.

---

### 🔴 Lỗi Layout/UX (Blocker)

**1. Tràn màn hình (Overflow) do fix cứng chiều cao thẻ & danh sách ngang**
- **Vấn đề:** Trong `daily_pick_card.dart` (`height: 220`) và `home_screen.dart` (`SizedBox(height: 280)` bọc ngoài `ListView.separated`), các chỉ số chiều cao bị fix cứng. Nếu người dùng điều chỉnh Text Scaling (phóng to chữ) từ cài đặt HĐH, nội dung bên trong sẽ bị tràn ra ngoài hoặc che khuất (Overflow).
- **Vị trí:** `daily_pick_card.dart`, `home_screen.dart`
- **Khắc phục:** Sử dụng `constraints` để định hình chiều cao tối thiểu, thay vì `height` cố định.
```dart
            Container(
              constraints: const BoxConstraints(minHeight: 220), // Thay thế height cố định
              decoration: BoxDecoration(
```

**2. Kích thước vùng chạm quá nhỏ & Thiếu hiệu ứng tương tác đồng nhất**
- **Vấn đề:** Nút "View all" (`actionText`) trong `section_header.dart` sử dụng `GestureDetector` trực tiếp bọc một Text widget, không có padding xung quanh, khiến vùng chạm nhỏ hơn tiêu chuẩn UX Mobile (48x48px). Không sử dụng `BounceWrapper` theo chuẩn của Design System.
- **Vị trí:** `section_header.dart`
- **Khắc phục:** Bọc trong `BounceWrapper` và mở rộng vùng chạm bằng `Padding`.
```dart
          if (actionText != null)
            BounceWrapper(
              onTap: onActionTap ?? () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
                child: Text(
                  actionText!,
```

**3. Hardcode kích thước Font chữ bỏ qua Design System**
- **Vấn đề:** Các kích cỡ chữ (`fontSize`) đang bị hardcode số nguyên ở một số widget (thay vì sử dụng `AppFontSize`).
- **Vị trí:** `horizontal_course_card.dart` và `home_footer.dart`
- **Khắc phục:** Dùng các giá trị đã quy định như `AppFontSize.md` hoặc `AppFontSize.lg`.

---

### 🟡 Cảnh báo (Warning)

**1. Thiếu `SafeArea` cho nội dung chính**
- **Vấn đề:** Toàn bộ nội dung của `HomeScreen` được bọc bởi `SingleChildScrollView` nhưng chưa bọc bởi `SafeArea`. Các phần tử trên cùng có nguy cơ bị đè bởi "tai thỏ" (Notch) hoặc thanh trạng thái (StatusBar).
- **Vị trí:** `home_screen.dart`
- **Khắc phục:**
```dart
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          // ...
```

**2. Anti-pattern Hiệu năng khi lồng GridView vào SingleChildScrollView**
- **Vấn đề:** Lạm dụng `shrinkWrap: true` và `NeverScrollableScrollPhysics` trong `GridView.builder` khiến Flutter phải tính toán toàn bộ chiều cao của GridView ngay khi render, vô tình huỷ bỏ cơ chế lazy-load và ảnh hưởng tới tốc độ khởi động/render màn hình.
- **Khắc phục:** Nên sử dụng `CustomScrollView` với `SliverToBoxAdapter` và `SliverGrid`.

**3. Các widget tĩnh thiếu từ khoá `const`**
- **Vấn đề:** Trong `home_screen.dart`, phương thức ánh xạ `mockRecommended.map(...)` trả ra các `HorizontalCourseCard` không phải `const`.

---

### 🟢 Đề xuất (Suggestion)

**1. Refactor "God Widget" (`home_screen.dart`)**
- **Vấn đề:** Hàm `build()` trong `home_screen.dart` kéo dài tới gần 200 dòng, khai báo tất cả các section con trực tiếp.
- **Đề xuất:** Hãy Extract (tách) các khối giao diện lớn thành các `StatelessWidget` riêng biệt hoặc các hàm `_build...` để dễ đọc, dễ bảo trì và giúp tối ưu hóa số lượng widget phải rebuild khi trạng thái nội bộ thay đổi.

**2. Nâng cấp trạng thái Tải dữ liệu (Empty/Loading State)**
- **Vấn đề:** Trạng thái `isLoading` hiện tại chỉ trả về một thẻ có nền màu trơn, trải nghiệm thị giác hơi cứng.
- **Đề xuất:** Áp dụng hiệu ứng `Shimmer` chớp nháy nhẹ (skeleton) để tạo cảm giác mượt mà và cao cấp hơn trong thời gian chờ tải dữ liệu.
