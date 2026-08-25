import 'dart:typed_data';

import 'package:flutter/material.dart';

/// ===== VAI TRÒ =====
enum UserRole { lanhDao, vanThu, quanTri, phongBan, thanhVien }

extension UserRoleX on UserRole {
  String get userName => switch (this) {
        UserRole.lanhDao => 'Đ/c Nguyễn Văn Nghĩa',
        UserRole.vanThu => 'Nguyễn Thị Lan',
        UserRole.quanTri => 'Trần Minh Đức',
        UserRole.phongBan => 'Lê Thị Mai',
        UserRole.thanhVien => 'Trần Văn Bình',
      };

  String get label => switch (this) {
        UserRole.lanhDao => 'Ban Lãnh đạo',
        UserRole.vanThu => 'Văn thư Ủy ban',
        UserRole.quanTri => 'Quản trị hệ thống (Admin)',
        UserRole.phongBan => 'Văn thư Văn phòng / Phòng ban',
        UserRole.thanhVien => 'Cán bộ, công chức',
      };

  /// Nhãn ngắn hiển thị trên nút chọn vai trò ở màn hình đăng nhập.
  String get shortLabel => switch (this) {
        UserRole.lanhDao => 'Ban Lãnh đạo',
        UserRole.vanThu => 'Văn thư Ủy ban',
        UserRole.quanTri => 'Admin',
        UserRole.phongBan => 'Văn thư đơn vị',
        UserRole.thanhVien => 'Thành viên tham dự',
      };

  String get hint => switch (this) {
        UserRole.lanhDao => 'Xem lịch · Xác nhận tham dự',
        UserRole.vanThu => 'Lên lịch Ủy ban',
        UserRole.quanTri => 'Điều phối phòng họp · Quản lý tài khoản',
        UserRole.phongBan => 'Lịch nội bộ · Quản lý tài khoản cán bộ',
        UserRole.thanhVien =>
          'Nhận lời mời họp · Xem tài liệu',
      };

  IconData get icon => switch (this) {
        UserRole.lanhDao => Icons.workspace_premium_outlined,
        UserRole.vanThu => Icons.edit_calendar_outlined,
        UserRole.quanTri => Icons.meeting_room_outlined,
        UserRole.phongBan => Icons.groups_outlined,
        UserRole.thanhVien => Icons.how_to_reg_outlined,
      };

  /// Trang mặc định sau khi đăng nhập.
  String get homePage => switch (this) {
        UserRole.lanhDao => 'ld-today',
        UserRole.vanThu => 'vt-list',
        UserRole.quanTri => 'qt-dash',
        UserRole.phongBan => 'pb-list',
        UserRole.thanhVien => 'tv-invites',
      };
}

/// ===== THÀNH VIÊN =====
enum AvatarColor { blue, green, purple, amber }

class Member {
  final int id;
  final String name;
  final String title;
  final String unit;
  final String initials;
  final AvatarColor color;
  final String? phone;
  final String? email;

  const Member({
    required this.id,
    required this.name,
    required this.title,
    required this.unit,
    required this.initials,
    required this.color,
    this.phone,
    this.email,
  });
}

/// ===== TÀI LIỆU =====
enum FileKind { pdf, doc, xls, img, other }

class MeetingFile {
  final String name;
  final String size;
  final FileKind kind;
  final int? id;
  final String? url;

  const MeetingFile(this.name, this.size, this.kind, {this.id, this.url});

  IconData get icon => switch (kind) {
        FileKind.pdf => Icons.picture_as_pdf_outlined,
        FileKind.doc => Icons.description_outlined,
        FileKind.xls => Icons.table_chart_outlined,
        FileKind.img => Icons.image_outlined,
        FileKind.other => Icons.insert_drive_file_outlined,
      };
}

/// Một file vừa được chọn ở máy người dùng, chưa gửi lên server (sẽ được
/// tải lên thật khi bấm "Đăng ký lịch"/"Lưu thay đổi").
class PendingFile {
  final String name;
  final int sizeBytes;
  final Uint8List bytes;
  final FileKind kind;

