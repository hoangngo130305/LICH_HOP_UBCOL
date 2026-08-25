import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/app_theme.dart';
import '../utils/open_url.dart';
import 'common.dart';

/// Thẻ cuộc họp dạng danh sách (tương ứng `.mitem` trong prototype).
class MeetingCard extends StatelessWidget {
  final Meeting meeting;
  final Color accent;
  final VoidCallback? onTap;
  final List<Widget> actions;
  final List<Widget> extraBadges;
  final bool showUnit;
  final bool showStatus;

  const MeetingCard(
    this.meeting, {
    super.key,
    this.accent = AppColors.navy,
    this.onTap,
    this.actions = const [],
    this.extraBadges = const [],
    this.showUnit = true,
    this.showStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: AppColors.s2,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.bd),
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: onTap,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Dải màu bên trái (thay cho border không đồng đều)
                Container(width: 3, color: accent),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 12, 12, 12),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 50,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(meeting.date.day.toString(),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      height: 1)),
                              const SizedBox(height: 2),
                              Text(VnDate.dow(meeting.date),
                                  style: const TextStyle(
                                      fontSize: 10, color: AppColors.tm)),
                            ],
                          ),
                        ),
                        Container(width: 1, height: 38, color: AppColors.bd),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(meeting.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTheme.itemTitle),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  _meta(Icons.schedule, meeting.timeLabel),
                                  AppBadge.session(meeting.session),
                                  if (showUnit && meeting.unit != null)
                                    AppBadge.unit(meeting.unit!),
                                  _meta(Icons.place_outlined, meeting.room),
                                  if (meeting.files.isNotEmpty)
                                    _meta(Icons.attach_file,
                                        '${meeting.files.length} tài liệu'),
                                  if (meeting.conflict) AppBadge.conflict,
                                  if (showStatus)
                                    AppBadge.status(meeting.status),
                                  ...extraBadges,
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (actions.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Wrap(spacing: 5, children: actions),
                        ],
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

  static Widget _meta(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.ts),
        const SizedBox(width: 3),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 220),
          child: Text(text,
              overflow: TextOverflow.ellipsis, style: AppTheme.meta),
        ),
      ],
    );
  }
}

/// Danh sách tài liệu đính kèm (chế độ xem – có nút tải).
class AttachmentList extends StatelessWidget {
  final List<MeetingFile> files;

  const AttachmentList(this.files, {super.key});

  static Color colorOf(FileKind kind) => switch (kind) {
        FileKind.pdf => AppColors.danger,
        FileKind.doc => AppColors.accent,
        FileKind.xls => AppColors.okGreen,
        FileKind.img => AppColors.purple,
        FileKind.other => AppColors.ts,
      };

  @override
  Widget build(BuildContext context) {
    if (files.isEmpty) {
      return const Text('Không có tài liệu đính kèm',
          style: TextStyle(
              fontSize: 11.5,
              color: AppColors.tm,
              fontStyle: FontStyle.italic));
    }
    return Column(
      children: [
        for (final f in files)
          Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.s1,
              border: Border.all(color: AppColors.bd),
              borderRadius: BorderRadius.circular(AppTheme.radius),
            ),
            child: Row(
              children: [
                Icon(f.icon, size: 20, color: colorOf(f.kind)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(f.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12.5, fontWeight: FontWeight.w500)),
                ),
                const SizedBox(width: 8),
                Text(f.size,
                    style:
                        const TextStyle(fontSize: 10.5, color: AppColors.tm)),
                const SizedBox(width: 6),
                ChipButton(
                  Icons.download_outlined,
                  label: 'Tải',
                  color: AppColors.accent,
                  onTap: () async {
                    if (f.url == null) {
                      showToast(context, 'Tệp không có sẵn để tải',
                          type: NoticeType.warn);
                      return;
                    }
                    final ok = await openUrlInNewTab(f.url!);
                    if (!ok && context.mounted) {
                      showToast(context, 'Không mở được tệp, thử lại',
                          type: NoticeType.warn);
                    }
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
