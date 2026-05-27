import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Dados do perfil exibidos na tela de perfil.
class ProfileData {
  const ProfileData({this.nome, this.email, this.fotoUrl, this.pontos = 0});

  final String? nome;
  final String? email;

  /// Foto atual: URL do Google ou data-URI base64 (foto personalizada).
  final String? fotoUrl;
  final int pontos;
}

/// Gerencia o perfil do usuário (nome e foto).
///
/// - **Nome**: salvo no Firebase Auth (`displayName`) e espelhado no doc do
///   ranking (`ranking/{uid}.nome`).
/// - **Foto**: como o app não usa Firebase Storage, a foto escolhida é reduzida
///   e gravada como data-URI base64 em `ranking/{uid}.fotoUrl` — assim aparece
///   no ranking para todos. Sem foto personalizada, vale a foto do Google.
class ProfileService {
  ProfileService._();
  static final ProfileService instance = ProfileService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _rankingDoc(String uid) =>
      _db.collection('ranking').doc(uid);

  /// Carrega o perfil do usuário logado (Auth + doc do ranking).
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

    return ProfileData(
      nome: user.displayName,
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
    await _rankingDoc(user.uid).set(
      {'nome': trimmed},
      SetOptions(merge: true),
    );
  }

  /// Salva a foto (bytes já reduzidos) como data-URI base64 no ranking.
  /// Retorna o data-URI gravado.
  Future<String> updatePhoto(Uint8List bytes, {String mime = 'image/jpeg'}) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Sem usuário logado.');
    final dataUri = 'data:$mime;base64,${base64Encode(bytes)}';
    await _rankingDoc(user.uid).set(
      {'fotoUrl': dataUri},
      SetOptions(merge: true),
    );
    return dataUri;
  }

  /// Remove a foto personalizada, voltando para a foto do Google (se houver).
  /// Retorna a foto resultante (URL do Google ou `null`).
  Future<String?> removeCustomPhoto() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final google = user.photoURL;
    await _rankingDoc(user.uid).set(
      {'fotoUrl': google},
      SetOptions(merge: true),
    );
    return google;
  }
}

/// Instância única compartilhada pelo app.
final profileService = ProfileService.instance;
