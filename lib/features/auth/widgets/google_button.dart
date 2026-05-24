import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Botão "Continuar com Google" no estilo das telas de auth.
class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key, required this.onPressed, this.enabled = true});

  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: enabled ? onPressed : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _GoogleG(),
          const SizedBox(width: 12),
          Text(
            'Continuar com Google',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: enabled ? AppColors.textPrimary : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

/// "G" do Google desenhado sem depender de asset externo.
class _GoogleG extends StatelessWidget {
  const _GoogleG();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.border),
      ),
      child: const Text(
        'G',
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 16,
          color: Color(0xFF4285F4),
        ),
      ),
    );
  }
}
