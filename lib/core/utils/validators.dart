class Validators {
  static String? validarEmail(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe o e-mail';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(valor.trim())) {
      return 'E-mail inválido';
    }
    return null;
  }

  static String? validarSenha(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe a senha';
    }
    if (valor.trim().length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }
}
