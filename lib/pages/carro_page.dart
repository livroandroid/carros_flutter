import 'package:carros/domain/carro.dart';
import 'package:carros/domain/db/CarroDB.dart';
import 'package:carros/domain/services/carro_service.dart';
import 'package:carros/pages/carro_form_page.dart';
import 'package:carros/utils/nav.dart';
import 'package:flutter/material.dart';

class CarroPage extends StatefulWidget {
  final Carro carro;

  const CarroPage(this.carro);

  @override
  _CarroPageState createState() => _CarroPageState();
}

class _CarroPageState extends State<CarroPage> {
  get carro => widget.carro;

  bool _isFavorito = false;

  @override
  void initState() {
    super.initState();

    CarroDB.getInstance().exists(carro).then((b){
      setState(() {
        _isFavorito = b;
      });
    });
  }

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
            onSelected: (value) {
              _onClickPopupMenu(value);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: "Editar",
                  child: Text("Editar"),
                ),
                PopupMenuItem(
                  value: "Deletar",
                  child: Text("Deletar"),
                ),
                PopupMenuItem(
                  value: "Share",
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
        Image.network(carro.urlFoto ?? "http://www.livroandroid.com.br/livro/carros/esportivos/Ferrari_FF.png"),
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
            color: _isFavorito ? Colors.red : Colors.grey,
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

      final exists = await db.exists(carro);

      if(exists) {
        db.deleteCarro(carro.id);
      } else {
        int id = await db.saveCarro(carro);

        print("Carro salvo $id");
      }

      setState(() {
        _isFavorito = !exists;
      });
  }

  void _onClickPopupMenu(String value) {
    print("_onClickPopupMenu > $value");
    if("Editar" == value) {
      push(context, CarroFormPage(carro:carro));
    }
  }
}
