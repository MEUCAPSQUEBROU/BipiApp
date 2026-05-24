import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Lembra (localmente) se o usuário já viu a introdução do Bipi.
///
/// É por dispositivo (não por conta). Simples e suficiente por ora; dá para
/// migrar para o Firestore por usuário depois, se necessário.
class OnboardingService extends ChangeNotifier {
  static const _key = 'onboarding_done';

  bool _done = false;
  bool get done => _done;

  /// Carrega o estado salvo. Chamar no `main()` antes de montar o app.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _done = prefs.getBool(_key) ?? false;
    notifyListeners();
  }

  /// Marca a introdução como concluída.
  Future<void> complete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
    _done = true;
    notifyListeners();
  }
}

/// Instância única compartilhada pelo app.
final onboardingService = OnboardingService();
