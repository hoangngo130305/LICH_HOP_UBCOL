import 'package:flutter/material.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'checkin_page.dart';
import 'dialogs.dart';
import 'lanhdao_pages.dart';
import 'meeting_form_page.dart';
import 'phongban_pages.dart';
import 'quantri_pages.dart';
import 'thanhvien_pages.dart';
import 'vanthu_pages.dart';

class NavItem {
  final String id;
  final IconData icon;
  final String label;
  final String Function(AppState)? badge;

  const NavItem(this.id, this.icon, this.label, {this.badge});
}

class NavSection {
  final String? title;
  final List<NavItem> items;

  const NavSection(this.items, {this.title});
}

/// Khung ứng dụng: thanh trên + menu trái (hoặc Drawer trên màn hình hẹp).
class ShellScreen extends StatelessWidget {
  const ShellScreen({super.key});

  static List<NavSection> sectionsFor(UserRole role,
          {bool canManageRooms = false}) =>
      switch (role) {
        UserRole.lanhDao => const [
            NavSection([
              NavItem('ld-today', Icons.event_available_outlined,
                  'Lịch hôm nay'),
              NavItem('ld-week', Icons.view_week_outlined, 'Lịch tuần'),
              NavItem('ld-cal', Icons.calendar_month_outlined, 'Lịch tháng'),
            ]),
          ],
        UserRole.vanThu => const [
            NavSection([
              NavItem('vt-list', Icons.list_alt_outlined,
                  'Danh sách lịch họp'),
              NavItem('vt-create', Icons.edit_calendar_outlined,
                  'Tạo lịch họp'),
              NavItem('vt-week', Icons.view_week_outlined, 'Xem theo tuần'),
              NavItem('vt-cal', Icons.calendar_month_outlined,
                  'Xem theo tháng'),
              NavItem('vt-checkin', Icons.fact_check_outlined, 'Điểm danh'),
            ]),
          ],
        UserRole.quanTri => [
            NavSection([
              NavItem('qt-dash', Icons.dashboard_outlined, 'Tổng quan',
                  badge: (s) => '${s.conflicts.length}'),
              const NavItem('qt-rooms', Icons.meeting_room_outlined,
                  'Quản lý phòng'),
              const NavItem('qt-all', Icons.event_note_outlined,
                  'Tất cả lịch họp'),
              NavItem('qt-conflict', Icons.warning_amber_rounded,
                  'Cảnh báo trùng',
                  badge: (s) => '${s.conflicts.length}'),
              const NavItem('qt-members', Icons.groups_outlined,
                  'Thành viên'),
            ]),
          ],
        UserRole.phongBan => [
            NavSection([
              NavItem('pb-list', Icons.event_note_outlined,
                  'Lịch họp của phòng'),
              NavItem('pb-create', Icons.edit_calendar_outlined,
                  'Tạo lịch họp'),
              NavItem('pb-checkin', Icons.fact_check_outlined, 'Điểm danh'),
              const NavItem('pb-members', Icons.groups_outlined,
                  'Thành viên'),
            ], title: 'Lịch họp Văn phòng'),
            const NavSection([
              NavItem('pb-ubnd', Icons.account_balance_outlined,
                  'Lịch Ủy ban (xem)'),
            ], title: 'Lịch chung'),
          ],
        UserRole.thanhVien => [
            NavSection([
              NavItem('tv-invites', Icons.mail_outline, 'Lời mời họp',
                  badge: (s) => '${s.countMyRsvp(Rsvp.pending)}'),
              const NavItem('tv-upcoming', Icons.event_available_outlined,
                  'Lịch sắp tới'),
              const NavItem('tv-history', Icons.history, 'Lịch sử cuộc họp'),
            ], title: 'Của tôi'),
            const NavSection([
              NavItem('tv-day', Icons.today_outlined, 'Theo ngày'),
              NavItem('tv-week', Icons.view_week_outlined, 'Theo tuần'),
              NavItem('tv-month', Icons.calendar_month_outlined,
                  'Theo tháng'),
            ], title: 'Lịch của tôi'),
            const NavSection([
              NavItem('tv-search', Icons.search, 'Tìm kiếm lịch họp'),
            ], title: 'Tra cứu'),
            if (canManageRooms)
              const NavSection([
                NavItem('tv-rooms', Icons.meeting_room_outlined,
                    'Quản lý phòng'),
              ], title: 'Hạ tầng'),
          ],
      };

  static Color accentFor(UserRole role) => switch (role) {
        UserRole.phongBan => AppColors.green,
        UserRole.thanhVien => AppColors.accentText,
        _ => AppColors.accent,
      };

  static Widget pageFor(String id) => switch (id) {
        'ld-today' => const LdTodayPage(),
        'ld-week' => const LdWeekPage(),
        'ld-cal' => const LdMonthPage(),
        'vt-list' => const VtListPage(),
        'vt-create' => const MeetingFormPage(level: MeetingLevel.uyBan),
        'vt-week' => const VtWeekPage(),
        'vt-cal' => const VtCalendarPage(),
        'vt-checkin' => const CheckinPage(level: MeetingLevel.uyBan),
        'qt-dash' => const QtDashboardPage(),
        'qt-rooms' => const QtRoomsPage(),
        'qt-all' => const QtAllMeetingsPage(),
        'qt-conflict' => const QtConflictPage(),
        'qt-members' => const QtMembersPage(),
        'pb-list' => const PbListPage(),
        'pb-create' => const MeetingFormPage(level: MeetingLevel.phongBan),
        'pb-checkin' => const CheckinPage(level: MeetingLevel.phongBan),
        'pb-members' => const PbMembersPage(),
        'pb-ubnd' => const PbUbndPage(),
        'tv-invites' => const TvInvitesPage(),
        'tv-upcoming' => const TvUpcomingPage(),
        'tv-history' => const TvHistoryPage(),
        'tv-day' => const TvDayPage(),
        'tv-week' => const TvWeekPage(),
        'tv-month' => const TvMonthPage(),
        'tv-search' => const TvSearchPage(),
        'tv-rooms' => const QtRoomsPage(),
        _ => const EmptyState(Icons.help_outline, 'Trang không tồn tại'),
      };

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final role = state.role!;
    final wide = MediaQuery.of(context).size.width >= 900;

