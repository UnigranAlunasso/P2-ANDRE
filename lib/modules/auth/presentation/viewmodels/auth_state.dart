class AuthFormState {
  final bool carregando;
  final String? mensagemErro;

  const AuthFormState({this.carregando = false, this.mensagemErro});

  AuthFormState copyWith({bool? carregando, String? mensagemErro}) {
    return AuthFormState(
      carregando: carregando ?? this.carregando,
      mensagemErro: mensagemErro,
    );
  }
}
