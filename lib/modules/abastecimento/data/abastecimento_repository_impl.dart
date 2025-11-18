import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'abastecimento_repository.dart';

class AbastecimentoRepositoryImpl implements AbastecimentoRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  AbastecimentoRepositoryImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _colecao() {
    final uid = _auth.currentUser!.uid;
    return _firestore.collection('users').doc(uid).collection('abastecimentos');
  }

  @override
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
    await _colecao().add({
      'data': data.toIso8601String(),
      'quantidadeLitros': quantidadeLitros,
      'valorPago': valorPago,
      'quilometragem': quilometragem,
      'tipoCombustivel': tipoCombustivel,
      'veiculoId': veiculoId,
      'consumo': consumo,
      'observacao': observacao,
      'criadoEm': DateTime.now(),
    });
  }

  @override
  Future<void> excluir(String id) async {
    await _colecao().doc(id).delete();
  }

  @override
  Stream<List<Map<String, dynamic>>> listar() {
    return _colecao()
        .orderBy('data', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map((d) {
            final data = d.data();
            data['id'] = d.id;
            return data;
          }).toList(),
        );
  }
}
