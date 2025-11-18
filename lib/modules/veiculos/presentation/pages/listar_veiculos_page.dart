import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/viewmodels/listar_veiculos_viewmodel.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../veiculos_module.dart';

class ListarVeiculosPage extends ConsumerWidget {
  const ListarVeiculosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncVeiculos = ref.watch(listarVeiculosProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Meus Veículos")),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/veiculos/novo');
        },
        child: const Icon(Icons.add),
      ),
      body: asyncVeiculos.when(
        data: (lista) {
          if (lista.isEmpty) {
            return const Center(child: Text("Nenhum veículo cadastrado."));
          }

          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, i) {
              final v = lista[i];

              return ListTile(
                leading: const Icon(Icons.directions_car),
                title: Text("${v['modelo']} - ${v['marca']}"),
                subtitle: Text("${v['placa']}   |   ${v['ano']}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    final repo = ref.read(veiculoRepositoryProvider);
                    await repo.excluirVeiculo(v['id']);
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) =>
            const Center(child: Text("Erro ao carregar veículos")),
      ),
    );
  }
}
