class AppConstants {
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );
  static const int defaultQuestionCount = 5;
}
