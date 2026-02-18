import 'package:isar_community/isar.dart';
import 'question.db.dart';
import 'quiz_enums.dart';

part 'quiz.db.g.dart';

@collection
class Quiz {
  Id isarId = Isar.autoIncrement;
  String id;
  String title;
  @ignore
  List<Question> questions;
  int quizTypeIndex;
  int difficultyIndex;
  int createdAtMillis;
  String sourceText;
  int? lastScore;
  int? lastTotalQuestions;

  Quiz({
    this.id = '',
    this.title = '',
    this.questions = const [],
    this.quizTypeIndex = 0,
    this.difficultyIndex = 0,
    this.createdAtMillis = 0,
    this.sourceText = '',
    this.lastScore,
    this.lastTotalQuestions,
  });

  @ignore
  DateTime get createdAt =>
      DateTime.fromMillisecondsSinceEpoch(createdAtMillis);

  @ignore
  QuizType get quizType => QuizType.values[quizTypeIndex];

  @ignore
  Difficulty get difficulty => Difficulty.values[difficultyIndex];

  Quiz copyWith({int? lastScore, int? lastTotalQuestions}) {
    final copy = Quiz(
      id: id,
      title: title,
      questions: questions,
      quizTypeIndex: quizTypeIndex,
      difficultyIndex: difficultyIndex,
      createdAtMillis: createdAtMillis,
      sourceText: sourceText,
      lastScore: lastScore ?? this.lastScore,
      lastTotalQuestions: lastTotalQuestions ?? this.lastTotalQuestions,
    );
    copy.isarId = isarId;
    return copy;
  }
}
