import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/app_theme.dart';
import 'common.dart';

/// Ô chọn thành phần tham dự: tìm kiếm → chọn → hiển thị dạng tag.
class MemberSelector extends StatefulWidget {
  final List<Member> allMembers;
  final List<int> initialSelected;
  final ValueChanged<List<int>> onChanged;

  /// Thêm người "Khác" (nhập tay, chưa có trong danh bạ). Trả về id thành
  /// viên mới nếu thành công. Nếu null, ẩn tùy chọn "Khác".
  final Future<int?> Function(String name)? onAddCustom;

  const MemberSelector({
    super.key,
    required this.allMembers,
    this.initialSelected = const [],
    required this.onChanged,
    this.onAddCustom,
  });

  @override
  State<MemberSelector> createState() => _MemberSelectorState();
}

class _MemberSelectorState extends State<MemberSelector> {
  late final List<int> _selected = List.of(widget.initialSelected);
  final _controller = TextEditingController();
  final _focus = FocusNode();
  String _query = '';
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      if (_focus.hasFocus) setState(() => _open = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  Member? _memberById(int id) {
    for (final m in widget.allMembers) {
      if (m.id == id) return m;
    }
    return null;
  }

  List<Member> get _filtered {
    final q = _query.trim().toLowerCase();
    return widget.allMembers
        .where((m) =>
            !_selected.contains(m.id) &&
            (q.isEmpty ||
                m.name.toLowerCase().contains(q) ||
                m.unit.toLowerCase().contains(q) ||
                m.title.toLowerCase().contains(q)))
        .toList();
  }

  void _add(int id) {
    setState(() {
      _selected.add(id);
      _controller.clear();
      _query = '';
    });
    widget.onChanged(List.of(_selected));
  }

  bool _addingCustom = false;

  Future<void> _addCustom(String name) async {
    if (widget.onAddCustom == null || name.trim().isEmpty) return;
    setState(() => _addingCustom = true);
    final id = await widget.onAddCustom!(name.trim());
    if (!mounted) return;
    setState(() => _addingCustom = false);
    if (id != null) _add(id);
  }

  void _remove(int id) {
    setState(() => _selected.remove(id));
    widget.onChanged(List.of(_selected));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          focusNode: _focus,
          onChanged: (v) => setState(() {
            _query = v;
            _open = true;
          }),
          decoration: InputDecoration(
            hintText: 'Tìm theo tên hoặc đơn vị...',
            prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.tm),
            suffixIcon: IconButton(
              icon: Icon(_open ? Icons.expand_less : Icons.expand_more,
                  size: 18, color: AppColors.tm),
              onPressed: () => setState(() => _open = !_open),
            ),
          ),
        ),
        if (_open) ...[
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 190),
            decoration: BoxDecoration(
              color: AppColors.s2,
              border: Border.all(color: AppColors.bd),
              borderRadius: BorderRadius.circular(AppTheme.radius),
            ),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                if (_filtered.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Không tìm thấy thành viên',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 12, color: AppColors.tm)),
                  )
                else
                  for (final m in _filtered)
                    InkWell(
                      onTap: () => _add(m.id),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            MemberAvatar(m, size: 28),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(m.name,
                                      style: const TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w500)),
                                  Text('${m.title} · ${m.unit}',
                                      style: const TextStyle(
                                          fontSize: 10.5,
                                          color: AppColors.tm)),
                                ],
                              ),
                            ),
                            const Icon(Icons.add,
                                size: 16, color: AppColors.tm),
                          ],
                        ),
                      ),
                    ),
                if (widget.onAddCustom != null && _query.trim().isNotEmpty)
                  InkWell(
                    onTap: _addingCustom ? null : () => _addCustom(_query),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.person_add_alt_outlined,
                              size: 18, color: AppColors.accent),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _addingCustom
                                  ? 'Đang thêm...'
                                  : 'Khác: thêm "${_query.trim()}" (nhập tay)',
                              style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.accent),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.s2,
            border: Border.all(color: AppColors.bds),
            borderRadius: BorderRadius.circular(AppTheme.radius),
          ),
          child: _selected.isEmpty
              ? const Text('Chưa chọn thành viên nào',
                  style: TextStyle(fontSize: 11.5, color: AppColors.tm))
              : Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    for (final id in _selected)
                      if (_memberById(id) != null)
                        _MemberTag(
                          _memberById(id)!,
                          onRemove: () => _remove(id),
                        ),
                  ],
                ),
        ),
        const SizedBox(height: 4),
        Text('Đã chọn ${_selected.length} thành viên',
            style: const TextStyle(fontSize: 11, color: AppColors.tm)),
      ],
    );
  }
}

class _MemberTag extends StatelessWidget {
  final Member member;
  final VoidCallback onRemove;

  const _MemberTag(this.member, {required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = MemberAvatar.colorsOf(member.color);
    return Container(
      padding: const EdgeInsets.fromLTRB(3, 3, 6, 3),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MemberAvatar(member, size: 20),
          const SizedBox(width: 5),
          Text(member.name, style: TextStyle(fontSize: 11.5, color: fg)),
          const SizedBox(width: 4),
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(10),
            child: Icon(Icons.close, size: 13, color: fg),
          ),
        ],
      ),
    );
  }
}
