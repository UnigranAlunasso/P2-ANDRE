import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/veiculo_repository.dart';
import 'data/veiculo_repository_impl.dart';

final veiculoRepositoryProvider = Provider<VeiculoRepository>((ref) {
  return VeiculoRepositoryImpl();
});
