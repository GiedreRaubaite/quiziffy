import 'package:isar_community/isar.dart';
import 'answer.db.dart';
import 'quiz_enums.dart';

part 'question.db.g.dart';

@collection
class Question {
  Id isarId = Isar.autoIncrement;

  String id;
  String text;
  @ignore
  List<Answer> answers;
  String explanation;
  int questionTypeIndex;

  Question({
    this.id = '',
    this.text = '',
    this.answers = const [],
    this.explanation = '',
    this.questionTypeIndex = 0,
  });

  @ignore
  QuizType get questionType => QuizType.values[questionTypeIndex];

  @ignore
  Answer get correctAnswer => answers.firstWhere((a) => a.isCorrect);

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json['id'] as String,
    text: json['text'] as String,
    answers: (json['answers'] as List)
        .map((a) => Answer.fromJson(a as Map<String, dynamic>))
        .toList(),
    explanation: json['explanation'] as String? ?? '',
    questionTypeIndex: json['questionTypeIndex'] as int,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'answers': answers.map((a) => a.toJson()).toList(),
    'explanation': explanation,
    'questionTypeIndex': questionTypeIndex,
  };
}
