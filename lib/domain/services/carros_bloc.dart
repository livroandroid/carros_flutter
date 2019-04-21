import 'dart:async';

import 'package:carros/domain/services/carro_service.dart';

class CarrosBloc {
  final _controller = StreamController();

  get stream => _controller.stream;

  int _page = 0;

  Future fetch(String tipo) {
    // Web Service
    return CarroService.getCarrosByTipo(tipo,_page)
        .then((carros) {
      _controller.sink.add(carros);
    }).catchError((error) {
      _controller.addError(error);
    });
  }

  Future fetchMore(String tipo) {
    _page++;
    fetch(tipo);
  }

  void close() {
    _controller.close();
  }
}
