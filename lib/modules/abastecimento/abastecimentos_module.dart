import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/abastecimento_repository.dart';
import 'data/abastecimento_repository_impl.dart';

final abastecimentoRepositoryProvider = Provider<AbastecimentoRepository>((
  ref,
) {
  return AbastecimentoRepositoryImpl();
});
