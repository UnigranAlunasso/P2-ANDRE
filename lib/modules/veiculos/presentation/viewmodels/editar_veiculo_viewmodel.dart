import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../veiculos_module.dart';

class EditarVeiculoViewModel extends StateNotifier<bool> {
  EditarVeiculoViewModel(this.ref) : super(false);

  final Ref ref;

  Future<void> criar({
    required String modelo,
    required String marca,
    required String placa,
    required String ano,
    required String tipoCombustivel,
  }) async {
    state = true;

    try {
      final repo = ref.read(veiculoRepositoryProvider);
      await repo.criarVeiculo(
        modelo: modelo,
        marca: marca,
        placa: placa,
        ano: ano,
        tipoCombustivel: tipoCombustivel,
      );
    } finally {
      state = false;
    }
  }
}

final editarVeiculoViewModelProvider =
    StateNotifierProvider<EditarVeiculoViewModel, bool>((ref) {
      return EditarVeiculoViewModel(ref);
    });
