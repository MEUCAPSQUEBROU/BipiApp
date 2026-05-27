import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Tela de carregamento exibida enquanto o app inicializa (Firebase, prefs,
/// áudio). Combina com o splash nativo (mesmo azul + mascote), então a
/// transição nativo → Flutter é contínua, sem tela preta.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key, this.hasError = false, this.onRetry});

  /// Quando true, mostra mensagem de falha + botão de tentar de novo.
  final bool hasError;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 260),
                child: Image.asset(
                  'assets/mascote/bipi_loading.gif',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Bipi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 44,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              if (hasError) ...[
                const Text(
                  'Não foi possível iniciar.\nVerifique sua conexão e tente de novo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.brandBlue,
                  ),
                  child: const Text('TENTAR DE NOVO'),
                ),
              ] else
                const SizedBox(
                  height: 34,
                  width: 34,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),
              const SizedBox(height: 56),
            ],
          ),
        ),
      ),
    );
  }
}
