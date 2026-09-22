import 'dart:convert';
import 'dart:js_interop';

/// Cầu nối JS <-> Dart cho Web Push (yêu cầu 23/09/2026: thông báo đẩy ra
/// thanh trạng thái điện thoại + rung). Logic thật (xin quyền, đăng ký
/// PushManager, rung) nằm ở web/push.js — file này chỉ gọi sang.

@JS('pushHelper.supported')
external bool _pushSupportedJS();

@JS('pushHelper.permission')
external String _pushPermissionJS();

@JS('pushHelper.subscribe')
external JSPromise<JSString> _pushSubscribeJS(JSString vapidKey);

@JS('pushHelper.unsubscribe')
external JSPromise<JSString> _pushUnsubscribeJS();

@JS('pushHelper.vibrate')
external void pushVibrate();

class PushSubscriptionData {
  final String endpoint;
  final String p256dh;
  final String auth;
  const PushSubscriptionData({
    required this.endpoint,
    required this.p256dh,
    required this.auth,
  });
}

/// true nếu trình duyệt hỗ trợ Web Push (Chrome/Edge/Firefox Android đều có;
/// Safari iOS chỉ hỗ trợ khi đã "Thêm vào màn hình chính").
bool get isPushSupported {
  try {
    return _pushSupportedJS();
  } catch (_) {
    return false;
  }
}

/// 'granted' | 'denied' | 'default' | 'unsupported'.
String get pushPermission {
  try {
    return _pushPermissionJS();
  } catch (_) {
    return 'unsupported';
  }
}

/// Xin quyền thông báo + đăng ký Web Push. Trả về thông tin subscription để
/// gửi lên backend, hoặc null nếu bị từ chối / không hỗ trợ / có lỗi.
Future<PushSubscriptionData?> requestPushSubscription(String vapidPublicKey) async {
  try {
    final jsResult = await _pushSubscribeJS(vapidPublicKey.toJS).toDart;
    final result = jsResult.toDart;
    if (result == 'denied' || result == 'unsupported' || result == 'error') {
      return null;
    }
    final json = jsonDecode(result) as Map<String, dynamic>;
    final keys = json['keys'] as Map<String, dynamic>? ?? const {};
    final endpoint = json['endpoint'] as String?;
    final p256dh = keys['p256dh'] as String?;
    final auth = keys['auth'] as String?;
    if (endpoint == null || p256dh == null || auth == null) return null;
    return PushSubscriptionData(endpoint: endpoint, p256dh: p256dh, auth: auth);
  } catch (_) {
    return null;
  }
}

/// Hủy đăng ký Web Push trên trình duyệt hiện tại. Trả về endpoint vừa hủy
/// (để báo backend xóa), null nếu không có subscription nào đang hoạt động.
Future<String?> cancelPushSubscription() async {
  try {
    final jsResult = await _pushUnsubscribeJS().toDart;
    final result = jsResult.toDart;
    return result.isEmpty ? null : result;
  } catch (_) {
    return null;
  }
}
