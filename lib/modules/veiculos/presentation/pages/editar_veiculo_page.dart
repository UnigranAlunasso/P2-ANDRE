import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/editar_veiculo_viewmodel.dart';

class EditarVeiculoPage extends ConsumerStatefulWidget {
  const EditarVeiculoPage({super.key});

  @override
  ConsumerState<EditarVeiculoPage> createState() => _EditarVeiculoPageState();
}

class _EditarVeiculoPageState extends ConsumerState<EditarVeiculoPage> {
  final _formKey = GlobalKey<FormState>();

  final _modeloCtrl = TextEditingController();
  final _marcaCtrl = TextEditingController();
  final _placaCtrl = TextEditingController();
  final _anoCtrl = TextEditingController();

  String? _combustivel;

  @override
  void dispose() {
    _modeloCtrl.dispose();
    _marcaCtrl.dispose();
    _placaCtrl.dispose();
    _anoCtrl.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(editarVeiculoViewModelProvider.notifier)
        .salvarVeiculo(
          modelo: _modeloCtrl.text.trim(),
          marca: _marcaCtrl.text.trim(),
          placa: _placaCtrl.text.trim(),
          ano: _anoCtrl.text.trim(),
          tipoCombustivel: _combustivel!,
        );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final carregando = ref.watch(editarVeiculoViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Novo Veículo")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(26),
        child: Container(
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            color: tema.colorScheme.surface,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: tema.colorScheme.secondary, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .08),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "Cadastrar Veículo",
                  style: tema.textTheme.titleLarge?.copyWith(
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 25),
                TextFormField(
                  controller: _modeloCtrl,
                  decoration: const InputDecoration(
                    labelText: "Modelo",
                    prefixIcon: Icon(Icons.drive_eta),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? "Informe o modelo" : null,
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _marcaCtrl,
                  decoration: const InputDecoration(
                    labelText: "Marca",
                    prefixIcon: Icon(Icons.factory),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? "Informe a marca" : null,
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _placaCtrl,
                  decoration: const InputDecoration(
                    labelText: "Placa",
                    prefixIcon: Icon(Icons.numbers),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? "Informe a placa" : null,
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _anoCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Ano",
                    prefixIcon: Icon(Icons.event),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? "Informe o ano" : null,
                ),
                const SizedBox(height: 18),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Tipo de combustível",
                    prefixIcon: Icon(Icons.local_gas_station),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: "Gasolina",
                      child: Text("Gasolina"),
                    ),
                    DropdownMenuItem(value: "Etanol", child: Text("Etanol")),
                    DropdownMenuItem(value: "Diesel", child: Text("Diesel")),
                    DropdownMenuItem(value: "GNV", child: Text("GNV")),
                  ],
                  onChanged: (v) => setState(() => _combustivel = v),
                  validator: (v) => v == null ? "Selecione um tipo" : null,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: carregando ? null : _salvar,
                    child: carregando
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text("Salvar"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
