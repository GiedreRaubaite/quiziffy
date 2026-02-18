import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:quizzify_app/theme/app_theme.dart' show AppTheme;
import '../models/quiz_enums.dart';
import '../providers/quiz_taking_provider.dart';
import '../providers/saved_quizzes_provider.dart';
import '../providers/service_providers.dart';

class QuizResultScreen extends ConsumerWidget {
  const QuizResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(quizTakingProvider);

    if (session == null || !session.isSubmitted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/home');
      });
      return const SizedBox.shrink();
    }

    final quiz = session.quiz;
    final score = session.score;
    final total = session.totalQuestions;

    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.buttonBlue,
        title: Text(quiz.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(quizTakingProvider.notifier).reset();
            context.go('/home');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Retake Quiz',
            onPressed: () {
              ref.read(quizTakingProvider.notifier).startQuiz(quiz);
              context.go('/quiz-taking');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Score Card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryBlue, AppTheme.tealGreen],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  'Your Score',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$score / $total',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getScoreMessage(score, total),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Questions List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: quiz.questions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final question = quiz.questions[index];
                final selectedAnswerId =
                    session.selectedAnswers[question.id];
                final isTrueFalse =
                    question.questionType == QuizType.trueFalse;

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Question text
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppTheme.primaryText,
                            ),
                            children: [
                              TextSpan(
                                text: '${index + 1}. ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: question.text),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Answer options
                        ...question.answers.asMap().entries.map((entry) {
                          final aIndex = entry.key;
                          final answer = entry.value;
                          final letters = ['A', 'B', 'C', 'D'];
                          final isSelected =
                              selectedAnswerId == answer.id;
                          final isCorrectAnswer = answer.isCorrect;
                          final isWrongSelection =
                              isSelected && !isCorrectAnswer;

                          Color bgColor;
                          Color borderColor;
                          if (isCorrectAnswer) {
                            bgColor = AppTheme.correctGreen;
                            borderColor = AppTheme.correctGreenBorder;
                          } else if (isWrongSelection) {
                            bgColor = Colors.red.shade100;
                            borderColor = Colors.red;
                          } else {
                            bgColor = Colors.white;
                            borderColor = Colors.grey.shade300;
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: bgColor,
                                border: Border.all(
                                  color: borderColor,
                                  width:
                                      (isCorrectAnswer || isWrongSelection)
                                          ? 2
                                          : 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                dense: true,
                                leading: isCorrectAnswer
                                    ? const Icon(
                                        Icons.check_circle,
                                        color:
                                            AppTheme.correctGreenBorder,
                                      )
                                    : isWrongSelection
                                        ? const Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          )
                                        : null,
                                title: Text(
                                  isTrueFalse
                                      ? answer.text
                                      : '${letters[aIndex]}  ${answer.text}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: (isCorrectAnswer ||
                                            isWrongSelection)
                                        ? AppTheme.primaryText
                                        : AppTheme.secondaryText,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),

                        // Explanation
                        if (question.explanation.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.lightbulb_outline,
                                  size: 18,
                                  color: AppTheme.primaryBlue,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    question.explanation,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppTheme.primaryText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await ref
                          .read(savedQuizzesProvider.notifier)
                          .saveQuiz(quiz);
                      await ref
                          .read(savedQuizzesProvider.notifier)
                          .updateQuizScore(quiz.id, score, total);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Quiz saved!')),
                        );
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Save Quiz'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.buttonBlue,
                      side: const BorderSide(color: AppTheme.buttonBlue),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      try {
                        await ref
                            .read(pdfExportServiceProvider)
                            .exportAndShare(quiz);
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Error exporting PDF: $e')),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Export PDF'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () {
                    Share.share(
                      'I scored $score/$total on "${quiz.title}" in Quizify AI!',
                    );
                  },
                  icon: const Icon(Icons.share),
                  color: AppTheme.buttonBlue,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getScoreMessage(int score, int total) {
    final percentage = (score / total) * 100;
    if (percentage == 100) return 'Perfect score!';
    if (percentage >= 80) return 'Great job!';
    if (percentage >= 60) return 'Good effort!';
    if (percentage >= 40) return 'Keep practicing!';
    return 'Better luck next time!';
  }
}
