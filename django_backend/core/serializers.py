from rest_framework import serializers
from .models import (
    Member, Room, Meeting, MeetingAttendee, MeetingFile, CheckinRecord, User,
    Notification, ConflictAcknowledgement, FileKind,
)

_EXT_TO_KIND = {
    'pdf': FileKind.PDF,
    'doc': FileKind.DOC, 'docx': FileKind.DOC,
    'xls': FileKind.XLS, 'xlsx': FileKind.XLS,
    'png': FileKind.IMG, 'jpg': FileKind.IMG, 'jpeg': FileKind.IMG,
}


class MemberSerializer(serializers.ModelSerializer):
    class Meta:
        model = Member
        fields = ['id', 'name', 'title', 'unit', 'initials', 'color', 'phone', 'email']


class MeSerializer(serializers.ModelSerializer):
    member = MemberSerializer(read_only=True)

    class Meta:
        model = User
        fields = ['id', 'email', 'role', 'display_name', 'unit', 'member', 'can_manage_rooms']


class UserAccountSerializer(serializers.ModelSerializer):
    """Danh sach tai khoan (dung cho man hinh Quan ly tai khoan)."""
    member = MemberSerializer(read_only=True)

    class Meta:
        model = User
        fields = ['id', 'email', 'role', 'display_name', 'unit', 'member', 'is_active', 'can_manage_rooms']


class UserCreateSerializer(serializers.ModelSerializer):
    """Tao tai khoan moi. Pham vi (vai tro nao duoc tao vai tro nao, don vi nao)
    duoc kiem tra o view, khong o day."""
    password = serializers.CharField(write_only=True, min_length=6)
    member_name = serializers.CharField(write_only=True, required=False, allow_blank=True)
    member_title = serializers.CharField(write_only=True, required=False, allow_blank=True)

    class Meta:
        model = User
        fields = ['id', 'email', 'password', 'role', 'display_name', 'unit',
                  'member_name', 'member_title', 'can_manage_rooms']
        extra_kwargs = {'can_manage_rooms': {'required': False}}

    def create(self, validated_data):
        member_name = validated_data.pop('member_name', '') or validated_data.get('display_name')
        member_title = validated_data.pop('member_title', '') or ''
        password = validated_data.pop('password')
        unit = validated_data.get('unit')

        member = None
        if member_name:
            initials = ''.join(p[0].upper() for p in member_name.split()[-2:] if p)
            member = Member.objects.create(
                name=member_name, title=member_title or validated_data['role'],
                unit=unit or '', initials=initials or 'NV',
                email=validated_data['email'],
            )

        user = User.objects.create_user(
            username=validated_data['email'],
            email=validated_data['email'],
            password=password,
            role=validated_data['role'],
            display_name=validated_data['display_name'],
            unit=unit,
            member=member,
            can_manage_rooms=validated_data.get('can_manage_rooms', False),
        )
        return user


class RoomSerializer(serializers.ModelSerializer):
    class Meta:
        model = Room
        fields = ['id', 'name', 'location', 'capacity', 'equipment']


class MeetingAttendeeSerializer(serializers.ModelSerializer):
    member = MemberSerializer(read_only=True)
    member_id = serializers.PrimaryKeyRelatedField(queryset=Member.objects.all(), source='member', write_only=True)

    class Meta:
        model = MeetingAttendee
        fields = ['id', 'meeting', 'member', 'member_id', 'status', 'decline_reason', 'responded_at']
        read_only_fields = ['responded_at']


class MeetingFileSerializer(serializers.ModelSerializer):
    file = serializers.FileField(use_url=True, required=True)

    class Meta:
        model = MeetingFile
        fields = ['id', 'meeting', 'name', 'file', 'size_bytes', 'kind', 'uploaded_at']
        read_only_fields = ['size_bytes', 'kind']

    def create(self, validated_data):
        f = validated_data['file']
        validated_data.setdefault('name', f.name)
        validated_data['size_bytes'] = f.size
        ext = f.name.rsplit('.', 1)[-1].lower() if '.' in f.name else ''
        validated_data['kind'] = _EXT_TO_KIND.get(ext, FileKind.OTHER)
        return super().create(validated_data)


