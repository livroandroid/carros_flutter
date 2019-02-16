
import 'package:carros/domain/carro.dart';
import 'package:carros/domain/services/carro_service.dart';
import 'package:carros/pages/carro_page.dart';
import 'package:carros/utils/nav.dart';
import 'package:carros/widgets/carros_listView.dart';
import 'package:flutter/material.dart';

class CarrosPage extends StatefulWidget {
  final String tipo;

  const CarrosPage(this.tipo) ;

  @override
  _CarrosPageState createState() => _CarrosPageState();
}

class _CarrosPageState extends State<CarrosPage>
    with AutomaticKeepAliveClientMixin<CarrosPage> {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  _body() {
    print("build carros ${widget.tipo}");

    // Web Service
    Future<List<Carro>> future = CarroService.getCarros(widget.tipo);

    return Container(
      padding: EdgeInsets.all(12),
      child: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            final List<Carro> carros = snapshot.data;

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
