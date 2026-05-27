import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Dados do perfil exibidos na tela de perfil.
class ProfileData {
  const ProfileData({this.nome, this.email, this.fotoUrl, this.pontos = 0});

  final String? nome;
  final String? email;

  /// Foto atual: URL do Google ou data-URI base64 (foto personalizada).
  final String? fotoUrl;
  final int pontos;
}

/// Gerencia o perfil do usuário (nome e foto) e **notifica** mudanças.
///
/// É um [ChangeNotifier]: a home e o perfil escutam via `ListenableBuilder`,
/// então trocar nome/foto reflete na hora no avatar da home (sem reabrir o app).
///
/// - **Nome**: salvo no Firebase Auth (`displayName`) e espelhado em `ranking/{uid}.nome`.
/// - **Foto**: sem Firebase Storage, é gravada como data-URI base64 em
///   `ranking/{uid}.fotoUrl` (assim aparece no ranking). Sem foto personalizada,
///   vale a foto do Google.
class ProfileService extends ChangeNotifier {
  ProfileService._() {
    // Ao trocar de conta (login/logout), zera o cache para não vazar a foto
    // de um usuário para outro.
    _auth.authStateChanges().listen((_) {
      _fotoUrl = null;
      _nome = null;
      _loaded = false;
      notifyListeners();
    });
  }
  static final ProfileService instance = ProfileService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Cache reativo (fonte para o avatar/nome exibidos pela home).
  String? _fotoUrl;
  String? _nome;
  bool _loaded = false;

  String? get fotoUrl => _fotoUrl;
  String? get nome => _nome;

  DocumentReference<Map<String, dynamic>> _rankingDoc(String uid) =>
      _db.collection('ranking').doc(uid);

  /// Carrega o perfil ao menos uma vez (usado pela home, sem recarregar à toa).
  Future<void> ensureLoaded() async {
    if (!_loaded) await load();
  }

  /// Carrega o perfil do usuário logado (Auth + doc do ranking) e atualiza o cache.
  Future<ProfileData> load() async {
    final user = _auth.currentUser;
    if (user == null) return const ProfileData();

    String? foto = user.photoURL;
    int pontos = 0;
    try {
      final snap = await _rankingDoc(user.uid).get();
      final data = snap.data();
      if (data != null) {
        final f = (data['fotoUrl'] as String?)?.trim();
        if (f != null && f.isNotEmpty) foto = f;
        pontos = (data['pontos'] as num?)?.toInt() ?? 0;
      }
    } catch (_) {
      // Sem rede: mostra ao menos o que o Auth tem.
    }

    _fotoUrl = foto;
    _nome = user.displayName;
    _loaded = true;
    notifyListeners();

    return ProfileData(
      nome: _nome,
      email: user.email,
      fotoUrl: foto,
      pontos: pontos,
    );
  }

  /// Atualiza o nome no Auth e no doc do ranking.
  Future<void> updateName(String name) async {
    final user = _auth.currentUser;
    if (user == null) return;
    final trimmed = name.trim();
    await user.updateDisplayName(trimmed);
    await _rankingDoc(user.uid).set({'nome': trimmed}, SetOptions(merge: true));
    _nome = trimmed;
    notifyListeners();
  }

  /// Salva a foto (bytes já recortados/reduzidos) como data-URI base64.
  /// Retorna o data-URI gravado.
  Future<String> updatePhoto(Uint8List bytes, {String mime = 'image/jpeg'}) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Sem usuário logado.');
    final dataUri = 'data:$mime;base64,${base64Encode(bytes)}';
    await _rankingDoc(user.uid).set({'fotoUrl': dataUri}, SetOptions(merge: true));
    _fotoUrl = dataUri;
    notifyListeners();
    return dataUri;
  }

  /// Remove a foto personalizada, voltando para a foto do Google (se houver).
  Future<String?> removeCustomPhoto() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final google = user.photoURL;
    await _rankingDoc(user.uid).set({'fotoUrl': google}, SetOptions(merge: true));
    _fotoUrl = google;
    notifyListeners();
    return google;
  }
}

/// Instância única compartilhada pelo app.
final profileService = ProfileService.instance;
