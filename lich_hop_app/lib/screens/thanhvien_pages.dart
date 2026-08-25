import 'package:flutter/material.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/calendar_grid.dart';
import '../widgets/common.dart';
import '../widgets/meeting_card.dart';
import 'dialogs.dart';

Color _rsvpColor(Rsvp r) => switch (r) {
      Rsvp.accepted => AppColors.okGreen,
      Rsvp.declined => AppColors.danger,
      Rsvp.pending => AppColors.warn,
    };

Color _rsvpBg(Rsvp r) => switch (r) {
      Rsvp.accepted => AppColors.greenBg,
      Rsvp.declined => AppColors.dangerBg,
      Rsvp.pending => AppColors.warnBg,
    };

/// ===== THẺ LỜI MỜI =====
class InviteCard extends StatelessWidget {
  final Meeting meeting;
  final bool showActions;

  const InviteCard(this.meeting, {super.key, this.showActions = true});

  Future<void> _decline(BuildContext context) async {
    final state = AppScope.read(context);
    final ctrl = TextEditingController();
    final ok = await showAppDialog<bool>(
      context,
      title: 'Lý do từ chối (tùy chọn)',
      width: 440,
      body: FormField2(
        'Lý do từ chối',
        TextField(
          controller: ctrl,
          maxLines: 3,
          decoration: const InputDecoration(
              hintText: 'VD: Bận công tác, có lịch trùng...'),
        ),
      ),
      actions: [
        GhostButton('Hủy', onPressed: () => Navigator.of(context).pop(false)),
        PrimaryButton('Gửi từ chối',
            icon: Icons.send,
            color: AppColors.danger,
            onPressed: () => Navigator.of(context).pop(true)),
      ],
    );
    final reason = ctrl.text.trim();
    ctrl.dispose();
    if (ok == true && context.mounted) {
      final success = await state.respond(meeting.id, Rsvp.declined,
          declineReason: reason.isEmpty ? null : reason);
      if (!context.mounted) return;
      showToast(
        context,
        success ? 'Đã gửi phản hồi từ chối' : 'Có lỗi, vui lòng thử lại',
        type: NoticeType.warn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final rsvp = state.rsvpOf(meeting.id);
    // Chỉ Lãnh đạo và Trưởng/Phó phòng được bấm "Xác nhận tham gia"
    // (theo biên bản họp 22/08/2026) — cán bộ khác chỉ xem trạng thái.
    final canConfirm = showActions && state.canConfirmAttendance;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.s2,
        border: Border.all(color: AppColors.bd),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: AppColors.navy,
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meeting.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _headMeta(Icons.calendar_today_outlined,
                        VnDate.longLabel(meeting.date)),
                    _headMeta(Icons.schedule,
                        '${meeting.timeLabel} · ${meeting.session.label}'),
                    if (meeting.unit != null)
                      _headMeta(Icons.account_balance_outlined,
                          meeting.unit!),
                    AppBadge.rsvp(rsvp),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoRow(Icons.place_outlined, 'Địa điểm', meeting.room),
                InfoRow(Icons.person_outline, 'Chủ trì', meeting.host),
                InfoRow(Icons.notes_outlined, 'Nội dung', meeting.content),
                if (meeting.files.isNotEmpty)
                  InfoRow(
                    Icons.attach_file,
                    'Tài liệu đính kèm',
                    '${meeting.files.length} file',
                    child: AttachmentList(meeting.files),
                  ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: AppColors.s1,
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (canConfirm && rsvp != Rsvp.accepted)
                  PrimaryButton('Xác nhận tham dự',
                      icon: Icons.check,
                      color: AppColors.okGreen, onPressed: () async {
                    final ok = await state.respond(meeting.id, Rsvp.accepted);
                    if (!context.mounted) return;
                    showToast(
                      context,
                      ok
                          ? 'Đã xác nhận tham dự cuộc họp!'
                          : 'Có lỗi, vui lòng thử lại',
                      type: ok ? NoticeType.ok : NoticeType.warn,
                    );
                  }),
                if (canConfirm && rsvp != Rsvp.declined)
                  PrimaryButton('Từ chối',
                      icon: Icons.close,
                      color: AppColors.danger,
                      onPressed: () => _decline(context)),
                if (!canConfirm) ...[
                  AppBadge.rsvp(rsvp),
                  if (showActions)
                    const Text('Chỉ Lãnh đạo/Trưởng, Phó phòng xác nhận được',
                        style: TextStyle(fontSize: 10.5, color: AppColors.tm)),
                ],
                ChipButton(Icons.info_outline,
                    label: 'Chi tiết & Danh sách',
                    onTap: () =>
                        showMeetingDetail(context, meeting, withRsvp: true)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _headMeta(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: const Color(0xFF8FA8D6)),
        const SizedBox(width: 5),
        Text(text,
            style: const TextStyle(fontSize: 11.5, color: Color(0xFF8FA8D6))),
      ],
    );
  }
}

/// THÀNH VIÊN – Lời mời họp.
class TvInvitesPage extends StatelessWidget {
  const TvInvitesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final mine = state.myMeetings.where((m) => !m.isDone).toList();
    final pending =
        mine.where((m) => state.rsvpOf(m.id) == Rsvp.pending).toList();
    final accepted =
        mine.where((m) => state.rsvpOf(m.id) == Rsvp.accepted).toList();
    final declined =
        mine.where((m) => state.rsvpOf(m.id) == Rsvp.declined).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader('Lời mời họp',
            '${state.userName} – ${state.myTitle ?? 'Cán bộ'} · ${state.unitLabel}'),
        StatRow([
          StatCard('Chờ xác nhận', '${pending.length}',
              valueColor: AppColors.warn),
          StatCard('Đã xác nhận', '${accepted.length}',
              valueColor: AppColors.okGreen),
          StatCard('Đã từ chối', '${declined.length}',
              valueColor: AppColors.danger),
          StatCard('Tổng lời mời', '${mine.length}'),
        ]),
        if (pending.isNotEmpty)
          Notice(
            'Bạn có ${pending.length} lời mời họp chưa xác nhận. '
            'Vui lòng phản hồi để ban tổ chức sắp xếp.',
            type: NoticeType.purple,
          ),
        SectionLabel('Chờ xác nhận (${pending.length})',
            icon: Icons.schedule, color: AppColors.warn),
        if (pending.isEmpty)
          const EmptyState(
              Icons.mark_email_read_outlined, 'Bạn đã phản hồi hết lời mời')
        else
          for (final m in pending) InviteCard(m),
        const SizedBox(height: 8),
        SectionLabel('Đã xác nhận tham dự (${accepted.length})',
            icon: Icons.check_circle_outline, color: AppColors.okGreen),
        if (accepted.isEmpty)
          const EmptyState(
              Icons.event_available_outlined, 'Chưa xác nhận cuộc họp nào')
        else
          for (final m in accepted) InviteCard(m, showActions: false),
        if (declined.isNotEmpty) ...[
          const SizedBox(height: 8),
          SectionLabel('Đã từ chối (${declined.length})',
              icon: Icons.cancel_outlined, color: AppColors.danger),
          for (final m in declined)
            MeetingCard(m,
                accent: AppColors.danger,
                extraBadges: [AppBadge.rsvp(Rsvp.declined)],
                onTap: () => showMeetingDetail(context, m, withRsvp: true)),
        ],
      ],
    );
  }
}

