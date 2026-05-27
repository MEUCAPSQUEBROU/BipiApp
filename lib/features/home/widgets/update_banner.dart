import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/audio/sound_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/update/update_service.dart';

/// Aviso de atualização na home.
///
/// Ao montar, checa o GitHub Releases. Se houver versão mais nova, mostra um
/// cartão com botão para baixar e instalar o APK pelo próprio app. Enquanto
/// não há atualização (ou a checagem falha), ocupa zero espaço.
class UpdateBanner extends StatefulWidget {
  const UpdateBanner({super.key});

  @override
  State<UpdateBanner> createState() => _UpdateBannerState();
}

class _UpdateBannerState extends State<UpdateBanner> {
  UpdateInfo? _update;
  bool _dismissed = false;
  final ValueNotifier<double> _progress = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    _check();
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  Future<void> _check() async {
    final update = await updateService.checkForUpdate();
    if (mounted) setState(() => _update = update);
  }

  Future<void> _startUpdate(UpdateInfo update) async {
    soundService.play(Sfx.tap);
    _progress.value = 0;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _DownloadDialog(progress: _progress),
    );
    try {
      await updateService.downloadAndInstall(
        update,
        onProgress: (p) => _progress.value = p,
      );
      if (mounted) Navigator.of(context).pop(); // fecha o diálogo de progresso
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível atualizar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final update = _update;
    if (update == null || _dismissed) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.system_update, color: AppColors.primaryDark),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nova versão disponível',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Atualize para a v${update.version}.',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => _startUpdate(update),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              minimumSize: Size.zero,
            ),
            child: const Text('ATUALIZAR'),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18, color: AppColors.textMuted),
            tooltip: 'Agora não',
            onPressed: () => setState(() => _dismissed = true),
          ),
        ],
      ),
    );
  }
}

class _DownloadDialog extends StatelessWidget {
  const _DownloadDialog({required this.progress});

  final ValueListenable<double> progress;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Baixando atualização'),
      content: ValueListenableBuilder<double>(
        valueListenable: progress,
        builder: (context, value, _) {
          final pct = (value * 100).round();
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: value > 0 ? value : null,
                  minHeight: 10,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                value > 0 ? '$pct%' : 'Iniciando…',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 4),
              const Text(
                'Ao terminar, o instalador do Android vai abrir.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ],
          );
        },
      ),
    );
  }
}
