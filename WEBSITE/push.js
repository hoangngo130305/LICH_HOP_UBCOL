// Web Push helper — được Dart gọi qua dart:js_interop (yêu cầu 23/09/2026:
// thông báo đẩy ra thanh trạng thái điện thoại + rung).
// Lưu ý: đăng ký Service Worker của Flutter (flutter_service_worker.js) đã
// được flutter_bootstrap.js tự lo — tại đây chỉ dùng lại registration đó
// (navigator.serviceWorker.ready) chứ KHÔNG đăng ký thêm 1 service worker
// khác, để tránh 2 service worker tranh nhau cùng 1 scope "/".
function urlBase64ToUint8Array(base64String) {
  var padding = '='.repeat((4 - (base64String.length % 4)) % 4);
  var base64 = (base64String + padding).replace(/-/g, '+').replace(/_/g, '/');
  var rawData = window.atob(base64);
  var outputArray = new Uint8Array(rawData.length);
  for (var i = 0; i < rawData.length; ++i) {
    outputArray[i] = rawData.charCodeAt(i);
  }
  return outputArray;
}

window.pushHelper = {
  supported: function () {
    return ('serviceWorker' in navigator) && ('PushManager' in window) &&
        (typeof Notification !== 'undefined');
  },

  permission: function () {
    return (typeof Notification !== 'undefined') ? Notification.permission : 'unsupported';
  },

  // Tra ve: chuoi JSON cua PushSubscription neu thanh cong, hoac 1 trong cac
  // ma loi: 'unsupported' | 'denied' | 'error'.
  subscribe: function (vapidPublicKey) {
    if (!window.pushHelper.supported()) {
      return Promise.resolve('unsupported');
    }
    return Notification.requestPermission().then(function (permission) {
      if (permission !== 'granted') return 'denied';
      return navigator.serviceWorker.ready.then(function (reg) {
        return reg.pushManager.getSubscription().then(function (existing) {
          if (existing) return JSON.stringify(existing.toJSON());
          return reg.pushManager.subscribe({
            userVisibleOnly: true,
            applicationServerKey: urlBase64ToUint8Array(vapidPublicKey),
          }).then(function (sub) {
            return JSON.stringify(sub.toJSON());
          });
        });
      });
    }).catch(function (err) {
      console.warn('[push] subscribe failed:', err);
      return 'error';
    });
  },

  // Tra ve endpoint da huy dang ky, hoac chuoi rong '' neu khong co gi de
  // huy / co loi (tranh phai xu ly null qua bien JS<->Dart).
  unsubscribe: function () {
    if (!('serviceWorker' in navigator)) return Promise.resolve('');
    return navigator.serviceWorker.ready.then(function (reg) {
      return reg.pushManager.getSubscription().then(function (sub) {
        if (!sub) return '';
        var endpoint = sub.endpoint;
        return sub.unsubscribe().then(function () { return endpoint; });
      });
    }).catch(function () { return ''; });
  },

  vibrate: function () {
    if (navigator.vibrate) { navigator.vibrate([200, 100, 200]); }
  },
};
