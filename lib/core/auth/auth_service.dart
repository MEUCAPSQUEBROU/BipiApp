import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Erro de autenticação já traduzido para exibição na UI.
class AuthFailure implements Exception {
  const AuthFailure(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Centraliza toda a lógica de autenticação do app (e-mail/senha + Google).
///
/// Uma única instância é compartilhada pelo app (ver [authService]).
class AuthService {
  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;
  bool _googleReady = false;

  /// Client ID do tipo "Web" (client_type 3) criado pelo Firebase ao habilitar
  /// o login Google. No Android ele é obrigatório para o `idToken` ser aceito
  /// pelo Firebase. Valor copiado do oauth_client do google-services.json.
  static const String _googleServerClientId =
      '254313833107-ng636pqecsb726pqfjbkkah0dbpjutvb.apps.googleusercontent.com';

  /// Emite o usuário logado (ou `null`) sempre que o estado de auth muda.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _guard(
      () => _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      ),
    );
  }

  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) {
    return _guard(() async {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final name = displayName?.trim();
      if (name != null && name.isNotEmpty) {
        await credential.user?.updateDisplayName(name);
      }
      return credential;
    });
  }

  Future<void> sendPasswordReset(String email) {
    return _guard(() => _auth.sendPasswordResetEmail(email: email.trim()));
  }

  /// Faz login com Google. Retorna `null` se o usuário cancelar o fluxo.
  Future<UserCredential?> signInWithGoogle() async {
    return _guard(() async {
      await _ensureGoogleInitialized();
      final GoogleSignInAccount account;
      try {
        account = await GoogleSignIn.instance.authenticate(
          scopeHint: const ['email'],
        );
      } on GoogleSignInException catch (e) {
        if (e.code == GoogleSignInExceptionCode.canceled) return null;
        rethrow;
      }

      final idToken = account.authentication.idToken;
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      return _auth.signInWithCredential(credential);
    });
  }

  Future<void> signOut() async {
    try {
      await GoogleSignIn.instance.signOut();
    } on GoogleSignInException {
      // Ignora: usuário pode não ter entrado via Google.
    }
    await _auth.signOut();
  }

  Future<void> _ensureGoogleInitialized() async {
    if (_googleReady) return;
    await GoogleSignIn.instance.initialize(
      serverClientId:
          _googleServerClientId.isEmpty ? null : _googleServerClientId,
    );
    _googleReady = true;
  }

  /// Executa [action] convertendo exceções do Firebase em [AuthFailure]
  /// com mensagens amigáveis em português.
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_messageFor(e.code));
    }
  }

  String _messageFor(String code) {
    switch (code) {
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'user-disabled':
        return 'Esta conta foi desativada.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-mail ou senha incorretos.';
      case 'email-already-in-use':
        return 'Já existe uma conta com este e-mail.';
      case 'weak-password':
        return 'A senha precisa ter ao menos 6 caracteres.';
      case 'operation-not-allowed':
        return 'Este método de login não está habilitado.';
      case 'network-request-failed':
        return 'Sem conexão. Verifique sua internet.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente em instantes.';
      default:
        return 'Não foi possível concluir. Tente novamente.';
    }
  }
}

/// Instância única compartilhada pelo app.
final authService = AuthService();
