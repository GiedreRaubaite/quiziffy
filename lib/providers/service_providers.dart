import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/gemini_service.dart';
import '../services/storage_service.dart';
import '../services/pdf_export_service.dart';

final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService();
});

final storageServiceProvider = Provider<StorageService>((ref) {
  // Initialized in main.dart and overridden via ProviderScope
  throw UnimplementedError('StorageService must be overridden in ProviderScope');
});

final pdfExportServiceProvider = Provider<PdfExportService>((ref) {
  return PdfExportService();
});
