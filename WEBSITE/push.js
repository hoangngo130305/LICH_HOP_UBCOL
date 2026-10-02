// Web Push helper — được Dart gọi qua dart:js_interop (yêu cầu 23/09/2026:
// thông báo đẩy ra thanh trạng thái điện thoại + rung).
//
// LƯU Ý QUAN TRỌNG (phát hiện 02/10/2026, test thật trên iPhone): từng nghĩ
// flutter_bootstrap.js luôn tự đăng ký Service Worker nên chỉ cần dùng lại
// qua navigator.serviceWorker.ready -- SAI. flutter_bootstrap.js (cơ chế
// "serviceWorkerVersion" cũ, đang bị Flutter deprecate) CHỈ update lại 1
// service worker nếu đã có sẵn 1 cái đang đăng ký từ trước; nếu chưa từng
// có cái nào (vd. sau khi xóa cache / lần đầu cài đặt), nó KHÔNG đăng ký gì
// cả. Khi đó navigator.serviceWorker.ready không bao giờ resolve vì chẳng
// có worker nào để "ready" lên -- đây là lý do nút "Bật thông báo đẩy" xoay
// vòng vô hạn. Phải TỰ register() ở đây, không trông chờ flutter_bootstrap.
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
      // Tu dang ky (hoac lay lai registration da co san, idempotent) thay vi
      // tin flutter_bootstrap.js da lo -- xem ghi chu o dau file.
      return navigator.serviceWorker.register('flutter_service_worker.js')
          .then(function () { return navigator.serviceWorker.ready; })
          .then(function (reg) {
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
    return navigator.serviceWorker.register('flutter_service_worker.js')
        .then(function () { return navigator.serviceWorker.ready; })
        .then(function (reg) {
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
