import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quiz.db.dart';

class QuizSessionState {
  final Quiz quiz;
  final Map<String, String> selectedAnswers; // questionId -> answerId
  final int currentQuestionIndex;
  final bool isSubmitted;

  const QuizSessionState({
    required this.quiz,
    this.selectedAnswers = const {},
    this.currentQuestionIndex = 0,
    this.isSubmitted = false,
  });

  int get totalQuestions => quiz.questions.length;

  int get answeredCount => selectedAnswers.length;

  bool get allAnswered => answeredCount == totalQuestions;

  int get score {
    if (!isSubmitted) return 0;
    int correct = 0;
    for (final question in quiz.questions) {
      final selectedId = selectedAnswers[question.id];
      if (selectedId != null) {
        final selectedAnswer = question.answers.firstWhere(
          (a) => a.id == selectedId,
        );
        if (selectedAnswer.isCorrect) correct++;
      }
    }
    return correct;
  }

  QuizSessionState copyWith({
    Map<String, String>? selectedAnswers,
    int? currentQuestionIndex,
    bool? isSubmitted,
  }) => QuizSessionState(
    quiz: quiz,
    selectedAnswers: selectedAnswers ?? this.selectedAnswers,
    currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
    isSubmitted: isSubmitted ?? this.isSubmitted,
  );
}

class QuizTakingNotifier extends Notifier<QuizSessionState?> {
  @override
  QuizSessionState? build() => null;

  void startQuiz(Quiz quiz) {
    state = QuizSessionState(quiz: quiz);
  }

  void selectAnswer(String questionId, String answerId) {
    if (state == null || state!.isSubmitted) return;
    final newAnswers = Map<String, String>.from(state!.selectedAnswers);
    newAnswers[questionId] = answerId;
    state = state!.copyWith(selectedAnswers: newAnswers);
  }

  void nextQuestion() {
    if (state == null) return;
    if (state!.currentQuestionIndex < state!.totalQuestions - 1) {
      state = state!.copyWith(
        currentQuestionIndex: state!.currentQuestionIndex + 1,
      );
    }
  }

  void previousQuestion() {
    if (state == null) return;
    if (state!.currentQuestionIndex > 0) {
      state = state!.copyWith(
        currentQuestionIndex: state!.currentQuestionIndex - 1,
      );
    }
  }

  void goToQuestion(int index) {
    if (state == null) return;
    if (index >= 0 && index < state!.totalQuestions) {
      state = state!.copyWith(currentQuestionIndex: index);
    }
  }

  void submitQuiz() {
    if (state == null) return;
    state = state!.copyWith(isSubmitted: true);
  }

  void reset() {
    state = null;
  }
}

final quizTakingProvider =
    NotifierProvider<QuizTakingNotifier, QuizSessionState?>(
      QuizTakingNotifier.new,
    );
