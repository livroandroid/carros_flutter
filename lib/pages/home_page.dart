import 'package:carros/domain/carro.dart';
import 'package:carros/domain/services/carro_service.dart';
import 'package:carros/utils/nav.dart';
import 'package:carros/widgets/carros_listView.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Carros"),
          bottom: TabBar(tabs: [
            Tab(icon: Icon(Icons.directions_car)),
            Tab(icon: Icon(Icons.directions_transit)),
            Tab(icon: Icon(Icons.directions_bike)),
          ]),
        ),
        body: _tabs(),
      ),
    );
  }

  _tabs() {
    return TabBarView(
      children: [
        CarrosListView(TipoCarro.classicos),
        CarrosListView(TipoCarro.esportivos),
        CarrosListView(TipoCarro.luxo),
      ],
    );
  }


}
