import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/onboarding/onboarding_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // No Android, lê a configuração do android/app/google-services.json.
  await Firebase.initializeApp();
  await onboardingService.load();
  runApp(const BipiApp());
}
