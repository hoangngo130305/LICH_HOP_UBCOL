import 'package:url_launcher/url_launcher.dart';

/// Bản Android/Windows — dùng gói url_launcher gốc để mở link bằng ứng
/// dụng/trình duyệt mặc định của hệ điều hành.
Future<bool> openUrlInNewTab(String url) => launchUrl(Uri.parse(url));
