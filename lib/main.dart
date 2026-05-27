import 'package:flutter/material.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // A inicialização pesada (Firebase, prefs, áudio) roda dentro do BipiApp,
  // exibindo a tela de loading em vez de uma tela preta.
  runApp(const BipiApp());
}