  const PendingFile({
    required this.name,
    required this.sizeBytes,
    required this.bytes,
    required this.kind,
  });

  String get sizeLabel => '${(sizeBytes / 1024).round()} KB';

  IconData get icon => switch (kind) {
        FileKind.pdf => Icons.picture_as_pdf_outlined,
        FileKind.doc => Icons.description_outlined,
        FileKind.xls => Icons.table_chart_outlined,
        FileKind.img => Icons.image_outlined,
        FileKind.other => Icons.insert_drive_file_outlined,
      };
}

/// ===== CUỘC HỌP =====
enum Session { am, pm, allDay }

extension SessionX on Session {
  String get label => switch (this) {
        Session.am => 'Buổi sáng',
        Session.pm => 'Buổi chiều',
        Session.allDay => 'Cả ngày',
      };

  String get shortLabel => switch (this) {
        Session.am => 'Sáng',
        Session.pm => 'Chiều',
        Session.allDay => 'Cả ngày',
      };
}

enum MeetingStatus { upcoming, done, postponed }

/// Cấp lịch: lịch của Ủy ban hay lịch nội bộ phòng ban.
enum MeetingLevel { uyBan, phongBan }

/// Thành phần tham dự của một cuộc họp cụ thể, kèm trạng thái phản hồi
/// thật của riêng cuộc họp đó (khác thành viên nào phản hồi thế nào ở
/// cuộc họp khác — dữ liệu lấy từ bảng `meeting_attendees`).
class Attendee {
  final int memberId;
  final Rsvp status;
  final String? declineReason;

  const Attendee({
    required this.memberId,
    this.status = Rsvp.pending,
    this.declineReason,
  });

  Attendee copyWith({Rsvp? status, String? declineReason}) => Attendee(
        memberId: memberId,
        status: status ?? this.status,
        declineReason: declineReason ?? this.declineReason,
      );
}

class Meeting {
  final int id;
  final String title;
  final DateTime date;
  final TimeOfDay time;
  final Session session;
  final String room;
  final int? roomId;
  final MeetingLevel level;

  /// Đơn vị chủ trì (hiển thị badge). Null với lịch nội bộ phòng.
  final String? unit;
  final String host;
  final List<Attendee> attendees;
  final String content;
  final List<MeetingFile> files;
  final bool conflict;
  final bool postponed;
  final bool isDraft;
  final String minutes;

  const Meeting({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.session,
    required this.room,
    required this.level,
    required this.host,
    required this.attendees,
    required this.content,
    this.roomId,
    this.unit,
    this.files = const [],
    this.conflict = false,
    this.postponed = false,
    this.isDraft = false,
    this.minutes = '',
  });

  String get timeLabel =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  /// "Đã qua" khi ngày họp trước ngày hôm nay thật (lịch đã hoãn không tính đã qua).
  bool get isDone => !postponed && date.isBefore(VnDate.today);

  MeetingStatus get status => postponed
      ? MeetingStatus.postponed
      : (isDone ? MeetingStatus.done : MeetingStatus.upcoming);

  List<int> get memberIds => attendees.map((a) => a.memberId).toList();

  Rsvp rsvpFor(int memberId) => attendees
      .firstWhere(
        (a) => a.memberId == memberId,
        orElse: () => Attendee(memberId: memberId),
      )
      .status;

  Meeting copyWith({
    String? title,
    DateTime? date,
    TimeOfDay? time,
    Session? session,
    String? room,
    int? roomId,
    String? host,
    List<Attendee>? attendees,
    String? content,
    List<MeetingFile>? files,
    bool? conflict,
    String? unit,
    bool? postponed,
    bool? isDraft,
    String? minutes,
  }) {
    return Meeting(
      id: id,
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
      session: session ?? this.session,
      room: room ?? this.room,
      roomId: roomId ?? this.roomId,
      level: level,
      host: host ?? this.host,
      attendees: attendees ?? this.attendees,
      content: content ?? this.content,
      unit: unit ?? this.unit,
      files: files ?? this.files,
      conflict: conflict ?? this.conflict,
      postponed: postponed ?? this.postponed,
      isDraft: isDraft ?? this.isDraft,
      minutes: minutes ?? this.minutes,
    );
  }
}

