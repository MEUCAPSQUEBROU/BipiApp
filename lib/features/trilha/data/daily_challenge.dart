import 'dart:math';

import '../../quiz/data/questions_repository.dart';
import '../../quiz/models/question.dart';
import '../models/phase.dart';

/// Monta a trilha de fases do dia de forma **determinística** (todo mundo recebe
/// o mesmo conjunto no mesmo dia) e com **dificuldade progressiva**: as primeiras
/// fases são fáceis e a coisa vai apertando.
class DailyChallenge {
  const DailyChallenge();

  static const int questionsPerPhase = 3;

  /// Dificuldade de cada fase (ordem = ramp de dificuldade).
  static const List<QuestionDifficulty> _phasePlan = [
    QuestionDifficulty.facil,
    QuestionDifficulty.facil,
    QuestionDifficulty.medio,
    QuestionDifficulty.medio,
    QuestionDifficulty.dificil,
  ];

  int get phasesPerDay => _phasePlan.length;

  String dayKey(DateTime date) => '${date.year}-${date.month}-${date.day}';

  List<Phase> phasesFor(DateTime date) {
    final all = const QuestionsRepository().all();
    final seed = date.year * 10000 + date.month * 100 + date.day;

    // Um "pool" embaralhado por dificuldade (determinístico pelo dia).
    final pools = <QuestionDifficulty, List<Question>>{};
    for (final d in QuestionDifficulty.values) {
      pools[d] = all.where((q) => q.difficulty == d).toList()
        ..shuffle(Random(seed + d.index));
    }
    final fallback = [...all]..shuffle(Random(seed));

    final cursors = {for (final d in QuestionDifficulty.values) d: 0};
    final used = <String>{};

    Question draw(QuestionDifficulty d) {
      final pool = pools[d]!;
      // Tenta uma pergunta dessa dificuldade ainda não usada hoje.
      for (var k = 0; k < pool.length; k++) {
        final q = pool[cursors[d]! % pool.length];
        cursors[d] = cursors[d]! + 1;
        if (used.add(q.id)) return q;
      }
      // Pool esgotado: pega qualquer uma ainda não usada.
      for (final q in fallback) {
        if (used.add(q.id)) return q;
      }
      return fallback.first;
    }

    final key = dayKey(date);
    return List.generate(_phasePlan.length, (i) {
      final diff = _phasePlan[i];
      final questions = List.generate(questionsPerPhase, (_) => draw(diff));
      return Phase(
        dayKey: key,
        index: i,
        title: 'Fase ${i + 1}',
        questions: questions,
      );
    });
  }
}
