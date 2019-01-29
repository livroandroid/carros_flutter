import 'package:carros/domain/carro.dart';
import 'package:carros/utils/prefs.dart';
import 'package:carros/widgets/carros_listView.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin<HomePage> {

  TabController tabController;

  @override
  initState()  {
    super.initState();

    tabController = TabController(length: 3, vsync: this);

    Prefs.getInt("tabIndex").then((idx){
      tabController.index = idx;
    });

    tabController.addListener(() async {
      int idx = tabController.index;

      Prefs.setInt("tabIndex",idx);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carros"),
        bottom: TabBar(
          controller: tabController,
          tabs: [
            Tab(
              text: "Clássicos",
              icon: Icon(Icons.directions_car),
            ),
            Tab(
              text: "Esportivos",
              icon: Icon(Icons.directions_car),
            ),
            Tab(
              text: "Luxo",
              icon: Icon(Icons.directions_car),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          CarrosListView(TipoCarro.classicos),
          CarrosListView(TipoCarro.esportivos),
          CarrosListView(TipoCarro.luxo),
        ],
      ),
    );
  }
}
