from django.contrib.auth import authenticate
from django.utils import timezone
from rest_framework import viewsets, generics, status
from rest_framework.decorators import action
from rest_framework.parsers import MultiPartParser, FormParser, JSONParser
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.exceptions import InvalidToken
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer, TokenRefreshSerializer
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

from .models import (
    Member, Room, Meeting, MeetingAttendee, MeetingFile, CheckinRecord, User,
    Notification, ConflictAcknowledgement,
)
from .permissions import (
    RoomPermission, MeetingPermission, AttendeePermission, MeetingFilePermission,
    CheckinPermission, UserManagementPermission,
)
from .serializers import (
    MemberSerializer, RoomSerializer, MeetingSerializer, MeetingAttendeeSerializer,
    MeetingFileSerializer, CheckinRecordSerializer, MeSerializer,
    UserAccountSerializer, UserCreateSerializer, NotificationSerializer,
    ConflictAcknowledgementSerializer,
)


class EmailTokenObtainPairSerializer(TokenObtainPairSerializer):
    """Dang nhap bang email + mat khau thay vi username."""

    @classmethod
    def get_token(cls, user):
        token = super().get_token(user)
        token['role'] = user.role
        token['display_name'] = user.display_name
        return token

    def validate(self, attrs):
        email = attrs.get('username') or attrs.get('email')
        password = attrs.get('password')
        try:
            user_obj = User.objects.get(email__iexact=email)
        except User.DoesNotExist:
            self.fail('no_active_account')
        user = authenticate(username=user_obj.username, password=password)
        if not user:
            self.fail('no_active_account')
        refresh = self.get_token(user)
        return {'refresh': str(refresh), 'access': str(refresh.access_token)}


class EmailTokenObtainPairView(TokenObtainPairView):
    serializer_class = EmailTokenObtainPairSerializer
    permission_classes = [AllowAny]


class SafeTokenRefreshSerializer(TokenRefreshSerializer):
    """
    simplejwt tra User.objects.get(...) khong boc try/except khi kiem tra
    tai khoan cua refresh token con ton tai hay khong -- neu tai khoan da bi
    xoa (vd. sau khi seed lai du lieu, hoac quan tri xoa tai khoan) se crash
    500 thay vi tra ve loi token khong hop le nhu binh thuong.
    """

    def validate(self, attrs):
        try:
            return super().validate(attrs)
        except User.DoesNotExist:
            raise InvalidToken('Tài khoản không còn tồn tại.')


class SafeTokenRefreshView(TokenRefreshView):
    serializer_class = SafeTokenRefreshSerializer


class MeView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        return Response(MeSerializer(request.user).data)


class VanThuContactView(APIView):
    """Thong tin lien he cua Van thu Uy ban hien tai -- de bat ky vai tro nao
    (vd Lanh dao) cung goi duoc dung nguoi, khong hardcode ten trong giao dien."""
    permission_classes = [IsAuthenticated]

    def get(self, request):
        vt = User.objects.filter(role='van_thu', member__isnull=False).select_related('member').first()
        if not vt or not vt.member:
            return Response(None)
        return Response(MemberSerializer(vt.member).data)


class MemberViewSet(viewsets.ModelViewSet):
    """
    Doc: ai dang nhap cung xem duoc. Tao moi: chi nguoi duoc tao lich (van_thu/
    phong_ban/quan_tri) moi them duoc -- phuc vu tinh nang "Khac" (nhap tay
    thanh phan tham du chua co trong danh ba), theo bien ban hop 22/08/2026.
    """
    queryset = Member.objects.all().order_by('id')
    serializer_class = MemberSerializer
    permission_classes = [IsAuthenticated]
    filterset_fields = ['unit']
    http_method_names = ['get', 'post', 'patch', 'head', 'options']

    def create(self, request, *args, **kwargs):
        if request.user.role not in ('van_thu', 'phong_ban', 'quan_tri'):
            return Response({'detail': 'Không có quyền thêm thành viên mới.'}, status=status.HTTP_403_FORBIDDEN)
        return super().create(request, *args, **kwargs)

    def partial_update(self, request, *args, **kwargs):
        """Sua thong tin nhan su da co (chuc danh, don vi, sdt, email) --
        theo ghi chu trong file Excel: can 1 form nhap lieu de bo sung hoac
        thay doi ve nhan su. quan_tri/van_thu sua duoc bat ky ai; phong_ban
        chi sua duoc nguoi trong dung don vi cua minh."""
        user = request.user
        if user.role not in ('van_thu', 'phong_ban', 'quan_tri'):
            return Response({'detail': 'Không có quyền sửa thông tin thành viên.'}, status=status.HTTP_403_FORBIDDEN)
        member = self.get_object()
        if user.role == 'phong_ban' and member.unit != user.unit:
            return Response({'detail': 'Chỉ sửa được thành viên trong đơn vị của bạn.'}, status=status.HTTP_403_FORBIDDEN)
        return super().partial_update(request, *args, **kwargs)


