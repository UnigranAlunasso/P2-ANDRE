import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../abastecimentos_module.dart';

final listarAbastecimentosProvider = StreamProvider.autoDispose((ref) {
  final repo = ref.watch(abastecimentoRepositoryProvider);
  return repo.listar();
});
