import 'dart:typed_data';

/// Kết quả chọn file thật từ máy người dùng (dùng chung cho mọi nền tảng).
class PickedFile {
  final String name;
  final int sizeBytes;
  final Uint8List bytes;

  const PickedFile({
    required this.name,
    required this.sizeBytes,
    required this.bytes,
  });
}
