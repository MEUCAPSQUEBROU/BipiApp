import 'package:flutter/foundation.dart';

/// Progresso das fases da trilha do dia.
///
/// v1: em memória (zera ao fechar o app). A persistência (local e, depois,
/// Firestore com o ranking) entra numa próxima etapa.
class TrilhaProgress extends ChangeNotifier {
  String? _dayKey;
  final Set<int> _completed = {};

  void _ensureDay(String dayKey) {
    if (_dayKey != dayKey) {
      _dayKey = dayKey;
      _completed.clear();
    }
  }

  /// Quantas fases foram concluídas hoje.
  int completedCount(String dayKey) {
    _ensureDay(dayKey);
    return _completed.length;
  }

  bool isCompleted(String dayKey, int phaseIndex) {
    _ensureDay(dayKey);
    return _completed.contains(phaseIndex);
  }

  /// Próxima fase desbloqueada (a menor ainda não concluída).
  /// Retorna [totalPhases] quando tudo foi concluído.
  int currentPhase(String dayKey, int totalPhases) {
    _ensureDay(dayKey);
    for (var i = 0; i < totalPhases; i++) {
      if (!_completed.contains(i)) return i;
    }
    return totalPhases;
  }

  void markCompleted(String dayKey, int phaseIndex) {
    _ensureDay(dayKey);
    if (_completed.add(phaseIndex)) notifyListeners();
  }
}

/// Instância única compartilhada pelo app.
final trilhaProgress = TrilhaProgress();
