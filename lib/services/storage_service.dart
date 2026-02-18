import 'package:isar_community/isar.dart';
import '../models/quiz.db.dart';

class StorageService {
  final Isar _isar;

  StorageService(this._isar);

  List<Quiz> getAllQuizzes() {
    return _isar.quizs.where().sortByCreatedAtMillisDesc().findAllSync();
  }

  Future<void> saveQuiz(Quiz quiz) async {
    await _isar.writeTxn(() async {
      await _isar.quizs.put(quiz);
    });
  }

  Future<void> deleteQuiz(String quizId) async {
    await _isar.writeTxn(() async {
      await _isar.quizs.filter().idEqualTo(quizId).deleteAll();
    });
  }

  Quiz? getQuiz(String quizId) {
    return _isar.quizs.filter().idEqualTo(quizId).findFirstSync();
  }

  Future<void> updateQuizScore(String quizId, int score, int total) async {
    final quiz = getQuiz(quizId);
    if (quiz != null) {
      final updated = quiz.copyWith(
        lastScore: score,
        lastTotalQuestions: total,
      );
      await _isar.writeTxn(() async {
        await _isar.quizs.put(updated);
      });
    }
  }
}
