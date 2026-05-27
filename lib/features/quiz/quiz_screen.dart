import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/audio/sound_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/bipi_mascot.dart';
import '../ranking/data/score_repository.dart';
import '../trilha/data/trilha_progress.dart';
import '../trilha/models/phase.dart';
import 'data/questions_repository.dart';
import 'models/question.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, this.phase});

  /// Quando vem da trilha, contém a fase a ser jogada. Nulo = jogo avulso.
  final Phase? phase;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final List<Question> _questions;
  late final ConfettiController _confetti;
  int _index = 0;
  int _streak = 0;
  int _bestStreak = 0;
  int _correctCount = 0;
  int? _selectedIndex;
  bool _answered = false;
  bool _showRedFlash = false;

  @override
  void initState() {
    super.initState();
    _questions =
        widget.phase?.questions ?? const QuestionsRepository().loadStarterPack();
    _confetti = ConfettiController(duration: const Duration(milliseconds: 800));
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  Question get _current => _questions[_index];
  bool get _isFinished => _index >= _questions.length;
  double get _progress => _index / _questions.length;

  void _pick(int i) {
    if (_answered) return;
    final isCorrect = _current.isCorrect(i);
    setState(() {
      _selectedIndex = i;
      _answered = true;
      if (isCorrect) {
        _streak += 1;
        _correctCount += 1;
        if (_streak > _bestStreak) _bestStreak = _streak;
      } else {
        _streak = 0;
        _showRedFlash = true;
      }
    });
    if (isCorrect) {
      _confetti.play();
      soundService.play(Sfx.correct);
      HapticFeedback.lightImpact();
    } else {
      soundService.play(Sfx.wrong);
      HapticFeedback.mediumImpact();
      Future.delayed(const Duration(milliseconds: 450), () {
        if (mounted) setState(() => _showRedFlash = false);
      });
    }
  }

  void _next() {
    final phase = widget.phase;
    setState(() {
      _index += 1;
      _selectedIndex = null;
      _answered = false;
    });
    if (phase != null && _index >= _questions.length) {
      final firstTime = !trilhaProgress.isCompleted(phase.dayKey, phase.index);
      trilhaProgress.markCompleted(phase.dayKey, phase.index);
      if (firstTime) {
        // 10 pontos por acerto na fase.
        scoreRepository.addPoints(_correctCount * 10);
      }
      soundService.play(Sfx.phaseComplete);
    }
  }

  void _restart() {
    setState(() {
      _index = 0;
      _streak = 0;
      _bestStreak = 0;
      _correctCount = 0;
      _selectedIndex = null;
      _answered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isFinished) {
      return _ResultView(
        correct: _correctCount,
        total: _questions.length,
        bestStreak: _bestStreak,
        onRestart: _restart,
        onHome: () => context.go(widget.phase != null ? '/trilha' : '/'),
        homeLabel: widget.phase != null ? 'VOLTAR À TRILHA' : 'VOLTAR PRO INÍCIO',
        showRestart: widget.phase == null,
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go(widget.phase != null ? '/trilha' : '/'),
        ),
        title: _StreakChip(streak: _streak),
        actions: [
          ListenableBuilder(
            listenable: soundService,
            builder: (context, _) => IconButton(
              icon: Icon(
                soundService.muted
                    ? Icons.volume_off_rounded
                    : Icons.volume_up_rounded,
              ),
              tooltip: soundService.muted ? 'Ativar som' : 'Silenciar',
              onPressed: soundService.toggleMuted,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_index + 1}/${_questions.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(16),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(value: _progress),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    _current.statement,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _current.options.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        return _OptionTile(
                          text: _current.options[i],
                          state: _stateFor(i),
                          onTap: () => _pick(i),
                        );
                      },
                    ),
                  ),
                  if (_answered) _FeedbackPanel(
                    correct: _current.isCorrect(_selectedIndex!),
                    explanation: _current.explanation,
                    onContinue: _next,
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 120),
                opacity: _showRedFlash ? 1 : 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      radius: 1.2,
                      colors: [
                        Colors.transparent,
                        AppColors.error.withValues(alpha: 0.55),
                      ],
                      stops: const [0.35, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              blastDirection: math.pi / 2,
              numberOfParticles: 24,
              emissionFrequency: 0.04,
              gravity: 0.25,
              maxBlastForce: 18,
              minBlastForce: 8,
              shouldLoop: false,
              colors: const [
                AppColors.primary,
                AppColors.success,
                AppColors.streak,
                Colors.white,
                Color(0xFF4FC3F7),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _OptionState _stateFor(int i) {
    if (!_answered) {
      return _selectedIndex == i ? _OptionState.selected : _OptionState.idle;
    }
    if (i == _current.correctIndex) return _OptionState.correct;
    if (i == _selectedIndex) return _OptionState.wrong;
    return _OptionState.idle;
  }
}

enum _OptionState { idle, selected, correct, wrong }

class _OptionTile extends StatefulWidget {
  const _OptionTile({
    required this.text,
    required this.state,
    required this.onTap,
  });

  final String text;
  final _OptionState state;
  final VoidCallback onTap;

  @override
  State<_OptionTile> createState() => _OptionTileState();
}

class _OptionTileState extends State<_OptionTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  @override
  void didUpdateWidget(_OptionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Treme só quando esta opção passa a ser a errada selecionada.
    if (widget.state == _OptionState.wrong &&
        oldWidget.state != _OptionState.wrong) {
      _shake.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = switch (widget.state) {
      _OptionState.idle => (
        bg: AppColors.surface,
        border: AppColors.border,
        fg: AppColors.textPrimary,
      ),
      _OptionState.selected => (
        bg: AppColors.surfaceVariant,
        border: AppColors.primary,
        fg: AppColors.textPrimary,
      ),
      _OptionState.correct => (
        bg: const Color(0xFFEAF8DC),
        border: AppColors.success,
        fg: AppColors.successDark,
      ),
      _OptionState.wrong => (
        bg: const Color(0xFFFCE4E4),
        border: AppColors.error,
        fg: AppColors.errorDark,
      ),
    };

    final tile = InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: colors.bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border, width: 2),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.text,
                style: TextStyle(
                  color: colors.fg,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
            ),
            if (widget.state == _OptionState.correct)
              const Icon(Icons.check_circle, color: AppColors.success),
            if (widget.state == _OptionState.wrong)
              const Icon(Icons.cancel, color: AppColors.error),
          ],
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _shake,
      builder: (context, child) {
        final t = _shake.value;
        // Vai-e-volta amortecido na horizontal.
        final dx = t == 0 ? 0.0 : math.sin(t * math.pi * 4) * 10 * (1 - t);
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: tile,
    );
  }
}

class _FeedbackPanel extends StatefulWidget {
  const _FeedbackPanel({
    required this.correct,
    required this.explanation,
    required this.onContinue,
  });

  final bool correct;
  final String explanation;
  final VoidCallback onContinue;

  @override
  State<_FeedbackPanel> createState() => _FeedbackPanelState();
}

class _FeedbackPanelState extends State<_FeedbackPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
  )..forward();
  late final Animation<double> _curve =
      CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final correct = widget.correct;
    final bg = correct ? const Color(0xFFEAF8DC) : const Color(0xFFFCE4E4);
    final fg = correct ? AppColors.successDark : AppColors.errorDark;
    final title = correct ? 'Mandou bem!' : 'Quase!';
    final icon = correct ? Icons.emoji_events : Icons.lightbulb;

    return FadeTransition(
      opacity: _curve,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, 0.12), end: Offset.zero)
            .animate(_curve),
        child: Container(
          margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: fg),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: fg,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.explanation,
            style: TextStyle(color: fg, fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: widget.onContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: correct ? AppColors.success : AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('CONTINUAR'),
          ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StreakChip extends StatefulWidget {
  const _StreakChip({required this.streak});
  final int streak;

  @override
  State<_StreakChip> createState() => _StreakChipState();
}

class _StreakChipState extends State<_StreakChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pop = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );
  // Pulo de escala: cresce rápido e volta suave a cada acerto encadeado.
  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween(begin: 1.0, end: 1.3).chain(CurveTween(curve: Curves.easeOut)),
      weight: 40,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 1.3, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
      weight: 60,
    ),
  ]).animate(_pop);

  @override
  void didUpdateWidget(_StreakChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.streak > oldWidget.streak && widget.streak > 0) {
      _pop.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _pop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.streak > 0;
    return ScaleTransition(
      scale: _scale,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppColors.streak.withValues(alpha: 0.12) : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.local_fire_department,
              size: 18,
              color: active ? AppColors.streak : AppColors.textMuted,
            ),
            const SizedBox(width: 4),
            Text(
              '${widget.streak}',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: active ? AppColors.streak : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultView extends StatefulWidget {
  const _ResultView({
    required this.correct,
    required this.total,
    required this.bestStreak,
    required this.onRestart,
    required this.onHome,
    this.homeLabel = 'VOLTAR PRO INÍCIO',
    this.showRestart = true,
  });

  final int correct;
  final int total;
  final int bestStreak;
  final VoidCallback onRestart;
  final VoidCallback onHome;
  final String homeLabel;

  /// Se falso, esconde o "JOGAR DE NOVO" (usado na trilha: fase é tentativa única).
  final bool showRestart;

  @override
  State<_ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<_ResultView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  /// Entrada (fade + sobe) numa janela [start, end] do controller.
  Widget _enter(double start, double end, Widget child) {
    final anim = CurvedAnimation(
      parent: _c,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position:
            Tween(begin: const Offset(0, 0.25), end: Offset.zero).animate(anim),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = widget.total;
    final correct = widget.correct;
    final ok = correct >= (total / 2).ceil();

    final mascotScale = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.0, 0.55, curve: Curves.elasticOut),
    );
    final countAnim = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.35, 0.9, curve: Curves.easeOut),
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              ScaleTransition(
                scale: mascotScale,
                child: BipiMascot(
                  ok ? BipiMood.feliz : BipiMood.duvida,
                  height: 180,
                ),
              ),
              const SizedBox(height: 24),
              _enter(
                0.25,
                0.55,
                Text(
                  ok ? 'Boa rodada!' : 'Bora de novo?',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _enter(
                0.35,
                0.65,
                AnimatedBuilder(
                  animation: countAnim,
                  builder: (context, _) {
                    final shown = (correct * countAnim.value).round();
                    final pct =
                        total == 0 ? 0 : ((shown / total) * 100).round();
                    return Text(
                      '$shown de $total ($pct%)',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              _enter(
                0.5,
                0.8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: AppColors.streak,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Maior streak: ${widget.bestStreak}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.streak,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              _enter(0.7, 1.0, _buildActions()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActions() {
    if (widget.showRestart) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onRestart,
              child: const Text('JOGAR DE NOVO'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: widget.onHome,
              child: Text(widget.homeLabel),
            ),
          ),
        ],
      );
    }
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.onHome,
        child: Text(widget.homeLabel),
      ),
    );
  }
}
