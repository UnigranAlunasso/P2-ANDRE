import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../veiculos/presentation/viewmodels/listar_veiculos_viewmodel.dart';
import '../viewmodels/registrar_abastecimento_viewmodel.dart';

class RegistrarAbastecimentoPage extends ConsumerStatefulWidget {
  const RegistrarAbastecimentoPage({super.key});

  @override
  ConsumerState<RegistrarAbastecimentoPage> createState() =>
      _RegistrarAbastecimentoPageState();
}

class _RegistrarAbastecimentoPageState
    extends ConsumerState<RegistrarAbastecimentoPage> {
  final _formKey = GlobalKey<FormState>();

  final _litrosCtrl = TextEditingController();
  final _valorCtrl = TextEditingController();
  final _kmCtrl = TextEditingController();
  final _consumoCtrl = TextEditingController();
  final _obsCtrl = TextEditingController();

  DateTime _data = DateTime.now();
  String? _combustivel;
  String? _veiculoId;

  @override
  void dispose() {
    _litrosCtrl.dispose();
    _valorCtrl.dispose();
    _kmCtrl.dispose();
    _consumoCtrl.dispose();
    _obsCtrl.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final agora = DateTime.now();
    final escolhida = await showDatePicker(
      context: context,
      initialDate: _data,
      firstDate: DateTime(2000),
      lastDate: DateTime(agora.year + 1),
    );
    if (escolhida != null) {
      setState(() => _data = escolhida);
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final litros = double.parse(_litrosCtrl.text.replaceAll(',', '.'));
    final valor = double.parse(_valorCtrl.text.replaceAll(',', '.'));
    final km = int.parse(_kmCtrl.text.trim());
    final consumo = double.parse(_consumoCtrl.text.replaceAll(',', '.'));

    await ref
        .read(registrarAbastecimentoViewModelProvider.notifier)
        .registrar(
          data: _data,
          quantidadeLitros: litros,
          valorPago: valor,
          quilometragem: km,
          tipoCombustivel: _combustivel!,
          veiculoId: _veiculoId!,
          consumo: consumo,
          observacao: _obsCtrl.text.trim(),
        );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final carregando = ref.watch(registrarAbastecimentoViewModelProvider);
    final veiculosAsync = ref.watch(listarVeiculosProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Abastecimento")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(26),
        child: veiculosAsync.when(
          data: (veiculos) {
            if (veiculos.isEmpty) {
              return const Center(child: Text("Cadastre um veículo primeiro."));
            }

            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: tema.colorScheme.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: tema.colorScheme.secondary,
                  width: 1.2,
                ),
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
                      "Novo Abastecimento",
                      style: tema.textTheme.titleLarge?.copyWith(
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Veículo",
                        prefixIcon: Icon(Icons.directions_car),
                      ),
                      items: veiculos.map<DropdownMenuItem<String>>((v) {
                        final id = v['id'] as String;
                        final modelo = v['modelo']?.toString() ?? '';
                        final marca = v['marca']?.toString() ?? '';
                        return DropdownMenuItem<String>(
                          value: id,
                          child: Text("$modelo - $marca"),
                        );
                      }).toList(),
                      onChanged: (v) => setState(() => _veiculoId = v),
                      validator: (v) =>
                          v == null ? "Selecione um veículo" : null,
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Data: ${_data.day.toString().padLeft(2, '0')}/"
                            "${_data.month.toString().padLeft(2, '0')}/"
                            "${_data.year}",
                            style: tema.textTheme.bodyMedium,
                          ),
                        ),
                        TextButton(
                          onPressed: _selecionarData,
                          child: const Text("Alterar data"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _litrosCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: "Litros abastecidos",
                        prefixIcon: Icon(Icons.local_gas_station),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? "Informe os litros" : null,
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _valorCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: "Valor pago (R\$)",
                        prefixIcon: Icon(Icons.payments),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? "Informe o valor" : null,
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _kmCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Quilometragem atual",
                        prefixIcon: Icon(Icons.route),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? "Informe a km" : null,
                    ),
                    const SizedBox(height: 18),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Tipo de combustível",
                        prefixIcon: Icon(Icons.fireplace),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "Gasolina",
                          child: Text("Gasolina"),
                        ),
                        DropdownMenuItem(
                          value: "Etanol",
                          child: Text("Etanol"),
                        ),
                        DropdownMenuItem(
                          value: "Diesel",
                          child: Text("Diesel"),
                        ),
                        DropdownMenuItem(value: "GNV", child: Text("GNV")),
                      ],
                      onChanged: (v) => setState(() => _combustivel = v),
                      validator: (v) =>
                          v == null ? "Selecione o combustível" : null,
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _consumoCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: "Consumo (km/L)",
                        prefixIcon: Icon(Icons.speed),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? "Informe o consumo" : null,
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _obsCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: "Observação (opcional)",
                        prefixIcon: Icon(Icons.edit_note),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: carregando ? null : _salvar,
                        child: carregando
                            ? const SizedBox(
                                width: 22,
                                height: 22,
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
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) =>
              const Center(child: Text("Erro ao carregar veículos")),
        ),
      ),
    );
  }
}
