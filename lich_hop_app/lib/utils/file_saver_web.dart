// ignore: deprecated_member_use
import 'dart:html' as html;

/// Tải một file văn bản (CSV...) về máy qua trình duyệt thật (Blob + link
/// tải ẩn) — dùng cho bản Web, nơi người dùng chính thức truy cập hệ thống.
bool saveTextFile(String filename, String content) {
  final bytes = html.Blob([content], 'text/csv;charset=utf-8');
  final url = html.Url.createObjectUrlFromBlob(bytes);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..click();
  html.Url.revokeObjectUrl(url);
  return true;
}
