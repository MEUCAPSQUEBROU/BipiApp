import '../../quiz/models/question.dart';

/// Uma fase da trilha diária: um pequeno conjunto de perguntas.
class Phase {
  const Phase({
    required this.dayKey,
    required this.index,
    required this.title,
    required this.questions,
  });

  /// Chave do dia (ex.: "2026-5-24") a que esta fase pertence.
  final String dayKey;

  /// Posição da fase na trilha do dia (0-based).
  final int index;

  final String title;
  final List<Question> questions;
}
