
import 'package:carros/domain/carro.dart';
import 'package:carros/domain/services/carro_service.dart';
import 'package:carros/widgets/carros_listView.dart';
import 'package:flutter/material.dart';

class CarrosSearch extends SearchDelegate<Carro> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    if(query.length > 2) {

      return FutureBuilder(
        future: CarroService.search(query),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<Carro> carros = snapshot.data;
            return CarrosListView(carros, search: true,);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    }

    //Retorna tile Vazio
    return Container();
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }
}