/// THÀNH VIÊN – Lịch sắp tới (đã xác nhận tham dự).
class TvUpcomingPage extends StatelessWidget {
  const TvUpcomingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final list = state.myMeetings
        .where((m) => !m.isDone && state.rsvpOf(m.id) == Rsvp.accepted)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageHeader(
            'Lịch sắp tới của tôi', 'Các cuộc họp đã xác nhận tham dự'),
        Notice('Bạn đã xác nhận tham dự ${list.length} cuộc họp sắp tới.',
            type: NoticeType.ok, icon: Icons.event_available_outlined),
        if (list.isEmpty)
          const EmptyState(Icons.event_busy_outlined,
              'Chưa có lịch họp nào được xác nhận.')
        else
          for (final m in list) InviteCard(m, showActions: false),
      ],
    );
  }
}

/// THÀNH VIÊN – Lịch sử cuộc họp.
class TvHistoryPage extends StatelessWidget {
  const TvHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final list = state.myMeetings.where((m) => m.isDone).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageHeader('Lịch sử cuộc họp', 'Các cuộc họp đã tham dự'),
        if (list.isEmpty)
          const EmptyState(Icons.history, 'Chưa có lịch sử cuộc họp.')
        else
          for (final m in list)
            MeetingCard(
              m,
              accent: AppColors.accent,
              showStatus: true,
              onTap: () => showMeetingDetail(context, m, withRsvp: true),
              actions: [
                ChipButton(Icons.description_outlined,
                    label: 'Biên bản',
                    onTap: () => showMeetingMinutesDialog(context, m)),
              ],
            ),
      ],
    );
  }
}

