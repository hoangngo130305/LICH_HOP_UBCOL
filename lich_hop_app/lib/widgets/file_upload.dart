import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/app_theme.dart';
import '../utils/pick_attachment.dart';
import 'common.dart';
import 'meeting_card.dart';

const int kMaxAttachmentBytes = 20 * 1024 * 1024; // 20MB - theo bien ban hop 22/08/2026

const _allowedExt = ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'png', 'jpg', 'jpeg'];

FileKind _kindOfName(String name) {
  final ext = name.contains('.') ? name.split('.').last.toLowerCase() : '';
  return switch (ext) {
    'pdf' => FileKind.pdf,
    'doc' || 'docx' => FileKind.doc,
    'xls' || 'xlsx' => FileKind.xls,
    'png' || 'jpg' || 'jpeg' => FileKind.img,
    _ => FileKind.other,
  };
}

/// Khu vực đính kèm tài liệu — chọn file thật trên máy (PDF/DOCX/XLSX/PNG/JPG,
/// tối đa 20MB/file) và tải lên server thật khi lưu lịch họp.
class FileUploadBox extends StatefulWidget {
  final List<MeetingFile> initialFiles;
  final ValueChanged<List<MeetingFile>> onExistingChanged;
  final ValueChanged<List<PendingFile>> onNewFilesChanged;

  const FileUploadBox({
    super.key,
    this.initialFiles = const [],
    required this.onExistingChanged,
    required this.onNewFilesChanged,
  });

  @override
  State<FileUploadBox> createState() => _FileUploadBoxState();
}

class _FileUploadBoxState extends State<FileUploadBox> {
  late final List<MeetingFile> _existing = List.of(widget.initialFiles);
  final List<PendingFile> _pending = [];

  Future<void> _pick() async {
    final result = await pickAttachmentFile(_allowedExt);
    if (result == null) return;
    if (result.sizeBytes > kMaxAttachmentBytes) {
      if (mounted) {
        showToast(context, 'Tệp "${result.name}" vượt quá 20MB, không thể đính kèm',
            type: NoticeType.warn);
      }
      return;
    }
    setState(() => _pending.add(PendingFile(
          name: result.name,
          sizeBytes: result.sizeBytes,
          bytes: result.bytes,
          kind: _kindOfName(result.name),
        )));
    widget.onNewFilesChanged(List.of(_pending));
    if (mounted) showToast(context, 'Đã chọn: ${result.name}');
  }

  void _removeExisting(int i) {
    setState(() => _existing.removeAt(i));
    widget.onExistingChanged(List.of(_existing));
  }

  void _removePending(int i) {
    setState(() => _pending.removeAt(i));
    widget.onNewFilesChanged(List.of(_pending));
  }

  Widget _row({
    required IconData icon,
    required Color color,
    required String name,
    required String size,
    required VoidCallback onRemove,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.s1,
        border: Border.all(color: AppColors.bd),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Row(
        children: [
          Icon(icon, size: 19, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(name,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500)),
          ),
          Text(size,
              style: const TextStyle(fontSize: 10.5, color: AppColors.tm)),
          IconButton(
            icon: const Icon(Icons.close, size: 15),
            color: AppColors.tm,
            visualDensity: VisualDensity.compact,
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: _pick,
          borderRadius: BorderRadius.circular(AppTheme.radius),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.s1,
              borderRadius: BorderRadius.circular(AppTheme.radius),
              border: Border.all(
                  color: AppColors.bds, style: BorderStyle.solid, width: 1.4),
            ),
            child: const Column(
              children: [
                Icon(Icons.cloud_upload_outlined,
                    size: 26, color: AppColors.tm),
                SizedBox(height: 6),
                Text('Nhấn để chọn tài liệu đính kèm',
                    style: TextStyle(fontSize: 12.5, color: AppColors.ts)),
                SizedBox(height: 2),
                Text(
                    'Hỗ trợ: PDF, DOCX, XLSX, PNG, JPG · Tối đa 20MB mỗi file',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: AppColors.tm)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        for (var i = 0; i < _existing.length; i++)
          _row(
            icon: _existing[i].icon,
            color: AttachmentList.colorOf(_existing[i].kind),
            name: _existing[i].name,
            size: _existing[i].size,
            onRemove: () => _removeExisting(i),
          ),
        for (var i = 0; i < _pending.length; i++)
          _row(
            icon: _pending[i].icon,
            color: AttachmentList.colorOf(_pending[i].kind),
            name: _pending[i].name,
            size: _pending[i].sizeLabel,
            onRemove: () => _removePending(i),
          ),
      ],
    );
  }
}
