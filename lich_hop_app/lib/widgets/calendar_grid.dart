import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/app_theme.dart';
import 'common.dart';

/// Lưới lịch tháng. [dotsBuilder] trả về danh sách màu chấm cho mỗi ngày.
class MonthGrid extends StatelessWidget {
  final DateTime month;
  final DateTime? today;
  final DateTime? selected;
  final List<Color> Function(DateTime day) dotsBuilder;
  final ValueChanged<DateTime>? onSelectDay;

  const MonthGrid({
    super.key,
    required this.month,
    required this.dotsBuilder,
    this.today,
    this.selected,
    this.onSelectDay,
  });

  @override
  Widget build(BuildContext context) {
    final first = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    // Cột đầu là Chủ nhật → weekday 7 (CN) ứng với offset 0.
    final leading = first.weekday % 7;
    final prevMonthDays = DateTime(month.year, month.month, 0).day;

    final cells = <Widget>[];
    for (var i = leading; i > 0; i--) {
      cells.add(_cell(context, null, prevMonthDays - i + 1));
    }
    for (var d = 1; d <= daysInMonth; d++) {
      cells.add(_cell(context, DateTime(month.year, month.month, d), d));
    }
    var next = 1;
    while (cells.length % 7 != 0) {
      cells.add(_cell(context, null, next++));
    }

    return LayoutBuilder(builder: (context, c) {
      final size = (c.maxWidth - 6 * 4) / 7;
      return Column(
        children: [
          Row(
            children: [
              for (final h in VnDate.gridHeaders)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(h,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.tm)),
                  ),
                ),
            ],
          ),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              for (final cell in cells) SizedBox(width: size, child: cell),
            ],
          ),
        ],
      );
    });
  }

  /// Ti le rong/cao cua o ngay — lon hon 1 de o thap va gon hon (thay vi
  /// vuong, von qua cao tren man hinh may tinh do be rong cot lon).
  static const _cellAspectRatio = 1.7;

  Widget _cell(BuildContext context, DateTime? day, int label) {
    if (day == null) {
      return AspectRatio(
        aspectRatio: _cellAspectRatio,
        child: Center(
          child: Text('$label',
              style: const TextStyle(fontSize: 11, color: AppColors.tm)),
        ),
      );
    }

    final dots = dotsBuilder(day);
    final isToday = today != null && VnDate.sameDay(day, today!);
    final isSelected = selected != null && VnDate.sameDay(day, selected!);

    return AspectRatio(
      aspectRatio: _cellAspectRatio,
      child: Material(
        color: isToday
            ? AppColors.navy
            : isSelected
                ? AppColors.accentBg
                : (dots.isNotEmpty ? AppColors.s1 : Colors.transparent),
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onSelectDay == null ? null : () => onSelectDay!(day),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${day.day}',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                    color: isToday ? Colors.white : AppColors.tp,
                  )),
              if (dots.isNotEmpty) ...[
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final c in dots)
                      Container(
                        width: 5,
                        height: 5,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isToday ? Colors.white : c,
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Thanh điều hướng tháng: ‹ Tháng 7 / 2025 ›
class MonthNav extends StatelessWidget {
  final DateTime month;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const MonthNav(this.month,
      {super.key, required this.onPrev, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 20),
            color: AppColors.ts,
            onPressed: onPrev,
          ),
          Text(VnDate.monthLabel(month),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 20),
            color: AppColors.ts,
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}

/// Chú thích màu dưới lịch.
class LegendRow extends StatelessWidget {
  final List<(Color, String)> items;

  const LegendRow(this.items, {super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 6,
      children: [
        for (final (color, label) in items)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 5),
              Text(label, style: AppTheme.meta),
            ],
          ),
      ],
    );
  }
}

