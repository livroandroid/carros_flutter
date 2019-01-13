import 'package:carros/domain/services/carro_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carros"),
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: _listView(),
      ),
    );
  }

  _listView() {
    final carros = CarroService.getCarros();
    return ListView.builder(
      itemCount: carros.length,
      itemBuilder: (ctx, idx) {
        final c = carros[idx];
        return Container(
          height: 150,
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  leading: Image.network(
                    c.urlFoto,
                    width: 150,
                  ),
                  title: Text(
                    c.nome,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 25,
                    ),
                  ),
                  subtitle: Text(
                    "descrição",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
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
        );
      },
    );
  }
}
