import 'dart:async';
import 'dart:io';

import 'package:carros/bus/event_bus.dart';
import 'package:carros/bus/events.dart';
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

  StreamSubscription subscription;

  get tipo => widget.tipo;

  @override
  bool get wantKeepAlive => true;

   ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _bloc.fetch(tipo, false);

    // Event Bus
    subscription = eventBus.stream.listen((event) {
      print(">> event $event ");
      _onEvent(event);
    });
  }

  void _onEvent(event) {
    if(event is NovoCarroEvent) {
      Carro c = event.carro;
      if(c.tipo == tipo) {
        _bloc.fetch(tipo, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Container(
        padding: EdgeInsets.all(12),
        child: StreamBuilder(
          stream: _bloc.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final CarrosData carrosData = snapshot.data;

              final List<Carro> carros = carrosData.carros;

              return CarrosListView(carros, scrollController: scrollController,scrollToTheEnd: carrosData.scrollToTheEnd);
            } else if (snapshot.hasError) {
              final error = snapshot.error;

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

  Future<void> _onRefresh() {
    print("onRefresh");
    return _bloc.fetch(tipo, false);
  }

  @override
  void dispose() {
    super.dispose();

    subscription?.cancel();
  }
}
