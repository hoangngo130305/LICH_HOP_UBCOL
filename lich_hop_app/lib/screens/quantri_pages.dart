import 'package:flutter/material.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/meeting_card.dart';
import '../widgets/room_card.dart';
import 'dialogs.dart';

/// QUẢN TRỊ – Tổng quan tình trạng phòng họp.
class QtDashboardPage extends StatelessWidget {
  const QtDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final conflicts = state.conflicts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader('Tổng quan',
            'Tình trạng phòng họp – ${VnDate.longLabel(VnDate.today)}'),
        StatRow([
          StatCard('Tổng phòng', '${state.rooms.length}'),
          StatCard('Còn trống', '${state.freeRoomCount}',
              valueColor: AppColors.okGreen),
          StatCard('Đang có lịch', '${state.busyRoomCount}',
              valueColor: AppColors.warn),
          StatCard('Cảnh báo trùng', '${conflicts.length}',
              valueColor: AppColors.danger),
        ]),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionLabel('Tình trạng phòng họp',
                  icon: Icons.meeting_room_outlined,
                  trailing: ChipButton(Icons.arrow_forward,
                      label: 'Xem tất cả',
                      onTap: () => state.goTo('qt-rooms'))),
              RoomGrid(state.rooms.take(3).toList()),
            ],
          ),
        ),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionLabel('Cảnh báo trùng lịch',
                  icon: Icons.warning_amber_rounded,
                  color: AppColors.danger,
                  trailing: ChipButton(Icons.arrow_forward,
                      label: 'Xem đầy đủ',
                      onTap: () => state.goTo('qt-conflict'))),
              if (conflicts.isEmpty)
                const EmptyState(
                    Icons.check_circle_outline, 'Không có lịch trùng')
              else
                for (final (a, b) in conflicts.take(2))
                  _ConflictTile(a: a, b: b),
              const SizedBox(height: 10),
              const Notice(
                'Hệ thống chỉ cảnh báo, không khóa cứng lịch họp.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ConflictTile extends StatelessWidget {
  final Meeting a;
  final Meeting b;

  const _ConflictTile({required this.a, required this.b});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.s1,
        border: Border.all(color: AppColors.bd),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.meeting_room_outlined,
                  size: 15, color: AppColors.ts),
              const SizedBox(width: 6),
              Expanded(
                child: Text(a.room,
                    style: const TextStyle(
                        fontSize: 12.5, fontWeight: FontWeight.w600)),
              ),
              AppBadge.session(a.session),
              const SizedBox(width: 6),
              AppBadge.conflict,
            ],
          ),
          const SizedBox(height: 8),
          _line(context, a),
          const SizedBox(height: 6),
          _line(context, b),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChipButton(Icons.swap_horiz,
                  label: 'Đổi phòng cho "${_short(b.title)}"',
                  onTap: () => showRoomChangeDialog(context, b)),
              ChipButton(Icons.check,
                  label: 'Xác nhận đã điều phối',
                  color: AppColors.greenText,
                  onTap: () async {
                    final state = AppScope.read(context);
                    final ok = await state.acknowledgeConflict(a.id, b.id);
                    if (!context.mounted) return;
                    showToast(
                      context,
                      ok
                          ? 'Đã xác nhận — các bên đã tự điều phối'
                          : 'Có lỗi khi xác nhận, vui lòng thử lại',
                      type: ok ? NoticeType.ok : NoticeType.warn,
                    );
                  }),
            ],
          ),
        ],
      ),
    );
  }

  static String _short(String s) => s.length <= 22 ? s : '${s.substring(0, 22)}…';

  Widget _line(BuildContext context, Meeting m) {
    return InkWell(
      onTap: () => showMeetingDetail(context, m),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
                color: AppColors.danger, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text('${m.timeLabel} · ${m.title}',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12.5)),
          ),
          Text(m.unit ?? '', style: AppTheme.meta),
        ],
      ),
    );
  }
}

/// QUẢN TRỊ – Danh sách phòng họp.
class QtRoomsPage extends StatelessWidget {
  const QtRoomsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(
          'Quản lý phòng họp',
          'Danh sách và tình trạng toàn bộ phòng họp',
          action: PrimaryButton('Thêm phòng',
              icon: Icons.add, onPressed: () => showAddRoomDialog(context)),
        ),
        RoomGrid(state.rooms),
      ],
    );
  }
}

/// QUẢN TRỊ – Tất cả lịch họp.
class QtAllMeetingsPage extends StatefulWidget {
  const QtAllMeetingsPage({super.key});

  @override
  State<QtAllMeetingsPage> createState() => _QtAllMeetingsPageState();
}

