import 'dart:convert';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:uuid/uuid.dart';
import '../models/quiz.db.dart';
import '../models/question.db.dart';
import '../models/answer.db.dart';
import '../models/quiz_enums.dart';

class GeminiService {
  late final GenerativeModel _model;
  final _uuid = const Uuid();

  GeminiService() {
    _model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-2.0-flash',
      generationConfig: GenerationConfig(responseMimeType: 'application/json'),
    );
  }

  Future<Quiz> generateQuiz({
    required String title,
    String description = '',
    required String sourceText,
    required QuizType quizType,
    required Difficulty difficulty,
    int questionCount = 5,
  }) async {
    final prompt = _buildPrompt(
      title: title,
      description: description,
      sourceText: sourceText,
      quizType: quizType,
      difficulty: difficulty,
      questionCount: questionCount,
    );

    final response = await _model.generateContent([Content.text(prompt)]);

    final jsonText = response.text;
    if (jsonText == null || jsonText.isEmpty) {
      throw Exception('Gemini returned an empty response');
    }

    return _parseResponse(
      jsonText: jsonText,
      title: title,
      quizType: quizType,
      difficulty: difficulty,
      sourceText: sourceText,
    );
  }

  String _buildPrompt({
    required String title,
    required String description,
    required String sourceText,
    required QuizType quizType,
    required Difficulty difficulty,
    required int questionCount,
  }) {
    final typeInstruction = switch (quizType) {
      QuizType.multipleChoice =>
        'Each question must have exactly 4 answer options with exactly one correct answer.',
      QuizType.trueFalse =>
        'Each question must have exactly 2 answer options: "True" and "False", with exactly one correct answer.',
      QuizType.shortAnswer =>
        'Each question must have exactly 1 answer which is the correct short answer (a few words).',
    };

    final descriptionSection = description.isNotEmpty
        ? '\nQuiz focus/instructions: $description\n'
        : '';

    return '''
You are a quiz generator. Based on the following text, generate a quiz with exactly $questionCount questions.

Quiz title: $title
$descriptionSection
Difficulty level: ${difficulty.displayName}
Question type: ${quizType.displayName}

$typeInstruction

Respond with valid JSON in this exact format:
{
  "questions": [
    {
      "text": "The question text",
      "answers": [
        {"text": "Answer text", "isCorrect": true},
        {"text": "Answer text", "isCorrect": false}
      ],
      "explanation": "Brief explanation of why the correct answer is correct"
    }
  ]
}

Source text:
$sourceText
''';
  }

  Quiz _parseResponse({
    required String jsonText,
    required String title,
    required QuizType quizType,
    required Difficulty difficulty,
    required String sourceText,
  }) {
    final Map<String, dynamic> parsed = jsonDecode(jsonText);
    final questionsJson = parsed['questions'] as List;

    final questions = questionsJson.map((q) {
      final question = q as Map<String, dynamic>;
      final answersJson = question['answers'] as List;

      final answers = answersJson.map((a) {
        final answer = a as Map<String, dynamic>;
        return Answer(
          id: _uuid.v4(),
          text: answer['text'] as String,
          isCorrect: answer['isCorrect'] as bool,
        );
      }).toList();

      return Question(
        id: _uuid.v4(),
        text: question['text'] as String,
        answers: answers,
        explanation: question['explanation'] as String? ?? '',
        questionTypeIndex: quizType.index,
      );
    }).toList();

    return Quiz(
      id: _uuid.v4(),
      title: title,
      questions: questions,
      quizTypeIndex: quizType.index,
      difficultyIndex: difficulty.index,
      createdAtMillis: DateTime.now().millisecondsSinceEpoch,
      sourceText: sourceText,
    );
  }
}
