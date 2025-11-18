abstract class VeiculoRepository {
  Future<void> criarVeiculo({
    required String modelo,
    required String marca,
    required String placa,
    required String ano,
    required String tipoCombustivel,
  });

  Future<void> excluirVeiculo(String id);

  Stream<List<Map<String, dynamic>>> listarVeiculos();
}
