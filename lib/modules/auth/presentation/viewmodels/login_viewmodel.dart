import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth_module.dart';
import 'auth_state.dart';

class LoginViewModel extends StateNotifier<AuthFormState> {
  LoginViewModel(this.ref) : super(const AuthFormState());

  final Ref ref;

  Future<bool> login({required String email, required String senha}) async {
    state = state.copyWith(carregando: true, mensagemErro: null);

    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.login(email: email, senha: senha);
      state = state.copyWith(carregando: false, mensagemErro: null);
      return true;
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      state = state.copyWith(carregando: false, mensagemErro: msg);
      return false;
    }
  }
}

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, AuthFormState>((ref) {
      return LoginViewModel(ref);
    });
