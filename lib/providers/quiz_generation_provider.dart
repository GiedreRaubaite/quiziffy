import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quiz.db.dart';
import '../models/quiz_enums.dart';
import 'service_providers.dart';

class QuizGenerationNotifier extends AsyncNotifier<Quiz?> {
  @override
  Future<Quiz?> build() async => null;

  Future<void> generateQuiz({
    required String title,
    String description = '',
    required String sourceText,
    required QuizType quizType,
    required Difficulty difficulty,
    int questionCount = 5,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final gemini = ref.read(geminiServiceProvider);
      return gemini.generateQuiz(
        title: title,
        description: description,
        sourceText: sourceText,
        quizType: quizType,
        difficulty: difficulty,
        questionCount: questionCount,
      );
    });
  }

  void reset() {
    state = const AsyncData(null);
  }
}

final quizGenerationProvider =
    AsyncNotifierProvider<QuizGenerationNotifier, Quiz?>(
      QuizGenerationNotifier.new,
    );
