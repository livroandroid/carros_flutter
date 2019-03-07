
import 'package:carros/domain/carro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritoService {
  getCarros() => _carros.snapshots();

  CollectionReference get _carros => Firestore.instance.collection("carros");

  Future<bool> favoritar(Carro carro) async {

    var document = _carros.document("${carro.id}");
    var documentSnapshot = await document.get();

    if (!documentSnapshot.exists) {
      print("save");
      document.setData(carro.toMap());

      return true;
    } else {
      print("delete");
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
}