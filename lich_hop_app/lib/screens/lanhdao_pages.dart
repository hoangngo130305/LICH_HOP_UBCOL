import 'package:flutter/material.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/calendar_grid.dart';
import '../widgets/common.dart';
import '../widgets/meeting_card.dart';
import 'dialogs.dart';

/// LÃNH ĐẠO – Lịch hôm nay (chế độ chỉ xem).
class LdTodayPage extends StatelessWidget {
  const LdTodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final today = VnDate.today;
    final todayMeetings = state.meetingsOn(today);
    final ubnd = todayMeetings.where((m) => m.unit == 'Ủy ban').toList();
    final others = todayMeetings.where((m) => m.unit != 'Ủy ban').toList();
    final conflictCount = state.conflicts.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(
          'Lịch hôm nay',
          '${VnDate.longLabel(today)} · ${state.userName}',
          action: PrimaryButton('Liên hệ văn thư',
              icon: Icons.phone_outlined,
              onPressed: () => showVanThuContact(context)),
        ),
        Notice(
          'Chế độ chỉ xem. Khi cần thay đổi lịch họp, vui lòng gọi '
          'Văn thư${state.vanThuContact != null ? ' – ${state.vanThuContact!.name}' : ''} để cập nhật.',
          icon: Icons.visibility_outlined,
        ),
        if (conflictCount > 0)
          Notice(
            '$conflictCount cặp lịch trùng buổi tại cùng phòng họp. '
            'Văn phòng đang điều phối.',
            type: NoticeType.warn,
          ),
        const SectionLabel('Lịch Ủy ban', icon: Icons.account_balance_outlined),
        if (ubnd.isEmpty)
          const EmptyState(Icons.event_busy_outlined,
              'Hôm nay không có lịch họp Ủy ban')
        else
          for (final m in ubnd)
            MeetingCard(m,
                onTap: () => showMeetingDetail(context, m)),
        const SizedBox(height: 14),
        const SectionLabel('Lịch phòng ban liên quan',
            icon: Icons.groups_outlined),
        if (others.isEmpty)
          const EmptyState(
              Icons.event_busy_outlined, 'Không có lịch phòng ban hôm nay')
        else
          for (final m in others)
            MeetingCard(m,
                accent: AppColors.warn,
                onTap: () => showMeetingDetail(context, m)),
      ],
    );
  }
}

/// LÃNH ĐẠO – Lịch tuần.
class LdWeekPage extends StatefulWidget {
  const LdWeekPage({super.key});

  @override
  State<LdWeekPage> createState() => _LdWeekPageState();
}

class _LdWeekPageState extends State<LdWeekPage> {
  DateTime _weekStart = VnDate.startOfWeek(VnDate.today);
  static const _hours = [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final days = [for (var i = 0; i < 7; i++) _weekStart.add(Duration(days: i))];
    final end = days.last;
    final meetings = state.allMeetings
        .where((m) =>
            !m.date.isBefore(_weekStart) &&
            !m.date.isAfter(end) &&
            m.level == MeetingLevel.uyBan)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(
          'Lịch tuần',
          '${VnDate.dm(_weekStart)} – ${VnDate.dmy(end)}',
          action: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ChipButton(Icons.chevron_left,
                  tooltip: 'Tuần trước',
                  onTap: () => setState(() => _weekStart =
                      _weekStart.subtract(const Duration(days: 7)))),
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
            (AppColors.okGreen, 'Lịch họp bình thường'),
            (AppColors.danger, 'Trùng lịch'),
          ],
        ),
      ],
    );
  }
}

/// LÃNH ĐẠO – Lịch tháng.
class LdMonthPage extends StatefulWidget {
  const LdMonthPage({super.key});

  @override
  State<LdMonthPage> createState() => _LdMonthPageState();
}

class _LdMonthPageState extends State<LdMonthPage> {
  DateTime _month = DateTime(VnDate.today.year, VnDate.today.month);
  DateTime? _selected;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final monthMeetings = state.ubndMeetings
        .where((m) =>
            m.date.year == _month.year && m.date.month == _month.month)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader('Lịch tháng', 'Tổng quan lịch họp ${VnDate.monthLabel(_month)}'),
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
                onPrev: () => setState(() {
                  _month = DateTime(_month.year, _month.month - 1);
                  _selected = null;
                }),
                onNext: () => setState(() {
                  _month = DateTime(_month.year, _month.month + 1);
                  _selected = null;
                }),
              ),
              MonthGrid(
                month: _month,
                today: VnDate.today,
                selected: _selected,
                dotsBuilder: (day) {
                  final list = state.ubndMeetings
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
                  final dayMeetings = state.ubndMeetings
                      .where((m) => VnDate.sameDay(m.date, day))
                      .toList();
                  showDayMeetingsDialog(context, day, dayMeetings);
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
