import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/audio/sound_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/bipi_mascot.dart';
import 'data/daily_challenge.dart';
import 'data/trilha_progress.dart';

/// Trilha diária estilo Duolingo: um caminho de fases que muda de perguntas
/// a cada dia. Concluir uma fase desbloqueia a próxima.
class TrilhaScreen extends StatefulWidget {
  const TrilhaScreen({super.key});

  @override
  State<TrilhaScreen> createState() => _TrilhaScreenState();
}

class _TrilhaScreenState extends State<TrilhaScreen>
    with SingleTickerProviderStateMixin {
  static const double _wave = 0.55;

  double _offsetFor(int i) => math.sin(i * math.pi / 2) * _wave;

  // Entrada em cascata: roda uma vez ao abrir a trilha.
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  /// Faz o item de índice [order] (de [count] itens) entrar com fade + subida,
  /// escalonando o atraso pela ordem.
  Widget _cascade(int order, int count, Widget child) {
    final start = (order / (count + 1)) * 0.6;
    final anim = CurvedAnimation(
      parent: _entrance,
      curve: Interval(start, (start + 0.45).clamp(0.0, 1.0), curve: Curves.easeOut),
    );
    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position:
            Tween(begin: const Offset(0, 0.18), end: Offset.zero).animate(anim),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final phases = const DailyChallenge().phasesFor(DateTime.now());
    final dayKey = phases.first.dayKey;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/'),
        ),
        title: const Text('Trilha de hoje'),
        actions: [
          ListenableBuilder(
            listenable: trilhaProgress,
            builder: (context, _) => Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: _ProgressChip(
                  done: trilhaProgress.completedCount(dayKey),
                  total: phases.length,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: trilhaProgress,
        builder: (context, _) {
          final current = trilhaProgress.currentPhase(dayKey, phases.length);
          final allDone = current >= phases.length;
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
            child: Column(
              children: [
                _cascade(0, phases.length, _Header(allDone: allDone)),
                const SizedBox(height: 24),
                for (var i = 0; i < phases.length; i++) ...[
                  _cascade(
                    i + 1,
                    phases.length,
                    Align(
                      alignment: Alignment(_offsetFor(i), 0),
                      child: _PhaseNode(
                        number: i + 1,
                        state: i < current
                            ? _NodeState.completed
                            : (i == current
                                ? _NodeState.current
                                : _NodeState.locked),
                        onTap: i == current
                            ? () {
                                soundService.play(Sfx.tap);
                                context.push('/quiz', extra: phases[i]);
                              }
                            : null,
                      ),
                    ),
                  ),
                  if (i < phases.length - 1)
                    _cascade(
                      i + 1,
                      phases.length,
                      _Connector(from: _offsetFor(i), to: _offsetFor(i + 1)),
                    ),
                ],
                if (allDone) ...[
                  const SizedBox(height: 28),
                  const _CompletionCard(),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.allDone});
  final bool allDone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        BipiMascot(allDone ? BipiMood.feliz : BipiMood.normal, height: 110),
        const SizedBox(height: 8),
        Text(
          allDone ? 'Trilha de hoje concluída!' : 'Bora pra trilha de hoje!',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          allDone
              ? 'Volte amanhã para novas perguntas. 🚦'
              : 'Complete as fases para subir no ranking.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

enum _NodeState { completed, current, locked }

class _PhaseNode extends StatefulWidget {
  const _PhaseNode({required this.number, required this.state, this.onTap});

  final int number;
  final _NodeState state;
  final VoidCallback? onTap;

  @override
  State<_PhaseNode> createState() => _PhaseNodeState();
}

class _PhaseNodeState extends State<_PhaseNode>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );
  late final Animation<double> _scale = Tween(begin: 1.0, end: 1.07)
      .animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));

  @override
  void initState() {
    super.initState();
    if (widget.state == _NodeState.current) _pulse.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(_PhaseNode oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Liga/desliga o pulso conforme a fase vira (ou deixa de ser) a atual.
    if (widget.state == _NodeState.current && !_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    } else if (widget.state != _NodeState.current && _pulse.isAnimating) {
      _pulse.stop();
      _pulse.value = 0;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color base, Color fg, IconData icon) = switch (widget.state) {
      _NodeState.completed => (
          AppColors.success,
          AppColors.successDark,
          Colors.white,
          Icons.check_rounded,
        ),
      _NodeState.current => (
          AppColors.primary,
          AppColors.primaryDark,
          AppColors.onPrimary,
          Icons.play_arrow_rounded,
        ),
      _NodeState.locked => (
          AppColors.surfaceVariant,
          AppColors.border,
          AppColors.textMuted,
          Icons.lock_rounded,
        ),
    };
    final size = widget.state == _NodeState.current ? 84.0 : 70.0;

    Widget circle = GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: base, offset: const Offset(0, 6)),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: fg, size: 34),
      ),
    );
    if (widget.state == _NodeState.current) {
      circle = ScaleTransition(scale: _scale, child: circle);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.state == _NodeState.current) ...[
          const _StartBubble(),
          const SizedBox(height: 8),
        ],
        circle,
        const SizedBox(height: 8),
        Text(
          'Fase ${widget.number}',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: widget.state == _NodeState.locked
                ? AppColors.textMuted
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _StartBubble extends StatefulWidget {
  const _StartBubble();

  @override
  State<_StartBubble> createState() => _StartBubbleState();
}

class _StartBubbleState extends State<_StartBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  )..repeat(reverse: true);
  late final Animation<double> _bob =
      CurvedAnimation(parent: _c, curve: Curves.easeInOut);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bob,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, -5 * _bob.value),
        child: child,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(color: AppColors.primaryDark, offset: const Offset(0, 3)),
          ],
        ),
        child: const Text(
          'COMEÇAR',
          style: TextStyle(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 12,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class _Connector extends StatelessWidget {
  const _Connector({required this.from, required this.to});
  final double from;
  final double to;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (j) {
        final t = (j + 1) / 4;
        final x = from + (to - from) * t;
        return Align(
          alignment: Alignment(x, 0),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: AppColors.surfaceVariant,
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
}

class _ProgressChip extends StatelessWidget {
  const _ProgressChip({required this.done, required this.total});
  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.flag_rounded, size: 18, color: AppColors.success),
          const SizedBox(width: 4),
          Text(
            '$done/$total',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.successDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletionCard extends StatefulWidget {
  const _CompletionCard();

  @override
  State<_CompletionCard> createState() => _CompletionCardState();
}

class _CompletionCardState extends State<_CompletionCard> {
  @override
  void initState() {
    super.initState();
    // O card só é montado quando a trilha do dia é concluída.
    soundService.play(Sfx.victory);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF8DC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(Icons.emoji_events, color: AppColors.success, size: 40),
          const SizedBox(height: 8),
          Text(
            'Mandou bem demais! 🎉',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w800, color: AppColors.successDark),
          ),
          const SizedBox(height: 4),
          const Text(
            'Você concluiu todas as fases de hoje. Amanhã tem mais!',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.successDark),
          ),
        ],
      ),
    );
  }
}
