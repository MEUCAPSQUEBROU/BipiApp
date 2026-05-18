import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import 'data/questions_repository.dart';
import 'models/question.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

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
    _questions = const QuestionsRepository().loadStarterPack();
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
    } else {
      Future.delayed(const Duration(milliseconds: 450), () {
        if (mounted) setState(() => _showRedFlash = false);
      });
    }
  }

  void _next() {
    setState(() {
      _index += 1;
      _selectedIndex = null;
      _answered = false;
    });
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
        onHome: () => context.go('/'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/'),
        ),
        title: _StreakChip(streak: _streak),
        actions: [
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

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.text,
    required this.state,
    required this.onTap,
  });

  final String text;
  final _OptionState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = switch (state) {
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

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
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
                text,
                style: TextStyle(
                  color: colors.fg,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
            ),
            if (state == _OptionState.correct)
              const Icon(Icons.check_circle, color: AppColors.success),
            if (state == _OptionState.wrong)
              const Icon(Icons.cancel, color: AppColors.error),
          ],
        ),
      ),
    );
  }
}

class _FeedbackPanel extends StatelessWidget {
  const _FeedbackPanel({
    required this.correct,
    required this.explanation,
    required this.onContinue,
  });

  final bool correct;
  final String explanation;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final bg = correct ? const Color(0xFFEAF8DC) : const Color(0xFFFCE4E4);
    final fg = correct ? AppColors.successDark : AppColors.errorDark;
    final title = correct ? 'Mandou bem!' : 'Quase!';
    final icon = correct ? Icons.emoji_events : Icons.lightbulb;

    return Container(
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
            explanation,
            style: TextStyle(color: fg, fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: correct ? AppColors.success : AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('CONTINUAR'),
          ),
        ],
      ),
    );
  }
}

class _StreakChip extends StatelessWidget {
  const _StreakChip({required this.streak});
  final int streak;

  @override
  Widget build(BuildContext context) {
    final active = streak > 0;
    return Container(
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
            '$streak',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: active ? AppColors.streak : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({
    required this.correct,
    required this.total,
    required this.bestStreak,
    required this.onRestart,
    required this.onHome,
  });

  final int correct;
  final int total;
  final int bestStreak;
  final VoidCallback onRestart;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pct = total == 0 ? 0 : ((correct / total) * 100).round();
    final ok = correct >= (total / 2).ceil();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: ok ? AppColors.success : AppColors.streak,
                  borderRadius: BorderRadius.circular(40),
                ),
                alignment: Alignment.center,
                child: Text(
                  ok ? '🏆' : '💪',
                  style: const TextStyle(fontSize: 72),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                ok ? 'Boa rodada!' : 'Bora de novo?',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '$correct de $total ($pct%)',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    color: AppColors.streak,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Maior streak: $bestStreak',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.streak,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onRestart,
                  child: const Text('JOGAR DE NOVO'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onHome,
                  child: const Text('VOLTAR PRO INÍCIO'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
