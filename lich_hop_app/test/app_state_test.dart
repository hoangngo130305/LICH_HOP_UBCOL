import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lich_hop_app/models/models.dart';

/// Ghi chú: từ bản 3.0 (nối Supabase), AppState là lớp gọi mạng thật
/// (đăng nhập, đọc/ghi Postgres) nên không còn phù hợp để unit-test đồng bộ
/// như trước. Bộ test này tập trung kiểm thử phần lõi nghiệp vụ THUẦN
/// (không phụ thuộc mạng): mô hình dữ liệu và thuật toán phát hiện trùng
/// lịch `findMeetingConflicts` — đúng phần quan trọng nhất, dễ sai nhất.

Meeting _m({
  required int id,
  required DateTime date,
  required Session session,
  int? roomId,
  List<Attendee> attendees = const [],
  MeetingLevel level = MeetingLevel.uyBan,
}) {
  return Meeting(
    id: id,
    title: 'Cuộc họp $id',
    date: date,
    time: const TimeOfDay(hour: 8, minute: 0),
    session: session,
    room: 'Phòng $roomId',
    roomId: roomId,
    level: level,
    host: 'Chủ trì',
    attendees: attendees,
    content: 'Nội dung',
  );
}

void main() {
  group('Tiện ích ngày tháng tiếng Việt', () {
    test('định dạng ngày đúng', () {
      final d = DateTime(2025, 7, 25); // thứ Sáu
      expect(VnDate.dmy(d), '25/07/2025');
      expect(VnDate.dm(d), '25/07');
      expect(VnDate.dow(d), 'T.Sáu');
      expect(VnDate.dowFull(d), 'Thứ Sáu');
      expect(VnDate.longLabel(d), 'Thứ Sáu, 25/07/2025');
    });

    test('đầu tuần luôn rơi vào thứ Hai', () {
      for (var i = 0; i < 14; i++) {
        final d = DateTime(2025, 7, 20).add(Duration(days: i));
        expect(VnDate.startOfWeek(d).weekday, DateTime.monday);
      }
    });

    test('so sánh cùng ngày bỏ qua giờ phút', () {
      expect(
        VnDate.sameDay(DateTime(2025, 7, 25, 8), DateTime(2025, 7, 25, 20)),
        isTrue,
      );
      expect(
        VnDate.sameDay(DateTime(2025, 7, 25), DateTime(2025, 7, 26)),
        isFalse,
      );
    });

    test('VnDate.today là ngày hiện tại thật, không lệch giờ/phút', () {
      final now = DateTime.now();
      expect(VnDate.today.year, now.year);
      expect(VnDate.today.month, now.month);
      expect(VnDate.today.day, now.day);
      expect(VnDate.today.hour, 0);
    });
  });

  group('Meeting / Attendee — trạng thái phản hồi & lịch đã qua', () {
    test('rsvpFor trả đúng trạng thái từng thành viên, mặc định pending', () {
      final m = _m(id: 1, date: VnDate.today, session: Session.am, attendees: [
        const Attendee(memberId: 1, status: Rsvp.accepted),
        const Attendee(memberId: 2, status: Rsvp.declined, declineReason: 'Bận'),
      ]);
      expect(m.rsvpFor(1), Rsvp.accepted);
      expect(m.rsvpFor(2), Rsvp.declined);
      expect(m.rsvpFor(999), Rsvp.pending); // chưa được mời -> mặc định
    });

    test('memberIds phái sinh đúng từ danh sách attendees', () {
      final m = _m(id: 1, date: VnDate.today, session: Session.am, attendees: [
        const Attendee(memberId: 5),
        const Attendee(memberId: 8),
      ]);
      expect(m.memberIds, [5, 8]);
    });

    test('isDone / status tính đúng theo ngày hôm nay thật', () {
      final past = _m(
          id: 1,
          date: VnDate.today.subtract(const Duration(days: 1)),
          session: Session.am);
      final future = _m(
          id: 2,
          date: VnDate.today.add(const Duration(days: 1)),
          session: Session.am);
      expect(past.isDone, isTrue);
      expect(past.status, MeetingStatus.done);
      expect(future.isDone, isFalse);
      expect(future.status, MeetingStatus.upcoming);
    });

    test('Attendee.copyWith chỉ thay đổi trường được truyền vào', () {
      const a = Attendee(memberId: 1, status: Rsvp.pending);
      final b = a.copyWith(status: Rsvp.accepted);
      expect(b.memberId, 1);
      expect(b.status, Rsvp.accepted);
    });
  });

  group('findMeetingConflicts — quy tắc phát hiện trùng lịch', () {
    test('cùng phòng + cùng ngày + cùng buổi -> trùng', () {
      final a = _m(id: 1, date: DateTime(2026, 8, 21), session: Session.am, roomId: 1);
      final b = _m(id: 2, date: DateTime(2026, 8, 21), session: Session.am, roomId: 1);
      final result = findMeetingConflicts([a, b]);
      expect(result.length, 1);
    });

    test('khác phòng -> không trùng dù cùng ngày cùng buổi', () {
      final a = _m(id: 1, date: DateTime(2026, 8, 21), session: Session.am, roomId: 1);
      final b = _m(id: 2, date: DateTime(2026, 8, 21), session: Session.am, roomId: 2);
      expect(findMeetingConflicts([a, b]), isEmpty);
    });

    test('khác ngày -> không trùng dù cùng phòng cùng buổi', () {
      final a = _m(id: 1, date: DateTime(2026, 8, 21), session: Session.am, roomId: 1);
      final b = _m(id: 2, date: DateTime(2026, 8, 22), session: Session.am, roomId: 1);
      expect(findMeetingConflicts([a, b]), isEmpty);
    });

    test('buổi sáng và buổi chiều cùng phòng cùng ngày -> không trùng', () {
      final a = _m(id: 1, date: DateTime(2026, 8, 21), session: Session.am, roomId: 1);
      final b = _m(id: 2, date: DateTime(2026, 8, 21), session: Session.pm, roomId: 1);
      expect(findMeetingConflicts([a, b]), isEmpty);
    });

    test('buổi "Cả ngày" trùng với cả buổi sáng và buổi chiều', () {
      final allDay =
          _m(id: 1, date: DateTime(2026, 8, 21), session: Session.allDay, roomId: 1);
      final am = _m(id: 2, date: DateTime(2026, 8, 21), session: Session.am, roomId: 1);
      final pm = _m(id: 3, date: DateTime(2026, 8, 21), session: Session.pm, roomId: 1);
      expect(findMeetingConflicts([allDay, am]).length, 1);
      expect(findMeetingConflicts([allDay, pm]).length, 1);
    });

    test('không có roomId (lịch nội bộ phòng ban) -> không bao giờ tính trùng', () {
      final a = _m(id: 1, date: DateTime(2026, 8, 21), session: Session.am, roomId: null);
      final b = _m(id: 2, date: DateTime(2026, 8, 21), session: Session.am, roomId: null);
      expect(findMeetingConflicts([a, b]), isEmpty);
    });

    test('phát hiện đúng nhiều cặp trùng trong một danh sách lớn hơn', () {
      final list = [
        _m(id: 1, date: DateTime(2026, 8, 21), session: Session.am, roomId: 1),
        _m(id: 2, date: DateTime(2026, 8, 21), session: Session.am, roomId: 1),
        _m(id: 3, date: DateTime(2026, 8, 21), session: Session.pm, roomId: 2),
        _m(id: 4, date: DateTime(2026, 8, 22), session: Session.am, roomId: 1),
        _m(id: 5, date: DateTime(2026, 8, 21), session: Session.pm, roomId: 2),
      ];
      final result = findMeetingConflicts(list);
      expect(result.length, 2); // (1,2) va (3,5)
    });
  });
}