class _QtAllMeetingsPageState extends State<QtAllMeetingsPage> {
  String? _roomFilter;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final rooms = <String>{for (final m in state.ubndMeetings) m.room}.toList()
      ..sort();
    final meetings = _roomFilter == null
        ? state.ubndMeetings
        : state.ubndMeetings.where((m) => m.room == _roomFilter).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageHeader('Tất cả lịch họp',
            'Lịch Ủy ban và phòng ban có sử dụng phòng họp'),
        AppCard(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Icon(Icons.filter_alt_outlined,
                  size: 16, color: AppColors.ts),
              const SizedBox(width: 8),
              const Text('Lọc theo phòng:', style: AppTheme.meta),
              const SizedBox(width: 10),
              Expanded(
                child: AppDropdown<String>(
                  value: _roomFilter,
                  items: rooms,
                  hint: 'Tất cả phòng',
                  labelOf: (r) => r,
                  onChanged: (v) => setState(() => _roomFilter = v),
                ),
              ),
              if (_roomFilter != null) ...[
                const SizedBox(width: 8),
                ChipButton(Icons.close,
                    tooltip: 'Bỏ lọc',
                    onTap: () => setState(() => _roomFilter = null)),
              ],
            ],
          ),
        ),
        if (meetings.isEmpty)
          const EmptyState(Icons.event_busy_outlined, 'Không có lịch họp')
        else
          for (final m in meetings)
            MeetingCard(
              m,
              showStatus: true,
              onTap: () => showMeetingDetail(context, m),
              actions: [
                if (m.conflict)
                  ChipButton(Icons.swap_horiz,
                      tooltip: 'Đổi phòng',
                      onTap: () => showRoomChangeDialog(context, m)),
                ChipButton(Icons.visibility_outlined,
                    tooltip: 'Xem chi tiết',
                    onTap: () => showMeetingDetail(context, m)),
                if (!m.postponed)
                  ChipButton(Icons.pause_circle_outline,
                      tooltip: 'Hoãn lịch họp',
                      color: AppColors.warn,
                      onTap: () => confirmPostponeMeeting(context, m)),
              ],
            ),
      ],
    );
  }
}

/// QUẢN TRỊ (SuperAdmin) – Quản lý tài khoản: xem toàn bộ tài khoản trong
/// hệ thống và tạo tài khoản Văn thư mới cho từng đơn vị (theo biên bản
/// họp 22/08/2026 — nhúng vào mục "Thành viên" có sẵn, không làm trang
/// quản trị riêng biệt).
class QtMembersPage extends StatefulWidget {
  const QtMembersPage({super.key});

  @override
  State<QtMembersPage> createState() => _QtMembersPageState();
}

class _QtMembersPageState extends State<QtMembersPage> {
  static const _pageSize = 10;
  bool _loading = true;
  int _tab = 0;
  int _accountPage = 0;
  int _memberPage = 0;

