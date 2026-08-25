import 'package:flutter/material.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/meeting_card.dart';

/// Chi tiết cuộc họp.
/// [withRsvp] = true → hiển thị thêm tình trạng phản hồi của từng thành viên.
Future<void> showMeetingDetail(
  BuildContext context,
  Meeting m, {
  bool withRsvp = false,
}) {
  final state = AppScope.read(context);
  final role = state.role;
  final members =
      m.memberIds.map(state.member).whereType<Member>().toList();
  final accepted =
      m.attendees.where((a) => a.status == Rsvp.accepted).length;
  final pendingCount = members.length - accepted;

  return showAppDialog(
    context,
    title: withRsvp ? 'Chi tiết & Danh sách tham dự' : 'Chi tiết cuộc họp',
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            AppBadge.session(m.session),
            if (m.unit != null) AppBadge.unit(m.unit!),
            if (m.conflict) AppBadge.conflict,
            AppBadge.status(m.status),
          ],
        ),
        const SizedBox(height: 14),
        Text(m.title,
            style: const TextStyle(
                fontSize: 15.5, fontWeight: FontWeight.w600, height: 1.4)),
        const SizedBox(height: 16),
        InfoRow(Icons.schedule, 'Thời gian',
            '${m.timeLabel} · ${m.session.label} · ${VnDate.longLabel(m.date)}'),
        InfoRow(Icons.place_outlined, 'Địa điểm', m.room),
        InfoRow(Icons.person_outline, 'Chủ trì', m.host),
        InfoRow(Icons.notes_outlined, 'Nội dung', m.content),
        const Divider(height: 24),
        SectionLabel('Thành phần tham dự (${members.length})',
            icon: Icons.groups_outlined),
        if (withRsvp) ...[
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              AppBadge('Tham dự: $accepted',
                  bg: AppColors.greenBg,
                  fg: AppColors.greenText,
                  icon: Icons.check),
              AppBadge('Chưa phản hồi: $pendingCount',
                  bg: AppColors.warnBg,
                  fg: AppColors.warnText,
                  icon: Icons.schedule),
            ],
          ),
          const SizedBox(height: 8),
        ],
        // Rút gọn danh sách tham dự (tránh tràn màn hình điện thoại) —
        // hiện 3 người đầu, bấm "Chi tiết" để xem đầy đủ.
        _CollapsibleAttendees(members: members, meeting: m, withRsvp: withRsvp),
        const Divider(height: 24),
        SectionLabel('Tài liệu đính kèm (${m.files.length})',
            icon: Icons.attach_file),
        AttachmentList(m.files),
        if (m.conflict) ...[
          const SizedBox(height: 12),
          const Notice(
            'Lịch họp này trùng buổi với cuộc họp khác tại cùng phòng.',
            type: NoticeType.warn,
          ),
        ],
        if (m.postponed) ...[
          const SizedBox(height: 12),
          const Notice(
            'Lịch họp này đã được hoãn. Phòng họp đã được giải phóng.',
            type: NoticeType.warn,
            icon: Icons.pause_circle_outline,
          ),
        ],
        if (role == UserRole.lanhDao) ...[
          const Divider(height: 24),
          Notice(
            'Cần điều chỉnh lịch họp này? Vui lòng liên hệ Văn thư – '
            '${state.vanThuContact?.name ?? ''} để cập nhật. Lãnh đạo chỉ '
            'theo dõi, không chỉnh sửa trực tiếp.',
            icon: Icons.phone_outlined,
          ),
        ],
      ],
    ),
    actions: [
      GhostButton('Đóng', onPressed: () => Navigator.of(context).pop()),
      if (role == UserRole.lanhDao)
        PrimaryButton('Gọi văn thư để thay đổi',
            icon: Icons.phone_outlined,
            onPressed: () {
              Navigator.of(context).pop();
              showVanThuContact(context);
            }),
      if (role == UserRole.vanThu ||
          role == UserRole.phongBan ||
          role == UserRole.quanTri)
        GhostButton('Biên bản',
            icon: Icons.description_outlined,
            onPressed: () {
              Navigator.of(context).pop();
              showMeetingMinutesDialog(context, m, editable: true);
            }),
      if (!m.postponed && _canPostpone(state, m))
        PrimaryButton('Hoãn lịch họp',
            icon: Icons.pause_circle_outline,
            color: AppColors.warn,
            onPressed: () async {
              Navigator.of(context).pop();
              await confirmPostponeMeeting(context, m);
            }),
    ],
  );
}

