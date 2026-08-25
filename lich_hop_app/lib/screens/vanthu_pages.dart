import 'package:flutter/material.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/calendar_grid.dart';
import '../widgets/common.dart';
import '../widgets/meeting_card.dart';
import 'dialogs.dart';

/// VĂN THƯ – Danh sách lịch họp (sắp diễn ra / đã qua / tất cả).
class VtListPage extends StatefulWidget {
  const VtListPage({super.key});

  @override
  State<VtListPage> createState() => _VtListPageState();
}

class _VtListPageState extends State<VtListPage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final upcoming = state.upcomingUbnd;
    final done = state.doneUbnd;
    final postponed = state.postponedUbnd;
    final shown = switch (_tab) {
      0 => upcoming,
      1 => done,
      2 => postponed,
      _ => state.ubndMeetings,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(
          'Danh sách lịch họp',
          'Quản lý toàn bộ lịch họp cấp Ủy ban',
          action: PrimaryButton('Tạo lịch họp',
              icon: Icons.add, onPressed: () => state.goTo('vt-create')),
        ),
        StatRow([
          StatCard('Tổng lịch họp', '${state.ubndMeetings.length}'),
          StatCard('Sắp diễn ra', '${upcoming.length}',
              valueColor: AppColors.okGreen),
          StatCard('Đã qua', '${done.length}', valueColor: AppColors.warn),
          StatCard('Cảnh báo trùng', '${state.conflicts.length}',
              valueColor: AppColors.danger),
        ]),
        AppTabs(
          [
            'Sắp diễn ra (${upcoming.length})',
            'Đã qua (${done.length})',
            'Hoãn (${postponed.length})',
            'Tất cả (${state.ubndMeetings.length})',
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
                      state.goTo('vt-create');
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

/// VĂN THƯ – Xem lịch theo tuần (đủ các ngày trong tuần kể cả ngày trống —
/// theo biên bản họp 22/08/2026, mục 4).
class VtWeekPage extends StatefulWidget {
  const VtWeekPage({super.key});

  @override
  State<VtWeekPage> createState() => _VtWeekPageState();
}

class _VtWeekPageState extends State<VtWeekPage> {
  DateTime _weekStart = VnDate.startOfWeek(VnDate.today);
  static const _hours = [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final days = [for (var i = 0; i < 7; i++) _weekStart.add(Duration(days: i))];
    final end = days.last;
    final meetings = state.allMeetings
        .where((m) => !m.date.isBefore(_weekStart) && !m.date.isAfter(end))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(
          'Xem theo tuần',
          '${VnDate.dm(_weekStart)} – ${VnDate.dmy(end)}',
          action: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ChipButton(Icons.chevron_left,
                  tooltip: 'Tuần trước',
                  onTap: () => setState(() => _weekStart =
                      _weekStart.subtract(const Duration(days: 7)))),
              const SizedBox(width: 6),
              ChipButton(Icons.today_outlined,
                  tooltip: 'Tuần này',
                  onTap: () => setState(
                      () => _weekStart = VnDate.startOfWeek(VnDate.today))),
              const SizedBox(width: 6),
              ChipButton(Icons.chevron_right,
                  tooltip: 'Tuần sau',
                  onTap: () => setState(() =>
                      _weekStart = _weekStart.add(const Duration(days: 7)))),
            ],
          ),
        ),
        StatRow([
          StatCard('Cuộc họp trong tuần', '${meetings.length}',
              valueColor: AppColors.accent),
          StatCard('Cảnh báo trùng',
              '${meetings.where((m) => m.conflict).length}',
              valueColor: AppColors.danger),
        ]),
        WeekTimelineGrid(
          days: days,
          meetings: meetings,
          hours: _hours,
          accentColor: (m) => m.conflict ? AppColors.danger : AppColors.okGreen,
          bgColor: (m) => m.conflict ? AppColors.dangerBg : AppColors.greenBg,
          onTapMeeting: (m) => showMeetingDetail(context, m),
          legend: const [
            (AppColors.okGreen, 'Có lịch họp'),
            (AppColors.danger, 'Có cảnh báo trùng'),
          ],
        ),
      ],
    );
  }
}

/// VĂN THƯ – Xem lịch theo tháng.
class VtCalendarPage extends StatefulWidget {
  const VtCalendarPage({super.key});

  @override
  State<VtCalendarPage> createState() => _VtCalendarPageState();
}

class _VtCalendarPageState extends State<VtCalendarPage> {
  DateTime _month = DateTime(VnDate.today.year, VnDate.today.month);
  DateTime? _selected;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final monthMeetings = state.allMeetings
        .where((m) =>
            m.date.year == _month.year && m.date.month == _month.month)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader('Xem theo tháng',
            'Toàn bộ lịch họp trong ${VnDate.monthLabel(_month).toLowerCase()}'),
        StatRow([
          StatCard('Tổng lịch họp', '${monthMeetings.length}',
              valueColor: AppColors.accent),
          StatCard('Cảnh báo trùng',
              '${monthMeetings.where((m) => m.conflict).length}',
              valueColor: AppColors.danger),
        ]),
        AppCard(
          child: Column(
            children: [
              MonthNav(
                _month,
                onPrev: () => setState(
                    () => _month = DateTime(_month.year, _month.month - 1)),
                onNext: () => setState(
                    () => _month = DateTime(_month.year, _month.month + 1)),
              ),
              MonthGrid(
                month: _month,
                today: VnDate.today,
                selected: _selected,
                dotsBuilder: (day) {
                  final list = state.allMeetings
                      .where((m) => VnDate.sameDay(m.date, day));
                  if (list.isEmpty) return const [];
                  return [
                    if (list.any((m) => m.conflict))
                      AppColors.danger
                    else
                      AppColors.okGreen,
                  ];
                },
                onSelectDay: (day) {
                  setState(() => _selected = day);
                  showDayMeetingsDialog(context, day, state.meetingsOn(day));
                },
              ),
              const SizedBox(height: 12),
              const Align(
                alignment: Alignment.centerLeft,
                child: LegendRow([
                  (AppColors.okGreen, 'Có lịch họp'),
                  (AppColors.danger, 'Có cảnh báo trùng'),
                  (AppColors.navy, 'Hôm nay'),
                ]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
