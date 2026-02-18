import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/quiz.db.dart';
import '../models/quiz_enums.dart';

class PdfExportService {
  Future<String> generatePdf(Quiz quiz) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(level: 0, text: quiz.title),
          pw.SizedBox(height: 8),
          pw.Text(
            'Type: ${quiz.quizType.displayName} | '
            'Difficulty: ${quiz.difficulty.displayName} | '
            'Questions: ${quiz.questions.length}',
            style: const pw.TextStyle(fontSize: 12),
          ),
          pw.Divider(),
          pw.SizedBox(height: 12),
          ...quiz.questions.asMap().entries.map((entry) {
            final index = entry.key;
            final question = entry.value;
            final letters = ['A', 'B', 'C', 'D'];

            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  '${index + 1}. ${question.text}',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 6),
                ...question.answers.asMap().entries.map((aEntry) {
                  final aIndex = aEntry.key;
                  final answer = aEntry.value;
                  final prefix = question.questionType == QuizType.trueFalse
                      ? ''
                      : '${letters[aIndex]}. ';
                  return pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 16, bottom: 4),
                    child: pw.Text(
                      '$prefix${answer.text}${answer.isCorrect ? '  [CORRECT]' : ''}',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: answer.isCorrect
                            ? pw.FontWeight.bold
                            : pw.FontWeight.normal,
                      ),
                    ),
                  );
                }),
                if (question.explanation.isNotEmpty) ...[
                  pw.SizedBox(height: 4),
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 16),
                    child: pw.Text(
                      'Explanation: ${question.explanation}',
                      style: pw.TextStyle(
                        fontSize: 11,
                        fontStyle: pw.FontStyle.italic,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ),
                ],
                pw.SizedBox(height: 16),
              ],
            );
          }),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final sanitizedTitle = quiz.title
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll(' ', '_');
    final file = File(
      '${dir.path}/quiz_${sanitizedTitle}_${quiz.id.substring(0, 8)}.pdf',
    );
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  Future<void> exportAndShare(Quiz quiz) async {
    final path = await generatePdf(quiz);
    await Share.shareXFiles([XFile(path)], text: 'Quiz: ${quiz.title}');
  }
}
