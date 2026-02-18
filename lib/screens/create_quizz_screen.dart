import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quizzify_app/theme/app_theme.dart' show AppTheme;
import '../models/quiz_enums.dart';
import '../providers/quiz_generation_provider.dart';
import '../providers/quiz_taking_provider.dart';
import '../providers/service_providers.dart';
import '../shared/widgets/loading_overlay.dart';

class CreateQuizScreen extends ConsumerStatefulWidget {
  const CreateQuizScreen({super.key});

  @override
  ConsumerState<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends ConsumerState<CreateQuizScreen> {
  final TextEditingController _textController = TextEditingController();
  String _selectedQuizType = 'Multiple Choice';
  String _selectedDifficulty = 'Medium';

  QuizType get _quizTypeEnum => QuizType.values.firstWhere(
        (t) => t.displayName == _selectedQuizType,
      );

  Difficulty get _difficultyEnum => Difficulty.values.firstWhere(
        (d) => d.displayName == _selectedDifficulty,
      );

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _handleUpload() async {
    final fileReader = ref.read(fileReaderServiceProvider);
    final text = await fileReader.pickAndReadFile();
    if (text != null) {
      _textController.text = text;
    }
  }

  Future<void> _handleGenerate() async {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter text or upload a file')),
      );
      return;
    }
    await ref.read(quizGenerationProvider.notifier).generateQuiz(
          sourceText: _textController.text,
          quizType: _quizTypeEnum,
          difficulty: _difficultyEnum,
        );
  }

  @override
  Widget build(BuildContext context) {
    final generationState = ref.watch(quizGenerationProvider);
    final isLoading = generationState.isLoading;

    ref.listen(quizGenerationProvider, (prev, next) {
      next.when(
        data: (quiz) {
          if (quiz != null) {
            ref.read(quizTakingProvider.notifier).startQuiz(quiz);
            context.go('/quiz-taking');
          }
        },
        loading: () {},
        error: (e, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error generating quiz: $e')),
          );
        },
      );
    });

    return LoadingOverlay(
      isLoading: isLoading,
      message: 'Generating your quiz...',
      child: Scaffold(
        backgroundColor: AppTheme.lightBackground,
        appBar: AppBar(
          backgroundColor: AppTheme.buttonBlue,
          title: const Text('New Quiz'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/home'),
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
                onPressed: isLoading ? null : _handleUpload,
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
                    onChanged: isLoading
                        ? null
                        : (value) {
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
                      DropdownMenuItem(
                          value: 'Medium', child: Text('Medium')),
                      DropdownMenuItem(value: 'Hard', child: Text('Hard')),
                    ],
                    onChanged: isLoading
                        ? null
                        : (value) {
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
                onPressed: isLoading ? null : _handleGenerate,
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
      ),
    );
  }
}
