import 'package:flutter/material.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/file_upload.dart';
import '../widgets/member_selector.dart';

/// Form tạo / chỉnh sửa lịch họp – dùng chung cho Văn thư (cấp Ủy ban)
/// và Hành chính phòng ban (lịch nội bộ).
class MeetingFormPage extends StatefulWidget {
  final MeetingLevel level;

  const MeetingFormPage({super.key, required this.level});

  @override
  State<MeetingFormPage> createState() => _MeetingFormPageState();
}

class _MeetingFormPageState extends State<MeetingFormPage> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  final _hostCtrl = TextEditingController();
  final _sizeCtrl = TextEditingController(text: '20');
  final _placeCtrl = TextEditingController();

  DateTime _date = VnDate.today.add(const Duration(days: 5));
  TimeOfDay _time = const TimeOfDay(hour: 8, minute: 0);
  Session _session = Session.am;
  Room? _room;
  String? _unit;
  List<int> _members = [];
  List<MeetingFile> _existingFiles = [];
  List<PendingFile> _newFiles = [];
  int? _editingId;
  bool _submitting = false;

  bool get _isUbnd => widget.level == MeetingLevel.uyBan;
  bool get _isEditing => _editingId != null;

  /// Danh sách 5 lãnh đạo phường – cài đặt sẵn (preset) để chọn nhanh khi
  /// tạo lịch họp cấp Ủy ban (theo biên bản họp 22/08/2026: bỏ ô "Chủ trì
  /// cuộc họp" tự gõ tay, đổi "Đơn vị chủ trì" thành "Người chủ trì").
  List<String> _leaderNames(AppState state) => state.members
      .where((m) => m.unit == 'Ban lãnh đạo phường')
      .map((m) => m.name)
      .toList();

  @override
  void initState() {
    super.initState();
    final state = AppScope.read(context);
    final editing = state.meetingBeingEdited;
    state.clearEdit();

    final leaders = _leaderNames(state);
    final units = state.members.map((m) => m.unit).toSet().toList()..sort();

    if (editing != null) {
      _editingId = editing.id;
      _titleCtrl.text = editing.title;
      _contentCtrl.text = editing.content;
      _hostCtrl.text = editing.host;
      _sizeCtrl.text = '20';
      _placeCtrl.text = _isUbnd ? '' : editing.room;
      _date = editing.date;
      _time = editing.time;
      _session = editing.session;
      _unit = _isUbnd
          ? (editing.unit ?? (leaders.isEmpty ? null : leaders.first))
          : (editing.unit ?? (units.isEmpty ? null : units.first));
      _members = List.of(editing.memberIds);
      _existingFiles = List.of(editing.files);
      if (_isUbnd && editing.roomId != null) {
        _room = state.rooms.where((r) => r.id == editing.roomId).firstOrNull;
      }
    } else {
      _placeCtrl.text = 'Tại phòng làm việc ${state.unitLabel}';
      _unit = _isUbnd
          ? (leaders.isEmpty ? null : leaders.first)
          : (units.isEmpty ? null : units.first);
      _members = [];
      _existingFiles = [];
      _hostCtrl.text = _isUbnd ? (_unit ?? '') : state.userName;
      _room = state.rooms.isEmpty ? null : state.rooms.first;
    }
  }

  /// Khi chọn người chủ trì, tự điền tên người đó vào đầu nội dung cuộc
  /// họp (theo biên bản họp: "nội dung tự động hiển thị kèm tên người
  /// chủ trì ở đầu dòng"), chỉ khi nội dung đang trống hoặc đang là
  /// prefix của người chủ trì trước đó (để không ghi đè nội dung đã gõ).
  void _onLeaderChanged(String? name) {
    if (name == null) return;
    final oldPrefix = '${_hostCtrl.text}: ';
    setState(() {
      if (_contentCtrl.text.isEmpty || _contentCtrl.text.startsWith(oldPrefix)) {
        final rest = _contentCtrl.text.startsWith(oldPrefix)
            ? _contentCtrl.text.substring(oldPrefix.length)
            : '';
        _contentCtrl.text = '$name: $rest';
      }
      _unit = name;
      _hostCtrl.text = name;
    });
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    _hostCtrl.dispose();
    _sizeCtrl.dispose();
    _placeCtrl.dispose();
    super.dispose();
  }

  /// Cảnh báo trùng phòng theo lựa chọn hiện tại.
  Meeting? get _clash {
    if (!_isUbnd || _room == null) return null;
    final state = AppScope.of(context);
    for (final m in state.ubndMeetings) {
      if (_isEditing && m.id == _editingId) continue;
      if (m.roomId == _room!.id &&
          VnDate.sameDay(m.date, _date) &&
          (m.session == _session ||
              m.session == Session.allDay ||
              _session == Session.allDay)) {
        return m;
      }
    }
    return null;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      helpText: 'Chọn ngày họp',
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time,
      helpText: 'Chọn giờ bắt đầu',
    );
    if (picked != null) {
      setState(() {
        _time = picked;
        if (picked.hour < 12) {
          _session = Session.am;
        } else if (_session == Session.am) {
          _session = Session.pm;
        }
      });
    }
  }

  Future<void> _submit({bool asDraft = false}) async {
    final state = AppScope.read(context);
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      showToast(context, 'Vui lòng nhập tiêu đề cuộc họp',
          type: NoticeType.warn);
      return;
    }
    if (_members.isEmpty) {
      showToast(context, 'Vui lòng chọn thành phần tham dự',
          type: NoticeType.warn);
      return;
    }

    setState(() => _submitting = true);
    final host =
        _hostCtrl.text.trim().isEmpty ? 'Chưa phân công' : _hostCtrl.text.trim();
    final estimated = int.tryParse(_sizeCtrl.text.trim());

    final bool ok;
    if (_isEditing) {
      ok = await state.updateMeetingFull(
        id: _editingId!,
        title: title,
        date: _date,
        time: _time,
        session: _session,
        content: _contentCtrl.text.trim(),
        memberIds: _members,
        host: host,
        roomId: _isUbnd ? _room?.id : null,
        locationText: _isUbnd ? null : _placeCtrl.text.trim(),
        unit: _isUbnd ? _unit : state.unit,
        estimatedPeople: estimated,
        keepExistingFiles: _existingFiles,
        newFiles: _newFiles,
        isDraft: asDraft,
      );
    } else {
      ok = await state.addMeeting(
        title: title,
        date: _date,
        time: _time,
        session: _session,
        level: widget.level,
        host: host,
        memberIds: _members,
        content: _contentCtrl.text.trim(),
        roomId: _isUbnd ? _room?.id : null,
        locationText: _isUbnd ? null : _placeCtrl.text.trim(),
        unit: _isUbnd ? _unit : state.unit,
        estimatedPeople: estimated,
        newFiles: _newFiles,
        isDraft: asDraft,
      );
    }

    if (!mounted) return;
    setState(() => _submitting = false);
    showToast(
      context,
      ok
          ? (asDraft
              ? 'Đã lưu nháp lịch họp'
              : (_isEditing ? 'Đã lưu thay đổi!' : 'Đã lưu lịch họp thành công!'))
          : 'Có lỗi khi lưu, vui lòng thử lại (${state.lastError ?? ''})',
      type: ok ? NoticeType.ok : NoticeType.warn,
    );
    if (ok) {
      state.goTo(_isUbnd ? 'vt-list' : 'pb-list');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final clash = _clash;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(
          _isEditing
              ? 'Chỉnh sửa lịch họp'
              : (_isUbnd ? 'Tạo lịch họp mới' : 'Tạo lịch họp nội bộ'),
          _isUbnd
              ? 'Đăng ký lịch họp cấp Ủy ban'
              : 'Phòng tự tổ chức tại phòng làm việc',
        ),
        if (_isUbnd)
          clash == null
              ? const Notice(
                  'Phòng họp đang trống trong buổi đã chọn. Có thể đăng ký lịch.',
                  type: NoticeType.ok,
                )
              : Notice(
                  '${_room?.name ?? ''} đã có "${clash.title}" lúc ${clash.timeLabel} '
                  '(${clash.session.label.toLowerCase()}) ngày ${VnDate.dm(_date)}. '
                  'Hệ thống chỉ cảnh báo, vẫn cho phép lưu — hãy xác nhận với các bên liên quan.',
                  type: NoticeType.warn,
                )
        else
          const Notice(
            'Lịch họp này do phòng tự tổ chức tại phòng làm việc. '
            'Không cần đặt phòng họp qua quản trị.',
            type: NoticeType.ok,
          ),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _FormSection('Thông tin cơ bản', Icons.info_outline),
              FormField2(
                'Tiêu đề cuộc họp',
                TextField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(
                      hintText: 'VD: Họp triển khai kế hoạch tháng 8'),
                ),
                required: true,
              ),
              if (_isUbnd)
                FormField2(
                  'Người chủ trì',
                  AppDropdown<String>(
                    value: _unit,
                    items: _leaderNames(state),
                    hint: 'Chọn người chủ trì',
                    labelOf: (v) => v,
                    onChanged: _onLeaderChanged,
                  ),
                  required: true,
                ),
              FormField2(
                'Nội dung / Mục tiêu',
                TextField(
                  controller: _contentCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      hintText: 'Mô tả ngắn nội dung sẽ thảo luận...'),
                ),
              ),
              const _FormSection('Thời gian', Icons.schedule),
              _twoCols(
                FormField2(
                  'Ngày họp',
                  _PickerField(
                    icon: Icons.calendar_today_outlined,
                    text: VnDate.longLabel(_date),
                    onTap: _pickDate,
                  ),
                  required: true,
                ),
                FormField2(
                  'Giờ bắt đầu',
                  _PickerField(
                    icon: Icons.access_time,
                    text:
                        '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}',
                    onTap: _pickTime,
                  ),
                  required: true,
                ),
              ),
              FormField2(
                'Buổi',
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final s in Session.values)
                      _SessionChip(
                        label: s.label,
                        selected: _session == s,
                        onTap: () => setState(() => _session = s),
                      ),
                  ],
                ),
                required: true,
              ),
              const _FormSection(
                  'Địa điểm & Thành phần', Icons.meeting_room_outlined),
              if (_isUbnd)
                _twoCols(
                  FormField2(
                    'Phòng họp',
                    AppDropdown<Room>(
                      value: _room,
                      items: state.rooms,
                      labelOf: (r) => '${r.name} – ${r.location}',
                      onChanged: (v) => setState(() => _room = v ?? _room),
                    ),
                  ),
                  FormField2(
                    'Ước tính số người',
                    TextField(
                      controller: _sizeCtrl,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                )
              else
                FormField2(
                  'Địa điểm họp',
                  TextField(controller: _placeCtrl),
                ),
              FormField2(
                'Thành phần tham dự',
                MemberSelector(
                  allMembers: state.members,
                  initialSelected: _members,
                  onChanged: (ids) => setState(() => _members = ids),
                  onAddCustom: (name) => state.addCustomAttendeeName(name),
                ),
                required: true,
              ),
              const _FormSection('Tài liệu đính kèm', Icons.attach_file),
              FileUploadBox(
                initialFiles: _existingFiles,
                onExistingChanged: (files) => _existingFiles = files,
                onNewFilesChanged: (files) => _newFiles = files,
              ),
              const Divider(height: 28),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 8,
                runSpacing: 8,
                children: [
                  GhostButton('Hủy',
                      onPressed: _submitting
                          ? null
                          : () => state.goTo(_isUbnd ? 'vt-list' : 'pb-list')),
                  GhostButton('Lưu nháp',
                      icon: Icons.save_outlined,
                      onPressed:
                          _submitting ? null : () => _submit(asDraft: true)),
                  PrimaryButton(
                    _submitting
                        ? 'Đang lưu...'
                        : (_isEditing
                            ? 'Lưu thay đổi'
                            : (_isUbnd ? 'Đăng ký lịch' : 'Lưu lịch họp')),
                    icon: Icons.event_available_outlined,
                    color: _isUbnd ? AppColors.navy : AppColors.green,
                    onPressed: _submitting ? null : _submit,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _twoCols(Widget a, Widget b) {
    return LayoutBuilder(builder: (context, c) {
      if (c.maxWidth < 520) {
        return Column(children: [a, b]);
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: a),
          const SizedBox(width: 12),
          Expanded(child: b),
        ],
      );
    });
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

class _FormSection extends StatelessWidget {
  final String title;
  final IconData icon;

  const _FormSection(this.title, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 6, bottom: 12),
      padding: const EdgeInsets.only(bottom: 6),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.bd)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.ts),
          const SizedBox(width: 6),
          Text(title.toUpperCase(), style: AppTheme.label),
        ],
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _PickerField(
      {required this.icon, required this.text, required this.onTap});

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
            Icon(icon, size: 16, color: AppColors.tm),
            const SizedBox(width: 8),
            Expanded(
              child: Text(text,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12.5)),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SessionChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.greenBg : Colors.white,
          border: Border.all(
              color: selected ? AppColors.okGreen : AppColors.bds),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: selected ? AppColors.greenText : AppColors.ts)),
      ),
    );
  }
}
