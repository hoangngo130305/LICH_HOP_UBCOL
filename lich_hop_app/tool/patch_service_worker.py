#!/usr/bin/env python3
"""Gan them push/notificationclick handler vao flutter_service_worker.js.

Flutter TU SINH LAI file nay moi lan `flutter build web`, nen khong the sua
tay 1 lan roi thoi -- phai chay lai script nay SAU MOI LAN build (yeu cau
23/09/2026: thong bao day + rung). Idempotent: chay nhieu lan khong bi gan
trung (kiem tra marker truoc khi noi vao).

Flutter (ban hien tai) sinh san 1 handler 'activate' TU HUY DANG KY chinh no
(self.registration.unregister()) de don dep service worker cache-based cua
cac ban Flutter cu -- nhung dieu nay khien service worker khong bao gio o
trang thai "active" on dinh, nen navigator.serviceWorker.ready phia client
(web/push.js) treo vo han, nguoi dung bam "Bat thong bao day" se thay xoay
vong khong dung (phat hien 02/10/2026 khi test that tren iPhone). Phai thay
handler nay bang ban khong tu huy TRUOC KHI noi them push handlers.

Dung: python tool/patch_service_worker.py [duong_dan_toi_build/web]
Mac dinh duong dan la build/web (thu muc chuan cua `flutter build web`).
"""
import re
import sys
from pathlib import Path

# Khop toan bo khoi "self.addEventListener('activate', ...)" Flutter sinh ra
# -- ^\}\);\n (khong thut dau dong) la dong dong ngoac THAT SU cuoi cung,
# phan biet voi cac dong "});"/"}" thut dau o ben trong than ham.
_SELF_DESTRUCT_ACTIVATE = re.compile(
    r"self\.addEventListener\('activate'.*?\n^\}\);\n",
    re.DOTALL | re.MULTILINE,
)
_SAFE_ACTIVATE = (
    "self.addEventListener('activate', (event) => {\n"
    "  event.waitUntil(self.clients.claim());\n"
    "});\n"
)

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

    patched_content, n = _SELF_DESTRUCT_ACTIVATE.subn(_SAFE_ACTIVATE, content)
    if n and patched_content != content:
        print("Neutered self-unregistering 'activate' handler (was breaking Web Push).")
    content = patched_content

    if MARKER in content:
        print(f"Push handlers already present in {sw_path.name}, skipping.")
        sw_path.write_text(content, encoding="utf-8")
        return
    sw_path.write_text(content + "\n" + PUSH_HANDLERS, encoding="utf-8")
    print(f"Patched push/notificationclick handlers into {sw_path.name}")


if __name__ == "__main__":
    target = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).resolve().parent.parent / "build" / "web"
    patch(target)
