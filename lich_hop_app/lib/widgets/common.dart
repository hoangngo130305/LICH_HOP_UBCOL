import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/app_theme.dart';

/// ===== BADGE =====
class AppBadge extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;
  final IconData? icon;

  const AppBadge(this.text,
      {super.key, required this.bg, required this.fg, this.icon});

  factory AppBadge.session(Session s) => switch (s) {
        Session.am => const AppBadge('Buổi sáng',
            bg: AppColors.accentBg, fg: AppColors.accentText),
        Session.pm => const AppBadge('Buổi chiều',
            bg: AppColors.warnBg, fg: AppColors.warnText),
        Session.allDay => const AppBadge('Cả ngày',
            bg: AppColors.greenBg, fg: Color(0xFF3B6D11)),
      };

  factory AppBadge.unit(String unit) => unit == 'Ủy ban'
      ? AppBadge(unit, bg: AppColors.purpleBg, fg: AppColors.purple)
      : AppBadge(unit, bg: AppColors.s0, fg: AppColors.ts);

  factory AppBadge.status(MeetingStatus s) => switch (s) {
        MeetingStatus.done =>
          const AppBadge('Đã kết thúc', bg: AppColors.s0, fg: AppColors.tm),
        MeetingStatus.postponed => const AppBadge('Hoãn',
            bg: AppColors.warnBg,
            fg: AppColors.warnText,
            icon: Icons.pause_circle_outline),
        MeetingStatus.upcoming => const AppBadge('Sắp diễn ra',
            bg: AppColors.greenBg, fg: AppColors.greenText),
      };

  factory AppBadge.rsvp(Rsvp r) => switch (r) {
        Rsvp.accepted => const AppBadge('Tham dự',
            bg: AppColors.greenBg, fg: AppColors.greenText, icon: Icons.check),
        Rsvp.declined => const AppBadge('Từ chối',
            bg: AppColors.dangerBg, fg: AppColors.dangerText, icon: Icons.close),
        Rsvp.pending => const AppBadge('Chờ xác nhận',
            bg: AppColors.warnBg,
            fg: AppColors.warnText,
            icon: Icons.schedule),
      };

  static const conflict = AppBadge('Trùng lịch',
      bg: AppColors.dangerBg,
      fg: AppColors.dangerText,
      icon: Icons.warning_amber_rounded);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: fg),
            const SizedBox(width: 3),
          ],
          Text(text,
              style: TextStyle(
                  fontSize: 10.5, color: fg, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

/// ===== NOTICE =====
enum NoticeType { info, warn, ok, purple }

class Notice extends StatelessWidget {
  final NoticeType type;
  final String text;
  final IconData? icon;
  final Widget? action;

  const Notice(this.text,
      {super.key, this.type = NoticeType.info, this.icon, this.action});

  @override
  Widget build(BuildContext context) {
    final (bg, border, fg, defIcon) = switch (type) {
      NoticeType.info => (
          AppColors.accentBg,
          const Color(0xFFB5D4F4),
          AppColors.accentText,
          Icons.info_outline
        ),
      NoticeType.warn => (
          AppColors.warnBg,
          const Color(0xFFFAC775),
          AppColors.warnText,
          Icons.warning_amber_rounded
        ),
      NoticeType.ok => (
          AppColors.greenBg,
          const Color(0xFF5DCAA5),
          const Color(0xFF085041),
          Icons.check_circle_outline
        ),
      NoticeType.purple => (
          AppColors.purpleBg,
          const Color(0xFFAFA9EC),
          AppColors.purple,
          Icons.notifications_none
        ),
    };

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon ?? defIcon, size: 17, color: fg),
          const SizedBox(width: 9),
          Expanded(
            child: Text(text,
                style: TextStyle(fontSize: 11.5, height: 1.5, color: fg)),
          ),
          if (action != null) ...[const SizedBox(width: 8), action!],
        ],
      ),
    );
  }
}

/// ===== CARD =====
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(16, 14, 16, 16),
    this.margin = const EdgeInsets.only(bottom: 14),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.s2,
        border: Border.all(color: AppColors.bd),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: child,
    );
  }
}

/// Tiêu đề nhỏ in hoa dùng trong card / giữa trang.
class SectionLabel extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color? color;
  final Widget? trailing;

  const SectionLabel(this.text,
      {super.key, this.icon, this.color, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color ?? AppColors.ts),
            const SizedBox(width: 6),
          ],
          Expanded(
            child: Text(
              text.toUpperCase(),
              style: AppTheme.label.copyWith(color: color ?? AppColors.ts),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// ===== TIÊU ĐỀ TRANG =====
class PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? action;

  const PageHeader(this.title, this.subtitle, {super.key, this.action});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTheme.h1),
                const SizedBox(height: 3),
                Text(subtitle, style: AppTheme.sub),
              ],
            ),
          ),
          if (action != null) ...[const SizedBox(width: 12), action!],
        ],
      ),
    );
  }
}

