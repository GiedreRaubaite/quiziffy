import 'package:flutter/material.dart';
import 'package:quizzify_app/theme/app_theme.dart' show AppTheme;

class CreateQuizScreen extends StatefulWidget {
  const CreateQuizScreen({super.key});

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  final TextEditingController _textController = TextEditingController();
  String _selectedQuizType = 'Multiple Choice';
  String _selectedDifficulty = 'Medium';

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.buttonBlue,
        title: const Text('New Quiz'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input Section
            const Text(
              'Enter Text or Upload File',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryText,
              ),
            ),

            const SizedBox(height: 12),

            // Text Input Field
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _textController,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: 'Paste or type your text here...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Upload Document Button
            ElevatedButton.icon(
              onPressed: () {
                // Handle file upload
              },
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Document'),
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

            // Quiz Type Section
            const Text(
              'Quiz Type:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryText,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedQuizType,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(
                      value: 'Multiple Choice',
                      child: Text('Multiple Choice'),
                    ),
                    DropdownMenuItem(
                      value: 'True/False',
                      child: Text('True/False'),
                    ),
                    DropdownMenuItem(
                      value: 'Short Answer',
                      child: Text('Short Answer'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedQuizType = value!;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Difficulty Section
            const Text(
              'Difficulty:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryText,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedDifficulty,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 'Easy', child: Text('Easy')),
                    DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                    DropdownMenuItem(value: 'Hard', child: Text('Hard')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedDifficulty = value!;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Generate Quiz Button
            ElevatedButton(
              onPressed: () {
                // Generate quiz
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.tealGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Generate Quiz',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
