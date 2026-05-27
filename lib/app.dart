import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/audio/sound_service.dart';
import 'core/onboarding/onboarding_service.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';

class BipiApp extends StatefulWidget {
  const BipiApp({super.key});

  @override
  State<BipiApp> createState() => _BipiAppState();
}

class _BipiAppState extends State<BipiApp> {
  late Future<void> _init = _bootstrap();

  /// Inicialização do app. Enquanto roda, mostramos a [SplashScreen].
  Future<void> _bootstrap() async {
    await Future.wait([
      _initServices(),
      // Tempo mínimo de splash, pra a animação de loading aparecer mesmo quando
      // o app carrega quase instantâneo.
      Future<void>.delayed(const Duration(milliseconds: 1600)),
    ]);
  }

  Future<void> _initServices() async {
    // No Android, lê a configuração do android/app/google-services.json.
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
    await onboardingService.load();
    await soundService.load();
  }

  void _retry() => setState(() => _init = _bootstrap());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _init,
      builder: (context, snapshot) {
        final ready = snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError;
        if (ready) {
          return MaterialApp.router(
            title: 'Bipi',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            routerConfig: appRouter,
          );
        }
        return MaterialApp(
          title: 'Bipi',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          home: SplashScreen(
            hasError: snapshot.hasError,
            onRetry: _retry,
          ),
        );
      },
    );
  }
}
