import json
import logging
import threading

from django.conf import settings
from pywebpush import webpush, WebPushException

from .models import PushSubscription

logger = logging.getLogger(__name__)


def _send_one(sub_id, endpoint, p256dh, auth, payload):
    try:
        webpush(
            subscription_info={
                'endpoint': endpoint,
                'keys': {'p256dh': p256dh, 'auth': auth},
            },
            data=payload,
            vapid_private_key=settings.VAPID_PRIVATE_KEY,
            vapid_claims={'sub': f'mailto:{settings.VAPID_CLAIM_EMAIL}'},
            timeout=5,
        )
    except WebPushException as exc:
        status = getattr(exc.response, 'status_code', None)
        if status in (404, 410):
            # Subscription het han/da bi trinh duyet huy -- xoa cho sach.
            PushSubscription.objects.filter(id=sub_id).delete()
        else:
            logger.warning('Web push that bai (endpoint=%s...): %s', endpoint[:60], exc)
    except Exception:
        logger.exception('Loi khong mong doi khi gui web push')


def _send_all(user_ids, title, message, url):
    payload = json.dumps({'title': title, 'body': message, 'url': url})
    subs = list(
        PushSubscription.objects.filter(user_id__in=user_ids).values(
            'id', 'endpoint', 'p256dh', 'auth'
        )
    )
    for sub in subs:
        _send_one(sub['id'], sub['endpoint'], sub['p256dh'], sub['auth'], payload)


def send_push_to_users(users, title, message, url='/'):
    """Gui web push (kem rung, theo cau hinh trong service worker) cho danh
    sach user -- chay o 1 thread nen rieng de KHONG lam cham response tao/
    sua lich hop (co the co hang chuc nguoi dang ky nhan push cung luc)."""
    user_ids = [u.id if hasattr(u, 'id') else u for u in users]
    if not user_ids:
        return
    threading.Thread(
        target=_send_all, args=(user_ids, title, message, url), daemon=True
    ).start()
