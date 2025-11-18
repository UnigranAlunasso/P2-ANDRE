import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth_module.dart';
import 'auth_state.dart';

class CadastroViewModel extends StateNotifier<AuthFormState> {
  CadastroViewModel(this.ref) : super(const AuthFormState());

  final Ref ref;

  Future<bool> registrar({required String email, required String senha}) async {
    state = state.copyWith(carregando: true, mensagemErro: null);

    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.registrar(email: email, senha: senha);
      state = state.copyWith(carregando: false, mensagemErro: null);
      return true;
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      state = state.copyWith(carregando: false, mensagemErro: msg);
      return false;
    }
  }
}

final cadastroViewModelProvider =
    StateNotifierProvider<CadastroViewModel, AuthFormState>((ref) {
      return CadastroViewModel(ref);
    });