    final content = Container(
      color: AppColors.s0,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: KeyedSubtree(
          key: ValueKey(state.pageId),
          child: pageFor(state.pageId),
        ),
      ),
    );

    return Scaffold(
      drawer: wide
          ? null
          : Drawer(
              backgroundColor: AppColors.s1,
              child: SafeArea(
                child: _SideMenu(role: role, closeOnTap: true),
              ),
            ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(52),
        child: _TopBar(wide: wide),
      ),
      body: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 210,
                  decoration: const BoxDecoration(
                    color: AppColors.s1,
                    border: Border(
                        right: BorderSide(color: AppColors.bd)),
                  ),
                  child: SingleChildScrollView(
                    child: _SideMenu(role: role, closeOnTap: false),
                  ),
                ),
                Expanded(child: content),
              ],
            )
          : content,
    );
  }
}

class _TopBar extends StatelessWidget {
  final bool wide;

  const _TopBar({required this.wide});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Container(
      color: AppColors.navy,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (!wide)
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white, size: 20),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              )
            else
              const SizedBox(width: 10),
            const Icon(Icons.account_balance, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            const Expanded(
              child: Text('Hệ thống Quản lý Lịch họp',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
            ),
            if (wide) ...[
              const Icon(Icons.account_circle_outlined,
                  color: Color(0xFF8FA8D6), size: 18),
              const SizedBox(width: 6),
              Text(state.userName,
                  style: const TextStyle(
                      color: Color(0xFF8FA8D6), fontSize: 12)),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0x1FFFFFFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(state.roleLabel,
                    style: const TextStyle(
                        color: Color(0xFFC5D8F0), fontSize: 10.5)),
              ),
              const SizedBox(width: 10),
            ],
            const _NotificationBell(),
            TextButton.icon(
              onPressed: state.logout,
              icon: const Icon(Icons.logout, size: 15),
              label: const Text('Thoát', style: TextStyle(fontSize: 12)),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF8FA8D6),
                padding: const EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Chuông thông báo — hiện số đỏ (giống Zalo) khi có thông báo lịch họp
/// mới chưa đọc (theo biên bản họp 22/08/2026, mục 12).
class _NotificationBell extends StatelessWidget {
  const _NotificationBell();

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final count = state.unreadNotificationCount;
    return Padding(
      padding: const EdgeInsets.only(right: 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => showNotificationsDialog(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications_outlined,
                  color: Color(0xFF8FA8D6), size: 20),
              if (count > 0)
                Positioned(
                  top: -4,
                  right: -6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4.5, vertical: 1.5),
                    constraints: const BoxConstraints(minWidth: 16),
                    decoration: BoxDecoration(
                      color: AppColors.danger,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.navy, width: 1.5),
                    ),
                    child: Text(
                      count > 99 ? '99+' : '$count',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          height: 1.2),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SideMenu extends StatelessWidget {
  final UserRole role;
  final bool closeOnTap;

  const _SideMenu({required this.role, required this.closeOnTap});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final accent = ShellScreen.accentFor(role);
    final bg = role == UserRole.phongBan ? AppColors.greenBg : AppColors.accentBg;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (closeOnTap)
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(state.userName,
                    style: const TextStyle(
                        fontSize: 13.5, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(state.roleLabel, style: AppTheme.meta),
              ],
            ),
          ),
        for (final section in ShellScreen.sectionsFor(role,
            canManageRooms: state.canManageRooms)) ...[
          if (section.title == null)
            const SizedBox(height: 10)
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              child: Text(section.title!.toUpperCase(),
                  style: AppTheme.label.copyWith(color: AppColors.tm)),
            ),
          for (final item in section.items)
            _NavTile(
              item: item,
              active: state.pageId == item.id,
              accent: accent,
              activeBg: bg,
              onTap: () {
                state.goTo(item.id);
                if (closeOnTap) Navigator.of(context).pop();
              },
            ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }
}

class _NavTile extends StatelessWidget {
  final NavItem item;
  final bool active;
  final Color accent;
  final Color activeBg;
  final VoidCallback onTap;

  const _NavTile({
    required this.item,
    required this.active,
    required this.accent,
    required this.activeBg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final badge = item.badge?.call(state);
    final showBadge = badge != null && badge != '0';

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(13, 9, 14, 9),
        decoration: BoxDecoration(
          color: active ? activeBg : Colors.transparent,
          border: Border(
            left: BorderSide(
                color: active ? accent : Colors.transparent, width: 3),
          ),
        ),
        child: Row(
          children: [
            Icon(item.icon,
                size: 17, color: active ? accent : AppColors.ts),
            const SizedBox(width: 9),
            Expanded(
              child: Text(item.label,
                  style: TextStyle(
                      fontSize: 12.5,
                      fontWeight:
                          active ? FontWeight.w600 : FontWeight.w400,
                      color: active ? accent : AppColors.ts)),
            ),
            if (showBadge)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.dangerBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(badge,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.dangerText)),
              ),
          ],
        ),
      ),
    );
  }
}
