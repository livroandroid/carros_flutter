import 'dart:async';

import 'package:carros/domain/services/carro_service.dart';

class CarrosBloc {
  final _controller = StreamController();

  get stream => _controller.stream;

  Future fetch(String tipo) {
    // Web Service
    return CarroService.getCarros(tipo)
        .then((carros) {
      _controller.sink.add(carros);
    }).catchError((error) {
      _controller.addError(error);
    });
  }

  void close() {
    _controller.close();
  }
}