/// Popup hiển thị danh sách cuộc họp của 1 ngày khi bấm vào ô ngày trên
/// lịch tháng — thay cho cách cũ là hiện danh sách ngay bên dưới lưới lịch.
/// Áp dụng cho mọi ô ngày có dữ liệu: có lịch họp bình thường, có cảnh báo
/// trùng, hoặc là hôm nay. Không làm gì nếu ngày đó không có cuộc họp nào.
Future<void> showDayMeetingsDialog(
  BuildContext context,
  DateTime day,
  List<Meeting> meetings, {
  bool withRsvp = false,
  Widget Function(BuildContext, Meeting)? itemBuilder,
}) {
  if (meetings.isEmpty) return Future.value();
  return showAppDialog<void>(
    context,
    title: VnDate.longLabel(day),
    width: 480,
    body: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final m in meetings)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: itemBuilder != null
                ? itemBuilder(context, m)
                : MeetingCard(
                    m,
                    showStatus: true,
                    onTap: () {
                      Navigator.of(context).pop();
                      showMeetingDetail(context, m, withRsvp: withRsvp);
                    },
                  ),
          ),
      ],
    ),
    actions: [
      GhostButton('Đóng', onPressed: () => Navigator.of(context).pop()),
    ],
  );
}

/// Xem / soạn biên bản cuộc họp. [editable] = true (Văn thư, Phòng ban,
/// Admin) cho phép gõ và lưu nội dung thật xuống server; ngược lại (Lãnh
/// đạo, Thành viên) chỉ xem nội dung đã có.
Future<void> showMeetingMinutesDialog(
  BuildContext context,
  Meeting m, {
  bool editable = false,
}) async {
  if (!editable) {
    await showAppDialog<void>(
      context,
      title: 'Biên bản cuộc họp',
      body: Text(
        m.minutes.trim().isEmpty
            ? 'Cuộc họp này chưa có biên bản.'
            : m.minutes,
        style: const TextStyle(fontSize: 13, height: 1.5),
      ),
      actions: [
        GhostButton('Đóng', onPressed: () => Navigator.of(context).pop()),
      ],
    );
    return;
  }

  final state = AppScope.read(context);
  final ctrl = TextEditingController(text: m.minutes);
  final saved = await showAppDialog<bool>(
    context,
    title: 'Biên bản cuộc họp',
    width: 480,
    body: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('"${m.title}"',
            style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        TextField(
          controller: ctrl,
          maxLines: 10,
          decoration: const InputDecoration(
            hintText: 'Nhập nội dung biên bản: diễn biến, kết luận, phân công...',
          ),
        ),
      ],
    ),
    actions: [
      GhostButton('Đóng', onPressed: () => Navigator.of(context).pop(false)),
      PrimaryButton('Lưu biên bản',
          icon: Icons.save_outlined,
          onPressed: () => Navigator.of(context).pop(true)),
    ],
  );
  if (saved == true && context.mounted) {
    final ok = await state.saveMeetingMinutes(m.id, ctrl.text.trim());
    if (!context.mounted) return;
    showToast(context, ok ? 'Đã lưu biên bản' : 'Lưu biên bản thất bại',
        type: ok ? NoticeType.ok : NoticeType.warn);
  }
}

/// Chỉ Văn thư (lịch Ủy ban), Văn thư Văn phòng/phòng ban (lịch đơn vị mình)
/// và SuperAdmin mới được hoãn lịch họp.
bool _canPostpone(AppState state, Meeting m) {
  final role = state.role;
  if (role == UserRole.quanTri) return true;
  if (m.level == MeetingLevel.uyBan) return role == UserRole.vanThu;
  return role == UserRole.phongBan && m.unit == state.unit;
}

/// Xác nhận hoãn lịch họp (không dùng "Hủy" — theo yêu cầu biên bản họp
/// 22/08/2026: hoãn phản ánh đúng thực tế khi lịch bị dời, phòng họp tự
/// động được giải phóng).
Future<void> confirmPostponeMeeting(BuildContext context, Meeting m) async {
  final state = AppScope.read(context);
  final ok = await showAppDialog<bool>(
    context,
    title: 'Hoãn lịch họp',
    width: 420,
    body: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Notice(
          'Hoãn lịch họp "${m.title}"? Phòng họp sẽ tự động được giải phóng '
          'cho cuộc họp khác sử dụng. Có thể tạo lại lịch mới khi có thời gian phù hợp.',
          type: NoticeType.warn,
        ),
      ],
    ),
    actions: [
      GhostButton('Đóng', onPressed: () => Navigator.of(context).pop(false)),
      PrimaryButton('Xác nhận hoãn',
          icon: Icons.pause_circle_outline,
          color: AppColors.warn,
          onPressed: () => Navigator.of(context).pop(true)),
    ],
  );
  if (ok == true && context.mounted) {
    final success = await state.postponeMeeting(m.id);
    if (!context.mounted) return;
    showToast(
      context,
      success ? 'Đã hoãn lịch họp, phòng đã được giải phóng' : 'Hoãn lịch họp thất bại, vui lòng thử lại',
      type: success ? NoticeType.ok : NoticeType.warn,
    );
  }
}

