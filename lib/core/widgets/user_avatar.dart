import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Avatar circular do usuário.
///
/// Aceita uma foto de rede (`http...`), uma foto embutida como data-URI base64
/// (`data:image/...;base64,...`) ou, na falta de ambas, mostra a inicial do
/// nome. Reutilizado na tela de perfil e no ranking.
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.fotoUrl,
    required this.nome,
    required this.size,
    this.ring,
    this.ringWidth = 3,
  });

  final String? fotoUrl;
  final String nome;
  final double size;

  /// Cor do anel ao redor. Se nulo, não desenha anel.
  final Color? ring;
  final double ringWidth;

  @override
  Widget build(BuildContext context) {
    final fallback = _Initial(initial: _initialOf(nome), size: size);
    Widget inner = fallback;

    final url = fotoUrl?.trim();
    if (url != null && url.isNotEmpty) {
      final bytes = _tryDecodeDataUri(url);
      if (bytes != null) {
        inner = Image.memory(
          bytes,
          width: size,
          height: size,
          fit: BoxFit.cover,
          gaplessPlayback: true,
          errorBuilder: (_, _, _) => fallback,
        );
      } else if (url.startsWith('http')) {
        inner = Image.network(
          url,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => fallback,
          loadingBuilder: (context, child, progress) =>
              progress == null ? child : fallback,
        );
      }
    }

    final clipped = ClipOval(
      child: SizedBox(width: size, height: size, child: inner),
    );

    if (ring == null) return clipped;
    return Container(
      padding: EdgeInsets.all(ringWidth),
      decoration: BoxDecoration(color: ring, shape: BoxShape.circle),
      child: clipped,
    );
  }

  static String _initialOf(String nome) {
    final t = nome.trim();
    return t.isEmpty ? '?' : t[0].toUpperCase();
  }

  /// Decodifica `data:...;base64,XXXX`. Retorna `null` se não for um data-URI.
  static Uint8List? _tryDecodeDataUri(String value) {
    if (!value.startsWith('data:')) return null;
    final marker = value.indexOf('base64,');
    if (marker == -1) return null;
    try {
      return base64Decode(value.substring(marker + 'base64,'.length));
    } catch (_) {
      return null;
    }
  }
}

class _Initial extends StatelessWidget {
  const _Initial({required this.initial, required this.size});
  final String initial;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: AppColors.primary,
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          color: AppColors.onPrimary,
          fontWeight: FontWeight.w800,
          fontSize: size * 0.42,
        ),
      ),
    );
  }
}
