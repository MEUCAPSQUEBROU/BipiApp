import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Tela de carregamento: o Bipi animado, centralizado, "flutuando" (balanço
/// suave) sobre o azul da marca. Combina com o splash nativo, então a transição
/// nativo → Flutter é contínua, sem tela preta.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.hasError = false, this.onRetry});

  /// Quando true, mostra mensagem de falha + botão de tentar de novo.
  final bool hasError;
  final VoidCallback? onRetry;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Balanço contínuo: sobe/desce (sin) + leve inclinação (cos) = flutuar.
  late final AnimationController _float = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..repeat();

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandBlue,
      body: Center(
        child: widget.hasError
            ? _ErrorView(onRetry: widget.onRetry)
            : _floatingBipi(),
      ),
    );
  }

  Widget _floatingBipi() {
    return AnimatedBuilder(
      animation: _float,
      builder: (context, child) {
        final t = _float.value * 2 * math.pi;
        return Transform.translate(
          offset: Offset(0, math.sin(t) * 10), // sobe/desce ~10px
          child: Transform.rotate(
            angle: math.cos(t) * 0.03, // inclina ~1.7° pra dar o balanço
            child: child,
          ),
        );
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 360, maxWidth: 300),
        child: Image.asset(
          'assets/mascote/bipi_loading.gif',
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