/// Lưới lịch tuần dạng dòng thời gian (7 ngày × khung giờ) — dùng chung cho
/// mọi vai trò để giao diện "Xem theo tuần" đồng bộ nhau (trước đây mỗi vai
/// trò tự vẽ kiểu khác nhau: danh sách phẳng, danh sách theo từng ngày...).
/// [accentColor]/[bgColor] cho phép mỗi vai trò tô màu theo ý nghĩa riêng
/// (trạng thái phản hồi, cảnh báo trùng lịch...) trong khi vẫn dùng chung bố
/// cục lưới với màn hình của Thành viên tham dự.
class WeekTimelineGrid extends StatelessWidget {
  final List<DateTime> days;
  final List<Meeting> meetings;
  final Color Function(Meeting) accentColor;
  final Color Function(Meeting) bgColor;
  final ValueChanged<Meeting> onTapMeeting;
  final List<(Color, String)> legend;
  final List<int> hours;

  const WeekTimelineGrid({
    super.key,
    required this.days,
    required this.meetings,
    required this.accentColor,
    required this.bgColor,
    required this.onTapMeeting,
    required this.legend,
    this.hours = const [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17],
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 46),
                    for (final d in days) _WeekHeaderCell(d),
                  ],
                ),
                for (final h in hours)
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: 46,
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 6, right: 6, bottom: 6),
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(color: AppColors.bd),
                                bottom: BorderSide(color: AppColors.bd),
                              ),
                            ),
                            child: Text('${h.toString().padLeft(2, '0')}:00',
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    fontSize: 10, color: AppColors.tm)),
                          ),
                        ),
                        for (final d in days)
                          _WeekCell(
                            day: d,
                            meetings: meetings
                                .where((m) =>
                                    VnDate.sameDay(m.date, d) &&
                                    m.time.hour == h)
                                .toList(),
                            accentColor: accentColor,
                            bgColor: bgColor,
                            onTapMeeting: onTapMeeting,
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.bd)),
            ),
            child: LegendRow(legend),
          ),
        ],
      ),
    );
  }
}

class _WeekHeaderCell extends StatelessWidget {
  final DateTime day;

  const _WeekHeaderCell(this.day);

  @override
  Widget build(BuildContext context) {
    final isToday = VnDate.sameDay(day, VnDate.today);
    return Container(
      width: 104,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isToday ? AppColors.accentBg : AppColors.s0,
        border: const Border(
          right: BorderSide(color: AppColors.bd),
          bottom: BorderSide(color: AppColors.bd),
        ),
      ),
      child: Column(
        children: [
          Text(VnDate.dow(day),
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.tm)),
          const SizedBox(height: 2),
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isToday ? AppColors.accent : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Text('${day.day}',
                style: TextStyle(
                  fontSize: isToday ? 14 : 13,
                  fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                  color: isToday ? Colors.white : AppColors.tp,
                )),
          ),
        ],
      ),
    );
  }
}

class _WeekCell extends StatelessWidget {
  final DateTime day;
  final List<Meeting> meetings;
  final Color Function(Meeting) accentColor;
  final Color Function(Meeting) bgColor;
  final ValueChanged<Meeting> onTapMeeting;

  const _WeekCell({
    required this.day,
    required this.meetings,
    required this.accentColor,
    required this.bgColor,
    required this.onTapMeeting,
  });

  @override
  Widget build(BuildContext context) {
    final isToday = VnDate.sameDay(day, VnDate.today);
    return Container(
      width: 104,
      constraints: const BoxConstraints(minHeight: 38),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isToday ? const Color(0x0A3B7DD8) : null,
        border: const Border(
          right: BorderSide(color: AppColors.bd),
          bottom: BorderSide(color: AppColors.bd),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final m in meetings)
            Container(
              margin: const EdgeInsets.only(bottom: 2),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: bgColor(m),
                borderRadius:
                    const BorderRadius.horizontal(right: Radius.circular(4)),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onTapMeeting(m),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(width: 2, color: accentColor(m)),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(4, 4, 5, 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(m.timeLabel,
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: accentColor(m))),
                                Text(m.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 10, height: 1.25)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
