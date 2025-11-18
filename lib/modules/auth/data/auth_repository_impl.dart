import 'package:firebase_auth/firebase_auth.dart';

import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<void> login({required String email, required String senha}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_traduzirErro(e.code));
    } catch (_) {
      throw Exception('Erro ao fazer login. Tente novamente.');
    }
  }

  @override
  Future<void> registrar({required String email, required String senha}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_traduzirErro(e.code));
    } catch (_) {
      throw Exception('Erro ao criar conta. Tente novamente.');
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  String? getUsuarioAtualId() {
    final user = _firebaseAuth.currentUser;
    return user?.uid;
  }

  String _traduzirErro(String code) {
    switch (code) {
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'user-not-found':
        return 'Usuário não encontrado.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'user-disabled':
        return 'Usuário desativado.';
      case 'email-already-in-use':
        return 'E-mail já está em uso.';
      case 'weak-password':
        return 'Senha muito fraca. Use pelo menos 6 caracteres.';
      case 'operation-not-allowed':
        return 'Operação não permitida. Entre em contato com o suporte.';
      default:
        return 'Erro de autenticação. Tente novamente.';
    }
  }
}
