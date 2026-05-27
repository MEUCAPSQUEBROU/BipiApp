import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/auth/auth_service.dart';
import '../../core/profile/profile_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/user_avatar.dart';
import '../auth/widgets/auth_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _picker = ImagePicker();

  bool _loading = true;
  bool _savingName = false;
  bool _photoBusy = false;

  String? _email;
  String? _fotoUrl;
  int _pontos = 0;
  String _version = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final data = await profileService.load();
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() {
      _nameCtrl.text = (data.nome ?? '').trim();
      _email = data.email;
      _fotoUrl = data.fotoUrl;
      _pontos = data.pontos;
      _version = 'Bipi v${info.version}';
      _loading = false;
    });
  }

  String get _nome =>
      _nameCtrl.text.trim().isEmpty ? 'Sem nome' : _nameCtrl.text.trim();

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _saveName() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    setState(() => _savingName = true);
    try {
      await profileService.updateName(_nameCtrl.text);
      setState(() {}); // atualiza o nome exibido sob o avatar
      _snack('Nome atualizado!');
    } catch (_) {
      _snack('Não foi possível salvar o nome.');
    } finally {
      if (mounted) setState(() => _savingName = false);
    }
  }

  Future<void> _openPhotoSheet() async {
    final hasCustom = (_fotoUrl ?? '').startsWith('data:');
    final action = await showModalBottomSheet<_PhotoAction>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Escolher da galeria'),
              onTap: () => Navigator.pop(context, _PhotoAction.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Tirar foto'),
              onTap: () => Navigator.pop(context, _PhotoAction.camera),
            ),
            if (hasCustom)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: AppColors.error),
                title: const Text('Remover foto',
                    style: TextStyle(color: AppColors.error)),
                onTap: () => Navigator.pop(context, _PhotoAction.remove),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (action == null) return;
    switch (action) {
      case _PhotoAction.gallery:
        await _pickPhoto(ImageSource.gallery);
      case _PhotoAction.camera:
        await _pickPhoto(ImageSource.camera);
      case _PhotoAction.remove:
        await _removePhoto();
    }
  }

  Future<void> _pickPhoto(ImageSource source) async {
    final XFile? picked;
    try {
      picked = await _picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
      );
    } catch (_) {
      _snack('Não foi possível acessar a câmera/galeria.');
      return;
    }
    if (picked == null) return; // usuário cancelou a seleção

    // Etapa de enquadramento: recorte circular/quadrado (combina com o avatar).
    final CroppedFile? cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      maxWidth: 512,
      maxHeight: 512,
      compressQuality: 80,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Enquadrar foto',
          toolbarColor: AppColors.brandBlue,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: AppColors.brandBlue,
          lockAspectRatio: true,
          hideBottomControls: true,
          cropStyle: CropStyle.circle,
        ),
      ],
    );
    if (cropped == null) return; // usuário cancelou o recorte

    setState(() => _photoBusy = true);
    try {
      final bytes = await File(cropped.path).readAsBytes();
      final dataUri = await profileService.updatePhoto(bytes);
      if (mounted) setState(() => _fotoUrl = dataUri);
      _snack('Foto atualizada!');
    } catch (_) {
      _snack('Não foi possível salvar a foto.');
    } finally {
      if (mounted) setState(() => _photoBusy = false);
    }
  }

  Future<void> _removePhoto() async {
    setState(() => _photoBusy = true);
    try {
      final foto = await profileService.removeCustomPhoto();
      if (mounted) setState(() => _fotoUrl = foto);
      _snack('Foto removida.');
    } catch (_) {
      _snack('Não foi possível remover a foto.');
    } finally {
      if (mounted) setState(() => _photoBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(child: _AvatarEditor(
                    fotoUrl: _fotoUrl,
                    nome: _nome,
                    busy: _photoBusy,
                    onTap: _photoBusy ? null : _openPhotoSheet,
                  )),
                  const SizedBox(height: 16),
                  Text(
                    _nome,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  if ((_email ?? '').isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      _email!,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Center(child: _PointsChip(pontos: _pontos)),
                  const SizedBox(height: 32),
                  Form(
                    key: _formKey,
                    child: AuthTextField(
                      controller: _nameCtrl,
                      label: 'Seu nome',
                      icon: Icons.person_outline,
                      textInputAction: TextInputAction.done,
                      enabled: !_savingName,
                      validator: AuthValidators.name,
                      onFieldSubmitted: (_) => _saveName(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _savingName ? null : _saveName,
                    child: _savingName
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.onPrimary,
                            ),
                          )
                        : const Text('SALVAR NOME'),
                  ),
                  const SizedBox(height: 32),
                  OutlinedButton.icon(
                    onPressed: () => authService.signOut(),
                    icon: const Icon(Icons.logout, color: AppColors.error),
                    label: const Text('SAIR',
                        style: TextStyle(color: AppColors.error)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.error, width: 2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _version,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
    );
  }
}

enum _PhotoAction { gallery, camera, remove }

/// Avatar grande com botão de câmera sobreposto e indicador de carregamento.
class _AvatarEditor extends StatelessWidget {
  const _AvatarEditor({
    required this.fotoUrl,
    required this.nome,
    required this.busy,
    required this.onTap,
  });

  final String? fotoUrl;
  final String nome;
  final bool busy;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 136,
      height: 136,
      child: Stack(
        children: [
          Center(
            child: UserAvatar(
              fotoUrl: fotoUrl,
              nome: nome,
              size: 120,
              ring: AppColors.primary,
            ),
          ),
          if (busy)
            const Positioned.fill(
              child: Center(child: CircularProgressIndicator()),
            ),
          Positioned(
            right: 2,
            bottom: 2,
            child: Material(
              color: AppColors.primary,
              shape: const CircleBorder(
                side: BorderSide(color: AppColors.background, width: 3),
              ),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onTap,
                child: const Padding(
                  padding: EdgeInsets.all(9),
                  child: Icon(Icons.photo_camera,
                      color: AppColors.onPrimary, size: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PointsChip extends StatelessWidget {
  const _PointsChip({required this.pontos});
  final int pontos;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.streak.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: AppColors.streak, size: 20),
          const SizedBox(width: 6),
          Text(
            '$pontos pts',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.streak,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
