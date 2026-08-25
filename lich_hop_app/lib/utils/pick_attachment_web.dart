import 'dart:async';
// ignore: deprecated_member_use
import 'dart:html' as html;
import 'dart:typed_data';

import 'pick_attachment_result.dart';

/// Bản Web — dựng thẳng input[type=file] qua dart:html thay vì gói
/// file_picker (bản 12.x của file_picker bị lỗi khi build --release --minify
/// trên Flutter Web: bấm chọn file ném lỗi JS, không mở được hộp thoại).
Future<PickedFile?> pickAttachmentFile(List<String> allowedExtensions) {
  final completer = Completer<PickedFile?>();
  final input = html.FileUploadInputElement()
    ..accept = allowedExtensions.map((e) => '.$e').join(',');

  void finish(PickedFile? f) {
    if (!completer.isCompleted) completer.complete(f);
  }

  input.onChange.listen((_) {
    final files = input.files;
    if (files == null || files.isEmpty) {
      finish(null);
      return;
    }
    final file = files.first;
    final reader = html.FileReader();
    reader.onLoadEnd.listen((_) {
      final result = reader.result;
      final Uint8List bytes;
      if (result is Uint8List) {
        bytes = result;
      } else if (result is ByteBuffer) {
        bytes = result.asUint8List();
      } else {
        bytes = Uint8List(0);
      }
      finish(PickedFile(name: file.name, sizeBytes: file.size, bytes: bytes));
    });
    reader.onError.listen((_) => finish(null));
    reader.readAsArrayBuffer(file);
  });

  input.click();

  // Nếu người dùng bấm Hủy trên hộp thoại chọn file của trình duyệt,
  // onChange sẽ không bao giờ bắn — dùng sự kiện focus quay lại cửa sổ để
  // tự kết thúc việc chờ sau một khoảng trễ ngắn.
  late final StreamSubscription<html.Event> focusSub;
  focusSub = html.window.onFocus.listen((_) {
    Future.delayed(const Duration(milliseconds: 600), () => finish(null));
    focusSub.cancel();
  });

  return completer.future;
}
