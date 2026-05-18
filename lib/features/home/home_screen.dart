import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  alignment: Alignment.center,
                  child: const Text('🚦', style: TextStyle(fontSize: 64)),
                ),
                const SizedBox(height: 24),
                Text('Bipi', style: theme.textTheme.displayMedium),
                const SizedBox(height: 8),
                Text(
                  'O Duolingo do trânsito',
                  style: theme.textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.push('/quiz'),
                    child: const Text('COMEÇAR'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('JÁ TENHO UMA CONTA'),
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
