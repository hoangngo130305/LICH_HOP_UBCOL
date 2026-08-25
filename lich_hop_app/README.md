# Hệ thống Quản lý Lịch họp – Ứng dụng Flutter

Chuyển toàn bộ tính năng của prototype `lich_hop_prototype_v2 (1).html` sang ứng dụng
Flutter chạy được trên Android / iOS / Windows / Web.

## 1. Chạy ứng dụng

Máy hiện chưa cài Flutter SDK. Sau khi cài (https://docs.flutter.dev/get-started/install/windows):

```bash
cd "e:/VAN/LICH HOP/lich_hop_app"
flutter create .        # sinh thư mục android/ ios/ web/ windows/ (chỉ chạy 1 lần)
flutter pub get
flutter run             # hoặc: flutter run -d chrome / -d windows
```

`flutter create .` chỉ bổ sung phần vỏ nền tảng, **không ghi đè** `lib/`, `pubspec.yaml`, `test/`.

Ứng dụng không dùng package ngoài nào — chỉ Flutter SDK, nên `pub get` chạy offline được.

## 2. Cấu trúc mã nguồn

```
lib/
├── main.dart                       Khởi tạo app, chuyển giữa Đăng nhập ↔ Khung chính
├── models/models.dart              Vai trò, Thành viên, Cuộc họp, Phòng họp, RSVP, tiện ích ngày VN
├── data/mock_data.dart             Toàn bộ dữ liệu mẫu lấy từ prototype
├── state/app_state.dart            ChangeNotifier + AppScope (InheritedNotifier)
├── theme/app_theme.dart            Bảng màu & kiểu chữ đúng theo prototype
├── widgets/
│   ├── common.dart                 Badge, Notice, Card, StatCard, Tabs, Dropdown, Toast, Dialog…
│   ├── meeting_card.dart           Thẻ cuộc họp + danh sách tài liệu đính kèm
│   ├── room_card.dart              Thẻ / lưới phòng họp
│   ├── member_selector.dart        Ô tìm & chọn thành phần tham dự (dạng tag)
│   ├── file_upload.dart            Khu vực đính kèm tài liệu
│   └── calendar_grid.dart          Lưới lịch tháng, thanh điều hướng tháng, chú thích màu
└── screens/
    ├── login_screen.dart           Chọn 1 trong 5 vai trò
    ├── shell_screen.dart           Thanh trên + menu trái (Drawer khi màn hình hẹp) + định tuyến trang
    ├── dialogs.dart                Chi tiết cuộc họp, liên hệ văn thư, xóa lịch, đổi phòng, thêm phòng
    ├── lanhdao_pages.dart          Lịch hôm nay / tuần / tháng
    ├── vanthu_pages.dart           Danh sách lịch họp, xem theo tháng
    ├── meeting_form_page.dart      Form tạo lịch (dùng chung Ủy ban & Phòng ban)
    ├── checkin_page.dart           Điểm danh quét thẻ
    ├── quantri_pages.dart          Tổng quan, quản lý phòng, tất cả lịch, cảnh báo trùng
    ├── phongban_pages.dart         Lịch phòng, thành viên phòng, xem lịch Ủy ban
    └── thanhvien_pages.dart        Lời mời, lịch sắp tới, lịch sử, ngày/tuần/tháng, tìm kiếm
```

## 3. Tính năng theo vai trò

| Vai trò | Chức năng |
|---|---|
| **Ban Lãnh đạo** | Lịch hôm nay (tách lịch Ủy ban / phòng ban), lịch tuần (chuyển tuần), lịch tháng (chọn ngày để lọc). Chế độ **chỉ xem** – nút "Gọi văn thư để thay đổi" trong chi tiết cuộc họp. |
| **Văn thư Ủy ban** | Danh sách lịch họp theo tab Sắp diễn ra / Đã qua / Tất cả, xem – sửa – **xóa** lịch; tạo lịch họp mới; xem theo tháng (chọn ngày xem lịch trong ngày); điểm danh. |
| **Quản trị phòng** | Tổng quan số phòng trống/bận/cảnh báo; lưới tình trạng phòng; danh sách toàn bộ phòng + **thêm phòng**; tất cả lịch họp (lọc theo phòng); trang cảnh báo trùng + **đổi phòng** (cập nhật lịch thật, xóa cờ trùng). |
| **Hành chính Phòng ban** | Lịch nội bộ phòng (tab + xem/sửa/xóa), tạo lịch nội bộ, điểm danh, danh sách cán bộ phòng, xem lịch Ủy ban (chỉ đọc). |
| **Thành viên tham dự** | Lời mời họp: **xác nhận tham dự / từ chối kèm lý do**; lịch sắp tới; lịch sử cuộc họp; lịch cá nhân theo **ngày** (dòng thời gian 07–18h), **tuần** (lưới giờ × 7 ngày), **tháng** (chấm màu theo trạng thái phản hồi + chi tiết ngày); tra cứu lịch họp theo từ khóa, đơn vị, khoảng ngày, buổi. |

## 4. Điểm khác so với prototype HTML

Những chỗ prototype chỉ "giả lập" đã được làm thành logic thật:

- **Cảnh báo trùng lịch** được tính động (cùng phòng, cùng ngày, cùng buổi) thay vì gắn cứng; form tạo lịch cảnh báo ngay khi chọn phòng/ngày/buổi.
- **Tạo lịch họp** lưu vào state và hiện ngay trong danh sách, lịch tháng, lời mời.
- **Xóa lịch, đổi phòng, thêm phòng, xác nhận/từ chối lời mời** đều cập nhật dữ liệu thật trong phiên chạy.
- **Tìm kiếm** lọc thật theo từ khóa / đơn vị / khoảng ngày / buổi.
- Lịch tuần – tháng dùng `DateTime` thật nên chuyển tuần, chuyển tháng hoạt động đúng.
- Giao diện đáp ứng: ≥900px hiện menu trái cố định, hẹp hơn thì chuyển thành Drawer.

Ngày "hôm nay" của bản demo được cố định là **25/07/2025** (`VnDate.today`) để khớp bộ dữ liệu mẫu.
Đổi hằng số này khi nối dữ liệu thật.

## 5. Bước tiếp theo khi lên bản thật

- Thay `MockData` bằng lớp repository gọi API (giữ nguyên `AppState` làm lớp trung gian).
- Đăng nhập thật (tài khoản + phân quyền theo vai trò) thay cho màn hình chọn vai trò.
- Đính kèm file thật: thêm `file_picker` + tải lên máy chủ (hiện đang mô phỏng).
- Điểm danh: nối đầu đọc thẻ từ / NFC.
- Thông báo lời mời họp: `firebase_messaging` hoặc hệ thống push nội bộ.
