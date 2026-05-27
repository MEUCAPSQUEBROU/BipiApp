import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/// Dados de uma versão mais nova publicada no GitHub Releases.
class UpdateInfo {
  const UpdateInfo({
    required this.version,
    required this.apkUrl,
    required this.notes,
  });

  /// Versão sem o "v" (ex.: "1.0.1").
  final String version;

  /// URL de download direto do APK (anexo do release).
  final String apkUrl;

  /// Texto das notas do release (pode estar vazio).
  final String notes;
}

class UpdateException implements Exception {
  const UpdateException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Verifica e aplica atualizações do app a partir do GitHub Releases.
///
/// Como o app é distribuído por GitHub Releases (ver dist/ e o QR do evento),
/// dá pra comparar a versão instalada com a `releases/latest` e oferecer o
/// download + instalação do APK novo sem passar por loja.
class UpdateService {
  UpdateService._();
  static final UpdateService instance = UpdateService._();

  static const String _owner = 'MEUCAPSQUEBROU';
  static const String _repo = 'BipiApp';
  static const String _latestApi =
      'https://api.github.com/repos/$_owner/$_repo/releases/latest';

  final Dio _dio = Dio();

  /// Retorna [UpdateInfo] se houver versão mais nova publicada; senão `null`.
  /// Falhas de rede são engolidas (retorna `null`) para não atrapalhar o uso.
  Future<UpdateInfo?> checkForUpdate() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final current = info.version; // ex.: "1.0.0"

      final res = await _dio.get<Map<String, dynamic>>(
        _latestApi,
        options: Options(
          headers: {
            // GitHub bloqueia requisições sem User-Agent (403).
            'User-Agent': 'BipiApp',
            'Accept': 'application/vnd.github+json',
          },
        ),
      );

      final data = res.data;
      if (data == null) return null;

      final tag = (data['tag_name'] as String?) ?? '';
      final latest = tag.replaceFirst(RegExp(r'^v'), '').trim();
      if (latest.isEmpty || !_isNewer(latest, current)) return null;

      final assets = (data['assets'] as List?) ?? const [];
      String? apkUrl;
      for (final asset in assets) {
        final name = ((asset as Map)['name'] as String?) ?? '';
        if (name.toLowerCase().endsWith('.apk')) {
          apkUrl = asset['browser_download_url'] as String?;
          break;
        }
      }
      if (apkUrl == null) return null;

      return UpdateInfo(
        version: latest,
        apkUrl: apkUrl,
        notes: ((data['body'] as String?) ?? '').trim(),
      );
    } catch (_) {
      return null;
    }
  }

  /// Baixa o APK do release e abre o instalador do Android.
  ///
  /// [onProgress] recebe o progresso do download de 0.0 a 1.0.
  /// Lança [UpdateException] em caso de permissão negada ou falha ao abrir.
  Future<void> downloadAndInstall(
    UpdateInfo update, {
    void Function(double progress)? onProgress,
  }) async {
    // Android 8+ exige permissão para instalar pacotes de fontes do app.
    final status = await Permission.requestInstallPackages.request();
    if (!status.isGranted) {
      throw const UpdateException(
        'Permissão para instalar apps não foi concedida.',
      );
    }

    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/bipi-${update.version}.apk';

    await _dio.download(
      update.apkUrl,
      path,
      options: Options(headers: {'User-Agent': 'BipiApp'}),
      onReceiveProgress: (received, total) {
        if (total > 0) onProgress?.call(received / total);
      },
    );

    final result = await OpenFilex.open(
      path,
      type: 'application/vnd.android.package-archive',
    );
    if (result.type != ResultType.done) {
      throw UpdateException('Não consegui abrir o instalador: ${result.message}');
    }
  }

  /// `true` se [latest] for maior que [current] comparando X.Y.Z.
  bool _isNewer(String latest, String current) {
    final l = _parse(latest);
    final c = _parse(current);
    for (var i = 0; i < 3; i++) {
      if (l[i] != c[i]) return l[i] > c[i];
    }
    return false;
  }

  /// Converte "1.2.3" (ou "1.2.3+4") em [1, 2, 3], preenchendo com zeros.
  List<int> _parse(String version) {
    final parts = version.split('+').first.split('.');
    return List.generate(
      3,
      (i) => i < parts.length ? (int.tryParse(parts[i]) ?? 0) : 0,
    );
  }
}

final updateService = UpdateService.instance;
