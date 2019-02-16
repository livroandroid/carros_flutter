import 'dart:async';
import 'dart:io';

import 'package:carros/domain/carro.dart';
import 'package:carros/domain/services/carro_service.dart';
import 'package:carros/domain/services/carros_bloc.dart';
import 'package:carros/widgets/carros_listView.dart';
import 'package:flutter/material.dart';

class CarrosPage extends StatefulWidget {
  final String tipo;

  const CarrosPage(this.tipo);

  @override
  _CarrosPageState createState() => _CarrosPageState();
}

class _CarrosPageState extends State<CarrosPage>
    with AutomaticKeepAliveClientMixin<CarrosPage> {
  final _bloc = CarrosBloc();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _bloc.fetch(widget.tipo);
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  _body() {
    print("build carros ${widget.tipo}");

    _bloc.fetch(widget.tipo);

    return Container(
      padding: EdgeInsets.all(12),
      child: StreamBuilder(
        stream: _bloc.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<Carro> carros = snapshot.data;

            return CarrosListView(carros);
          } else if (snapshot.hasError) {
            final error = snapshot.error;

            return Center(
              child: Text(
                error is SocketException
                    ? "Conexão indisponível, por favor verifique sua internet."
                    : "Ocorreu um erro ao buscar a lista de carros",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 26,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
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

  @override
  void dispose() {
    super.dispose();

    print("close ${widget.tipo}!");
    _bloc.close();
  }
}
