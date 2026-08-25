import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lich_hop_app/screens/login_screen.dart';
import 'package:lich_hop_app/theme/app_theme.dart';

/// Ghi chú: từ bản 3.0 (nối Supabase), đăng nhập là một lệnh gọi mạng thật
/// (Supabase Auth) nên các bài test không còn "đăng nhập giả lập tức thì"
/// như bản mock trước đây — làm vậy sẽ khiến bộ test phụ thuộc mạng và có
/// thể ghi đè dữ liệu thật. Bộ test này kiểm thử màn hình Đăng nhập một
/// cách độc lập (không cần AppState/Supabase) — đúng phần có thể kiểm thử
/// đáng tin cậy mà không cần mạng: hiển thị đúng 5 vai trò, và chọn vai trò
/// điền đúng email tương ứng.
void main() {
  Future<void> pumpLogin(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
        MaterialApp(theme: AppTheme.light, home: const LoginScreen()));
    await tester.pumpAndSettle();
  }

  testWidgets('Màn hình đăng nhập hiện đủ 5 vai trò và ô email/mật khẩu',
      (tester) async {
    await pumpLogin(tester);

    expect(find.text('Hệ thống Quản lý Lịch họp'), findsOneWidget);
    expect(find.text('Ban Lãnh đạo'), findsOneWidget);
    expect(find.text('Văn thư Ủy ban'), findsOneWidget);
    expect(find.text('SuperAdmin'), findsOneWidget);
    expect(find.text('Văn thư đơn vị'), findsOneWidget);
    expect(find.text('Thành viên tham dự'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Mật khẩu'), findsOneWidget);
  });

  final cases = {
    'Ban Lãnh đạo': 'lanhdao@caungolanh.gov.vn',
    'Văn thư Ủy ban': 'vanthu.ubnd@caungolanh.gov.vn',
    'SuperAdmin': 'superadmin@caungolanh.gov.vn',
    'Văn thư đơn vị': 'vanthu.vanphong@caungolanh.gov.vn',
    'Thành viên tham dự': 'canbo@caungolanh.gov.vn',
  };

  for (final entry in cases.entries) {
    testWidgets('Chọn vai trò "${entry.key}" tự điền đúng email mẫu',
        (tester) async {
      await pumpLogin(tester);

      await tester.tap(find.text(entry.key));
      await tester.pump();

      final field =
          tester.widget<TextField>(find.widgetWithText(TextField, 'Email'));
      expect(field.controller!.text, entry.value);
    });
  }

  testWidgets('Bấm đăng nhập khi chưa nhập gì sẽ báo thiếu thông tin',
      (tester) async {
    await pumpLogin(tester);

    await tester.ensureVisible(find.text('Đăng nhập'));
    await tester.tap(find.text('Đăng nhập'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.textContaining('Vui lòng nhập email và mật khẩu'),
        findsOneWidget);
  });
}
