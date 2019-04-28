import 'dart:async';

import 'package:carros/domain/carro.dart';
import 'package:carros/domain/services/carro_service.dart';

class CarrosData {
  // Lista de carros
  final List<Carro> carros;
  // Flag que indica se precisa fazer scroll até o final
  final bool scrollToTheEnd;

  CarrosData(this.carros, this.scrollToTheEnd);
}

class CarrosBloc {
  final _controller = StreamController<CarrosData>();

  get stream => _controller.stream;

  int _page = 0;

  Future fetch(String tipo, bool scrollToTheEnd) {
    // Web Service
    return CarroService.getCarrosByTipo(tipo,_page)
        .then((carros) {
      _controller.sink.add(CarrosData(carros, scrollToTheEnd));
    }).catchError((error) {
      _controller.addError(error);
    });
  }

  Future fetchMore(String tipo) {
    _page++;
    fetch(tipo, false);
  }

  void close() {
    _controller.close();
  }
}
