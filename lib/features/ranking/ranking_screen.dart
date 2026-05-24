import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/bipi_mascot.dart';
import 'data/score_repository.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  late Future<List<RankingEntry>> _future;

  @override
  void initState() {
    super.initState();
    _future = scoreRepository.top10();
  }

  void _reload() {
    setState(() => _future = scoreRepository.top10());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ranking')),
      body: RefreshIndicator(
        onRefresh: () async => _reload(),
        child: FutureBuilder<List<RankingEntry>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return _Message(
                mood: BipiMood.duvida,
                title: 'Não rolou carregar o ranking',
                subtitle: 'Verifique sua conexão e tente de novo.',
                onRetry: _reload,
              );
            }
            final entries = snapshot.data ?? const [];
            if (entries.isEmpty) {
              return _Message(
                mood: BipiMood.normal,
                title: 'Ninguém pontuou ainda',
                subtitle: 'Jogue a trilha e seja o primeiro do ranking! 🚦',
                onRetry: _reload,
              );
            }
            final myUid = scoreRepository.currentUid;
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              itemCount: entries.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, i) => _RankTile(
                position: i + 1,
                entry: entries[i],
                isMe: entries[i].uid == myUid,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RankTile extends StatelessWidget {
  const _RankTile({
    required this.position,
    required this.entry,
    required this.isMe,
  });

  final int position;
  final RankingEntry entry;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final medal = switch (position) {
      1 => const Color(0xFFFFC93C),
      2 => const Color(0xFFC0C7D1),
      3 => const Color(0xFFE0A36B),
      _ => AppColors.surfaceVariant,
    };
    final isPodium = position <= 3;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isMe ? AppColors.primary.withValues(alpha: 0.12) : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isMe ? AppColors.primary : AppColors.border,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: medal,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$position',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: isPodium ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              isMe ? '${entry.nome} (você)' : entry.nome,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded, size: 18, color: AppColors.streak),
              const SizedBox(width: 4),
              Text(
                '${entry.pontos}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.mood,
    required this.title,
    required this.subtitle,
    required this.onRetry,
  });

  final BipiMood mood;
  final String title;
  final String subtitle;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // ListView para o RefreshIndicator funcionar mesmo "vazio".
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      children: [
        BipiMascot(mood, height: 140),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),
        OutlinedButton(onPressed: onRetry, child: const Text('TENTAR DE NOVO')),
      ],
    );
  }
}
