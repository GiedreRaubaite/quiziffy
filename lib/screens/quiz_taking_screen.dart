import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/quiz_taking_provider.dart';
import '../models/quiz_enums.dart';
import '../theme/app_theme.dart';

class QuizTakingScreen extends ConsumerWidget {
  const QuizTakingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(quizTakingProvider);

    if (session == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/home');
      });
      return const SizedBox.shrink();
    }

    final question = session.quiz.questions[session.currentQuestionIndex];
    final selectedAnswerId = session.selectedAnswers[question.id];
    final isLast = session.currentQuestionIndex == session.totalQuestions - 1;
    final isFirst = session.currentQuestionIndex == 0;

    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.buttonBlue,
        title: Text(session.quiz.title),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Quit Quiz?'),
                content: const Text(
                    'Your progress will be lost. Are you sure?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ref.read(quizTakingProvider.notifier).reset();
                      context.go('/home');
                    },
                    child: const Text('Quit'),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '${session.currentQuestionIndex + 1} / ${session.totalQuestions}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress dots
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(session.totalQuestions, (index) {
                final isAnswered = session.selectedAnswers.containsKey(
                    session.quiz.questions[index].id);
                final isCurrent = index == session.currentQuestionIndex;
                return GestureDetector(
                  onTap: () =>
                      ref.read(quizTakingProvider.notifier).goToQuestion(index),
                  child: Container(
                    width: isCurrent ? 12 : 10,
                    height: isCurrent ? 12 : 10,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCurrent
                          ? AppTheme.buttonBlue
                          : isAnswered
                              ? AppTheme.tealGreen
                              : Colors.grey.shade300,
                      border: isCurrent
                          ? Border.all(color: AppTheme.darkBlue, width: 2)
                          : null,
                    ),
                  ),
                );
              }),
            ),
          ),

          // Question card
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Question text
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        question.text,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryText,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Answer options
                  ...question.answers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final answer = entry.value;
                    final isSelected = selectedAnswerId == answer.id;
                    final letters = ['A', 'B', 'C', 'D'];
                    final isTrueFalse =
                        question.questionType == QuizType.trueFalse;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () {
                          ref.read(quizTakingProvider.notifier).selectAnswer(
                                question.id,
                                answer.id,
                              );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.tealGreen.withValues(alpha: 0.15)
                                : Colors.white,
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.tealGreen
                                  : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              if (!isTrueFalse)
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? AppTheme.tealGreen
                                        : Colors.grey.shade200,
                                  ),
                                  child: Center(
                                    child: Text(
                                      letters[index],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? Colors.white
                                            : AppTheme.primaryText,
                                      ),
                                    ),
                                  ),
                                ),
                              if (!isTrueFalse) const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  answer.text,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isSelected
                                        ? AppTheme.primaryText
                                        : AppTheme.secondaryText,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle,
                                  color: AppTheme.tealGreen,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Bottom navigation
          Container(
            padding: const EdgeInsets.all(16),
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
                // Previous button
                Expanded(
                  child: OutlinedButton(
                    onPressed: isFirst
                        ? null
                        : () => ref
                            .read(quizTakingProvider.notifier)
                            .previousQuestion(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.buttonBlue,
                      side: BorderSide(
                        color: isFirst
                            ? Colors.grey.shade300
                            : AppTheme.buttonBlue,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Previous'),
                  ),
                ),
                const SizedBox(width: 12),
                // Next / Submit button
                Expanded(
                  child: isLast
                      ? ElevatedButton(
                          onPressed: session.allAnswered
                              ? () {
                                  ref
                                      .read(quizTakingProvider.notifier)
                                      .submitQuiz();
                                  context.go('/quiz-result');
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.tealGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            disabledBackgroundColor: Colors.grey.shade300,
                          ),
                          child: Text(
                            session.allAnswered
                                ? 'Submit'
                                : 'Answer All (${session.answeredCount}/${session.totalQuestions})',
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () => ref
                              .read(quizTakingProvider.notifier)
                              .nextQuestion(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.buttonBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Next'),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

