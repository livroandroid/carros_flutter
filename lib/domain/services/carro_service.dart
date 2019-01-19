import 'dart:async';
import 'dart:convert';

import 'package:carros/domain/carro.dart';
import 'package:http/http.dart' as http;

class CarroService {
  static Future<List<Carro>> getCarros() async {

    final url = "http://livrowebservices.com.br/rest/carros";
    print("> get: $url");

    final response = await http.get(url);

//    print("< : ${response.body}");

    final mapCarros = json.decode(response.body).cast<Map<String, dynamic>>();

    final carros = mapCarros.map<Carro>((json) => Carro.fromJson(json)).toList();

    return carros;
  }

  /*static List<Carro> getCarrosFake() {
    final carros = List.generate(50, (idx) {
      var url =
          "http://www.livroandroid.com.br/livro/carros/esportivos/Ferrari_FF.png";

      return Carro("Ferrari $idx", url);
    },);

    return carros;
  }*/
}
