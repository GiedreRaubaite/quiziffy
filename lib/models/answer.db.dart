import 'package:isar_community/isar.dart';

part 'answer.db.g.dart';

@collection
class Answer {
  Id isarId = Isar.autoIncrement;
  String id;
  String text;
  bool isCorrect;

  Answer({this.id = '', this.text = '', this.isCorrect = false});

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
    id: json['id'] as String,
    text: json['text'] as String,
    isCorrect: json['isCorrect'] as bool,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'isCorrect': isCorrect,
  };
}