/// THÀNH VIÊN – Lịch theo ngày (dòng thời gian).
class TvDayPage extends StatefulWidget {
  const TvDayPage({super.key});

  @override
  State<TvDayPage> createState() => _TvDayPageState();
}

class _TvDayPageState extends State<TvDayPage> {
  DateTime _day = VnDate.today;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final meetings = state.myMeetingsOn(_day)
      ..sort((a, b) => a.time.hour.compareTo(b.time.hour));
    final accepted =
        meetings.where((m) => state.rsvpOf(m.id) == Rsvp.accepted).length;
    final pending =
        meetings.where((m) => state.rsvpOf(m.id) == Rsvp.pending).length;
    final isToday = VnDate.sameDay(_day, VnDate.today);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(
          'Lịch theo ngày',
          'Xem lịch họp chi tiết từng ngày',
          action: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ChipButton(Icons.chevron_left,
                  tooltip: 'Ngày trước',
                  onTap: () => setState(() =>
                      _day = _day.subtract(const Duration(days: 1)))),
              const SizedBox(width: 6),
              ChipButton(Icons.today,
                  tooltip: 'Hôm nay',
                  onTap: () => setState(() => _day = VnDate.today)),
              const SizedBox(width: 6),
              ChipButton(Icons.chevron_right,
                  tooltip: 'Ngày sau',
                  onTap: () => setState(
                      () => _day = _day.add(const Duration(days: 1)))),
            ],
          ),
        ),
        StatRow([
          StatCard('Cuộc họp trong ngày', '${meetings.length}',
              valueColor: AppColors.accent),
          StatCard('Đã xác nhận', '$accepted', valueColor: AppColors.okGreen),
          StatCard('Chờ xác nhận', '$pending', valueColor: AppColors.warn),
        ]),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.schedule, size: 14, color: AppColors.ts),
                  const SizedBox(width: 6),
                  Text(VnDate.longLabel(_day).toUpperCase(),
                      style: AppTheme.label),
                  if (isToday) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                          color: AppColors.navy,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Text('Hôm nay',
                          style:
                              TextStyle(fontSize: 10, color: Colors.white)),
                    ),
                  ],
                  const Spacer(),
                  Text('${meetings.length} cuộc họp', style: AppTheme.meta),
                ],
              ),
              const SizedBox(height: 12),
              if (meetings.isEmpty)
                const EmptyState(
                    Icons.event_busy_outlined, 'Không có cuộc họp')
              else
                for (var h = 7; h <= 18; h++)
                  _HourRow(
                    hour: h,
                    meetings:
                        meetings.where((m) => m.time.hour == h).toList(),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HourRow extends StatelessWidget {
  final int hour;
  final List<Meeting> meetings;

  const _HourRow({required this.hour, required this.meetings});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 46,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, right: 8),
              child: Text('${hour.toString().padLeft(2, '0')}:00',
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 11, color: AppColors.tm)),
            ),
          ),
          Container(width: 1, color: AppColors.bd),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 4, 0, 4),
              child: meetings.isEmpty
                  ? const SizedBox(height: 28)
                  : Column(
                      children: [
                        for (final m in meetings)
                          _TimelineItem(m, rsvp: state.rsvpOf(m.id)),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final Meeting meeting;
  final Rsvp rsvp;

  const _TimelineItem(this.meeting, {required this.rsvp});

  @override
  Widget build(BuildContext context) {
    final color = _rsvpColor(rsvp);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 4),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: _rsvpBg(rsvp),
        borderRadius:
            const BorderRadius.horizontal(right: Radius.circular(8)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => showMeetingDetail(context, meeting, withRsvp: true),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 3, color: color),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(9, 8, 12, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(meeting.timeLabel,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: color)),
                            const SizedBox(width: 8),
                            AppBadge.session(meeting.session),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(meeting.title, style: AppTheme.itemTitle),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.place_outlined,
                                    size: 12, color: AppColors.ts),
                                const SizedBox(width: 3),
                                Text(meeting.room, style: AppTheme.meta),
                              ],
                            ),
                            if (meeting.files.isNotEmpty)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.attach_file,
                                      size: 12, color: AppColors.ts),
                                  const SizedBox(width: 3),
                                  Text('${meeting.files.length}',
                                      style: AppTheme.meta),
                                ],
                              ),
                            AppBadge.rsvp(rsvp),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// THÀNH VIÊN – Lịch theo tuần (lưới giờ × ngày).
class TvWeekPage extends StatefulWidget {
  const TvWeekPage({super.key});

  @override
  State<TvWeekPage> createState() => _TvWeekPageState();
}

