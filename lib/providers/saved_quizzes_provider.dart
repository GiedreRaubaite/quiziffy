import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quiz.db.dart';
import 'service_providers.dart';

class SavedQuizzesNotifier extends Notifier<List<Quiz>> {
  @override
  List<Quiz> build() {
    return ref.read(storageServiceProvider).getAllQuizzes();
  }

  Future<void> saveQuiz(Quiz quiz) async {
    await ref.read(storageServiceProvider).saveQuiz(quiz);
    state = ref.read(storageServiceProvider).getAllQuizzes();
  }

  Future<void> deleteQuiz(String quizId) async {
    await ref.read(storageServiceProvider).deleteQuiz(quizId);
    state = ref.read(storageServiceProvider).getAllQuizzes();
  }

  Future<void> updateQuizScore(String quizId, int score, int total) async {
    await ref
        .read(storageServiceProvider)
        .updateQuizScore(quizId, score, total);
    state = ref.read(storageServiceProvider).getAllQuizzes();
  }

  void refresh() {
    state = ref.read(storageServiceProvider).getAllQuizzes();
  }
}

final savedQuizzesProvider = NotifierProvider<SavedQuizzesNotifier, List<Quiz>>(
  SavedQuizzesNotifier.new,
);
