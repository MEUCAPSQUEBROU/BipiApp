import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Uma posição no ranking.
class RankingEntry {
  const RankingEntry({
    required this.uid,
    required this.nome,
    required this.pontos,
    this.fotoUrl,
  });

  final String uid;
  final String nome;
  final int pontos;
  final String? fotoUrl;

  /// Primeiro nome, para exibição compacta (pódio).
  String get primeiroNome {
    final t = nome.trim();
    return t.isEmpty ? 'Anônimo' : t.split(RegExp(r'\s+')).first;
  }

  factory RankingEntry.fromDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    final nome = (data['nome'] as String?)?.trim();
    final foto = (data['fotoUrl'] as String?)?.trim();
    return RankingEntry(
      uid: doc.id,
      nome: (nome == null || nome.isEmpty) ? 'Anônimo' : nome,
      pontos: (data['pontos'] as num?)?.toInt() ?? 0,
      fotoUrl: (foto == null || foto.isEmpty) ? null : foto,
    );
  }
}

/// Pontuação e ranking, persistidos no Firestore (coleção `ranking`).
///
/// Documento por usuário: `ranking/{uid}` → { nome, pontos, atualizadoEm }.
class ScoreRepository {
  ScoreRepository({FirebaseFirestore? db, FirebaseAuth? auth})
      : _db = db ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _ranking =>
      _db.collection('ranking');

  String? get currentUid => _auth.currentUser?.uid;

  /// Soma [points] ao total do usuário logado (cria o doc se não existir).
  /// É best-effort: falha de rede/Firestore não deve travar o jogo.
  Future<void> addPoints(int points) async {
    final user = _auth.currentUser;
    if (user == null || points <= 0) return;

    final displayName = user.displayName?.trim();
    final nome = (displayName != null && displayName.isNotEmpty)
        ? displayName
        : (user.email ?? 'Anônimo');
    final ref = _ranking.doc(user.uid);

    try {
      await _db.runTransaction((tx) async {
        final snap = await tx.get(ref);
        final fotoAtual = (snap.data()?['fotoUrl'] as String?)?.trim();
        tx.set(ref, {
          'nome': nome,
          // Só grava a foto do Google se ainda não houver uma — assim não
          // sobrescreve a foto personalizada salva pelo perfil.
          if (fotoAtual == null || fotoAtual.isEmpty) 'fotoUrl': user.photoURL,
          'pontos': FieldValue.increment(points),
          'atualizadoEm': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      });
    } catch (_) {
      // Ranking é best-effort; ignora falhas para não interromper o quiz.
    }
  }

  /// Top 10 jogadores por pontos (decrescente).
  Future<List<RankingEntry>> top10() async {
    final snap =
        await _ranking.orderBy('pontos', descending: true).limit(10).get();
    return snap.docs.map(RankingEntry.fromDoc).toList();
  }
}

/// Instância única compartilhada pelo app.
final scoreRepository = ScoreRepository();