/// Danh sách thành phần tham dự dạng rút gọn — hiện 3 người đầu, bấm
/// "Chi tiết" để mở rộng xem đầy đủ (tránh tràn màn hình điện thoại).
class _CollapsibleAttendees extends StatefulWidget {
  final List<Member> members;
  final Meeting meeting;
  final bool withRsvp;

  const _CollapsibleAttendees(
      {required this.members, required this.meeting, required this.withRsvp});

  @override
  State<_CollapsibleAttendees> createState() => _CollapsibleAttendeesState();
}

class _CollapsibleAttendeesState extends State<_CollapsibleAttendees> {
  bool _expanded = false;
  static const _collapsedCount = 3;

  @override
  Widget build(BuildContext context) {
    final members = widget.members;
    final shown = _expanded || members.length <= _collapsedCount
        ? members
        : members.take(_collapsedCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final member in shown)
          MemberRow(
            member,
            rsvp: widget.withRsvp ? widget.meeting.rsvpFor(member.id) : null,
          ),
        if (members.length > _collapsedCount)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: GhostButton(
              _expanded
                  ? 'Thu gọn'
                  : 'Chi tiết (${members.length - _collapsedCount} người khác)',
              icon: _expanded
                  ? Icons.expand_less
                  : Icons.expand_more,
              onPressed: () => setState(() => _expanded = !_expanded),
            ),
          ),
      ],
    );
  }
}

/// Danh sách thông báo (chuông ở góc trên bên phải) — lịch họp mới gửi đến
/// toàn bộ tài khoản, không lọc theo đơn vị (biên bản họp 22/08/2026, mục 12).
Future<void> showNotificationsDialog(BuildContext context) async {
  final state = AppScope.read(context);
  await showAppDialog(
    context,
    title: 'Thông báo',
    width: 460,
    body: StatefulBuilder(builder: (context, setLocal) {
      final items = state.notifications;
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('Chưa có thông báo nào',
                    style: TextStyle(fontSize: 12.5, color: AppColors.tm)),
              ),
            )
          else ...[
            Align(
              alignment: Alignment.centerRight,
              child: GhostButton('Đánh dấu đã đọc tất cả',
                  icon: Icons.done_all,
                  onPressed: state.unreadNotificationCount == 0
                      ? null
                      : () async {
                          await state.markAllNotificationsRead();
                          setLocal(() {});
                        }),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 420),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (final n in items)
                      _NotificationTile(
                        n,
                        onTap: () async {
                          if (n['is_read'] != true) {
                            await state.markNotificationRead(n['id'] as int);
                            setLocal(() {});
                          }
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ],
      );
    }),
    actions: [
      GhostButton('Đóng', onPressed: () => Navigator.of(context).pop()),
    ],
  );
}

