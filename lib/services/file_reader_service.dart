import 'dart:io';
import 'package:file_picker/file_picker.dart';

class FileReaderService {
  Future<String?> pickAndReadFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt', 'md', 'text'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) return null;

    final file = result.files.first;

    // Try bytes first (works on all platforms including web)
    if (file.bytes != null) {
      return String.fromCharCodes(file.bytes!);
    }

    // Fallback to path (mobile/desktop)
    if (file.path != null) {
      return File(file.path!).readAsString();
    }

    return null;
  }
}
