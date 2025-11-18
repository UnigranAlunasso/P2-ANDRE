import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'veiculo_repository.dart';

class VeiculoRepositoryImpl implements VeiculoRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  VeiculoRepositoryImpl({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _colecao() {
    final uid = _auth.currentUser!.uid;
    return _firestore.collection('users').doc(uid).collection('veiculos');
  }

  @override
  Future<void> criarVeiculo({
    required String modelo,
    required String marca,
    required String placa,
    required String ano,
    required String tipoCombustivel,
  }) async {
    await _colecao().add({
      'modelo': modelo,
      'marca': marca,
      'placa': placa,
      'ano': ano,
      'tipoCombustivel': tipoCombustivel,
      'criadoEm': DateTime.now(),
    });
  }

  @override
  Future<void> excluirVeiculo(String id) async {
    await _colecao().doc(id).delete();
  }

  @override
  Stream<List<Map<String, dynamic>>> listarVeiculos() {
    return _colecao().orderBy('criadoEm', descending: true).snapshots().map((
      snap,
    ) {
      return snap.docs.map((d) {
        final data = d.data();
        data['id'] = d.id;
        return data;
      }).toList();
    });
  }
}
