
import 'dart:async';

import 'package:carros/domain/carro.dart';
import 'package:carros/domain/services/carro_service.dart';

class CarrosBloc {

  final _controller = StreamController();

  get stream => _controller.stream;

  fetch(String tipo) {
    // Web Service
    Future<List<Carro>> future = CarroService.getCarros(tipo);
    future.then((carros){
      _controller.sink.add(carros);
    });
  }

  void close() {
    _controller.close();
  }
}