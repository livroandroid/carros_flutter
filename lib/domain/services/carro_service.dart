import 'package:carros/domain/carro.dart';

class CarroService {

  static List<Carro> getCarros() {
    final carros = List.generate(50, (idx) {
      var url1 =
          "http://www.livroandroid.com.br/livro/carros/esportivos/Ferrari_FF.png";
      var url2 =
          "https://robbreportedit.files.wordpress.com/2018/02/13.jpg?w=1024";
      return Carro("Ferrari $idx", url1);
    });

    return carros;
  }
}