/// ===== THẺ SỐ LIỆU =====
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const StatCard(this.label, this.value, {super.key, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.s1,
        border: Border.all(color: AppColors.bd),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 11.5, color: AppColors.ts),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? AppColors.tp)),
        ],
      ),
    );
  }
}

/// Hàng thẻ số liệu tự xuống dòng theo bề rộng.
class StatRow extends StatelessWidget {
  final List<StatCard> children;

  const StatRow(this.children, {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final int perRow = c.maxWidth < 460
          ? (children.length < 2 ? 1 : 2)
          : (children.length > 4 ? 4 : children.length);
      final width = (c.maxWidth - (perRow - 1) * 10) / perRow;
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final child in children)
              SizedBox(width: width, child: child),
          ],
        ),
      );
    });
  }
}

/// ===== AVATAR =====
class MemberAvatar extends StatelessWidget {
  final Member member;
  final double size;

  const MemberAvatar(this.member, {super.key, this.size = 32});

  static (Color, Color) colorsOf(AvatarColor c) => switch (c) {
        AvatarColor.blue => (AppColors.accentBg, AppColors.accentText),
        AvatarColor.green => (AppColors.greenBg, AppColors.green),
        AvatarColor.purple => (AppColors.purpleBg, AppColors.purple),
        AvatarColor.amber => (AppColors.warnBg, AppColors.warnText),
      };

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = colorsOf(member.color);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Text(
        member.initials,
        style: TextStyle(
            fontSize: size * .36, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }
}

/// Một dòng thành viên: avatar + tên + chức danh (+ badge phản hồi).
class MemberRow extends StatelessWidget {
  final Member member;
  final Rsvp? rsvp;
  final bool divider;
  final VoidCallback? onEdit;

  const MemberRow(this.member,
      {super.key, this.rsvp, this.divider = true, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: divider
          ? const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.bd)))
          : null,
      child: Row(
        children: [
          MemberAvatar(member),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.name, style: AppTheme.itemTitle),
                const SizedBox(height: 2),
                Text('${member.title} · ${member.unit}',
                    style: AppTheme.meta),
              ],
            ),
          ),
          if (rsvp != null) AppBadge.rsvp(rsvp!),
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 17),
              color: AppColors.tm,
              visualDensity: VisualDensity.compact,
              tooltip: 'Sửa thông tin',
              onPressed: onEdit,
            ),
        ],
      ),
    );
  }
}

/// ===== PHÂN TRANG =====
/// Thanh điều hướng trang: ‹ Trang 2 / 3 (11–20 / 23) ›
class Paginator extends StatelessWidget {
  final int page;
  final int pageCount;
  final int totalItems;
  final int pageSize;
  final ValueChanged<int> onChanged;

  const Paginator({
    super.key,
    required this.page,
    required this.pageCount,
    required this.totalItems,
    required this.pageSize,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (pageCount <= 1) return const SizedBox.shrink();
    final from = page * pageSize + 1;
    final to = (page * pageSize + pageSize).clamp(0, totalItems);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Hiển thị $from–$to / $totalItems', style: AppTheme.meta),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, size: 20),
                color: AppColors.ts,
                onPressed: page > 0 ? () => onChanged(page - 1) : null,
              ),
              Text('Trang ${page + 1} / $pageCount',
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
              IconButton(
                icon: const Icon(Icons.chevron_right, size: 20),
                color: AppColors.ts,
                onPressed: page < pageCount - 1 ? () => onChanged(page + 1) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ===== NÚT =====
class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color color;

  const PrimaryButton(this.label,
      {super.key, this.icon, this.onPressed, this.color = AppColors.navy});

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: icon == null ? null : Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12.5)),
      style: FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radius)),
      ),
    );
  }
}

class GhostButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color? color;

  const GhostButton(this.label,
      {super.key, this.icon, this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: icon == null ? null : Icon(icon, size: 15),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: OutlinedButton.styleFrom(
        foregroundColor: color ?? AppColors.ts,
        side: const BorderSide(color: AppColors.bds),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radius)),
      ),
    );
  }
}

