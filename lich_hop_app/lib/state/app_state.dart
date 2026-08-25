import 'dart:async';

import 'package:flutter/material.dart';

import '../models/models.dart';
import '../services/api_client.dart';

/// Trạng thái toàn ứng dụng: phiên đăng nhập thật (JWT qua backend Django),
/// dữ liệu lịch họp / phòng họp / thành viên lấy từ MySQL (qua REST API),
/// và các thao tác thêm / sửa / xóa ghi thẳng xuống máy chủ.
class AppState extends ChangeNotifier {
  UserRole? _role;
  String _pageId = '';
  bool _loading = false;
  String? _authError;
  String? _lastError;

  int? currentMemberId;
  String _userName = '';
  String? _unit;
  String? _myTitle;
  bool _canManageRooms = false;

  List<Member> members = [];
  List<Room> rooms = [];
  List<Meeting> ubndMeetings = [];
  List<Meeting> deptMeetings = [];

  /// meetingId -> memberId -> giờ quét thẻ (chuỗi HH:mm) — null nếu chưa quét.
  final Map<int, Map<int, String>> checkinTimes = {};

  /// meetingId -> memberId -> id dòng checkin_records (dùng để gọi API điểm danh).
  final Map<int, Map<int, int>> _checkinIds = {};

  /// meetingId -> memberId -> id dòng meeting_attendees (dùng để gọi API RSVP).
  final Map<int, Map<int, int>> _attendeeRecordIds = {};

  /// Cuộc họp đang được mở để chỉnh sửa (dùng chung form Tạo/Sửa lịch).
  Meeting? meetingBeingEdited;

  /// Thông báo lịch họp mới — gửi đến TOÀN BỘ tài khoản, không lọc theo
  /// đơn vị (theo biên bản họp 22/08/2026, mục 12).
  List<Map<String, dynamic>> notifications = [];
  int get unreadNotificationCount =>
      notifications.where((n) => n['is_read'] == false).length;
  Timer? _notifTimer;

  UserRole? get role => _role;
  String get pageId => _pageId;
  bool get isLoggedIn => _role != null;
  bool get isLoading => _loading;
  String? get authError => _authError;
  String? get lastError => _lastError;

  String get userName => _userName;
  String? get myTitle => _myTitle;
  String get roleLabel => _role?.label ?? '';
  String? get unit => _unit;
  String get unitLabel => _unit ?? 'Phòng ban';
  bool get canManageRooms => _canManageRooms || _role == UserRole.quanTri;

  AppState() {
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    _loading = true;
    notifyListeners();
    await api.loadTokens();
    if (!api.hasSession) {
      _loading = false;
      notifyListeners();
      return;
    }
    try {
      await _loadProfileAndData();
      _pageId = _role!.homePage;
    } catch (_) {
      _role = null;
      await api.clearSession();
    }
    _loading = false;
    notifyListeners();
  }

