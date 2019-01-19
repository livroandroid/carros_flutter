import 'package:carros/domain/carro.dart';
import 'package:carros/domain/services/carro_service.dart';
import 'package:carros/utils/nav.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carros"),
      ),
      body: _body(),
    );
  }

  _body() {
    return Container(
      padding: EdgeInsets.all(12),
      child: FutureBuilder(
        future: CarroService.getCarros(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _listView(snapshot.data);
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

  _listView(List<Carro> carros) {
    return ListView.builder(
      itemCount: carros.length,
      itemBuilder: (ctx, idx) {
        final c = carros[idx];
        return Container(
          height: 280,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Image.network(
                      c.urlFoto,
                    ),
                  ),
                  Text(
                    c.nome,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    c.desc,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  ButtonTheme.bar(
                    child: ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('DETALHES'),
                          onPressed: () {
                            /* ... */
                          },
                        ),
                        FlatButton(
                          child: const Text('SHARE'),
                          onPressed: () {
                            /* ... */
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
