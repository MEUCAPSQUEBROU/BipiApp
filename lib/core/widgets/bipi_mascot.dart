import 'package:flutter/material.dart';

/// Expressões disponíveis do mascote Bipi.
enum BipiMood { normal, feliz, duvida, decepcao }

/// Exibe o mascote Bipi em uma das suas expressões.
///
/// Centraliza os caminhos dos assets para o resto do app não precisar
/// conhecê-los.
class BipiMascot extends StatelessWidget {
  const BipiMascot(this.mood, {super.key, this.height = 140, this.width});

  final BipiMood mood;
  final double? height;
  final double? width;

  String get _asset {
    switch (mood) {
      case BipiMood.normal:
        return 'assets/mascote/bipi_normal.png';
      case BipiMood.feliz:
        return 'assets/mascote/bipi_feliz.png';
      case BipiMood.duvida:
        return 'assets/mascote/bipi_duvida.png';
      case BipiMood.decepcao:
        return 'assets/mascote/bipi_decepcao.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _asset,
      height: height,
      width: width,
      fit: BoxFit.contain,
    );
  }
}
