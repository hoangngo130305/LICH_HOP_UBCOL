from django.contrib.auth.models import AbstractUser
from django.db import models


class Role(models.TextChoices):
    LANH_DAO = 'lanh_dao', 'Ban Lãnh đạo'
    VAN_THU = 'van_thu', 'Văn thư Ủy ban'
    QUAN_TRI = 'quan_tri', 'Quản trị hệ thống (SuperAdmin)'
    PHONG_BAN = 'phong_ban', 'Văn thư Văn phòng / Phòng ban'
    THANH_VIEN = 'thanh_vien', 'Cán bộ, công chức'


class AvatarColor(models.TextChoices):
    BLUE = 'blue', 'Xanh dương'
    GREEN = 'green', 'Xanh lá'
    PURPLE = 'purple', 'Tím'
    AMBER = 'amber', 'Hổ phách'


class MeetingSession(models.TextChoices):
    AM = 'am', 'Buổi sáng'
    PM = 'pm', 'Buổi chiều'
    ALL_DAY = 'all_day', 'Cả ngày'


class MeetingLevel(models.TextChoices):
    UY_BAN = 'uy_ban', 'Lịch Ủy ban'
    PHONG_BAN = 'phong_ban', 'Lịch phòng ban'


class RsvpStatus(models.TextChoices):
    ACCEPTED = 'accepted', 'Đã xác nhận'
    DECLINED = 'declined', 'Đã từ chối'
    PENDING = 'pending', 'Chờ xác nhận'


class FileKind(models.TextChoices):
    PDF = 'pdf', 'PDF'
    DOC = 'doc', 'DOC'
    XLS = 'xls', 'XLS'
    IMG = 'img', 'Ảnh'
    OTHER = 'other', 'Khác'


class Member(models.Model):
    """Danh bạ nhân sự nội bộ cơ quan (dùng để mời họp / điểm danh)."""
    name = models.CharField(max_length=150)
    title = models.CharField(max_length=150)
    unit = models.CharField(max_length=150)
    initials = models.CharField(max_length=10)
    color = models.CharField(max_length=10, choices=AvatarColor.choices, default=AvatarColor.BLUE)
    phone = models.CharField(max_length=30, blank=True, null=True)
    email = models.EmailField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'members'

    def __str__(self):
        return self.name


class User(AbstractUser):
    """Tài khoản đăng nhập, gộp luôn vai trò (thay cho bảng profiles riêng của Supabase)."""
    email = models.EmailField(unique=True)
    role = models.CharField(max_length=20, choices=Role.choices)
    member = models.ForeignKey(Member, null=True, blank=True, on_delete=models.SET_NULL, related_name='user_accounts')
    display_name = models.CharField(max_length=150)
    unit = models.CharField(max_length=150, blank=True, null=True)
    can_manage_rooms = models.BooleanField(
        default=False,
        help_text="Duoc them/sua/xoa phong hop du khong phai quan_tri (vd. can bo phu trach ha tang/server).",
    )

    class Meta:
        db_table = 'users'

    def __str__(self):
        return f"{self.display_name} ({self.role})"


class Room(models.Model):
    name = models.CharField(max_length=150)
    location = models.CharField(max_length=150)
    capacity = models.IntegerField()
    equipment = models.CharField(max_length=255, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'rooms'
        ordering = ['id']

    def __str__(self):
        return self.name


class Meeting(models.Model):
    title = models.CharField(max_length=255)
    meeting_date = models.DateField()
    start_time = models.TimeField()
    session = models.CharField(max_length=10, choices=MeetingSession.choices)
    level = models.CharField(max_length=15, choices=MeetingLevel.choices)
    room = models.ForeignKey(Room, null=True, blank=True, on_delete=models.SET_NULL, related_name='meetings')
    location_text = models.CharField(max_length=255, blank=True, null=True)
    unit = models.CharField(max_length=150, blank=True, null=True)
    host = models.CharField(max_length=150, blank=True, null=True)
    content = models.TextField(blank=True, null=True)
    estimated_people = models.IntegerField(blank=True, null=True)
    postponed = models.BooleanField(default=False)
    is_draft = models.BooleanField(default=False)
    minutes = models.TextField(blank=True, default='')
    created_by = models.ForeignKey(User, null=True, blank=True, on_delete=models.SET_NULL, related_name='created_meetings')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'meetings'
        ordering = ['-meeting_date', '-start_time']

    def __str__(self):
        return self.title


class ConflictAcknowledgement(models.Model):
    """
    Danh dau mot cap lich trung phong da duoc cac ben tu thoa thuan (khong
    can doi phong) -- QT-07 "Xac nhan da dieu phoi". Luu chuan hoa
    meeting_a.id < meeting_b.id de tranh trung cap theo 2 chieu.
    """
    meeting_a = models.ForeignKey(Meeting, on_delete=models.CASCADE, related_name='+')
    meeting_b = models.ForeignKey(Meeting, on_delete=models.CASCADE, related_name='+')
    acknowledged_by = models.ForeignKey(User, null=True, blank=True, on_delete=models.SET_NULL)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'conflict_acknowledgements'
        unique_together = ('meeting_a', 'meeting_b')


class MeetingAttendee(models.Model):
    meeting = models.ForeignKey(Meeting, on_delete=models.CASCADE, related_name='attendees')
    member = models.ForeignKey(Member, on_delete=models.CASCADE, related_name='attendances')
    status = models.CharField(max_length=10, choices=RsvpStatus.choices, default=RsvpStatus.PENDING)
    decline_reason = models.TextField(blank=True, null=True)
    responded_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        db_table = 'meeting_attendees'
        unique_together = ('meeting', 'member')


class MeetingFile(models.Model):
    meeting = models.ForeignKey(Meeting, on_delete=models.CASCADE, related_name='files')
    name = models.CharField(max_length=255)
    file = models.FileField(upload_to='meeting_files/%Y/%m/', null=True, blank=True)
    size_bytes = models.BigIntegerField(blank=True, null=True)
    kind = models.CharField(max_length=10, choices=FileKind.choices, default=FileKind.OTHER)
    uploaded_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'meeting_files'


class CheckinRecord(models.Model):
    meeting = models.ForeignKey(Meeting, on_delete=models.CASCADE, related_name='checkins')
    member = models.ForeignKey(Member, on_delete=models.CASCADE, related_name='checkins')
    checkin_time = models.DateTimeField(blank=True, null=True)

    class Meta:
        db_table = 'checkin_records'
        unique_together = ('meeting', 'member')


class Notification(models.Model):
    """
    Thong bao lich hop moi gui den TOAN BO tai khoan (khong loc theo phong
    ban) -- theo bien ban hop 22/08/2026: "Van phong khong du nhan luc de
    loc danh sach cho tung cuoc hop; ai khong lien quan co the bo qua".
    """
    recipient = models.ForeignKey(User, on_delete=models.CASCADE, related_name='notifications')
    meeting = models.ForeignKey(Meeting, null=True, blank=True, on_delete=models.CASCADE, related_name='notifications')
    title = models.CharField(max_length=255)
    message = models.CharField(max_length=500)
    is_read = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'notifications'
        ordering = ['-created_at']
