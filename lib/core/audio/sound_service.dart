import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Efeitos sonoros do app. Cada valor aponta para um arquivo em assets/sounds/.
///
/// Para ativar um som, basta colocar o .mp3 correspondente na pasta. Enquanto
/// o arquivo não existir, a chamada é ignorada silenciosamente (sem erro).
enum Sfx {
  /// Resposta certa (toca junto do confete).
  correct('sounds/correct.wav'),

  /// Resposta errada (buzzer suave, não punitivo).
  wrong('sounds/wrong.wav'),

  /// Fase da trilha concluída.
  phaseComplete('sounds/phase_complete.wav'),

  /// Trilha do dia inteira concluída.
  victory('sounds/victory.wav'),

  /// Toque de botão.
  tap('sounds/tap.wav');

  const Sfx(this.asset);

  /// Caminho relativo a `assets/` (o audioplayers já prefixa com "assets/").
  final String asset;
}

/// Toca efeitos sonoros curtos e lembra a preferência de mudo.
///
/// É tolerante a arquivos ausentes: enquanto você não colocar os `.mp3` em
/// `assets/sounds/`, as chamadas a [play] simplesmente não fazem nada.
class SoundService extends ChangeNotifier {
  static const _mutedKey = 'sound_muted';

  final Map<Sfx, AudioPlayer> _players = {};
  bool _muted = false;
  bool _ready = false;

  bool get muted => _muted;

  /// Carrega a preferência salva e pré-aquece os players.
  /// Chamar no `main()` antes de montar o app.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _muted = prefs.getBool(_mutedKey) ?? false;

    for (final sfx in Sfx.values) {
      final player = AudioPlayer(playerId: sfx.name)
        ..setReleaseMode(ReleaseMode.stop);
      try {
        // Modo de baixa latência: ideal para efeitos curtos e repetidos.
        await player.setPlayerMode(PlayerMode.lowLatency);
        // Pré-carrega para tirar o "engasgo" da primeira reprodução.
        await player.setSource(AssetSource(sfx.asset));
      } catch (_) {
        // Arquivo ainda não adicionado: tudo bem, toca quando existir.
      }
      _players[sfx] = player;
    }

    _ready = true;
    notifyListeners();
  }

  /// Toca um efeito. Ignora se estiver no mudo ou se o arquivo não existir.
  Future<void> play(Sfx sfx) async {
    if (_muted || !_ready) return;
    final player = _players[sfx];
    if (player == null) return;
    try {
      await player.stop();
      await player.play(AssetSource(sfx.asset));
    } catch (_) {
      // Sem arquivo ou falha de playback: silencioso de propósito.
    }
  }

  /// Liga/desliga o som e persiste a escolha.
  Future<void> setMuted(bool value) async {
    if (_muted == value) return;
    _muted = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_mutedKey, value);
  }

  Future<void> toggleMuted() => setMuted(!_muted);

  @override
  void dispose() {
    for (final player in _players.values) {
      player.dispose();
    }
    super.dispose();
  }
}

/// Instância única compartilhada pelo app.
final soundService = SoundService();
