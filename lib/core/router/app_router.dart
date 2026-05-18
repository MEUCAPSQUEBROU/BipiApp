import 'package:go_router/go_router.dart';

import '../../features/home/home_screen.dart';
import '../../features/quiz/quiz_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/quiz',
      builder: (context, state) => const QuizScreen(),
    ),
  ],
);
