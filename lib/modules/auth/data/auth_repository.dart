abstract class AuthRepository {
  Future<void> login({required String email, required String senha});

  Future<void> registrar({required String email, required String senha});

  Future<void> logout();

  String? getUsuarioAtualId();
}
