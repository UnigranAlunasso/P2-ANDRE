import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/veiculo_repository.dart';
import '../../veiculos_module.dart';

final editarVeiculoViewModelProvider =
    StateNotifierProvider.autoDispose<EditarVeiculoViewModel, bool>((ref) {
      final repo = ref.watch(veiculoRepositoryProvider);
      return EditarVeiculoViewModel(repo);
    });

class EditarVeiculoViewModel extends StateNotifier<bool> {
  final VeiculoRepository _repository;

  EditarVeiculoViewModel(this._repository) : super(false);

  Future<void> salvarVeiculo({
    required String modelo,
    required String marca,
    required String placa,
    required String ano,
    required String tipoCombustivel,
  }) async {
    state = true;
    try {
      await _repository.criarVeiculo(
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
