import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/quiz/quiz_screen.dart';
import '../../features/trilha/models/phase.dart';
import '../../features/trilha/trilha_screen.dart';
import '../auth/auth_service.dart';

const _authRoutes = {'/login', '/register'};

final appRouter = GoRouter(
  initialLocation: '/',
  refreshListenable: GoRouterRefreshStream(authService.authStateChanges),
  redirect: (context, state) {
    final loggedIn = authService.currentUser != null;
    final goingToAuth = _authRoutes.contains(state.matchedLocation);

    // Sem login: só pode ver as telas de auth.
    if (!loggedIn && !goingToAuth) return '/login';
    // Já logado: não faz sentido ver login/cadastro.
    if (loggedIn && goingToAuth) return '/';
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/trilha',
      builder: (context, state) => const TrilhaScreen(),
    ),
    GoRoute(
      path: '/quiz',
      builder: (context, state) => QuizScreen(phase: state.extra as Phase?),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
  ],
);

/// Faz o [GoRouter] reavaliar o `redirect` sempre que o estado de
/// autenticação muda (login, logout, expiração de sessão).
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
