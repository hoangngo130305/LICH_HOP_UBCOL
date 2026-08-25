from rest_framework.permissions import BasePermission, SAFE_METHODS


def role(request):
    return getattr(request.user, 'role', None)


def unit(request):
    return getattr(request.user, 'unit', None)


def member_id(request):
    return getattr(request.user, 'member_id', None)


class RoomPermission(BasePermission):
    """Ai cung xem duoc; chi quan_tri (hoac nguoi duoc gan co
    can_manage_rooms=True, vd. can bo phu trach ha tang/server) duoc them/sua."""

    def has_permission(self, request, view):
        if request.method in SAFE_METHODS:
            return True
        if role(request) == 'quan_tri':
            return True
        return bool(getattr(request.user, 'can_manage_rooms', False))


class MeetingPermission(BasePermission):
    """
    - cap uy_ban: ai cung xem duoc; chi van_thu tao/sua/xoa; quan_tri duoc sua rieng room_id
    - cap phong_ban: nguoi cung don vi (hoac van_thu/quan_tri) xem duoc; chi phong_ban tao/sua/xoa cua don vi minh
    """

    def has_permission(self, request, view):
        if request.method in SAFE_METHODS:
            return True
        if request.method == 'POST' and getattr(view, 'action', None) == 'create':
            data = request.data
            level = data.get('level')
            if level == 'uy_ban':
                return role(request) == 'van_thu'
            if level == 'phong_ban':
                return role(request) == 'phong_ban' and data.get('unit') == unit(request)
            return False
        return True  # object-level check (postpone/PATCH/PUT/DELETE) xu ly rieng

    def has_object_permission(self, request, view, obj):
        if request.method in SAFE_METHODS:
            if obj.level == 'uy_ban':
                return True
            return obj.unit == unit(request) or role(request) in ('van_thu', 'quan_tri')

        if view.action in ('postpone', 'acknowledge_conflict'):
            # View da tu kiem tra lai dieu kien chi tiet (postpone: quan_tri
            # moi cap, van_thu cap uy_ban, phong_ban dung don vi minh;
            # acknowledge_conflict: chi quan_tri) va tra ve 403 rieng neu
            # khong hop le, nen o day chi can cho qua object-level check de
            # khong bi chan nham truoc khi toi duoc logic do.
            return True

        if obj.level == 'uy_ban':
            if role(request) == 'van_thu':
                return True
            if role(request) == 'quan_tri' and request.method in ('PATCH', 'PUT'):
                # quan_tri chi duoc doi phong (kiem tra field o serializer/view)
                return True
            return False
        if obj.level == 'phong_ban':
            return role(request) == 'phong_ban' and obj.unit == unit(request)
        return False


class AttendeePermission(BasePermission):
    def has_permission(self, request, view):
        if request.method in SAFE_METHODS:
            return True
        if request.method == 'POST':
            return role(request) in ('van_thu', 'phong_ban')
        return True

    def has_object_permission(self, request, view, obj):
        if request.method in SAFE_METHODS:
            return True
        if request.method == 'DELETE':
            return role(request) in ('van_thu', 'phong_ban')
        if request.method in ('PATCH', 'PUT'):
            if role(request) in ('van_thu', 'phong_ban', 'quan_tri'):
                return True
            # Tu xac nhan tham du chinh minh: chi Lanh dao hoac Truong/Pho phong
            # (theo bien ban hop 22/08/2026) moi duoc bam "Xac nhan tham gia".
            if obj.member_id == member_id(request):
                if role(request) == 'lanh_dao':
                    return True
                title = (getattr(request.user.member, 'title', '') or '') if request.user.member_id else ''
                return any(k in title for k in ('Trưởng', 'Phó'))
            return False
        return False


class MeetingFilePermission(BasePermission):
    def has_permission(self, request, view):
        if request.method in SAFE_METHODS:
            return True
        return role(request) in ('van_thu', 'phong_ban')


class UserManagementPermission(BasePermission):
    """
    Phan cap tao tai khoan (theo yeu cau bien ban hop):
    - quan_tri (SuperAdmin): xem tat ca, tao duoc tai khoan vai tro bat ky
    - phong_ban (Van thu Van phong/phong ban): chi xem + tao duoc tai khoan
      'thanh_vien' trong DUNG don vi cua minh
    """

    def has_permission(self, request, view):
        if request.method in SAFE_METHODS:
            return role(request) in ('quan_tri', 'phong_ban')
        if request.method == 'POST':
            if role(request) == 'quan_tri':
                return True
            if role(request) == 'phong_ban':
                data = request.data
                return data.get('role') == 'thanh_vien' and data.get('unit') == unit(request)
            return False
        return role(request) == 'quan_tri'


class CheckinPermission(BasePermission):
    """
    Giong RLS cua Postgres: role khong co quyen xem thi duoc phep GOI API
    nhung ket qua tra ve rong (loc o get_queryset), khong chan hang 403 --
    vi 403 se lam frontend crash o buoc tai du lieu dau tien sau dang nhap.
    """

    def has_permission(self, request, view):
        if request.method in SAFE_METHODS:
            return True
        return role(request) in ('van_thu', 'phong_ban')
