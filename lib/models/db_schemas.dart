import 'package:isar_community/isar.dart';
import 'package:quizzify_app/models/answer.db.dart';
import 'package:quizzify_app/models/quiz.db.dart';
import 'package:quizzify_app/models/question.db.dart';

class DbSchemas {
  static List<CollectionSchema<dynamic>> allSchemas = [
    AnswerSchema,
    QuizSchema,
    QuestionSchema,
  ];
}
