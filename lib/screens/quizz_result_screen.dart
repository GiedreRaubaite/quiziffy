import 'package:flutter/material.dart';
import 'package:quizzify_app/theme/app_theme.dart' show AppTheme;

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.buttonBlue,
        title: const Text('Biology Quiz'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {
              // Open chat or comments
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Question 1
                _buildQuestionCard(
                  questionNumber: 1,
                  questionText: 'What is the main function of chlorophyll?',
                  options: [
                    ('A', 'To absorb sunlight', false),
                    ('B', 'To store water', false),
                    ('C', 'To produce oxygen', true),
                    ('D', 'To provide nutrients', false),
                  ],
                  selectedAnswer: 'C',
                  isCorrect: true,
                ),

                const SizedBox(height: 16),

                // Question 2
                _buildQuestionCard(
                  questionNumber: 2,
                  questionText:
                      'True or False: Mitochondria are the powerhouse of the cell.',
                  options: [('', 'True', true), ('', 'False', false)],
                  selectedAnswer: 'True',
                  isCorrect: true,
                  isTrueFalse: true,
                ),
              ],
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Save quiz
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
                    onPressed: () {
                      // Export as PDF
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
                    // Share quiz
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

  Widget _buildQuestionCard({
    required int questionNumber,
    required String questionText,
    required List<(String, String, bool)> options,
    required String selectedAnswer,
    required bool isCorrect,
    bool isTrueFalse = false,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Number and Text
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 16,
                  color: AppTheme.primaryText,
                ),
                children: [
                  TextSpan(
                    text: '$questionNumber. ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: questionText),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Options
            ...options.map((option) {
              final (letter, text, isCorrectAnswer) = option;
              final isSelected = isTrueFalse
                  ? text == selectedAnswer
                  : letter == selectedAnswer;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: isCorrectAnswer && isSelected
                        ? AppTheme.correctGreen
                        : Colors.white,
                    border: Border.all(
                      color: isCorrectAnswer && isSelected
                          ? AppTheme.correctGreenBorder
                          : Colors.grey.shade300,
                      width: isCorrectAnswer && isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    dense: true,
                    leading: isCorrectAnswer && isSelected
                        ? const Icon(
                            Icons.check_circle,
                            color: AppTheme.correctGreenBorder,
                          )
                        : null,
                    title: Text(
                      isTrueFalse ? text : '$letter  $text',
                      style: TextStyle(
                        fontSize: 14,
                        color: isCorrectAnswer && isSelected
                            ? AppTheme.primaryText
                            : AppTheme.secondaryText,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
