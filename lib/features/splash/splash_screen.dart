import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Tela de carregamento: só o Bipi animado, centralizado, sobre o azul da marca.
/// O GIF é o próprio indicador de carregamento. Combina com o splash nativo,
/// então a transição nativo → Flutter é contínua, sem tela preta.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key, this.hasError = false, this.onRetry});

  /// Quando true, mostra mensagem de falha + botão de tentar de novo.
  final bool hasError;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandBlue,
      body: Center(
        child: hasError
            ? _ErrorView(onRetry: onRetry)
            : Image.asset(
                'assets/mascote/bipi_loading.gif',
                width: MediaQuery.sizeOf(context).width * 0.72,
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/mascote/bipi_loading.gif',
            width: 180,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 24),
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
        ],
      ),
    );
  }
}
