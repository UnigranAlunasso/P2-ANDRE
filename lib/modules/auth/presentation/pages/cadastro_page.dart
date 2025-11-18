import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/validators.dart';
import '../viewmodels/cadastro_viewmodel.dart';

class CadastroPage extends ConsumerStatefulWidget {
  const CadastroPage({super.key});

  @override
  ConsumerState<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends ConsumerState<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  final _confirmarCtrl = TextEditingController();

  bool _verSenha = false;
  bool _verConfirmar = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    _confirmarCtrl.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    if (!_formKey.currentState!.validate()) return;

    if (_senhaCtrl.text.trim() != _confirmarCtrl.text.trim()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("As senhas não coincidem.")));
      return;
    }

    final ok = await ref
        .read(cadastroViewModelProvider.notifier)
        .registrar(
          email: _emailCtrl.text.trim(),
          senha: _senhaCtrl.text.trim(),
        );

    final estado = ref.read(cadastroViewModelProvider);

    if (!ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(estado.mensagemErro ?? "Erro")));
      return;
    }

    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cadastroViewModelProvider);
    final tema = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 26, right: 26, top: 26),
          child: Container(
            padding: const EdgeInsets.all(30),
            constraints: const BoxConstraints(maxWidth: 480),
            decoration: BoxDecoration(
              color: tema.colorScheme.surface,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: tema.colorScheme.secondary, width: 1.4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .08),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.person_add_alt_1,
                  size: 74,
                  color: tema.colorScheme.primary.withValues(alpha: .85),
                ),

                const SizedBox(height: 24),

                Text(
                  "Criar Conta",
                  style: tema.textTheme.headlineLarge?.copyWith(
                    letterSpacing: 0.8,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  "Preencha os dados abaixo",
                  style: tema.textTheme.bodyMedium,
                ),

                const SizedBox(height: 30),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailCtrl,
                        decoration: const InputDecoration(
                          labelText: "E-mail",
                          prefixIcon: Icon(Icons.mail_outline),
                        ),
                        validator: Validators.validarEmail,
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller: _senhaCtrl,
                        obscureText: !_verSenha,
                        decoration: InputDecoration(
                          labelText: "Senha",
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _verSenha
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: tema.colorScheme.primary,
                            ),
                            onPressed: () =>
                                setState(() => _verSenha = !_verSenha),
                          ),
                        ),
                        validator: Validators.validarSenha,
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller: _confirmarCtrl,
                        obscureText: !_verConfirmar,
                        decoration: InputDecoration(
                          labelText: "Confirmar senha",
                          prefixIcon: const Icon(Icons.lock_reset),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _verConfirmar
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: tema.colorScheme.primary,
                            ),
                            onPressed: () =>
                                setState(() => _verConfirmar = !_verConfirmar),
                          ),
                        ),
                        validator: Validators.validarSenha,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.carregando ? null : _registrar,
                    child: state.carregando
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text("Cadastrar"),
                  ),
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  },
                  child: const Text("Já tenho conta"),
                ),

                const SizedBox(height: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
