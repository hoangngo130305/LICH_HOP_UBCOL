import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/meeting_card.dart';
import 'dialogs.dart';

/// PHÒNG BAN – Lịch họp nội bộ của phòng.
class PbListPage extends StatefulWidget {
  const PbListPage({super.key});

  @override
  State<PbListPage> createState() => _PbListPageState();
}

class _PbListPageState extends State<PbListPage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final upcoming = state.upcomingDept;
    final done = state.doneDept;
    final postponed = state.postponedDept;
    final shown = switch (_tab) {
      0 => upcoming,
      1 => done,
      2 => postponed,
      _ => state.deptMeetings,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(
          'Lịch họp – ${state.unitLabel}',
          'Tự tổ chức tại phòng làm việc, không cần đặt phòng họp',
          action: PrimaryButton('Tạo lịch họp',
              icon: Icons.add,
              color: AppColors.green,
              onPressed: () => state.goTo('pb-create')),
        ),
        StatRow([
          StatCard('Tổng lịch họp', '${state.deptMeetings.length}'),
          StatCard('Sắp diễn ra', '${upcoming.length}',
              valueColor: AppColors.okGreen),
          StatCard('Đã qua', '${done.length}', valueColor: AppColors.warn),
        ]),
        AppTabs(
          [
            'Sắp diễn ra (${upcoming.length})',
            'Đã qua (${done.length})',
            'Hoãn (${postponed.length})',
            'Tất cả (${state.deptMeetings.length})',
          ],
          selected: _tab,
          onChanged: (i) => setState(() => _tab = i),
        ),
        if (shown.isEmpty)
          const EmptyState(Icons.event_busy_outlined, 'Chưa có lịch họp nào')
        else
          for (final m in shown)
            MeetingCard(
              m,
              accent: AppColors.okGreen,
              showStatus: true,
              onTap: () => showMeetingDetail(context, m),
              actions: [
                ChipButton(Icons.visibility_outlined,
                    tooltip: 'Xem chi tiết',
                    onTap: () => showMeetingDetail(context, m)),
                ChipButton(Icons.edit_outlined,
                    tooltip: 'Chỉnh sửa',
                    onTap: () {
                      state.startEdit(m);
                      state.goTo('pb-create');
                    }),
                if (!m.postponed)
                  ChipButton(Icons.pause_circle_outline,
                      tooltip: 'Hoãn lịch họp',
                      color: AppColors.warn,
                      onTap: () => confirmPostponeMeeting(context, m)),
                ChipButton(Icons.delete_outline,
                    tooltip: 'Xóa',
                    color: AppColors.danger,
                    onTap: () => confirmDeleteMeeting(context, m)),
              ],
            ),
      ],
    );
  }
}

/// PHÒNG BAN – Danh sách cán bộ của phòng + tạo tài khoản mới cho cán bộ
/// trong đơn vị mình (theo biên bản họp 22/08/2026: Văn thư Văn phòng/phòng
/// ban tự tạo tài khoản cho cán bộ, không cần nhờ kỹ thuật).
class PbMembersPage extends StatefulWidget {
  const PbMembersPage({super.key});

  @override
  State<PbMembersPage> createState() => _PbMembersPageState();
}

class _PbMembersPageState extends State<PbMembersPage> {
  static const _pageSize = 10;
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final members = state.myUnitMembers;
    final pageCount = (members.length / _pageSize).ceil().clamp(1, 1 << 30);
    final page = _page.clamp(0, pageCount - 1);
    final shown = members.skip(page * _pageSize).take(_pageSize).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader('Thành viên ${state.unitLabel}',
            '${members.length} cán bộ công chức',
            action: PrimaryButton('Thêm tài khoản',
                icon: Icons.person_add_alt,
                color: AppColors.green,
                onPressed: () => showCreateAccountDialog(context,
                    fixedUnit: state.unit ?? state.unitLabel))),
        AppCard(
          child: Column(
            children: [
              for (var i = 0; i < shown.length; i++)
                MemberRow(shown[i],
                    divider: i != shown.length - 1,
                    onEdit: () => showEditMemberDialog(context, shown[i])),
              Paginator(
                page: page,
                pageCount: pageCount,
                totalItems: members.length,
                pageSize: _pageSize,
                onChanged: (p) => setState(() => _page = p),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// PHÒNG BAN – Xem lịch Ủy ban (chỉ đọc).
class PbUbndPage extends StatelessWidget {
  const PbUbndPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageHeader('Lịch Ủy ban',
            'Chỉ xem — để biết lịch lớn và tránh trùng nhân sự'),
        const Notice(
          'Phòng ban chỉ có quyền xem lịch Ủy ban để tránh trùng nhân sự '
          'khi lên lịch nội bộ.',
          icon: Icons.visibility_outlined,
        ),
        for (final m in state.ubndMeetings)
          MeetingCard(m,
              showStatus: true, onTap: () => showMeetingDetail(context, m)),
      ],
    );
  }
}