class _NotificationTile extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap;

  const _NotificationTile(this.data, {required this.onTap});

  static String _timeAgo(String iso) {
    final dt = DateTime.tryParse(iso)?.toLocal();
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return '${diff.inDays} ngày trước';
  }

  @override
  Widget build(BuildContext context) {
    final isRead = data['is_read'] == true;
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isRead ? AppColors.s1 : AppColors.accentBg,
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4, right: 8),
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isRead ? Colors.transparent : AppColors.accent,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['title'] as String? ?? '',
                      style: const TextStyle(
                          fontSize: 12.5, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(data['message'] as String? ?? '',
                      style: const TextStyle(fontSize: 11.5, color: AppColors.ts)),
                  const SizedBox(height: 3),
                  Text(_timeAgo(data['created_at'] as String? ?? ''),
                      style: AppTheme.meta),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Thông tin liên hệ văn thư (dành cho Ban lãnh đạo).
Future<void> showVanThuContact(BuildContext context) {
  final vanThu = AppScope.read(context).vanThuContact;
  final name = vanThu?.name ?? 'Văn thư Ủy ban';
  final phone = vanThu?.phone ?? '—';
  final email = vanThu?.email ?? '—';

  return showAppDialog(
    context,
    title: 'Liên hệ Văn thư',
    body: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: AppColors.greenBg, shape: BoxShape.circle),
          child: Text(vanThu?.initials ?? 'VT',
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.green)),
        ),
        const SizedBox(height: 12),
        Text(name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text('Văn thư Ủy ban · ${vanThu?.unit ?? 'VP UBND'}',
            style: AppTheme.sub),
        const SizedBox(height: 16),
        _contactRow(Icons.phone_outlined, 'Điện thoại', phone,
            highlight: true),
        _contactRow(Icons.mail_outline, 'Email', email),
        const SizedBox(height: 12),
        const Notice(
          'Lãnh đạo báo nội dung cần thay đổi qua điện thoại, '
          'văn thư sẽ cập nhật lịch trên hệ thống.',
        ),
      ],
    ),
    actions: [
      GhostButton('Đóng', onPressed: () => Navigator.of(context).pop()),
      PrimaryButton('Gọi ngay',
          icon: Icons.call,
          color: AppColors.okGreen,
          onPressed: () {
            Navigator.of(context).pop();
            showToast(context, 'Đang gọi Văn thư – $name...');
          }),
    ],
  );
}

Widget _contactRow(IconData icon, String label, String value,
    {bool highlight = false}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 6),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: highlight ? AppColors.accentBg : AppColors.s1,
      border: Border.all(
          color: highlight ? const Color(0xFFB5D4F4) : AppColors.bd),
      borderRadius: BorderRadius.circular(AppTheme.radius),
    ),
    child: Row(
      children: [
        Icon(icon, size: 19, color: highlight ? AppColors.accent : AppColors.ts),
        const SizedBox(width: 10),
        Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontSize: 12.5, fontWeight: FontWeight.w500))),
        Text(value,
            style: TextStyle(
                fontSize: 12.5,
                fontWeight: highlight ? FontWeight.w600 : FontWeight.w400,
                color: highlight ? AppColors.accent : AppColors.ts)),
      ],
    ),
  );
}

/// Xác nhận xóa lịch họp.
Future<void> confirmDeleteMeeting(BuildContext context, Meeting m) async {
  final state = AppScope.read(context);
  final ok = await showAppDialog<bool>(
    context,
    title: 'Xóa lịch họp',
    width: 420,
    body: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Notice(
          'Bạn có chắc muốn xóa lịch họp "${m.title}"? '
          'Hành động không thể hoàn tác.',
          type: NoticeType.warn,
        ),
      ],
    ),
    actions: [
      GhostButton('Hủy', onPressed: () => Navigator.of(context).pop(false)),
      PrimaryButton('Xóa',
          icon: Icons.delete_outline,
          color: AppColors.danger,
          onPressed: () => Navigator.of(context).pop(true)),
    ],
  );
  if (ok == true && context.mounted) {
    final success = await state.deleteMeeting(m.id);
    if (!context.mounted) return;
    showToast(
      context,
      success ? 'Đã xóa lịch họp' : 'Xóa lịch họp thất bại, vui lòng thử lại',
      type: success ? NoticeType.warn : NoticeType.warn,
    );
  }
}

/// Đổi phòng họp cho một cuộc họp đang trùng lịch.
Future<void> showRoomChangeDialog(BuildContext context, Meeting m) async {
  final state = AppScope.read(context);

  bool isFreeFor(Room r) => !state.ubndMeetings.any((other) =>
      other.id != m.id &&
      other.roomId == r.id &&
      VnDate.sameDay(other.date, m.date) &&
      (other.session == m.session ||
          other.session == Session.allDay ||
          m.session == Session.allDay));

  final options = state.rooms.where(isFreeFor).toList();
  Room? picked = options.isEmpty ? null : options.first;

  final result = await showAppDialog<Room>(
    context,
    title: 'Đổi phòng họp',
    width: 460,
    body: StatefulBuilder(builder: (context, setLocal) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chọn phòng thay thế cho "${m.title}" – '
            '${m.timeLabel} ${m.session.label.toLowerCase()}',
            style: AppTheme.sub,
          ),
          const SizedBox(height: 14),
          FormField2(
            'Phòng họp thay thế',
            AppDropdown<Room>(
              value: picked,
              items: options,
              labelOf: (r) => '${r.name} – ${r.location} (${r.capacity} người · Còn trống)',
              hint: 'Không còn phòng trống',
              onChanged: (v) => setLocal(() => picked = v),
            ),
          ),
          const SizedBox(height: 12),
          const Notice(
            'Phòng được chọn còn trống trong buổi này. Có thể xếp lịch.',
            type: NoticeType.ok,
          ),
        ],
      );
    }),
    actions: [
      GhostButton('Hủy', onPressed: () => Navigator.of(context).pop()),
      PrimaryButton('Xác nhận đổi phòng',
          icon: Icons.swap_horiz,
          onPressed: () => Navigator.of(context).pop(picked)),
    ],
  );

  if (result != null && context.mounted) {
    final success = await state.changeMeetingRoom(m.id, result);
    if (!context.mounted) return;
    showToast(
      context,
      success
          ? 'Đã đổi phòng thành công. Đã thông báo đến văn thư liên quan.'
          : 'Đổi phòng thất bại, vui lòng thử lại.',
      type: success ? NoticeType.ok : NoticeType.warn,
    );
  }
}

