import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // No Android, lê a configuração do android/app/google-services.json.
  await Firebase.initializeApp();
  runApp(const BipiApp());
}
