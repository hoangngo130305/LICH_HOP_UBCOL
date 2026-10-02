from django.core.management.base import BaseCommand
from django.utils import timezone

from core.models import Meeting, Notification, User
from core.push import send_push_to_users

MAX_LISTED = 6


class Command(BaseCommand):
    """Gui 1 thong bao "nhac lai" TOAN BO lich hop trong ngay hom nay, cho
    TOAN BO tai khoan -- yeu cau 02/10/2026: "1 tuan 20 cuoc hop thi khong
    nho noi, can nhac lai 1 lan nua cho ngay do". Thong bao luc tao lich (co
    the tu vai tuan truoc) de nguoi dung biet lich moi xuat hien; thong bao
    nay la nhac LAI nhung lich DA CO, dung vao sang som ngay dien ra.

    Khong tu chay dinh ky -- phai dat cron goi lenh nay 1 lan/ngay (vd. 6h
    sang): `python manage.py send_daily_reminders`.
    """

    help = "Gui thong bao nhac lai toan bo lich hop dien ra trong ngay hom nay."

    def handle(self, *args, **options):
        today = timezone.localdate()
        meetings = (
            Meeting.objects.filter(meeting_date=today, is_draft=False, postponed=False)
            .select_related('room')
            .order_by('start_time')
        )
        count = meetings.count()
        if count == 0:
            self.stdout.write("Khong co lich hop nao hom nay, bo qua.")
            return

        lines = [
            f"{m.start_time.strftime('%H:%M')} - {m.title}" for m in meetings[:MAX_LISTED]
        ]
        if count > MAX_LISTED:
            lines.append(f"... và {count - MAX_LISTED} cuộc khác")

        title = f"Nhắc lịch: {count} cuộc họp hôm nay"
        message = "\n".join(lines)[:500]

        recipients = list(User.objects.all())
        Notification.objects.bulk_create([
            Notification(recipient=user, meeting=None, title=title, message=message)
            for user in recipients
        ])
        send_push_to_users(recipients, title, message)
        self.stdout.write(
            f"Da nhac {count} lich hop hom nay ({today}) toi {len(recipients)} tai khoan."
        )
