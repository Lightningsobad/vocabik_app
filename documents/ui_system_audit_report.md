# Báo Cáo Kiểm Toán UI Toàn Hệ Thống (Vocabik System-wide UI Audit)

**Ngày kiểm toán:** 31/07/2026
**Mục tiêu:** Đánh giá Bức tranh lớn về tổ chức UI, tính nhất quán, và khả năng tái sử dụng theo [Vocabik Design System](ui_ux_design_system.md).

---

## 🔴 Lỗ hổng Hệ thống (Systematic Blockers)

Đây là các vấn đề nghiêm trọng vi phạm trực tiếp Design System và tính nhất quán, lặp lại trên nhiều nơi:

1. **Sai lệch Theme (Dark/Light mode) ở các màn hình chính:**
   - Các màn hình `HomeScreen`, `DiscoverScreen`, `ProgressScreen` đang dùng `Scaffold` **nhưng không khai báo `backgroundColor: colors.background;`** (vốn được trích xuất từ `Theme.of(context).extension<AppColorsExtension>()!`). Việc dựa vào theme mặc định của Flutter dễ gây lệch màu nền khi chuyển đổi Dark/Light mode so với `ProfileScreen` và `MainShellScreen`.
   - Các Text nội dung ở các màn hình này cũng chưa sử dụng `GoogleFonts.nunito` hay màu `colors.textPrimary` chuẩn.

2. **Bỏ quên BounceWrapper ở các điểm chạm:**
   - Trong `AppHeader` (`shared/presentation/widgets/header/app_header.dart`), vùng chứa Logo và BrandText có dùng `GestureDetector` để tap về trang chủ, nhưng lại **quên không bọc `BounceWrapper`**. Điều này gây đứt gãy Micro-UX.
   - Thanh điều hướng dưới đáy `BottomNavigationBar` ở `MainShellScreen` hiện đang sử dụng hiệu ứng ripple mặc định của Material. Theo Design System, nên cân nhắc custom BottomNav hoặc các icon này để có hiệu ứng Bounce đồng bộ toàn bộ app.

3. **Lỗi Hardcode padding gây rủi ro Layout (Overflow/Responsive):**
   - Trong `ProfileScreen`, để tránh bị Bottom Navigation Bar che mất nội dung khi cuộn, code đang sử dụng `padding: const EdgeInsets.only(bottom: 100.0)`. Việc fix cứng `100.0` là rủi ro trên các thiết bị có `SafeArea` khác nhau ở cạnh dưới (ví dụ iPhone có home indicator). Nên sử dụng padding động theo system insets hoặc kiến trúc Scaffold phù hợp hơn.

---

## 🟡 Cơ hội Tái sử dụng (Refactor/Reusability Opportunities)

Danh sách các phần nên được gom (componentization) và chuyển ra `shared/presentation/widgets`:

1. **Page Layout Template:**
   - Khuôn mẫu sau đang bị lặp lại (copy-paste) ở 4 màn hình (`HomeScreen`, `DiscoverScreen`, `ProgressScreen`, `ProfileScreen`):
     ```dart
     Scaffold(
       body: SafeArea(
         bottom: false,
         child: Column(
           children: [
             const AppHeader(...),
             Expanded(child: ...),
           ],
         ),
       ),
     )
     ```
   - **Đề xuất:** Tạo một widget chung ví dụ `AppScaffoldTemplate` hoặc `MainPageLayout` trong thư mục `shared`, giúp áp luôn `AppHeader` và tự động setup `colors.background`.

2. **Tái sử dụng Tab Bar:**
   - `ProfileTabBar` hiện đang được code riêng cho Profile với mảng tab fix cứng `_tabs = ['Profile', 'Preferences', ...]`. 
   - UI của Tab Bar này rất đẹp và chuẩn mực. **Đề xuất:** Đổi tên thành `SharedSegmentedTabBar` và chuyển vào `shared/presentation/widgets/`, cho phép truyền tham số `List<String> tabs` để các màn hình khác (ví dụ: màn hình học tập cần chia tab Từ vựng / Ngữ pháp) có thể xài lại.

3. **Tái sử dụng Action Card:**
   - `_ActionGridItem` nằm trong `profile_action_grid.dart` là một component rất tổng quát (Gồm 1 Icon/Emoji + Text + Badge đỏ thông báo).
   - **Đề xuất:** Tách thành `IconActionCard` để có thể tái sử dụng nếu sau này màn hình Home hoặc Discover muốn dùng dạng thẻ tương tự.

---

## 🟢 Đánh giá tổng quan (Overall Health)

**Điểm sức khỏe UI: 7.5/10 (Khá Tốt)**

**Nhận xét:**
- **Điểm sáng:** 
  - `ProfileScreen` là màn hình mẫu mực nhất hiện tại, bám sát Design System (sử dụng đúng màu sắc ngữ nghĩa, Nunito font, xử lý tốt chia cột responsive với LayoutBuilder). 
  - Hệ thống `AppHeader` và `BounceWrapper` đã được xây dựng làm nền tảng rất tốt và đã nằm đúng vị trí trong thư mục `shared`.
- **Cần cải thiện:** 
  - Thiếu đi một sự dọn dẹp các "boilerplate code" bị lặp lại ở các trang root. Việc chuẩn hoá một `AppScaffoldTemplate` sẽ dọn dẹp 80% code thừa và giải quyết luôn lỗi quên gán `backgroundColor`.
  - Cần rà soát gắt gao hơn việc 100% các text mới xuất hiện phải được ép font Nunito.

Báo cáo này cung cấp định hướng kiến trúc trước khi triển khai tính năng mới hoặc thực hiện refactor.
