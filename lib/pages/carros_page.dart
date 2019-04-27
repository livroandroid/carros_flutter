import 'dart:async';
import 'dart:io';

import 'package:carros/domain/carro.dart';
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

  get tipo => widget.tipo;

  @override
  bool get wantKeepAlive => true;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _bloc.fetch(tipo);

    // Fim do scroll, carrega mais
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("FIM!");

        // Descomente isso para testar a paginação
        _bloc.fetchMore(tipo);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Carro> list = [];

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Container(
        padding: EdgeInsets.all(12),
        child: StreamBuilder(
          stream: _bloc.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<Carro> carros = snapshot.data;

              list.addAll(carros);

              print("Carros $carros");

              // Descomente isso para testar a paginação
              bool showProgress = carros.length > 0 && carros.length % 10 == 0;

              return CarrosListView(
                list,
                scrollController: _scrollController,
                showProgress: showProgress,
              );
            } else if (snapshot.hasError) {
              final error = snapshot.error;

              return _error(error);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  _error(Object error) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Text(
            error is SocketException
                ? "Conexão indisponível, por favor verifique sua internet."
                : "Ocorreu um erro ao buscar a lista de carros",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 26,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  Future<void> _onRefresh() {
    print("onRefresh");
    return _bloc.fetch(tipo);
  }

  @override
  void dispose() {
    super.dispose();

    _bloc.close();
  }
}
