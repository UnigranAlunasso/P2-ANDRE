import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/viewmodels/listar_abastecimentos_viewmodel.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../veiculos/data/veiculo_by_id_provider.dart';
import '../../abastecimentos_module.dart';

class ListarAbastecimentosPage extends ConsumerWidget {
  const ListarAbastecimentosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listaAsync = ref.watch(listarAbastecimentosProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Histórico de Abastecimentos")),
      drawer: const AppDrawer(),
      body: listaAsync.when(
        data: (lista) {
          if (lista.isEmpty) {
            return const Center(
              child: Text("Nenhum abastecimento registrado."),
            );
          }

          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, i) {
              final a = lista[i];

              final dataObj = DateTime.tryParse(a['data'] ?? '');
              final dataStr = dataObj == null
                  ? "Data inválida"
                  : "${dataObj.day.toString().padLeft(2, '0')}/"
                        "${dataObj.month.toString().padLeft(2, '0')}/"
                        "${dataObj.year}";

              final veiculoFuture = ref.watch(
                veiculoByIdProvider(a['veiculoId']),
              );

              return veiculoFuture.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(12),
                  child: LinearProgressIndicator(),
                ),
                error: (_, __) =>
                    const ListTile(title: Text("Erro ao carregar veículo")),
                data: (veiculo) {
                  final modeloMarca = veiculo == null
                      ? "Veículo não encontrado"
                      : "${veiculo['modelo']} - ${veiculo['marca']}";

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            modeloMarca,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),

                          const SizedBox(height: 4),
                          Text("Data: $dataStr"),

                          const SizedBox(height: 8),

                          Text("Combustível: ${a['tipoCombustivel']}"),
                          Text("Litros: ${a['quantidadeLitros']} L"),
                          Text(
                            "Valor pago: R\$ ${a['valorPago'].toStringAsFixed(2)}",
                          ),
                          Text("Quilometragem: ${a['quilometragem']} km"),
                          Text("Consumo: ${a['consumo']} km/L"),

                          if (a['observacao'] != null &&
                              a['observacao'].trim().isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              "Observação:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            Text(a['observacao']),
                          ],

                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final repo = ref.read(
                                  abastecimentoRepositoryProvider,
                                );
                                await repo.excluir(a['id']);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) =>
            const Center(child: Text("Erro ao carregar abastecimentos")),
      ),
    );
  }
}
