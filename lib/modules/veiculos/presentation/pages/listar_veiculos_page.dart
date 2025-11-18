import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/listar_veiculos_viewmodel.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/routes/app_routes.dart';
import '../../veiculos_module.dart';

class ListarVeiculosPage extends ConsumerWidget {
  const ListarVeiculosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(listarVeiculosProvider);
    final repo = ref.read(veiculoRepositoryProvider);
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Meus Veículos")),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.novoVeiculo);
        },
        backgroundColor: tema.colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: async.when(
        data: (lista) {
          if (lista.isEmpty) {
            return const Center(child: Text("Nenhum veículo cadastrado."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: lista.length,
            itemBuilder: (context, i) {
              final v = lista[i];

              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: tema.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
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
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  leading: Icon(
                    Icons.directions_car,
                    size: 34,
                    color: tema.colorScheme.primary,
                  ),
                  title: Text(
                    "${v['modelo']} - ${v['marca']}",
                    style: tema.textTheme.titleMedium,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      "Placa: ${v['placa']}\nAno: ${v['ano']}\nCombustível: ${v['tipoCombustivel']}",
                      style: tema.textTheme.bodyMedium,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await repo.excluirVeiculo(v['id']);
                    },
                  ),
                ),
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
