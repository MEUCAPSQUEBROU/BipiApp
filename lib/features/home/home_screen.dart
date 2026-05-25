import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/audio/sound_service.dart';
import '../../core/auth/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/bipi_mascot.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _greeting() {
    final user = authService.currentUser;
    final name = user?.displayName?.trim();
    if (name != null && name.isNotEmpty) return 'Olá, ${name.split(' ').first}!';
    final email = user?.email;
    if (email != null && email.isNotEmpty) return 'Olá!';
    return 'Bem-vindo!';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const BipiMascot(BipiMood.normal, height: 170),
                const SizedBox(height: 16),
                Text('Bipi', style: theme.textTheme.displayMedium),
                const SizedBox(height: 8),
                Text(
                  _greeting(),
                  style: theme.textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      soundService.play(Sfx.tap);
                      context.push('/trilha');
                    },
                    child: const Text('COMEÇAR'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      soundService.play(Sfx.tap);
                      context.push('/ranking');
                    },
                    icon: const Icon(Icons.emoji_events_outlined),
                    label: const Text('RANKING'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      soundService.play(Sfx.tap);
                      authService.signOut();
                    },
                    child: const Text('SAIR'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
