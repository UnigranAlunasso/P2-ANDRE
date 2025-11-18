abstract class AbastecimentoRepository {
  Future<void> registrar({
    required DateTime data,
    required double quantidadeLitros,
    required double valorPago,
    required int quilometragem,
    required String tipoCombustivel,
    required String veiculoId,
    required double consumo,
    required String observacao,
  });

  Future<void> excluir(String id);

  Stream<List<Map<String, dynamic>>> listar();
}
