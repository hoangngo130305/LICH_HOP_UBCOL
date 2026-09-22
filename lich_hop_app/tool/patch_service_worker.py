#!/usr/bin/env python3
"""Gan them push/notificationclick handler vao flutter_service_worker.js.

Flutter TU SINH LAI file nay moi lan `flutter build web`, nen khong the sua
tay 1 lan roi thoi -- phai chay lai script nay SAU MOI LAN build (yeu cau
23/09/2026: thong bao day + rung). Idempotent: chay nhieu lan khong bi gan
trung (kiem tra marker truoc khi noi vao).

Dung: python tool/patch_service_worker.py [duong_dan_toi_build/web]
Mac dinh duong dan la build/web (thu muc chuan cua `flutter build web`).
"""
import sys
from pathlib import Path

MARKER = "/* ===== WEB PUSH HANDLERS (patch_service_worker.py) ===== */"

PUSH_HANDLERS = MARKER + """
self.addEventListener('push', function (event) {
  var data = {};
  try { data = event.data ? event.data.json() : {}; } catch (e) {}
  var title = data.title || 'Th\\u00f4ng b\\u00e1o m\\u1edbi';
  var options = {
    body: data.body || '',
    icon: 'icons/Icon-192.png',
    badge: 'icons/Icon-192.png',
    vibrate: [200, 100, 200],
    data: { url: data.url || '/' },
  };
  event.waitUntil(self.registration.showNotification(title, options));
});

self.addEventListener('notificationclick', function (event) {
  event.notification.close();
  var url = (event.notification.data && event.notification.data.url) || '/';
  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then(function (clientList) {
      for (var i = 0; i < clientList.length; i++) {
        if ('focus' in clientList[i]) return clientList[i].focus();
      }
      if (clients.openWindow) return clients.openWindow(url);
    })
  );
});
"""


def patch(build_web_dir: Path) -> None:
    # In ten file thay vi duong dan day du -- duong dan repo nay chua ky tu
    # tieng Viet, in thang se vo console Windows cp1252 (loi bien duoc, roi
    # tung gap nhieu lan trong du an nay).
    sw_path = build_web_dir / "flutter_service_worker.js"
    if not sw_path.exists():
        print(f"NOT FOUND: {sw_path.name} -- run `flutter build web` first.")
        sys.exit(1)
    content = sw_path.read_text(encoding="utf-8")
    if MARKER in content:
        print(f"Push handlers already present in {sw_path.name}, skipping.")
        return
    sw_path.write_text(content + "\n" + PUSH_HANDLERS, encoding="utf-8")
    print(f"Patched push/notificationclick handlers into {sw_path.name}")


if __name__ == "__main__":
    target = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).resolve().parent.parent / "build" / "web"
    patch(target)
