import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/quiz/quiz_screen.dart';
import '../../features/ranking/ranking_screen.dart';
import '../../features/trilha/models/phase.dart';
import '../../features/trilha/trilha_screen.dart';
import '../auth/auth_service.dart';
import '../onboarding/onboarding_service.dart';

const _authRoutes = {'/login', '/register'};

final appRouter = GoRouter(
  initialLocation: '/',
  refreshListenable: Listenable.merge([
    GoRouterRefreshStream(authService.authStateChanges),
    onboardingService,
  ]),
  redirect: (context, state) {
    final loggedIn = authService.currentUser != null;
    final loc = state.matchedLocation;
    final goingToAuth = _authRoutes.contains(loc);

    // Sem login: só pode ver as telas de auth.
    if (!loggedIn) {
      return goingToAuth ? null : '/login';
    }
    // Logado mas ainda não viu a intro do Bipi: força o onboarding.
    if (!onboardingService.done) {
      return loc == '/onboarding' ? null : '/onboarding';
    }
    // Já logado e com a intro vista: sai das telas de auth/onboarding.
    if (goingToAuth || loc == '/onboarding') return '/';
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
      path: '/ranking',
      builder: (context, state) => const RankingScreen(),
    ),
    GoRoute(
      path: '/perfil',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
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
