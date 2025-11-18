import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../abastecimentos_module.dart';

class RegistrarAbastecimentoViewModel extends StateNotifier<bool> {
  RegistrarAbastecimentoViewModel(this.ref) : super(false);

  final Ref ref;

  Future<void> registrar({
    required DateTime data,
    required double quantidadeLitros,
    required double valorPago,
    required int quilometragem,
    required String tipoCombustivel,
    required String veiculoId,
    required double consumo,
    required String observacao,
  }) async {
    state = true;
    try {
      final repo = ref.read(abastecimentoRepositoryProvider);
      await repo.registrar(
        data: data,
        quantidadeLitros: quantidadeLitros,
        valorPago: valorPago,
        quilometragem: quilometragem,
        tipoCombustivel: tipoCombustivel,
        veiculoId: veiculoId,
        consumo: consumo,
        observacao: observacao,
      );
    } finally {
      state = false;
    }
  }
}

final registrarAbastecimentoViewModelProvider =
    StateNotifierProvider<RegistrarAbastecimentoViewModel, bool>((ref) {
      return RegistrarAbastecimentoViewModel(ref);
    });