/// Nút nhỏ dạng "chip" giống prototype.
class ChipButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback onTap;
  final Color? color;
  final String? tooltip;

  const ChipButton(this.icon,
      {super.key, this.label, required this.onTap, this.color, this.tooltip});

  @override
  Widget build(BuildContext context) {
    final child = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radius),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: label == null ? 8 : 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.s2,
          border: Border.all(color: AppColors.bds),
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: color ?? AppColors.ts),
            if (label != null) ...[
              const SizedBox(width: 4),
              Text(label!,
                  style:
                      TextStyle(fontSize: 11.5, color: color ?? AppColors.ts)),
            ],
          ],
        ),
      ),
    );
    return tooltip == null ? child : Tooltip(message: tooltip!, child: child);
  }
}

/// ===== TAB =====
/// Thanh tab đơn giản (không dùng TabBarView để đặt được trong ScrollView).
class AppTabs extends StatelessWidget {
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;

  const AppTabs(this.labels,
      {super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.bd)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var i = 0; i < labels.length; i++)
              InkWell(
                onTap: () => onChanged(i),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: i == selected
                            ? AppColors.navy
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(labels[i],
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight:
                            i == selected ? FontWeight.w600 : FontWeight.w400,
                        color: i == selected ? AppColors.navy : AppColors.ts,
                      )),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// ===== DROPDOWN =====
/// Bọc DropdownButton trong khung giống ô nhập liệu (tránh phụ thuộc
/// vào API DropdownButtonFormField vốn đổi tên tham số giữa các bản Flutter).
class AppDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String Function(T) labelOf;
  final ValueChanged<T?> onChanged;
  final String? hint;

  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.labelOf,
    required this.onChanged,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.bds),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          isDense: true,
          hint: hint == null
              ? null
              : Text(hint!,
                  style: const TextStyle(fontSize: 12.5, color: AppColors.tm)),
          icon: const Icon(Icons.expand_more, size: 18, color: AppColors.tm),
          style: const TextStyle(fontSize: 12.5, color: AppColors.tp),
          padding: const EdgeInsets.symmetric(vertical: 10),
          items: [
            for (final item in items)
              DropdownMenuItem<T>(
                value: item,
                child: Text(labelOf(item),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12.5)),
              ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

/// Nhãn + widget nhập liệu, dùng chung cho các form.
class FormField2 extends StatelessWidget {
  final String label;
  final Widget child;
  final bool required;

  const FormField2(this.label, this.child,
      {super.key, this.required = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.ts),
              children: [
                if (required)
                  const TextSpan(
                      text: ' *', style: TextStyle(color: AppColors.danger)),
              ],
            ),
          ),
          const SizedBox(height: 5),
          child,
        ],
      ),
    );
  }
}

/// ===== TRẠNG THÁI RỖNG =====
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String text;

  const EmptyState(this.icon, this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(icon, size: 34, color: AppColors.tm),
          const SizedBox(height: 10),
          Text(text,
              style: const TextStyle(fontSize: 12.5, color: AppColors.tm)),
        ],
      ),
    );
  }
}

/// ===== TOAST =====
void showToast(BuildContext context, String message, {NoticeType? type}) {
  final bg = switch (type) {
    NoticeType.ok => AppColors.greenText,
    NoticeType.warn => AppColors.warnText,
    _ => AppColors.navy,
  };
  final icon = switch (type) {
    NoticeType.ok => Icons.check_circle_outline,
    NoticeType.warn => Icons.warning_amber_rounded,
    _ => Icons.info_outline,
  };
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      backgroundColor: bg,
      duration: const Duration(seconds: 3),
      width: 360,
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message,
                style: const TextStyle(color: Colors.white, fontSize: 12.5)),
          ),
        ],
      ),
    ));
}

/// ===== DIALOG CHUẨN =====
Future<T?> showAppDialog<T>(
  BuildContext context, {
  required String title,
  required Widget body,
  List<Widget> actions = const [],
  double width = 520,
}) {
  return showDialog<T>(
    context: context,
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: width,
          maxHeight: MediaQuery.of(context).size.height * .88,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 12, 14),
              decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: AppColors.bd)),
              ),
              child: Row(
                children: [
                  Expanded(child: Text(title, style: AppTheme.h2)),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    color: AppColors.ts,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                child: body,
              ),
            ),
            if (actions.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.bd)),
                ),
                child: Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 8,
                  runSpacing: 8,
                  children: actions,
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

/// Dòng thông tin có icon dùng trong dialog chi tiết cuộc họp.
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Widget? child;

  const InfoRow(this.icon, this.label, this.value, {super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 17, color: AppColors.tm),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTheme.meta),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500)),
                if (child != null) ...[const SizedBox(height: 6), child!],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