/// Tìm các cặp lịch trùng: cùng phòng (roomId), cùng ngày, cùng buổi
/// (buổi "Cả ngày" coi là trùng với cả buổi sáng và buổi chiều).
/// Hàm thuần (pure) — không phụ thuộc AppState, dễ kiểm thử độc lập.
List<(Meeting, Meeting)> findMeetingConflicts(List<Meeting> meetings) {
  final result = <(Meeting, Meeting)>[];
  for (var i = 0; i < meetings.length; i++) {
    for (var j = i + 1; j < meetings.length; j++) {
      final a = meetings[i], b = meetings[j];
      if (!a.postponed &&
          !b.postponed &&
          a.roomId != null &&
          a.roomId == b.roomId &&
          VnDate.sameDay(a.date, b.date) &&
          (a.session == b.session ||
              a.session == Session.allDay ||
              b.session == Session.allDay)) {
        result.add((a, b));
      }
    }
  }
  return result;
}

/// ===== PHẢN HỒI LỜI MỜI =====
enum Rsvp { accepted, declined, pending }

extension RsvpX on Rsvp {
  String get label => switch (this) {
        Rsvp.accepted => 'Tham dự',
        Rsvp.declined => 'Từ chối',
        Rsvp.pending => 'Chờ xác nhận',
      };
}

/// ===== PHÒNG HỌP =====
enum RoomStatus { free, busy, conflict }

enum SlotDot { ok, busy, warn }

class RoomSlot {
  final String time;
  final String title;
  final SlotDot dot;
  final bool conflict;

  const RoomSlot(this.time, this.title, this.dot, {this.conflict = false});
}

class Room {
  final int id;
  final String name;
  final String location;
  final int capacity;
  final RoomStatus status;
  final List<RoomSlot> schedule;
  final String? equipment;

  const Room({
    required this.id,
    required this.name,
    required this.location,
    required this.capacity,
    required this.status,
    this.schedule = const [],
    this.equipment,
  });
}

/// ===== ĐIỂM DANH =====
class CheckinRecord {
  final String name;
  final String unit;
  final String? time;

  const CheckinRecord(this.name, this.unit, this.time);

  bool get present => time != null;
}

/// ===== TIỆN ÍCH NGÀY THÁNG (tiếng Việt, không cần package intl) =====
class VnDate {
  /// Ngày hôm nay thật (chỉ lấy phần ngày, bỏ giờ/phút/giây).
  static DateTime get today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static const _short = [
    'T.Hai',
    'T.Ba',
    'T.Tư',
    'T.Năm',
    'T.Sáu',
    'T.Bảy',
    'CN'
  ];
  static const _full = [
    'Thứ Hai',
    'Thứ Ba',
    'Thứ Tư',
    'Thứ Năm',
    'Thứ Sáu',
    'Thứ Bảy',
    'Chủ nhật'
  ];
  static const _grid = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];

  static String dow(DateTime d) => _short[d.weekday - 1];

  static String dowFull(DateTime d) => _full[d.weekday - 1];

  static List<String> get gridHeaders => _grid;

  /// 25/07/2025
  static String dmy(DateTime d) =>
      '${pad2(d.day)}/${pad2(d.month)}/${d.year}';

  /// 25/07
  static String dm(DateTime d) => '${pad2(d.day)}/${pad2(d.month)}';

  /// Thứ Sáu, 25/07/2025
  static String longLabel(DateTime d) => '${dowFull(d)}, ${dmy(d)}';

  static String monthLabel(DateTime d) => 'Tháng ${d.month} / ${d.year}';

  static bool sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Thứ Hai đầu tuần chứa [d].
  static DateTime startOfWeek(DateTime d) =>
      DateTime(d.year, d.month, d.day).subtract(Duration(days: d.weekday - 1));

  static String pad2(int v) => v.toString().padLeft(2, '0');
}