class RoomViewSet(viewsets.ModelViewSet):
    queryset = Room.objects.all().order_by('id')
    serializer_class = RoomSerializer
    permission_classes = [IsAuthenticated, RoomPermission]


class MeetingViewSet(viewsets.ModelViewSet):
    serializer_class = MeetingSerializer
    permission_classes = [IsAuthenticated, MeetingPermission]
    filterset_fields = ['level', 'room']

    def get_queryset(self):
        from django.db.models import Q
        user = self.request.user
        qs = Meeting.objects.all()
        # Lich nhap chi nguoi tao thay (va quan_tri thay het de giam sat) --
        # cac tai khoan khac chua duoc thong bao nen cung khong duoc thay.
        if user.role != 'quan_tri':
            qs = qs.filter(Q(is_draft=False) | Q(created_by=user))
        if user.role in ('van_thu', 'quan_tri'):
            return qs.order_by('-meeting_date', '-start_time')
        return qs.filter(Q(level='uy_ban') | Q(unit=user.unit)).order_by('-meeting_date', '-start_time')

    def perform_destroy(self, instance):
        instance.delete()

    @action(detail=True, methods=['post'])
    def postpone(self, request, pk=None):
        """Hoan lich hop (khong dung 'Huy') -- phong hop tu dong duoc giai phong
        vi cac cuoc hop da hoan bi loai khoi tinh trang/canh bao trung lich."""
        meeting = self.get_object()
        user = request.user
        allowed = (
            user.role == 'quan_tri'
            or (meeting.level == 'uy_ban' and user.role == 'van_thu')
            or (meeting.level == 'phong_ban' and user.role == 'phong_ban' and meeting.unit == user.unit)
        )
        if not allowed:
            return Response({'detail': 'Không có quyền hoãn lịch họp này.'}, status=status.HTTP_403_FORBIDDEN)
        meeting.postponed = True
        meeting.save(update_fields=['postponed', 'updated_at'])
        return Response(MeetingSerializer(meeting).data)

    @action(detail=True, methods=['post'])
    def acknowledge_conflict(self, request, pk=None):
        """QT-07 'Xac nhan da dieu phoi': danh dau mot cap lich trung phong la
        cac ben da tu thoa thuan, khong can doi phong. Chi Quan tri he thong
        (quan_tri) duoc xu ly canh bao trung lich."""
        meeting = self.get_object()
        if request.user.role != 'quan_tri':
            return Response({'detail': 'Chỉ Quản trị hệ thống mới xác nhận điều phối được.'}, status=status.HTTP_403_FORBIDDEN)
        other_id = request.data.get('other_meeting_id')
        other = Meeting.objects.filter(pk=other_id).first()
        if not other:
            return Response({'detail': 'Thiếu hoặc sai other_meeting_id.'}, status=status.HTTP_400_BAD_REQUEST)
        a, b = sorted([meeting, other], key=lambda m: m.id)
        ack, _ = ConflictAcknowledgement.objects.get_or_create(
            meeting_a=a, meeting_b=b, defaults={'acknowledged_by': request.user},
        )
        return Response(ConflictAcknowledgementSerializer(ack).data, status=status.HTTP_201_CREATED)


