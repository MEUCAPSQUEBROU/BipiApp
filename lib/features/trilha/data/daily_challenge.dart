import 'dart:math';

import '../../quiz/data/questions_repository.dart';
import '../../quiz/models/question.dart';
import '../models/phase.dart';

/// Monta a trilha de fases do dia de forma **determinística**: dado um dia,
/// todo mundo recebe exatamente o mesmo conjunto de perguntas (essencial para
/// um ranking justo). No dia seguinte, o conjunto muda.
class DailyChallenge {
  const DailyChallenge();

  static const int phasesPerDay = 5;
  static const int questionsPerPhase = 3;

  /// Chave estável do dia, usada para progresso e seed.
  String dayKey(DateTime date) => '${date.year}-${date.month}-${date.day}';

  /// Fases do dia [date].
  List<Phase> phasesFor(DateTime date) {
    final all = const QuestionsRepository().all();
    final seed = date.year * 10000 + date.month * 100 + date.day;
    final shuffled = [...all]..shuffle(Random(seed));

    final needed = phasesPerDay * questionsPerPhase;
    // Se o banco for menor que o necessário, repete o ciclo embaralhado.
    final pool = <Question>[];
    while (pool.length < needed) {
      pool.addAll(shuffled);
    }
    final selected = pool.take(needed).toList();

    final key = dayKey(date);
    return List.generate(phasesPerDay, (i) {
      final start = i * questionsPerPhase;
      return Phase(
        dayKey: key,
        index: i,
        title: 'Fase ${i + 1}',
        questions: selected.sublist(start, start + questionsPerPhase),
      );
    });
  }
}