/// Tạo tài khoản mới (phân cấp theo biên bản họp 22/08/2026):
/// - SuperAdmin (quan_tri) tạo tài khoản Văn thư cho bất kỳ đơn vị nào
///   ([fixedUnit] = null, cho chọn đơn vị + vai trò 'phong_ban').
/// - Văn thư Văn phòng/phòng ban chỉ tạo được cán bộ trong đúng đơn vị
///   mình ([fixedUnit] cố định, vai trò luôn là 'thanh_vien').
/// Được nhúng vào ngay trang "Thành viên" đã có sẵn — không làm trang riêng.
Future<void> showCreateAccountDialog(
  BuildContext context, {
  String? fixedUnit,
  List<String> unitOptions = const [],
}) async {
  final state = AppScope.read(context);
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final isSuperAdmin = fixedUnit == null;
  String role = isSuperAdmin ? 'phong_ban' : 'thanh_vien';
  String? unit = fixedUnit ?? (unitOptions.isEmpty ? null : unitOptions.first);

  final ok = await showAppDialog<bool>(
    context,
    title: 'Thêm tài khoản mới',
    width: 460,
    body: StatefulBuilder(builder: (context, setLocal) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormField2(
            'Họ tên',
            TextField(
                controller: nameCtrl,
                decoration:
                    const InputDecoration(hintText: 'Họ tên cán bộ')),
            required: true,
          ),
          FormField2(
            'Email đăng nhập',
            TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(
                    hintText: 'ten.can.bo@caungolanh.gov.vn')),
            required: true,
          ),
          FormField2(
            'Mật khẩu ban đầu',
            TextField(
                controller: passCtrl,
                decoration: const InputDecoration(
                    hintText: 'Tối thiểu 6 ký tự')),
            required: true,
          ),
          if (isSuperAdmin) ...[
            FormField2(
              'Đơn vị',
              AppDropdown<String>(
                value: unit,
                items: unitOptions,
                labelOf: (v) => v,
                onChanged: (v) => setLocal(() => unit = v),
              ),
              required: true,
            ),
            const Notice(
              'Tài khoản mới sẽ là Văn thư của đơn vị này — tự tạo được '
              'tài khoản cán bộ trong đơn vị mình.',
            ),
          ] else
            Notice('Tài khoản mới sẽ thuộc đơn vị "$fixedUnit", vai trò cán bộ (chỉ xem).',
                icon: Icons.info_outline),
        ],
      );
    }),
    actions: [
      GhostButton('Hủy', onPressed: () => Navigator.of(context).pop(false)),
      PrimaryButton('Tạo tài khoản',
          icon: Icons.person_add_alt,
          onPressed: () => Navigator.of(context).pop(true)),
    ],
  );

  if (ok == true && context.mounted) {
    final name = nameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();
    if (name.isEmpty || email.isEmpty || pass.length < 6) {
      showToast(context, 'Vui lòng nhập đủ họ tên, email và mật khẩu (≥ 6 ký tự)',
          type: NoticeType.warn);
    } else {
      final error = await state.createAccount(
        email: email,
        password: pass,
        role: role,
        displayName: name,
        unit: unit ?? '',
      );
      if (context.mounted) {
        showToast(
          context,
          error == null ? 'Đã tạo tài khoản cho $name' : 'Tạo tài khoản thất bại: $error',
          type: error == null ? NoticeType.ok : NoticeType.warn,
        );
      }
    }
  }

  nameCtrl.dispose();
  emailCtrl.dispose();
  passCtrl.dispose();
}

