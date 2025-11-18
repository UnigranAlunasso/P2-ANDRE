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
  final _observacaoCtrl = TextEditingController();
  final _consumoCtrl = TextEditingController();

  String? _tipo;
  String? _veiculoId;

  DateTime _data = DateTime.now();

  @override
  void dispose() {
    _litrosCtrl.dispose();
    _valorCtrl.dispose();
    _kmCtrl.dispose();
    _observacaoCtrl.dispose();
    _consumoCtrl.dispose();
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
      setState(() {
        _data = escolhida;
      });
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final litros = double.parse(_litrosCtrl.text.trim().replaceAll(',', '.'));
    final valor = double.parse(_valorCtrl.text.trim().replaceAll(',', '.'));
    final km = int.parse(_kmCtrl.text.trim());
    final consumo = double.parse(_consumoCtrl.text.trim().replaceAll(',', '.'));

    await ref
        .read(registrarAbastecimentoViewModelProvider.notifier)
        .registrar(
          data: _data,
          quantidadeLitros: litros,
          valorPago: valor,
          quilometragem: km,
          tipoCombustivel: _tipo!,
          veiculoId: _veiculoId!,
          consumo: consumo,
          observacao: _observacaoCtrl.text.trim(),
        );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final carregando = ref.watch(registrarAbastecimentoViewModelProvider);
    final veiculosAsync = ref.watch(listarVeiculosProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Abastecimento')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: veiculosAsync.when(
          data: (veiculos) {
            if (veiculos.isEmpty) {
              return const Center(child: Text('Cadastre um veículo primeiro.'));
            }

            return Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Veículo'),
                    items: veiculos.map<DropdownMenuItem<String>>((v) {
                      return DropdownMenuItem<String>(
                        value: v['id'] as String,
                        child: Text('${v['modelo']} (${v['placa']})'),
                      );
                    }).toList(),
                    onChanged: (v) => setState(() => _veiculoId = v),
                    validator: (v) => v == null ? 'Selecione um veículo' : null,
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Data: ${_data.day.toString().padLeft(2, '0')}/'
                          '${_data.month.toString().padLeft(2, '0')}/'
                          '${_data.year}',
                        ),
                      ),
                      TextButton(
                        onPressed: _selecionarData,
                        child: const Text('Alterar data'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _litrosCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Quantidade de litros',
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Informe a quantidade' : null,
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _valorCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Valor pago (R\$)',
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Informe o valor' : null,
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _kmCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quilometragem',
                    ),
                    validator: (v) => v == null || v.isEmpty
                        ? 'Informe a quilometragem'
                        : null,
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Tipo de combustível',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Gasolina',
                        child: Text('Gasolina'),
                      ),
                      DropdownMenuItem(value: 'Etanol', child: Text('Etanol')),
                      DropdownMenuItem(value: 'Diesel', child: Text('Diesel')),
                      DropdownMenuItem(value: 'GNV', child: Text('GNV')),
                    ],
                    onChanged: (v) => setState(() => _tipo = v),
                    validator: (v) =>
                        v == null ? 'Selecione o combustível' : null,
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _consumoCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Consumo (km/L)',
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Informe o consumo' : null,
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _observacaoCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Observação (opcional)',
                    ),
                    maxLines: 2,
                  ),

                  const SizedBox(height: 32),

                  ElevatedButton(
                    onPressed: carregando ? null : _salvar,
                    child: carregando
                        ? const CircularProgressIndicator()
                        : const Text('Salvar'),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) =>
              const Center(child: Text('Erro ao carregar veículos')),
        ),
      ),
    );
  }
}
