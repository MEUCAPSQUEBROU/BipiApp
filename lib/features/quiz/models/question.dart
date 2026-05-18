enum QuestionDifficulty { facil, medio, dificil }

class Question {
  const Question({
    required this.id,
    required this.statement,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.difficulty = QuestionDifficulty.facil,
  }) : assert(correctIndex >= 0);

  final String id;
  final String statement;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final QuestionDifficulty difficulty;

  bool isCorrect(int chosenIndex) => chosenIndex == correctIndex;
}
