import 'package:go_router/go_router.dart';
import 'package:quizzify_app/screens/_screens.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const WelcomeScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/create-quiz',
      builder: (context, state) => const CreateQuizScreen(),
    ),
    GoRoute(
      path: '/quiz-taking',
      builder: (context, state) => const QuizTakingScreen(),
    ),
    GoRoute(
      path: '/quiz-result',
      builder: (context, state) => const QuizResultScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
