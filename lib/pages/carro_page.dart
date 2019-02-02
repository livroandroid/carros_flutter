import 'package:carros/domain/carro.dart';
import 'package:carros/domain/db/CarroDB.dart';
import 'package:carros/domain/services/carro_service.dart';
import 'package:flutter/material.dart';

class CarroPage extends StatefulWidget {
  final Carro carro;

  const CarroPage(this.carro);

  @override
  _CarroPageState createState() => _CarroPageState();
}

class _CarroPageState extends State<CarroPage> {
  get carro => widget.carro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(carro.nome),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.place),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            onSelected: (string) {},
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text("Editar"),
                ),
                PopupMenuItem(
                  child: Text("Deletar"),
                ),
                PopupMenuItem(
                  child: Text("Share"),
                )
              ];
            },
          )
        ],
      ),
      body: _body(),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: <Widget>[
        Image.network(carro.urlFoto),
        _bloco1(),
        _bloco2(),
      ],
    );
  }

  _bloco1() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                carro.nome,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                carro.tipo,
                style: TextStyle(fontSize: 16, color: Colors.grey[500]),
              )
            ],
          ),
        ),
        InkWell(
          onTap: () { _onClickFavorito(context,carro); },
          child: Icon(
            Icons.favorite,
            color: Colors.red,
            size: 36,
          ),
        ),
        InkWell(
          onTap: () {},
          child: Icon(
            Icons.share,
            size: 36,
          ),
        ),
      ],
    );
  }

  _bloco2() {
    return Container(
      padding: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            carro.desc,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          FutureBuilder<String>(
            future: CarroService.getLoremIpsim(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? Text(snapshot.data)
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            },
          )
        ],
      ),
    );
  }

  Future _onClickFavorito(BuildContext context, carro) async {
      final db = CarroDB.getInstance();

      int id = await db.saveCarro(carro);

      print("Carro salvo $id");
  }
}
