import 'package:file_picker/file_picker.dart';

import 'pick_attachment_result.dart';

/// Bản Android/Windows — dùng gói file_picker gốc (không qua trình duyệt).
Future<PickedFile?> pickAttachmentFile(List<String> allowedExtensions) async {
  final result = await FilePicker.pickFile(
    type: FileType.custom,
    allowedExtensions: allowedExtensions,
  );
  if (result == null) return null;
  final bytes = await result.readAsBytes();
  return PickedFile(name: result.name, sizeBytes: bytes.length, bytes: bytes);
}
