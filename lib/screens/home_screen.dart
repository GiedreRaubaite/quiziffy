import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quizzify_app/theme/app_theme.dart';
import '../models/quiz.db.dart';
import '../providers/saved_quizzes_provider.dart';
import '../providers/quiz_taking_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedQuizzes = ref.watch(savedQuizzesProvider);

    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.tealGreen,
        title: const Text('Quizify AI'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Create New Quiz Button
            ElevatedButton.icon(
              onPressed: () => context.go('/create-quiz'),
              icon: const Icon(Icons.add),
              label: const Text('Create New Quiz'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.tealGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Saved Quizzes Section
            const Text(
              'Saved Quizzes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryText,
              ),
            ),

            const SizedBox(height: 16),

            // Quiz List
            Expanded(
              child: savedQuizzes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.quiz_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No quizzes yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Create your first quiz to get started!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: savedQuizzes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final quiz = savedQuizzes[index];
                        return _buildQuizCard(context, ref, quiz);
                      },
                    ),
            ),

            const SizedBox(height: 16),

            // TODO: Implement Upgrade to Pro feature
            // _buildOptionCard(
            //   context,
            //   icon: Icons.star_outline,
            //   title: 'Upgrade to Pro',
            //   color: AppTheme.tealGreen,
            //   onTap: () {},
            // ),
            // const SizedBox(height: 12),

            _buildOptionCard(
              context,
              icon: Icons.settings,
              title: 'Settings',
              color: AppTheme.tealGreen,
              onTap: () => context.go('/settings'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizCard(BuildContext context, WidgetRef ref, Quiz quiz) {
    final subtitle =
        '${quiz.quizType.displayName} | ${quiz.difficulty.displayName}';
    final scoreText = quiz.lastScore != null
        ? 'Last score: ${quiz.lastScore}/${quiz.lastTotalQuestions}'
        : null;

    return Dismissible(
      key: Key(quiz.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete Quiz'),
            content: Text('Delete "${quiz.title}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        ref.read(savedQuizzesProvider.notifier).deleteQuiz(quiz.id);
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          title: Text(
            quiz.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(subtitle, style: const TextStyle(fontSize: 12)),
              if (scoreText != null)
                Text(
                  scoreText,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.tealGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            ref.read(quizTakingProvider.notifier).startQuiz(quiz);
            context.go('/quiz-taking');
          },
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
