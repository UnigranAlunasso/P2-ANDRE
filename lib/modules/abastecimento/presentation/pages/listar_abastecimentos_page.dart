import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodels/listar_abastecimentos_viewmodel.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../veiculos/data/veiculo_by_id_provider.dart';
import '../../abastecimentos_module.dart';

class ListarAbastecimentosPage extends ConsumerWidget {
  const ListarAbastecimentosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(listarAbastecimentosProvider);
    final repo = ref.read(abastecimentoRepositoryProvider);
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Histórico de Abastecimentos")),
      drawer: const AppDrawer(),
      body: async.when(
        data: (lista) {
          if (lista.isEmpty) {
            return const Center(
              child: Text("Nenhum abastecimento registrado."),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: lista.length,
            itemBuilder: (context, i) {
              final a = lista[i];
              final veiculoAsync = ref.watch(
                veiculoByIdProvider(a['veiculoId']),
              );

              final dataObj = DateTime.tryParse(a['data']);
              final dataStr = dataObj == null
                  ? "Data inválida"
                  : "${dataObj.day.toString().padLeft(2, '0')}/"
                        "${dataObj.month.toString().padLeft(2, '0')}/"
                        "${dataObj.year}";

              return veiculoAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, __) =>
                    const ListTile(title: Text("Erro ao carregar veículo")),
                data: (veiculo) {
                  final modelo = veiculo?['modelo'] ?? "Indefinido";
                  final marca = veiculo?['marca'] ?? "";

                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: tema.colorScheme.surface,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: tema.colorScheme.secondary,
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .06),
                          blurRadius: 14,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$modelo - $marca",
                          style: tema.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text("Data: $dataStr"),
                        Text("Combustível: ${a['tipoCombustivel']}"),
                        Text("Litros: ${a['quantidadeLitros']} L"),
                        Text(
                          "Valor pago: R\$ ${a['valorPago'].toStringAsFixed(2)}",
                        ),
                        Text("KM atual: ${a['quilometragem']}"),
                        Text("Consumo: ${a['consumo']} km/L"),
                        if ((a['observacao'] ?? '')
                            .toString()
                            .trim()
                            .isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text("Obs: ${a['observacao']}"),
                          ),
                        const SizedBox(height: 14),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await repo.excluir(a['id']);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text("Erro ao carregar")),
      ),
    );
  }
}
