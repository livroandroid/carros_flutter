
import 'package:carros/domain/carro.dart';
import 'package:carros/firebase/favoritos_service.dart';
import 'package:carros/widgets/carros_listView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavoritosPage extends StatefulWidget {
  @override
  _FavoritosPageState createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage>
    with AutomaticKeepAliveClientMixin<FavoritosPage> {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  _body() {

    //Banco de Dados
    //Future<List<Carro>> future = CarroDB.getInstance().getCarros();

    final service = FavoritosService();

    return Container(
      padding: EdgeInsets.all(12),
      child: StreamBuilder<QuerySnapshot>(
        stream: service.getCarros(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {

//            final List<Carro> carros = snapshot.data;
            List<Carro> carros = service.toList(snapshot);

            return CarrosListView(carros);
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Sem dados",style: TextStyle(
                  color: Colors.grey,
                  fontSize: 26,
                  fontStyle: FontStyle.italic
              ),),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }


}
