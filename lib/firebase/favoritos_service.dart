
import 'package:carros/domain/carro.dart';
import 'package:carros/firebase/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/async.dart';

class FavoritosService {
  getCarros() => _carros.snapshots();

  DocumentReference get _user => Firestore.instance.collection("users").document(firebaseUserUid);

  CollectionReference get _carros => _user.collection("carros");

  List<Carro> toList(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((document) => Carro.fromJson(document.data) )
        .toList();
  }

  Future<bool> favoritar(Carro carro) async {

    var document = _carros.document("${carro.id}");
    var documentSnapshot = await document.get();

    if (!documentSnapshot.exists) {
      print("${carro.nome}, adicionado nos favoritos");
      document.setData(carro.toMap());

      return true;
    } else {
      print("${carro.nome}, removido nos favoritos");
      document.delete();

      return false;
    }
  }

  Future<bool> exists(Carro carro) async {

    // Busca o carro no Firestore
    var document = _carros.document("${carro.id}");

    var documentSnapshot = await document.get();

    // Verifica se o carro está favoritado
    return await documentSnapshot.exists;
  }

  logout() {
    String uid = firebaseUserUid;
    print("Delete user $uid");
    _carros
  }
}