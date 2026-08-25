import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/app_theme.dart';

/// Thẻ phòng họp: dải màu phía trên đổi theo tình trạng.
class RoomCard extends StatelessWidget {
  final Room room;

  const RoomCard(this.room, {super.key});

  @override
  Widget build(BuildContext context) {
    final (topColor, chipBg, chipFg, chipIcon, chipText) =
        switch (room.status) {
      RoomStatus.free => (
          AppColors.okGreen,
          AppColors.greenBg,
          AppColors.greenText,
          Icons.check_circle_outline,
          'Còn trống'
        ),
      RoomStatus.busy => (
          AppColors.danger,
          AppColors.dangerBg,
          AppColors.dangerText,
          Icons.radio_button_checked,
          'Đang sử dụng'
        ),
      RoomStatus.conflict => (
          AppColors.warn,
          AppColors.warnBg,
          AppColors.warnText,
          Icons.warning_amber_rounded,
          'Có cảnh báo'
        ),
    };

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.s2,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.bd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 3, width: double.infinity, color: topColor),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 11, 14, 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(room.name, style: AppTheme.itemTitle),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.groups_outlined,
                        size: 12, color: AppColors.tm),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text('${room.location} · ${room.capacity} người',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.tm)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                      color: chipBg, borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(chipIcon, size: 12, color: chipFg),
                      const SizedBox(width: 4),
                      Text(chipText,
                          style: TextStyle(
                              fontSize: 11,
                              color: chipFg,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                if (room.schedule.isEmpty)
                  const Text('Chưa có lịch',
                      style: TextStyle(
                          fontSize: 11,
                          color: AppColors.tm,
                          fontStyle: FontStyle.italic))
                else
                  for (final s in room.schedule)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: switch (s.dot) {
                                SlotDot.ok => AppColors.okGreen,
                                SlotDot.busy => AppColors.danger,
                                SlotDot.warn => AppColors.warn,
                              },
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text('${s.time} ${s.title}',
                                overflow: TextOverflow.ellipsis,
                                style: AppTheme.meta),
                          ),
                          if (s.conflict)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                  color: AppColors.warnBg,
                                  borderRadius: BorderRadius.circular(8)),
                              child: const Text('Trùng',
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: AppColors.warnText)),
                            ),
                        ],
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

/// Lưới phòng họp, tự đổi số cột theo bề rộng.
class RoomGrid extends StatelessWidget {
  final List<Room> rooms;

  const RoomGrid(this.rooms, {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final columns = c.maxWidth < 520 ? 1 : (c.maxWidth < 860 ? 2 : 3);
      final width = (c.maxWidth - (columns - 1) * 10) / columns;
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final r in rooms) SizedBox(width: width, child: RoomCard(r)),
        ],
      );
    });
  }
}
