import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/bipi_mascot.dart';
import '../../core/widgets/user_avatar.dart';
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
            final top3 = entries.take(3).toList();
            final rest = entries.length > 3 ? entries.sublist(3) : const [];

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
              children: [
                _Podium(top3: top3, myUid: myUid),
                if (rest.isNotEmpty) ...[
                  const SizedBox(height: 28),
                  for (var i = 0; i < rest.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _RankTile(
                        position: i + 4,
                        entry: rest[i],
                        isMe: rest[i].uid == myUid,
                      ),
                    ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

Color _medalColor(int position) => switch (position) {
      1 => const Color(0xFFFFC93C),
      2 => const Color(0xFFC0C7D1),
      3 => const Color(0xFFE0A36B),
      _ => AppColors.surfaceVariant,
    };

class _Podium extends StatelessWidget {
  const _Podium({required this.top3, required this.myUid});
  final List<RankingEntry> top3;
  final String? myUid;

  @override
  Widget build(BuildContext context) {
    final first = top3.isNotEmpty ? top3[0] : null;
    final second = top3.length > 1 ? top3[1] : null;
    final third = top3.length > 2 ? top3[2] : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (second != null)
          _PodiumColumn(entry: second, position: 2, isMe: second.uid == myUid),
        if (first != null)
          _PodiumColumn(entry: first, position: 1, isMe: first.uid == myUid),
        if (third != null)
          _PodiumColumn(entry: third, position: 3, isMe: third.uid == myUid),
      ],
    );
  }
}

class _PodiumColumn extends StatelessWidget {
  const _PodiumColumn({
    required this.entry,
    required this.position,
    required this.isMe,
  });

  final RankingEntry entry;
  final int position;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final medal = _medalColor(position);
    final pillarHeight = switch (position) { 1 => 110.0, 2 => 86.0, _ => 66.0 };
    final avatarSize = position == 1 ? 68.0 : 56.0;

    return SizedBox(
      width: 104,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 26,
            child: position == 1
                ? const Text('👑', style: TextStyle(fontSize: 22))
                : null,
          ),
          UserAvatar(
            fotoUrl: entry.fotoUrl,
            nome: entry.nome,
            size: avatarSize,
            ring: medal,
          ),
          const SizedBox(height: 6),
          Text(
            isMe ? '${entry.primeiroNome} (você)' : entry.primeiroNome,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: isMe ? AppColors.primaryDark : AppColors.textPrimary,
            ),
          ),
          Text(
            '${entry.pontos} pts',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 88,
            height: pillarHeight,
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: medal,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Text(
              '$position',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 26,
              ),
            ),
          ),
        ],
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
          SizedBox(
            width: 24,
            child: Text(
              '$position',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          UserAvatar(
            fotoUrl: entry.fotoUrl,
            nome: entry.nome,
            size: 40,
            ring: AppColors.border,
          ),
          const SizedBox(width: 12),
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
