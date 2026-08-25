// ignore: deprecated_member_use
import 'dart:html' as html;

/// Bản Web — mở tab mới bằng dart:html thay vì gói url_launcher (url_launcher_web
/// bị lỗi tương tự file_picker khi build --release --minify trên Flutter Web:
/// bấm "Tải" ném lỗi JS, không mở được tab mới).
Future<bool> openUrlInNewTab(String url) async {
  final anchor = html.AnchorElement(href: url)..target = '_blank';
  anchor.click();
  return true;
}