/// Thêm phòng họp mới (Quản trị phòng).
Future<void> showAddRoomDialog(BuildContext context) async {
  final state = AppScope.read(context);
  final nameCtrl = TextEditingController();
  final locCtrl = TextEditingController();
  final capCtrl = TextEditingController(text: '20');
  final equipCtrl = TextEditingController();

  final ok = await showAppDialog<bool>(
    context,
    title: 'Thêm phòng họp mới',
    width: 480,
    body: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormField2(
          'Tên phòng',
          TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(hintText: 'VD: Phòng họp B'),
          ),
          required: true,
        ),
        FormField2(
          'Vị trí',
          TextField(
            controller: locCtrl,
            decoration: const InputDecoration(hintText: 'VD: Tầng 2'),
          ),
        ),
        FormField2(
          'Sức chứa (người)',
          TextField(controller: capCtrl, keyboardType: TextInputType.number),
        ),
        FormField2(
          'Trang thiết bị',
          TextField(
            controller: equipCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
                hintText: 'Máy chiếu, bảng trắng, điều hòa...'),
          ),
        ),
      ],
    ),
    actions: [
      GhostButton('Hủy', onPressed: () => Navigator.of(context).pop(false)),
      PrimaryButton('Thêm phòng',
          icon: Icons.add, onPressed: () => Navigator.of(context).pop(true)),
    ],
  );

  if (ok == true && context.mounted) {
    final name = nameCtrl.text.trim();
    if (name.isEmpty) {
      showToast(context, 'Vui lòng nhập tên phòng', type: NoticeType.warn);
    } else {
      final success = await state.addRoom(Room(
        id: 0,
        name: name,
        location: locCtrl.text.trim().isEmpty ? '—' : locCtrl.text.trim(),
        capacity: int.tryParse(capCtrl.text.trim()) ?? 0,
        status: RoomStatus.free,
        equipment: equipCtrl.text.trim().isEmpty ? null : equipCtrl.text.trim(),
      ));
      if (context.mounted) {
        showToast(
          context,
          success ? 'Đã thêm phòng họp mới' : 'Thêm phòng họp thất bại',
          type: success ? NoticeType.ok : NoticeType.warn,
        );
      }
    }
  }

  nameCtrl.dispose();
  locCtrl.dispose();
  capCtrl.dispose();
  equipCtrl.dispose();
}

/// Sửa thông tin nhân sự đã có (chức danh, đơn vị, sđt, email) — theo ghi
/// chú trong file Excel: cần chỗ để bổ sung hoặc cập nhật khi có thay đổi
/// về nhân sự (chuyển công tác, đổi chức danh...), không chỉ tạo mới.
Future<void> showEditMemberDialog(BuildContext context, Member member) async {
  final state = AppScope.read(context);
  final titleCtrl = TextEditingController(text: member.title);
  final unitCtrl = TextEditingController(text: member.unit);
  final phoneCtrl = TextEditingController(text: member.phone ?? '');
  final emailCtrl = TextEditingController(text: member.email ?? '');

  final ok = await showAppDialog<bool>(
    context,
    title: 'Sửa thông tin: ${member.name}',
    width: 480,
    body: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormField2('Chức danh', TextField(controller: titleCtrl)),
        FormField2('Đơn vị', TextField(controller: unitCtrl)),
        FormField2('Số điện thoại',
            TextField(controller: phoneCtrl, keyboardType: TextInputType.phone)),
        FormField2('Email',
            TextField(controller: emailCtrl, keyboardType: TextInputType.emailAddress)),
      ],
    ),
    actions: [
      GhostButton('Hủy', onPressed: () => Navigator.of(context).pop(false)),
      PrimaryButton('Lưu thay đổi',
          icon: Icons.save_outlined,
          onPressed: () => Navigator.of(context).pop(true)),
    ],
  );

  if (ok == true && context.mounted) {
    final success = await state.updateMember(
      member.id,
      title: titleCtrl.text.trim(),
      unit: unitCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      email: emailCtrl.text.trim(),
    );
    if (context.mounted) {
      showToast(
        context,
        success ? 'Đã cập nhật thông tin' : 'Cập nhật thất bại, vui lòng thử lại',
        type: success ? NoticeType.ok : NoticeType.warn,
      );
    }
  }

  titleCtrl.dispose();
  unitCtrl.dispose();
  phoneCtrl.dispose();
  emailCtrl.dispose();
}
