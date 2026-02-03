import 'package:flutter/material.dart';
import 'package:quizzify_app/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.tealGreen,
        title: const Text('Quizify AI'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Open drawer
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              // Navigate to home
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Create New Quiz Button
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to create quiz screen
              },
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
              child: ListView(
                children: [
                  _buildQuizCard(context, 'Biology Chapter 1', () {
                    // Navigate to quiz
                  }),
                  const SizedBox(height: 12),
                  _buildQuizCard(context, 'History: World War II', () {
                    // Navigate to quiz
                  }),
                  const SizedBox(height: 12),
                  _buildQuizCard(context, 'My Notes', () {
                    // Navigate to quiz
                  }),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Bottom Options
            _buildOptionCard(
              context,
              icon: Icons.star_outline,
              title: 'Upgrade to Pro',
              color: AppTheme.tealGreen,
              onTap: () {
                // Navigate to upgrade
              },
            ),

            const SizedBox(height: 12),

            _buildOptionCard(
              context,
              icon: Icons.settings,
              title: 'Settings',
              color: AppTheme.tealGreen,
              onTap: () {
                // Navigate to settings
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizCard(
    BuildContext context,
    String title,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
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
