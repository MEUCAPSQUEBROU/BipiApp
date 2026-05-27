import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/audio/sound_service.dart';
import '../../core/auth/auth_service.dart';
import '../../core/profile/profile_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/bipi_mascot.dart';
import '../../core/widgets/user_avatar.dart';
import 'widgets/update_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Carrega foto/nome do perfil (Firestore) para o avatar refletir a foto
    // personalizada. Mudanças posteriores chegam via ListenableBuilder.
    profileService.ensureLoaded();
  }

  String _greeting() {
    final name = (profileService.nome ?? authService.currentUser?.displayName)
        ?.trim();
    if (name != null && name.isNotEmpty) return 'Olá, ${name.split(' ').first}!';
    final email = authService.currentUser?.email;
    if (email != null && email.isNotEmpty) return 'Olá!';
    return 'Bem-vindo!';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 16, 0),
                child: _ProfileButton(),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const UpdateBanner(),
                      const BipiMascot(BipiMood.normal, height: 170),
                      const SizedBox(height: 16),
                      Text('Bipi', style: theme.textTheme.displayMedium),
                      const SizedBox(height: 8),
                      ListenableBuilder(
                        listenable: profileService,
                        builder: (context, _) => Text(
                          _greeting(),
                          style: theme.textTheme.titleMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Botão circular no topo da home que leva ao perfil.
/// Reflete a foto/nome atuais do perfil (reativo via [profileService]).
class _ProfileButton extends StatelessWidget {
  const _ProfileButton();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: profileService,
      builder: (context, _) {
        final user = authService.currentUser;
        final nome =
            (profileService.nome ?? user?.displayName)?.trim();
        final display = (nome != null && nome.isNotEmpty)
            ? nome
            : (user?.email ?? '?');
        return InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () {
            soundService.play(Sfx.tap);
            context.push('/perfil');
          },
          child: UserAvatar(
            fotoUrl: profileService.fotoUrl ?? user?.photoURL,
            nome: display,
            size: 40,
            ring: AppColors.border,
          ),
        );
      },
    );
  }
}