class MeetingAttendeeViewSet(viewsets.ModelViewSet):
    serializer_class = MeetingAttendeeSerializer
    permission_classes = [IsAuthenticated, AttendeePermission]
    filterset_fields = ['meeting', 'member']

    def get_queryset(self):
        user = self.request.user
        qs = MeetingAttendee.objects.select_related('member', 'meeting')
        if user.role in ('van_thu', 'quan_tri'):
            return qs
        from django.db.models import Q
        return qs.filter(Q(member_id=user.member_id) | Q(meeting__level='uy_ban') | Q(meeting__unit=user.unit))

    @action(detail=True, methods=['patch'])
    def respond(self, request, pk=None):
        """RSVP: thanh vien tu xac nhan/tu choi tham du."""
        attendee = self.get_object()
        status_value = request.data.get('status')
        if status_value not in ('accepted', 'declined'):
            return Response({'detail': 'status khong hop le'}, status=status.HTTP_400_BAD_REQUEST)
        attendee.status = status_value
        attendee.decline_reason = request.data.get('decline_reason') if status_value == 'declined' else None
        attendee.responded_at = timezone.now()
        attendee.save()
        return Response(MeetingAttendeeSerializer(attendee).data)


class MeetingFileViewSet(viewsets.ModelViewSet):
    serializer_class = MeetingFileSerializer
    permission_classes = [IsAuthenticated, MeetingFilePermission]
    parser_classes = [MultiPartParser, FormParser, JSONParser]
    filterset_fields = ['meeting']

    def get_queryset(self):
        user = self.request.user
        qs = MeetingFile.objects.select_related('meeting')
        if user.role in ('van_thu', 'quan_tri'):
            return qs
        from django.db.models import Q
        return qs.filter(Q(meeting__level='uy_ban') | Q(meeting__unit=user.unit))


class ConflictAcknowledgementViewSet(viewsets.ReadOnlyModelViewSet):
    """Danh sach cac cap lich trung da duoc xac nhan dieu phoi (QT-07) -- dung
    de frontend biet cap nao khong con phai canh bao nua."""
    serializer_class = ConflictAcknowledgementSerializer
    permission_classes = [IsAuthenticated]
    queryset = ConflictAcknowledgement.objects.all()


class CheckinRecordViewSet(viewsets.ModelViewSet):
    serializer_class = CheckinRecordSerializer
    permission_classes = [IsAuthenticated, CheckinPermission]
    filterset_fields = ['meeting']

    def get_queryset(self):
        user = self.request.user
        if user.role not in ('van_thu', 'phong_ban', 'quan_tri'):
            return CheckinRecord.objects.none()
        return CheckinRecord.objects.select_related('member', 'meeting')

    @action(detail=True, methods=['post'])
    def mark(self, request, pk=None):
        record = self.get_object()
        record.checkin_time = timezone.now()
        record.save()
        return Response(CheckinRecordSerializer(record).data)


class NotificationViewSet(viewsets.ReadOnlyModelViewSet):
    """Thong bao cua rieng nguoi dang dang nhap (lich hop moi, gui cho tat ca
    tai khoan theo bien ban hop 22/08/2026, muc 12)."""
    serializer_class = NotificationSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Notification.objects.filter(recipient=self.request.user)

    @action(detail=True, methods=['post'])
    def mark_read(self, request, pk=None):
        n = self.get_object()
        n.is_read = True
        n.save(update_fields=['is_read'])
        return Response(NotificationSerializer(n).data)

    @action(detail=False, methods=['post'])
    def mark_all_read(self, request):
        self.get_queryset().filter(is_read=False).update(is_read=True)
        return Response({'detail': 'ok'})


class UserAccountViewSet(viewsets.ModelViewSet):
    """
    Quan ly tai khoan phan cap (theo bien ban hop 22/08/2026):
    SuperAdmin (quan_tri) tao tai khoan Van thu cho tung phong ban;
    Van thu Van phong/phong ban (phong_ban) tu tao tai khoan can bo trong
    dung don vi cua minh. Duoc nhung vao trang "Thanh vien" co san, khong
    lam trang rieng.
    """
    permission_classes = [IsAuthenticated, UserManagementPermission]
    http_method_names = ['get', 'post', 'head', 'options']

    def get_serializer_class(self):
        return UserCreateSerializer if self.request.method == 'POST' else UserAccountSerializer

    def get_queryset(self):
        user = self.request.user
        qs = User.objects.select_related('member').order_by('unit', 'display_name')
        if user.role == 'quan_tri':
            return qs
        return qs.filter(unit=user.unit)

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        return Response(UserAccountSerializer(user).data, status=status.HTTP_201_CREATED)
