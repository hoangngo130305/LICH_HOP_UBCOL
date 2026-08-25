import 'package:flutter/material.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/file_saver.dart';
import '../widgets/common.dart';

/// Chuyển 1 giá trị thành ô CSV an toàn (bọc trong dấu ngoặc kép nếu có
/// dấu phẩy/ngoặc kép/xuống dòng, theo chuẩn CSV).
String _csvCell(String v) {
  if (v.contains(',') || v.contains('"') || v.contains('\n')) {
    return '"${v.replaceAll('"', '""')}"';
  }
  return v;
}

String _buildCheckinCsv(Meeting meeting, List<_Row> records, bool showUnit) {
  final header = ['Họ tên', if (showUnit) 'Đơn vị', 'Giờ quét', 'Trạng thái'];
  final lines = <String>[header.map(_csvCell).join(',')];
  for (final r in records) {
    final row = [
      r.member?.name ?? '—',
      if (showUnit) r.member?.unit ?? '',
      r.time ?? '',
      r.time != null ? 'Đã điểm danh' : 'Chưa điểm danh',
    ];
    lines.add(row.map(_csvCell).join(','));
  }
  return '﻿${lines.join('\r\n')}'; // BOM de Excel doc dung UTF-8 co dau
}

/// Điểm danh bằng thẻ từ – dùng cho Văn thư và Hành chính phòng ban.
class CheckinPage extends StatefulWidget {
  final MeetingLevel level;

  const CheckinPage({super.key, required this.level});

  @override
  State<CheckinPage> createState() => _CheckinPageState();
}

class _CheckinPageState extends State<CheckinPage> {
  Meeting? _selected;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final isUbnd = widget.level == MeetingLevel.uyBan;
    final meetings = isUbnd ? state.ubndMeetings : state.deptMeetings;

    // Luon dong bo lai _selected ve dung instance hien co trong `meetings`
    // (khong chi kiem tra id con ton tai) — vi moi lan AppState nap lai du
    // lieu (vd. poll thong bao 20s) se tao Meeting instance MOI, va
    // DropdownButton doi value phai identical() voi 1 item trong `items`
    // thi moi khong bao "assertion failed" (Meeting khong override ==).
    if (meetings.isEmpty) {
      _selected = null;
    } else {
      final match = meetings.where((m) => m.id == _selected?.id);
      _selected = match.isNotEmpty ? match.first : meetings.first;
    }

    final records = _selected == null
        ? <_Row>[]
        : [
            for (final a in _selected!.attendees)
              _Row(
                member: state.member(a.memberId),
                time: state.checkinTimes[_selected!.id]?[a.memberId],
              ),
          ];
    final presentCount = records.where((r) => r.time != null).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(
          'Điểm danh',
          isUbnd
              ? 'Quản lý quét thẻ điểm danh cuộc họp'
              : '${state.unitLabel} – Quét thẻ điểm danh',
        ),
        const Notice(
          'Thành viên sử dụng thẻ từ/thẻ viết để tự quét điểm danh '
          'khi vào phòng họp. Bấm "Điểm danh" để ghi nhận thủ công.',
        ),
        if (meetings.isEmpty)
          const EmptyState(
              Icons.fact_check_outlined, 'Chưa có cuộc họp cần điểm danh')
        else ...[
          StatRow([
            StatCard('Thành phần mời', '${records.length}'),
            StatCard('Đã điểm danh', '$presentCount',
                valueColor: AppColors.okGreen),
            StatCard('Chưa điểm danh', '${records.length - presentCount}',
                valueColor: AppColors.warn),
          ]),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormField2(
                  'Cuộc họp',
                  AppDropdown<Meeting>(
                    value: _selected,
                    items: meetings,
                    labelOf: (m) =>
                        '${m.title} – ${VnDate.dm(m.date)} ${m.timeLabel}',
                    onChanged: (m) => setState(() => _selected = m),
                  ),
                ),
                const SizedBox(height: 4),
                _CheckinTable(
                  records: records,
                  showUnit: isUbnd,
                  onCheckin: (memberId) async {
                    final ok = await state.checkin(_selected!.id, memberId);
                    if (context.mounted && !ok) {
                      showToast(context, 'Điểm danh thất bại, thử lại',
                          type: NoticeType.warn);
                    }
                  },
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: GhostButton('Xuất danh sách',
                      icon: Icons.download_outlined,
                      onPressed: () {
                        final csv =
                            _buildCheckinCsv(_selected!, records, isUbnd);
                        final fileName =
                            'diem_danh_${_selected!.id}_${VnDate.dmy(_selected!.date).replaceAll('/', '-')}.csv';
                        final saved = saveTextFile(fileName, csv);
                        showToast(
                          context,
                          saved
                              ? 'Đã xuất danh sách điểm danh: $fileName'
                              : 'Tính năng xuất file cần chạy trên trình duyệt (bản Web)',
                          type: saved ? NoticeType.ok : NoticeType.warn,
                        );
                      }),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _Row {
  final Member? member;
  final String? time;
  const _Row({required this.member, required this.time});
}

class _CheckinTable extends StatelessWidget {
  final List<_Row> records;
  final bool showUnit;
  final ValueChanged<int> onCheckin;

  const _CheckinTable(
      {required this.records, required this.showUnit, required this.onCheckin});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.bd),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            color: AppColors.s0,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            child: Row(
              children: [
                const Expanded(flex: 3, child: Text('Họ tên', style: AppTheme.label)),
                if (showUnit)
                  const Expanded(
                      flex: 3, child: Text('Đơn vị', style: AppTheme.label)),
                const Expanded(
                    flex: 2, child: Text('Giờ quét', style: AppTheme.label)),
                const Expanded(
                    flex: 3, child: Text('Trạng thái', style: AppTheme.label)),
              ],
            ),
          ),
          for (var i = 0; i < records.length; i++)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                border: i == records.length - 1
                    ? null
                    : const Border(
                        bottom: BorderSide(color: AppColors.bd)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(records[i].member?.name ?? '—',
                        style: const TextStyle(fontSize: 12.5)),
                  ),
                  if (showUnit)
                    Expanded(
                      flex: 3,
                      child: Text(records[i].member?.unit ?? '',
                          style: AppTheme.meta),
                    ),
                  Expanded(
                    flex: 2,
                    child: Text(records[i].time ?? '–',
                        style: const TextStyle(fontSize: 12.5)),
                  ),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: records[i].time != null
                          ? const AppBadge('Đã điểm danh',
                              bg: AppColors.greenBg,
                              fg: AppColors.greenText,
                              icon: Icons.check)
                          : ChipButton(Icons.touch_app_outlined,
                              label: 'Điểm danh',
                              onTap: records[i].member == null
                                  ? () {}
                                  : () => onCheckin(records[i].member!.id)),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