class _TvWeekPageState extends State<TvWeekPage> {
  DateTime _weekStart = VnDate.startOfWeek(VnDate.today);

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final days = [for (var i = 0; i < 7; i++) _weekStart.add(Duration(days: i))];
    final end = days.last;
    final weekMeetings = state.myMeetings
        .where((m) => !m.date.isBefore(_weekStart) && !m.date.isAfter(end))
        .toList();
    const hours = [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(
          'Lịch theo tuần',
          'Tuần ${VnDate.dm(_weekStart)} – ${VnDate.dmy(end)}',
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
          StatCard('Cuộc họp trong tuần', '${weekMeetings.length}',
              valueColor: AppColors.accent),
          StatCard(
              'Đã xác nhận',
              '${weekMeetings.where((m) => state.rsvpOf(m.id) == Rsvp.accepted).length}',
              valueColor: AppColors.okGreen),
          StatCard(
              'Chờ xác nhận',
              '${weekMeetings.where((m) => state.rsvpOf(m.id) == Rsvp.pending).length}',
              valueColor: AppColors.warn),
          StatCard(
              'Từ chối',
              '${weekMeetings.where((m) => state.rsvpOf(m.id) == Rsvp.declined).length}',
              valueColor: AppColors.danger),
        ]),
        WeekTimelineGrid(
          days: days,
          meetings: weekMeetings,
          hours: hours,
          accentColor: (m) => _rsvpColor(state.rsvpOf(m.id)),
          bgColor: (m) => _rsvpBg(state.rsvpOf(m.id)),
          onTapMeeting: (m) => showMeetingDetail(context, m, withRsvp: true),
          legend: const [
            (AppColors.okGreen, 'Đã xác nhận'),
            (AppColors.warn, 'Chờ xác nhận'),
            (AppColors.danger, 'Từ chối'),
          ],
        ),
      ],
    );
  }
}

/// THÀNH VIÊN – Lịch theo tháng.
class TvMonthPage extends StatefulWidget {
  const TvMonthPage({super.key});

  @override
  State<TvMonthPage> createState() => _TvMonthPageState();
}