class CheckinRecordSerializer(serializers.ModelSerializer):
    member = MemberSerializer(read_only=True)

    class Meta:
        model = CheckinRecord
        fields = ['id', 'meeting', 'member', 'checkin_time']


class ConflictAcknowledgementSerializer(serializers.ModelSerializer):
    class Meta:
        model = ConflictAcknowledgement
        fields = ['id', 'meeting_a', 'meeting_b', 'created_at']
        read_only_fields = ['id', 'created_at']


class NotificationSerializer(serializers.ModelSerializer):
    meeting_title = serializers.CharField(source='meeting.title', read_only=True, default=None)

    class Meta:
        model = Notification
        fields = ['id', 'meeting', 'meeting_title', 'title', 'message', 'is_read', 'created_at']


class MeetingSerializer(serializers.ModelSerializer):
    attendees = MeetingAttendeeSerializer(many=True, read_only=True)
    files = MeetingFileSerializer(many=True, read_only=True)
    room_name = serializers.CharField(source='room.name', read_only=True, default=None)
    room_location = serializers.CharField(source='room.location', read_only=True, default=None)
    member_ids = serializers.PrimaryKeyRelatedField(
        queryset=Member.objects.all(), many=True, write_only=True, required=False
    )

    class Meta:
        model = Meeting
        fields = [
            'id', 'title', 'meeting_date', 'start_time', 'session', 'level',
            'room', 'room_name', 'room_location', 'location_text', 'unit', 'host', 'content',
            'estimated_people', 'postponed', 'is_draft', 'minutes', 'created_by', 'created_at', 'updated_at',
            'attendees', 'files', 'member_ids',
        ]
        read_only_fields = ['created_by', 'created_at', 'updated_at']

    def create(self, validated_data):
        member_ids = validated_data.pop('member_ids', [])
        request = self.context['request']
        meeting = Meeting.objects.create(created_by=request.user, **validated_data)
        for member in member_ids:
            MeetingAttendee.objects.create(meeting=meeting, member=member)

        # Lich nhap chua cong bo chinh thuc nen khong gui thong bao (chi
        # nguoi tao thay, cho toi khi sua lai va bo trang thai nhap).
        if meeting.is_draft:
            return meeting

        # Thong bao lich hop moi den TOAN BO tai khoan, khong loc theo don vi
        # (theo bien ban hop 22/08/2026, muc 12).
        when = f"{meeting.meeting_date.strftime('%d/%m/%Y')} · {meeting.start_time.strftime('%H:%M')}"
        Notification.objects.bulk_create([
            Notification(
                recipient=user,
                meeting=meeting,
                title='Lịch họp mới',
                message=f'"{meeting.title}" — {when}',
            )
            for user in User.objects.exclude(id=request.user.id)
        ])
        return meeting

    def update(self, instance, validated_data):
        member_ids = validated_data.pop('member_ids', None)
        request = self.context['request']

        # quan_tri chi duoc doi phong hop, khong duoc sua truong khac
        if request.user.role == 'quan_tri' and instance.level == 'uy_ban':
            if 'room' in validated_data:
                instance.room = validated_data['room']
                instance.save(update_fields=['room', 'updated_at'])
            return instance

        was_draft = instance.is_draft
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()

        # Lich tu nhap chuyen sang cong bo chinh thuc: gui thong bao luc nay
        # (luc tao con dang nhap thi da bo qua thong bao).
        if was_draft and not instance.is_draft:
            when = f"{instance.meeting_date.strftime('%d/%m/%Y')} · {instance.start_time.strftime('%H:%M')}"
            Notification.objects.bulk_create([
                Notification(
                    recipient=user,
                    meeting=instance,
                    title='Lịch họp mới',
                    message=f'"{instance.title}" — {when}',
                )
                for user in User.objects.exclude(id=request.user.id)
            ])

        if member_ids is not None:
            new_ids = {m.id for m in member_ids}
            existing_ids = set(instance.attendees.values_list('member_id', flat=True))
            for member in member_ids:
                if member.id not in existing_ids:
                    MeetingAttendee.objects.create(meeting=instance, member=member)
            for att in instance.attendees.exclude(member_id__in=new_ids):
                att.delete()
        return instance