  // ===== ĐĂNG NHẬP / ĐĂNG XUẤT =====
  Future<bool> login(String email, String password) async {
    _loading = true;
    _authError = null;
    notifyListeners();
    try {
      final ok = await api.login(email.trim(), password);
      if (!ok) {
        _authError = 'Sai email hoặc mật khẩu.';
        _loading = false;
        notifyListeners();
        return false;
      }
      await _loadProfileAndData();
      _pageId = _role!.homePage;
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _authError = 'Sai email hoặc mật khẩu.';
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> _loadProfileAndData() async {
    final me = await api.get('me/') as Map<String, dynamic>;
    _role = _roleFromDb(me['role'] as String);
    final memberObj = me['member'] as Map<String, dynamic>?;
    currentMemberId = memberObj?['id'] as int?;
    _myTitle = memberObj?['title'] as String?;
    _userName = me['display_name'] as String? ?? '';
    _unit = me['unit'] as String?;
    _canManageRooms = me['can_manage_rooms'] as bool? ?? false;
    await _loadAll();
    await loadNotifications();
    _startNotifPolling();
  }

  /// Tự động kiểm tra thông báo mới mỗi 20 giây — mô phỏng thông báo tức
  /// thời (không có hạ tầng push/websocket) để số đỏ trên chuông cập nhật
  /// mà không cần người dùng thao tác gì.
  void _startNotifPolling() {
    _notifTimer?.cancel();
    _notifTimer = Timer.periodic(const Duration(seconds: 20), (_) => loadNotifications());
  }

  Future<void> loadNotifications() async {
    try {
      final rows = await api.get('notifications/') as List;
      notifications = rows.cast<Map<String, dynamic>>();
      notifyListeners();
    } catch (_) {
      // Giu nguyen danh sach cu neu loi mang tam thoi, khong xoa trang.
    }
  }

  Future<void> markNotificationRead(int id) async {
    try {
      await api.post('notifications/$id/mark_read/');
      final idx = notifications.indexWhere((n) => n['id'] == id);
      if (idx != -1) notifications[idx]['is_read'] = true;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> markAllNotificationsRead() async {
    try {
      await api.post('notifications/mark_all_read/');
      for (final n in notifications) {
        n['is_read'] = true;
      }
      notifyListeners();
    } catch (_) {}
  }

  @override
  void dispose() {
    _notifTimer?.cancel();
    super.dispose();
  }

  /// Chỉ Lãnh đạo hoặc Trưởng/Phó phòng mới được bấm "Xác nhận tham gia"
  /// (theo biên bản họp 22/08/2026) — các cán bộ khác chỉ được xem.
  bool get canConfirmAttendance =>
      _role == UserRole.lanhDao ||
      _role == UserRole.vanThu ||
      _role == UserRole.phongBan ||
      _role == UserRole.quanTri ||
      (_myTitle != null &&
          (_myTitle!.contains('Trưởng') || _myTitle!.contains('Phó')));

  Future<void> logout() async {
    _notifTimer?.cancel();
    notifications = [];
    await api.logout();
    _role = null;
    _pageId = '';
    currentMemberId = null;
    _userName = '';
    _unit = null;
    _canManageRooms = false;
    members = [];
    rooms = [];
    ubndMeetings = [];
    deptMeetings = [];
    checkinTimes.clear();
    _checkinIds.clear();
    _attendeeRecordIds.clear();
    notifyListeners();
  }

  // ===== Điều hướng =====
  void goTo(String pageId) {
    if (_pageId == pageId) return;
    _pageId = pageId;
    notifyListeners();
  }

  void startEdit(Meeting m) => meetingBeingEdited = m;
  void clearEdit() => meetingBeingEdited = null;

  // ===== NẠP DỮ LIỆU TỪ BACKEND DJANGO =====
  Future<void> _loadAll() async {
    final membersRows = await api.get('members/');
    final roomsRows = await api.get('rooms/');
    final meetingRows = await api.get('meetings/');
    final checkinRows = await api.get('checkin-records/');
    final ackRows = await api.get('conflict-acknowledgements/');

    _acknowledgedConflicts
      ..clear()
      ..addAll((ackRows as List).map((r) {
        final row = r as Map<String, dynamic>;
        return _ackKey(row['meeting_a'] as int, row['meeting_b'] as int);
      }));

    members = (membersRows as List)
        .map((r) => _memberFromRow(r as Map<String, dynamic>))
        .toList();

    rooms = (roomsRows as List)
        .map((r) => _roomFromRowRaw(r as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.id.compareTo(b.id));

    final all = (meetingRows as List)
        .map((r) => _meetingFromRow(r as Map<String, dynamic>))
        .toList();
    ubndMeetings = all.where((m) => m.level == MeetingLevel.uyBan).toList();
    deptMeetings = all.where((m) => m.level == MeetingLevel.phongBan).toList();

    _attendeeRecordIds.clear();
    for (final r in meetingRows) {
      final row = r as Map<String, dynamic>;
      final mid = row['id'] as int;
      for (final a in (row['attendees'] as List? ?? [])) {
        final ar = a as Map<String, dynamic>;
        final memberObj = ar['member'] as Map<String, dynamic>;
        _attendeeRecordIds.putIfAbsent(mid, () => {})[memberObj['id'] as int] =
            ar['id'] as int;
      }
    }

    checkinTimes.clear();
    _checkinIds.clear();
    for (final r in checkinRows as List) {
      final row = r as Map<String, dynamic>;
      final mid = row['meeting'] as int;
      final memberObj = row['member'] as Map<String, dynamic>;
      final memberId = memberObj['id'] as int;
      _checkinIds.putIfAbsent(mid, () => {})[memberId] = row['id'] as int;
      final t = row['checkin_time'] as String?;
      if (t == null) continue;
      final dt = DateTime.tryParse(t);
      if (dt == null) continue;
      final local = dt.toLocal();
      final label =
          '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
      checkinTimes.putIfAbsent(mid, () => {})[memberId] = label;
    }

    _recomputeConflicts();
    _recomputeRoomStatuses();

    try {
      final vt = await api.get('vanthu-contact/');
      _vanThuContact = vt == null ? null : _memberFromRow(vt as Map<String, dynamic>);
    } catch (_) {
      _vanThuContact = null;
    }
  }

  // ===== Truy vấn lịch họp =====
  List<Meeting> get allMeetings => [...ubndMeetings, ...deptMeetings];

  Meeting? meetingById(int id) {
    for (final m in allMeetings) {
      if (m.id == id) return m;
    }
    return null;
  }

  Member? member(int id) {
    for (final m in members) {
      if (m.id == id) return m;
    }
    return null;
  }

  /// Cán bộ Văn thư Ủy ban (dùng cho hộp thoại "Liên hệ Văn thư") — lấy
  /// đúng người đang giữ vai trò Văn thư qua API riêng (không đoán theo
  /// chức danh, vì dữ liệu thật không ghi "Văn thư" trong title).
  Member? _vanThuContact;
  Member? get vanThuContact => _vanThuContact;

  /// Cán bộ thuộc cùng đơn vị với người đang đăng nhập (Hành chính Phòng ban).
  List<Member> get myUnitMembers =>
      members.where((m) => m.unit == _unit).toList();

  /// "Sắp diễn ra" không tính lịch đã hoãn — hoãn là trạng thái riêng, hiển
  /// thị ở tab "Hoãn" (theo biên bản họp 22/08/2026, mục 10: bổ sung trạng
  /// thái "Hoãn" bên cạnh "Sắp diễn ra" và "Đã kết thúc").
  List<Meeting> get upcomingUbnd => ubndMeetings
      .where((m) => !m.isDone && !m.postponed)
      .toList()
    ..sort(_byDateTime);

  List<Meeting> get doneUbnd => ubndMeetings.where((m) => m.isDone).toList();

  List<Meeting> get postponedUbnd =>
      ubndMeetings.where((m) => m.postponed).toList()..sort(_byDateTime);

  List<Meeting> get upcomingDept => deptMeetings
      .where((m) => !m.isDone && !m.postponed)
      .toList()
    ..sort(_byDateTime);

  List<Meeting> get doneDept => deptMeetings.where((m) => m.isDone).toList();

  List<Meeting> get postponedDept =>
      deptMeetings.where((m) => m.postponed).toList()..sort(_byDateTime);

  /// Lịch của thành viên đang đăng nhập.
  List<Meeting> get myMeetings => allMeetings
      .where((m) => currentMemberId != null && m.memberIds.contains(currentMemberId))
      .toList()
    ..sort(_byDateTime);

  List<Meeting> myMeetingsOn(DateTime day) =>
      myMeetings.where((m) => VnDate.sameDay(m.date, day)).toList();

  List<Meeting> meetingsOn(DateTime day) =>
      allMeetings.where((m) => VnDate.sameDay(m.date, day)).toList()
        ..sort(_byDateTime);

  Rsvp rsvpOf(int meetingId) {
    if (currentMemberId == null) return Rsvp.pending;
    final m = meetingById(meetingId);
    return m?.rsvpFor(currentMemberId!) ?? Rsvp.pending;
  }

  int countMyRsvp(Rsvp r) =>
      myMeetings.where((m) => rsvpOf(m.id) == r).length;

  /// Các cặp lịch trùng: cùng phòng, cùng ngày, cùng buổi (chỉ tính lịch Ủy ban).
  List<(Meeting, Meeting)> get conflicts => findMeetingConflicts(
          ubndMeetings.where((m) => !m.isDone).toList())
      .where((pair) => !_isAcknowledged(pair.$1.id, pair.$2.id))
      .toList();

  /// Các cặp lịch trùng đã được Quản trị hệ thống "Xác nhận đã điều phối"
  /// (QT-07) — không còn cần cảnh báo nữa dù vẫn cùng phòng/ngày/buổi.
  final Set<String> _acknowledgedConflicts = {};

  static String _ackKey(int a, int b) =>
      a < b ? '$a-$b' : '$b-$a';

  bool _isAcknowledged(int a, int b) =>
      _acknowledgedConflicts.contains(_ackKey(a, b));

  int get freeRoomCount =>
      rooms.where((r) => r.status == RoomStatus.free).length;

  int get busyRoomCount =>
      rooms.where((r) => r.status != RoomStatus.free).length;

  void _recomputeConflicts() {
    final flags = <int, bool>{};
    for (final (a, b) in conflicts) {
      flags[a.id] = true;
      flags[b.id] = true;
    }
    ubndMeetings = [
      for (final m in ubndMeetings)
        m.copyWith(conflict: flags[m.id] ?? false),
    ];
  }

  void _recomputeRoomStatuses() {
    final today = VnDate.today;
    rooms = [
      for (final r in rooms)
        () {
          final todays = ubndMeetings
              .where((m) => m.roomId == r.id && VnDate.sameDay(m.date, today))
              .toList()
            ..sort((a, b) =>
                (a.time.hour * 60 + a.time.minute) -
                (b.time.hour * 60 + b.time.minute));
          final slots = [
            for (final m in todays)
              RoomSlot(m.timeLabel, m.title,
                  m.conflict ? SlotDot.warn : SlotDot.ok,
                  conflict: m.conflict),
          ];
          final status = todays.isEmpty
              ? RoomStatus.free
              : (todays.any((m) => m.conflict)
                  ? RoomStatus.conflict
                  : RoomStatus.busy);
          return Room(
            id: r.id,
            name: r.name,
            location: r.location,
            capacity: r.capacity,
            status: status,
            schedule: slots,
            equipment: r.equipment,
          );
        }(),
    ];
  }

  // ===== Thao tác dữ liệu (ghi thật xuống backend, sau đó nạp lại) =====
  Future<bool> _mutate(Future<void> Function() action) async {
    try {
      await action();
      await _loadAll();
      _lastError = null;
      notifyListeners();
      return true;
    } catch (e) {
      _lastError = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Cập nhật phản hồi lời mời của chính người đang đăng nhập.
  Future<bool> respond(int meetingId, Rsvp rsvp, {String? declineReason}) {
    if (currentMemberId == null) return Future.value(false);
    final recId = _attendeeRecordIds[meetingId]?[currentMemberId];
    if (recId == null) return Future.value(false);
    return _mutate(() => api.patch('meeting-attendees/$recId/respond/', body: {
          'status': _rsvpToDb(rsvp),
          if (declineReason != null) 'decline_reason': declineReason,
        }));
  }

  Future<void> _uploadFile(int meetingId, PendingFile f) => api.uploadFile(
        'meeting-files/',
        bytes: f.bytes,
        filename: f.name,
        fields: {'meeting': '$meetingId', 'name': f.name},
      );

  Future<bool> addMeeting({
    required String title,
    required DateTime date,
    required TimeOfDay time,
    required Session session,
    required MeetingLevel level,
    required String host,
    required List<int> memberIds,
    required String content,
    int? roomId,
    String? locationText,
    String? unit,
    int? estimatedPeople,
    List<PendingFile> newFiles = const [],
    bool isDraft = false,
  }) {
    return _mutate(() async {
      final created = await api.post('meetings/', body: {
        'title': title,
        'meeting_date': _fmtDate(date),
        'start_time': _fmtTime(time),
        'session': _sessionToDb(session),
        'level': _levelToDb(level),
        'room': roomId,
        'location_text': locationText,
        'unit': unit,
        'host': host,
        'content': content,
        'estimated_people': estimatedPeople,
        'member_ids': memberIds,
        'is_draft': isDraft,
      }) as Map<String, dynamic>;
      final newId = created['id'] as int;
      for (final f in newFiles) {
        await _uploadFile(newId, f);
      }
    });
  }

  /// Cập nhật toàn bộ nội dung lịch họp (dùng cho chức năng "Chỉnh sửa").
  Future<bool> updateMeetingFull({
    required int id,
    required String title,
    required DateTime date,
    required TimeOfDay time,
    required Session session,
    required String content,
    required List<int> memberIds,
    String? host,
    int? roomId,
    String? locationText,
    String? unit,
    int? estimatedPeople,
    List<MeetingFile> keepExistingFiles = const [],
    List<PendingFile> newFiles = const [],
    bool? isDraft,
  }) {
    final old = meetingById(id);
    return _mutate(() async {
      await api.patch('meetings/$id/', body: {
        'title': title,
        'meeting_date': _fmtDate(date),
        'start_time': _fmtTime(time),
        'session': _sessionToDb(session),
        'room': roomId,
        'location_text': locationText,
        'unit': unit,
        'host': host,
        'content': content,
        'estimated_people': estimatedPeople,
        'member_ids': memberIds,
        if (isDraft != null) 'is_draft': isDraft,
      });

      if (old != null) {
        final keepIds = keepExistingFiles.map((f) => f.id).toSet();
        for (final f in old.files) {
          if (f.id != null && !keepIds.contains(f.id)) {
            await api.delete('meeting-files/${f.id}/');
          }
        }
      }
      for (final f in newFiles) {
        await _uploadFile(id, f);
      }
    });
  }

  /// Lưu nội dung biên bản cuộc họp (Văn thư/Phòng ban soạn sau khi họp xong).
  Future<bool> saveMeetingMinutes(int id, String minutes) {
    return _mutate(() => api.patch('meetings/$id/', body: {'minutes': minutes}));
  }

  /// Đổi phòng họp cho một cuộc họp (dùng cho hộp thoại "Đổi phòng").
  Future<bool> changeMeetingRoom(int meetingId, Room newRoom) {
    return _mutate(
        () => api.patch('meetings/$meetingId/', body: {'room': newRoom.id}));
  }

  Future<bool> deleteMeeting(int id) {
    return _mutate(() => api.delete('meetings/$id/'));
  }

  /// Hoãn lịch họp (không dùng "Hủy") — phòng họp tự động được giải phóng
  /// vì lịch đã hoãn bị loại khỏi tính toán trùng lịch/tình trạng phòng.
  Future<bool> postponeMeeting(int id) {
    return _mutate(() => api.post('meetings/$id/postpone/'));
  }

  /// QT-07 "Xác nhận đã điều phối": đánh dấu một cặp lịch trùng phòng là đã
  /// được các bên tự thỏa thuận, không cần đổi phòng — cảnh báo trùng của
  /// đúng cặp này sẽ biến mất khỏi mọi màn hình.
  Future<bool> acknowledgeConflict(int meetingIdA, int meetingIdB) {
    return _mutate(() => api.post('meetings/$meetingIdA/acknowledge_conflict/',
        body: {'other_meeting_id': meetingIdB}));
  }

  /// Sửa thông tin nhân sự đã có trong danh bạ (chức danh, đơn vị, sđt,
  /// email) — theo ghi chú trong file Excel: cần chỗ để bổ sung hoặc cập
  /// nhật khi có thay đổi về nhân sự, không chỉ tạo mới.
  Future<bool> updateMember(
    int id, {
    String? title,
    String? unit,
    String? phone,
    String? email,
  }) {
    return _mutate(() => api.patch('members/$id/', body: {
          if (title != null) 'title': title,
          if (unit != null) 'unit': unit,
          if (phone != null) 'phone': phone,
          if (email != null) 'email': email,
        }));
  }

  /// Tạo tài khoản mới (phân cấp: SuperAdmin tạo Văn thư phòng ban bất kỳ;
  /// Văn thư phòng ban chỉ tạo được cán bộ trong đúng đơn vị của mình).
  /// Trả về thông báo lỗi cụ thể nếu thất bại, null nếu thành công.
  Future<String?> createAccount({
    required String email,
    required String password,
    required String role,
    required String displayName,
    required String unit,
    String? memberTitle,
  }) async {
    try {
      await api.post('accounts/', body: {
        'email': email,
        'password': password,
        'role': role,
        'display_name': displayName,
        'unit': unit,
        'member_name': displayName,
        'member_title': memberTitle ?? '',
      });
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  List<Map<String, dynamic>> _accounts = [];
  List<Map<String, dynamic>> get accounts => _accounts;

  /// Nạp danh sách tài khoản (SuperAdmin thấy tất cả; Văn thư phòng ban chỉ
  /// thấy tài khoản trong đơn vị mình) — dùng cho trang "Thành viên".
  Future<void> loadAccounts() async {
    try {
      final rows = await api.get('accounts/') as List;
      _accounts = rows.cast<Map<String, dynamic>>();
      notifyListeners();
    } catch (_) {
      _accounts = [];
    }
  }

  /// Thêm 1 người "Khác" (nhập tay, chưa có trong danh bạ) làm thành phần
  /// tham dự — theo biên bản họp 22/08/2026: "vừa có sẵn các cơ quan cố
  /// định để chọn nhanh, vừa có ô 'Khác' để nhập tay khi phát sinh".
  /// Trả về id thành viên mới nếu thành công, null nếu thất bại.
  Future<int?> addCustomAttendeeName(String name, {String unit = 'Khác'}) async {
    try {
      final initials = name
          .trim()
          .split(RegExp(r'\s+'))
          .where((p) => p.isNotEmpty)
          .toList()
          .reversed
          .take(2)
          .map((p) => p[0].toUpperCase())
          .join();
      final created = await api.post('members/', body: {
        'name': name.trim(),
        'title': 'Khác',
        'unit': unit,
        'initials': initials.isEmpty ? 'KH' : initials,
        'color': 'amber',
      }) as Map<String, dynamic>;
      members = [...members, _memberFromRow(created)];
      notifyListeners();
      return created['id'] as int;
    } catch (e) {
      _lastError = e.toString();
      return null;
    }
  }

  Future<bool> addRoom(Room room) {
    return _mutate(() => api.post('rooms/', body: {
          'name': room.name,
          'location': room.location,
          'capacity': room.capacity,
          'equipment': room.equipment,
        }));
  }

  /// Điểm danh: ghi nhận giờ quét thẻ của một thành viên cho một cuộc họp.
  Future<bool> checkin(int meetingId, int memberId) {
    final recId = _checkinIds[meetingId]?[memberId];
    if (recId == null) return Future.value(false);
    return _mutate(() => api.post('checkin-records/$recId/mark/'));
  }

  static int _byDateTime(Meeting a, Meeting b) {
    final d = a.date.compareTo(b.date);
    if (d != 0) return d;
    return (a.time.hour * 60 + a.time.minute)
        .compareTo(b.time.hour * 60 + b.time.minute);
  }

  // ===== Chuyển đổi dữ liệu <-> Backend Django =====
  Member _memberFromRow(Map<String, dynamic> r) => Member(
        id: r['id'] as int,
        name: r['name'] as String,
        title: r['title'] as String,
        unit: r['unit'] as String,
        initials: r['initials'] as String,
        color: _colorFromDb(r['color'] as String),
        phone: r['phone'] as String?,
        email: r['email'] as String?,
      );

  Room _roomFromRowRaw(Map<String, dynamic> r) => Room(
        id: r['id'] as int,
        name: r['name'] as String,
        location: r['location'] as String,
        capacity: r['capacity'] as int,
        status: RoomStatus.free,
        equipment: r['equipment'] as String?,
      );

  Meeting _meetingFromRow(Map<String, dynamic> r) {
    final level = _levelFromDb(r['level'] as String);
    final roomName = r['room_name'] as String?;
    final roomLocation = r['room_location'] as String?;
    final roomLabel = level == MeetingLevel.phongBan
        ? (r['location_text'] as String? ?? '—')
        : (roomName != null && roomLocation != null
            ? '$roomName – $roomLocation'
            : (r['location_text'] as String? ?? '—'));

    final attendeeRows = (r['attendees'] as List? ?? []);
    final attendees = attendeeRows.map((a) {
      final row = a as Map<String, dynamic>;
      final memberObj = row['member'] as Map<String, dynamic>;
      return Attendee(
        memberId: memberObj['id'] as int,
        status: _rsvpFromDb(row['status'] as String),
        declineReason: row['decline_reason'] as String?,
      );
    }).toList();

    final fileRows = (r['files'] as List? ?? []);
    final files = fileRows.map((f) {
      final row = f as Map<String, dynamic>;
      final bytes = row['size_bytes'] as int?;
      return MeetingFile(
        row['name'] as String,
        bytes == null ? '—' : '${(bytes / 1024).round()} KB',
        _kindFromDb(row['kind'] as String),
        id: row['id'] as int?,
        url: row['file'] as String?,
      );
    }).toList();

    final timeParts = (r['start_time'] as String).split(':');

    return Meeting(
      id: r['id'] as int,
      title: r['title'] as String,
      date: DateTime.parse(r['meeting_date'] as String),
      time: TimeOfDay(
          hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1])),
      session: _sessionFromDb(r['session'] as String),
      room: roomLabel,
      roomId: r['room'] as int?,
      level: level,
      unit: r['unit'] as String?,
      host: r['host'] as String? ?? '',
      attendees: attendees,
      content: r['content'] as String? ?? '',
      files: files,
      postponed: r['postponed'] as bool? ?? false,
      isDraft: r['is_draft'] as bool? ?? false,
      minutes: r['minutes'] as String? ?? '',
    );
  }

  static String _fmtDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static String _fmtTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00';

  static UserRole _roleFromDb(String s) => switch (s) {
        'lanh_dao' => UserRole.lanhDao,
        'van_thu' => UserRole.vanThu,
        'quan_tri' => UserRole.quanTri,
        'phong_ban' => UserRole.phongBan,
        'thanh_vien' => UserRole.thanhVien,
        _ => throw Exception('Vai trò không hợp lệ: $s'),
      };

  static Session _sessionFromDb(String s) => switch (s) {
        'am' => Session.am,
        'pm' => Session.pm,
        _ => Session.allDay,
      };
  static String _sessionToDb(Session s) => switch (s) {
        Session.am => 'am',
        Session.pm => 'pm',
        Session.allDay => 'all_day',
      };

  static MeetingLevel _levelFromDb(String s) =>
      s == 'phong_ban' ? MeetingLevel.phongBan : MeetingLevel.uyBan;
  static String _levelToDb(MeetingLevel l) =>
      l == MeetingLevel.phongBan ? 'phong_ban' : 'uy_ban';

  static Rsvp _rsvpFromDb(String s) => switch (s) {
        'accepted' => Rsvp.accepted,
        'declined' => Rsvp.declined,
        _ => Rsvp.pending,
      };
  static String _rsvpToDb(Rsvp r) => switch (r) {
        Rsvp.accepted => 'accepted',
        Rsvp.declined => 'declined',
        Rsvp.pending => 'pending',
      };

  static FileKind _kindFromDb(String s) => switch (s) {
        'pdf' => FileKind.pdf,
        'doc' => FileKind.doc,
        'xls' => FileKind.xls,
        'img' => FileKind.img,
        _ => FileKind.other,
      };
  static AvatarColor _colorFromDb(String s) => switch (s) {
        'green' => AvatarColor.green,
        'purple' => AvatarColor.purple,
        'amber' => AvatarColor.amber,
        _ => AvatarColor.blue,
      };
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

/// Cho phép truy cập AppState từ mọi widget con: `AppScope.of(context)`.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope không tồn tại trong cây widget');
    return scope!.notifier!;
  }

  /// Đọc state mà không đăng ký rebuild (dùng trong callback).
  static AppState read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope không tồn tại trong cây widget');
    return scope!.notifier!;
  }
}