  @override
  void initState() {
    super.initState();
    AppScope.read(context).loadAccounts().then((_) {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    // "Khác" là đơn vị dùng cho khách mời nhập tay (không phải cán bộ cơ hữu),
    // không phải lựa chọn hợp lệ khi tạo tài khoản đăng nhập thật.
    final units = state.members
        .map((m) => m.unit)
        .where((u) => u != 'Khác')
        .toSet()
        .toList()
      ..sort();
    final accounts = state.accounts;
    final members = List.of(state.members)
      ..sort((a, b) => a.unit == b.unit
          ? a.name.compareTo(b.name)
          : a.unit.compareTo(b.unit));

    final accountPageCount =
        (accounts.length / _pageSize).ceil().clamp(1, 1 << 30);
    final accountPage = _accountPage.clamp(0, accountPageCount - 1);
    final shownAccounts =
        accounts.skip(accountPage * _pageSize).take(_pageSize).toList();

    final memberPageCount =
        (members.length / _pageSize).ceil().clamp(1, 1 << 30);
    final memberPage = _memberPage.clamp(0, memberPageCount - 1);
    final shownMembers =
        members.skip(memberPage * _pageSize).take(_pageSize).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(
          'Thành viên',
          'Tài khoản đăng nhập và danh bạ toàn bộ cán bộ, công chức',
          action: PrimaryButton('Thêm tài khoản',
              icon: Icons.person_add_alt,
              onPressed: () => showCreateAccountDialog(
                context,
                unitOptions: units,
                // SuperAdmin duoc tao tai khoan bat ky vai tro nao (backend
                // UserManagementPermission khong gioi han quan_tri) -- truoc
                // day dialog mac dinh chi cho chon 2/5 vai tro.
                roleOptions: [
                  for (final role in UserRole.values)
                    {'value': role.dbValue, 'label': role.label},
                ],
              ).then((_) => state.loadAccounts())),
        ),
        AppTabs(
          [
            'Tài khoản đăng nhập (${accounts.length})',
            'Danh bạ nhân sự (${members.length})',
          ],
          selected: _tab,
          onChanged: (i) => setState(() => _tab = i),
        ),
        if (_loading)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_tab == 0)
          if (accounts.isEmpty)
            const EmptyState(Icons.group_outlined, 'Chưa có tài khoản nào')
          else
            AppCard(
              child: Column(
                children: [
                  for (var i = 0; i < shownAccounts.length; i++)
                    _AccountRow(shownAccounts[i],
                        divider: i != shownAccounts.length - 1,
                        canDelete: shownAccounts[i]['id'] != state.currentUserId,
                        onDelete: () => confirmDeleteAccount(
                            context, shownAccounts[i])),
                  Paginator(
                    page: accountPage,
                    pageCount: accountPageCount,
                    totalItems: accounts.length,
                    pageSize: _pageSize,
                    onChanged: (p) => setState(() => _accountPage = p),
                  ),
                ],
              ),
            )
        else if (members.isEmpty)
          const EmptyState(Icons.badge_outlined, 'Chưa có cán bộ nào')
        else
          AppCard(
            child: Column(
              children: [
                for (var i = 0; i < shownMembers.length; i++)
                  MemberRow(shownMembers[i],
                      divider: i != shownMembers.length - 1,
                      onEdit: () =>
                          showEditMemberDialog(context, shownMembers[i])
                              .then((_) => setState(() {}))),
                Paginator(
                  page: memberPage,
                  pageCount: memberPageCount,
                  totalItems: members.length,
                  pageSize: _pageSize,
                  onChanged: (p) => setState(() => _memberPage = p),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _AccountRow extends StatelessWidget {
  final Map<String, dynamic> account;
  final bool divider;
  final bool canDelete;
  final VoidCallback? onDelete;

  const _AccountRow(this.account,
      {this.divider = true, this.canDelete = false, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final member = account['member'] as Map<String, dynamic>?;
    final title = (member?['title'] as String?)?.trim();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: divider
          ? const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.bd)))
          : null,
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: AppColors.accentBg, shape: BoxShape.circle),
            child: Text(
                _firstLetter(account['display_name'] as String? ?? '?'),
                style: const TextStyle(
                    fontWeight: FontWeight.w700, color: AppColors.accent)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(account['display_name'] as String? ?? '',
                    style: const TextStyle(
                        fontSize: 12.5, fontWeight: FontWeight.w500)),
                Text(title == null || title.isEmpty ? '—' : title,
                    style: AppTheme.meta),
              ],
            ),
          ),
          AppBadge(_roleLabel(account['role'] as String? ?? ''),
              bg: AppColors.s0, fg: AppColors.ts),
          IconButton(
            icon: const Icon(Icons.login, size: 18, color: AppColors.tm),
            tooltip: 'Xem thông tin đăng nhập',
            onPressed: () => _showLoginInfo(context),
          ),
          IconButton(
            icon: const Icon(Icons.lock_reset, size: 18, color: AppColors.tm),
            tooltip: 'Cấp lại mật khẩu',
            onPressed: () => confirmResetPassword(context, account),
          ),
          if (canDelete && onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  size: 18, color: AppColors.danger),
              tooltip: 'Xóa tài khoản',
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }

  void _showLoginInfo(BuildContext context) {
    showAppDialog<void>(
      context,
      title: 'Thông tin đăng nhập',
      width: 400,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CredentialLine('Họ tên', account['display_name'] as String? ?? '—'),
          CredentialLine(
              'Tên đăng nhập', account['username'] as String? ?? '—'),
          CredentialLine('Email', account['email'] as String? ?? '—'),
          const CredentialLine('Mật khẩu',
              '(không hiển thị lại được — bấm nút "Cấp lại mật khẩu" nếu quên)'),
        ],
      ),
      actions: [
        GhostButton('Đóng', onPressed: () => Navigator.of(context).pop()),
      ],
    );
  }

  static String _firstLetter(String s) =>
      s.trim().isEmpty ? '?' : s.trim().substring(0, 1).toUpperCase();

  static String _roleLabel(String role) => switch (role) {
        'quan_tri' => 'Admin',
        'van_thu' => 'Văn thư Ủy ban',
        'phong_ban' => 'Văn thư đơn vị',
        'lanh_dao' => 'Lãnh đạo',
        _ => 'Cán bộ',
      };
}

/// QUẢN TRỊ – Cảnh báo trùng lịch.
class QtConflictPage extends StatelessWidget {
  const QtConflictPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final conflicts = state.conflicts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageHeader(
            'Cảnh báo trùng lịch', 'Cùng phòng, cùng buổi — cần điều phối'),
        if (conflicts.isEmpty)
          const Notice('Hiện không phát hiện lịch trùng nào.',
              type: NoticeType.ok)
        else
          Notice(
            'Phát hiện ${conflicts.length} cặp lịch trùng buổi. '
            'Hệ thống không khóa lịch — các bên tự liên hệ điều phối.',
            type: NoticeType.warn,
          ),
        for (final (a, b) in conflicts) _ConflictTile(a: a, b: b),
      ],
    );
  }
}
