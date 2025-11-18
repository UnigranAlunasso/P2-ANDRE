import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/viewmodels/editar_veiculo_viewmodel.dart';

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
  String? _tipo;

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

    final vm = ref.read(editarVeiculoViewModelProvider.notifier);
    await vm.criar(
      modelo: _modeloCtrl.text.trim(),
      marca: _marcaCtrl.text.trim(),
      placa: _placaCtrl.text.trim(),
      ano: _anoCtrl.text.trim(),
      tipoCombustivel: _tipo!,
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final carregando = ref.watch(editarVeiculoViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Cadastrar Veículo")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _modeloCtrl,
                decoration: const InputDecoration(labelText: "Modelo"),
                validator: (v) => v!.isEmpty ? "Informe o modelo" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _marcaCtrl,
                decoration: const InputDecoration(labelText: "Marca"),
                validator: (v) => v!.isEmpty ? "Informe a marca" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _placaCtrl,
                decoration: const InputDecoration(labelText: "Placa"),
                validator: (v) => v!.isEmpty ? "Informe a placa" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _anoCtrl,
                decoration: const InputDecoration(labelText: "Ano"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Informe o ano" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Tipo de combustível",
                ),
                items: const [
                  DropdownMenuItem(value: "Gasolina", child: Text("Gasolina")),
                  DropdownMenuItem(value: "Etanol", child: Text("Etanol")),
                  DropdownMenuItem(value: "Diesel", child: Text("Diesel")),
                  DropdownMenuItem(value: "GNV", child: Text("GNV")),
                ],
                onChanged: (v) => setState(() => _tipo = v),
                validator: (v) => v == null ? "Selecione um tipo" : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: carregando ? null : _salvar,
                child: carregando
                    ? const CircularProgressIndicator()
                    : const Text("Salvar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
