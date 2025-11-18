import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../veiculos_module.dart';

final listarVeiculosProvider = StreamProvider.autoDispose((ref) {
  final repo = ref.watch(veiculoRepositoryProvider);
  return repo.listarVeiculos();
});
