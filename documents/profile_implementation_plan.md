# Phân tích giao diện màn hình Profile & Settings

Dựa vào ảnh chụp và tài liệu thiết kế `@Vocabik Mobile.dc.html`, chúng ta sẽ phân rã giao diện màn hình **Profile & Settings** thành các thành phần (Widgets & UI Components) để dễ quản lý, bảo trì và tái sử dụng.

## Phân tích cấu trúc (Widgets & UI Components)

Màn hình này sử dụng `Scaffold` với nội dung chính cố định, không cho phép cuộn toàn màn hình. Chỉ có nội dung bên trong từng tab (ví dụ tab Preferences) mới được phép cuộn. Header (`AppHeader`) đã được xây dựng từ trước sẽ được tái sử dụng.

### 1. Main Layout (`ProfileScreen`)
- **Cấu trúc Cuộn động**:
  - Gốc của màn hình là một `Column`. Widget đầu tiên là `AppHeader` luôn được ghim cố định ở trên cùng.
  - Phần không gian bên dưới (bọc bởi `Expanded`) sẽ thay đổi cấu trúc cuộn tùy thuộc vào Tab đang được chọn:
    - **Khi ở tab "Profile"**: Tiêu đề ("Profile & Settings"), Thanh Tab (`ProfileTabBar`) và Nội dung tab Profile được bọc trong một `SingleChildScrollView`. Điều này giúp tránh lỗi tràn màn hình (Bottom Overflow) hoặc bị che khuất khi bàn phím ảo (keyboard) hiện lên lúc người dùng tương tác với các ô nhập liệu.
    - **Khi ở tab "Preferences" (Cuộn toàn bộ)**: Tiêu đề, Thanh Tab và Nội dung tab Preferences được bọc CHUNG trong một `SingleChildScrollView` (hoặc cấu trúc `CustomScrollView` / `SliverList`). Khi vuốt, nội dung sẽ đẩy cả Tiêu đề và Thanh Tab cuộn lên trên, nhưng `AppHeader` vẫn giữ nguyên.
- **Padding**: Sử dụng padding hai bên (khoảng 16px - `AppSpacing.lg`) cho các thành phần nội dung để tạo khoảng trống với viền màn hình. **Lưu ý quan trọng**: Phần nội dung cuộn bên dưới cần được cộng thêm một khoảng `padding-bottom` (khoảng 80-100px) để không bị che khuất bởi Bottom Navigation Bar và Floating Action Button của `MainShellScreen`.
- **Nền màn hình**: Nền sáng, có thể hơi thiên về trắng xám nhạt (`AppColors.surfaceCard2` hoặc màu trắng tinh).

### 2. Tiêu đề "Profile & Settings"
- **Widget**: `Text` với style chữ to, in đậm (sử dụng `Theme.of(context).textTheme.headlineLarge` hoặc tương đương, kết hợp `fontWeight: FontWeight.bold` hoặc `w900`).
- **Màu sắc**: Màu đen/xanh navy sẫm (`AppColors.ink950`).

### 3. Thanh Tab Filter (Profile, Preferences, Subscription, Security)
- **Component**: `ProfileTabBar`
- **Widget**: `SingleChildScrollView` (với `scrollDirection: Axis.horizontal`) kết hợp với `Row`, hoặc sử dụng `ListView.separated` chiều ngang.
- **Item**: Sử dụng `GestureDetector` bọc `Container` để tạo các tab custom.
  - *Trạng thái được chọn*: `Container` có nền màu xanh Cyan (`AppColors.accent`), chữ màu trắng, bo góc tròn (khoảng 20px).
  - *Trạng thái bình thường*: `Container` có nền trắng hoặc trong suốt, viền mỏng màu xám nhạt (`AppColors.borderSubtle`), chữ màu xám (`AppColors.textSecondary`).

### 4. Lưới các nút chức năng (Action Grid)
- **Component**: `ProfileActionGrid`
- **Widget**: `GridView` với `SliverGridDelegateWithFixedCrossAxisCount` (2 cột, tỷ lệ khung hình tuỳ chỉnh) hoặc đơn giản là `Wrap` / tổ hợp `Column` và `Row` nếu số lượng nút cố định. Bắt buộc dùng `shrinkWrap: true` và `physics: NeverScrollableScrollPhysics()` để nằm gọn trong thẻ cuộn chính.
- **Item**: `Container` bo góc (radius khoảng 12-16px), nền màu trắng tinh, viền rất mờ hoặc dùng bóng đổ siêu nhẹ (`BoxShadow`). Bên trong là một `Row` hoặc `Wrap` chứa Emoji (`Text` thường) và Tiêu đề chữ đen in hoa nhẹ (`Text` với `fontWeight: FontWeight.w600`).
  - *Khả năng mở rộng*: Component item này cần được thiết kế linh hoạt, nhận vào tham số (ví dụ: `badgeCount` hoặc `hasNotification`) để sẵn sàng hiển thị chấm thông báo đỏ hoặc số lượng thông báo ở góc trong tương lai.
