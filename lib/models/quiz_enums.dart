enum QuizType {
  multipleChoice('Multiple Choice'),
  trueFalse('True/False'),
  shortAnswer('Short Answer');

  final String displayName;
  const QuizType(this.displayName);
}

enum Difficulty {
  easy('Easy'),
  medium('Medium'),
  hard('Hard');

  final String displayName;
  const Difficulty(this.displayName);
}