class _TvMonthPageState extends State<TvMonthPage> {
  DateTime _month = DateTime(VnDate.today.year, VnDate.today.month);
  DateTime? _selected;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final monthMeetings = state.myMeetings
        .where((m) =>
            m.date.year == _month.year && m.date.month == _month.month)
        .toList();
    final dayCount =
        monthMeetings.map((m) => m.date.day).toSet().length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader('Lịch theo tháng',
            '${VnDate.monthLabel(_month)} · ${state.userName}'),
        StatRow([
          StatCard('Tổng cuộc họp', '${monthMeetings.length}',
              valueColor: AppColors.accent),
          StatCard(
              'Đã xác nhận',
              '${monthMeetings.where((m) => state.rsvpOf(m.id) == Rsvp.accepted).length}',
              valueColor: AppColors.okGreen),
          StatCard(
              'Chờ xác nhận',
              '${monthMeetings.where((m) => state.rsvpOf(m.id) == Rsvp.pending).length}',
              valueColor: AppColors.warn),
          StatCard('Ngày có lịch họp', '$dayCount'),
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
                  final list = state.myMeetingsOn(day);
                  return [
                    if (list.any((m) => state.rsvpOf(m.id) == Rsvp.accepted))
                      AppColors.okGreen,
                    if (list.any((m) => state.rsvpOf(m.id) == Rsvp.pending))
                      AppColors.warn,
                    if (list.any((m) => state.rsvpOf(m.id) == Rsvp.declined))
                      AppColors.danger,
                  ];
                },
                onSelectDay: (day) {
                  setState(() => _selected = day);
                  showDayMeetingsDialog(
                    context,
                    day,
                    state.myMeetingsOn(day),
                    itemBuilder: (context, m) => MeetingCard(
                      m,
                      accent: _rsvpColor(state.rsvpOf(m.id)),
                      extraBadges: [AppBadge.rsvp(state.rsvpOf(m.id))],
                      onTap: () {
                        Navigator.of(context).pop();
                        showMeetingDetail(context, m, withRsvp: true);
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              const Align(
                alignment: Alignment.centerLeft,
                child: LegendRow([
                  (AppColors.okGreen, 'Đã xác nhận tham dự'),
                  (AppColors.warn, 'Chờ xác nhận'),
                  (AppColors.danger, 'Đã từ chối'),
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

/// THÀNH VIÊN – Tra cứu lịch họp.
class TvSearchPage extends StatefulWidget {
  const TvSearchPage({super.key});

  @override
  State<TvSearchPage> createState() => _TvSearchPageState();
}

class _TvSearchPageState extends State<TvSearchPage> {
  final _keywordCtrl = TextEditingController();
  String? _unit;
  Session? _session;
  String _sessionLabel = _allSessions;
  DateTime _from = VnDate.today.subtract(const Duration(days: 60));
  DateTime _to = VnDate.today.add(const Duration(days: 90));
  bool _searched = false;

  static const _allUnits = 'Tất cả đơn vị';
  static const _allSessions = 'Tất cả';

  @override
  void dispose() {
    _keywordCtrl.dispose();
    super.dispose();
  }

  List<Meeting> _results(AppState state) {
    final kw = _keywordCtrl.text.trim().toLowerCase();
    return state.allMeetings.where((m) {
      if (kw.isNotEmpty && !m.title.toLowerCase().contains(kw)) return false;
      if (_unit != null && _unit != _allUnits && m.unit != _unit) return false;
      if (_session != null && m.session != _session) return false;
      if (m.date.isBefore(_from) || m.date.isAfter(_to)) return false;
      return true;
    }).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  Future<void> _pick(bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? _from : _to,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _from = picked;
        } else {
          _to = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final results = _results(state);
    final units = [
      _allUnits,
      ...{for (final m in state.allMeetings) m.unit}.whereType<String>(),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageHeader(
            'Tìm kiếm lịch họp', 'Tra cứu lịch họp trong hệ thống'),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(builder: (context, c) {
                final narrow = c.maxWidth < 560;
                final fields = [
                  FormField2(
                    'Từ khóa tiêu đề',
                    TextField(
                      controller: _keywordCtrl,
                      onSubmitted: (_) => setState(() => _searched = true),
                      decoration: const InputDecoration(
                          hintText: 'VD: giao ban, biên chế...'),
                    ),
                  ),
                  FormField2(
                    'Đơn vị',
                    AppDropdown<String>(
                      value: _unit ?? _allUnits,
                      items: units,
                      labelOf: (u) => u,
                      onChanged: (v) => setState(() => _unit = v),
                    ),
                  ),
                  FormField2(
                    'Từ ngày',
                    _DateBox(VnDate.dmy(_from), () => _pick(true)),
                  ),
                  FormField2(
                    'Đến ngày',
                    _DateBox(VnDate.dmy(_to), () => _pick(false)),
                  ),
                  FormField2(
                    'Buổi',
                    AppDropdown<String>(
                      value: _sessionLabel,
                      items: const [
                        _allSessions,
                        'Buổi sáng',
                        'Buổi chiều',
                        'Cả ngày'
                      ],
                      labelOf: (s) => s,
                      onChanged: (v) => setState(() {
                        _sessionLabel = v ?? _allSessions;
                        _session = switch (_sessionLabel) {
                          'Buổi sáng' => Session.am,
                          'Buổi chiều' => Session.pm,
                          'Cả ngày' => Session.allDay,
                          _ => null,
                        };
                      }),
                    ),
                  ),
                ];
                if (narrow) return Column(children: fields);
                return Wrap(
                  spacing: 12,
                  children: [
                    for (final f in fields)
                      SizedBox(width: (c.maxWidth - 24) / 3, child: f),
                  ],
                );
              }),
              Align(
                alignment: Alignment.centerRight,
                child: PrimaryButton('Tìm kiếm',
                    icon: Icons.search,
                    onPressed: () => setState(() => _searched = true)),
              ),
            ],
          ),
        ),
        SectionLabel(
            _searched
                ? 'Kết quả (${results.length})'
                : 'Tất cả lịch họp (${results.length})'),
        if (results.isEmpty)
          const EmptyState(
              Icons.search_off, 'Không tìm thấy lịch họp phù hợp')
        else
          for (final m in results)
            MeetingCard(
              m,
              accent: AppColors.accent,
              showStatus: true,
              onTap: () => showMeetingDetail(context, m, withRsvp: true),
              actions: [
                ChipButton(Icons.visibility_outlined,
                    tooltip: 'Xem',
                    onTap: () =>
                        showMeetingDetail(context, m, withRsvp: true)),
              ],
            ),
      ],
    );
  }
}

class _DateBox extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _DateBox(this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radius),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.bds),
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined,
                size: 15, color: AppColors.tm),
            const SizedBox(width: 8),
            Text(text, style: const TextStyle(fontSize: 12.5)),
          ],
        ),
      ),
    );
  }
}