- **Danh sách chức năng**: 🏅 Achievements, 📖 Notebook, 🏆 Leaderboard, 🎓 Classroom, 🔥 Daily Challenge, ✈️ Bot integration.

### 5. Khung thông tin cá nhân (Profile Avatar & Info Form)
- **Component**: `UserProfileSection`
- **Avatar & Đổi ảnh**:
  - `Row` chứa hình đại diện và nút đổi ảnh.
  - *Avatar*: `Container` hình tròn (hoặc `CircleAvatar`) kích thước lớn (~64x64), viền xám mỏng, nền trắng/xám nhạt, chữ "AN" ở giữa (in đậm, màu xanh đen).
  - *Nút "Change photo"*: Dùng `OutlinedButton` hoặc `Container` bo góc tròn, viền xám nhạt, chữ màu đen.
- **Form tên (Your name)**:
  - Nhãn: `Text("Your name")` màu xám xậm, in đậm vừa (`w600`).
  - Ô nhập: Sử dụng `TextField` kết hợp với `FocusNode` để lắng nghe trạng thái tương tác.
    - *Trạng thái bình thường*: Nền xám nhạt, bo góc 12px, viền mỏng trong suốt hoặc xám nhạt, chữ "An Nguyễn".
    - *Trạng thái tương tác (Focus)*: Đổi màu viền (border) sang màu Cyan (`AppColors.accent`) - đồng bộ với màu của tab đang được chọn.
    - *Cơ chế lưu (Auto-save)*: Không sử dụng nút Save rời. Ứng dụng sẽ tự động lưu thay đổi (gọi API) khi người dùng hoàn tất nhập liệu và tắt bàn phím (sự kiện `onSubmitted` hoặc `FocusNode` bị mất focus).
- **Thông tin tĩnh (Email & Member Since)**:
  - *Email*: Dùng `Text.rich` với `TextSpan` để kết hợp chữ thường ("Email: "), chữ đậm ("an.nguyen@gmail.com") và chữ màu xám ("(readonly)").
  - *Member since*: `Text("Member since: 15/05/2026")` màu xám nhạt (`AppColors.textSecondary`).

### 6. Nút nổi (Floating Action Button - Chathead)
- Widget hình tròn có biểu tượng mặt cười 😐/🙂 nằm ở góc dưới bên phải.
- **Lưu ý**: Nút này luôn hiển thị ở mọi màn hình chính, do đó nó sẽ được đặt trong cấu trúc khung chung (`MainShellScreen`), **không** đặt trong màn hình `ProfileScreen`.

### 7. Hiệu ứng Tương tác chung (Global Interactions)
- **Hiệu ứng Nhún nhẹ (Bounce/Scale down)**: Tất cả các thành phần có thể nhấn được (như các Tab Filter, các nút chức năng trong lưới Action Grid, nút đổi ảnh đại diện...) đều được áp dụng hiệu ứng thu nhỏ nhẹ (giảm scale xuống khoảng `0.95` - `0.97`) khi người dùng chạm vào (OnTapDown) và bật trở lại bình thường khi nhả tay (OnTapUp).
- **Cách thực hiện**: Sẽ tạo một Widget dùng chung (ví dụ `BounceWrapper` hoặc `ScaleButton`) sử dụng `GestureDetector` kết hợp `AnimationController`, hoặc sử dụng package hỗ trợ bounce effect để bọc ngoài các item cần thiết.

## Cấu trúc thư mục dự kiến triển khai

```text
lib/features/profile/presentation/
├── screens/
│   └── profile_screen.dart (Thay đổi Layout, dùng Column và Expanded cho Tab content)
└── widgets/
    ├── profile_tab_bar.dart (NEW - Component thanh tab)
    ├── profile_action_grid.dart (NEW - Component lưới chức năng)
    └── user_profile_section.dart (NEW - Component form thông tin cá nhân)
```
