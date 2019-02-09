import 'dart:async';
import 'dart:convert';

import 'package:carros/domain/carro.dart';
import 'package:http/http.dart' as http;

class CarroService {
  static Future<List<Carro>> getCarros(String tipo) async {

    final url = "http://livrowebservices.com.br/rest/carros/tipo/$tipo";
    print("> get: $url");

    final response = await http.get(url);

//    print("< : ${response.body}");

    final mapCarros = json.decode(response.body).cast<Map<String, dynamic>>();

    final carros = mapCarros.map<Carro>((json) => Carro.fromJson(json)).toList();

    return carros;
  }

  static Future<bool> salvar(Carro c) async {
    final url = "http://livrowebservices.com.br/rest/carros";
    print("> post: $url");

    final headers = { "Content-Type": "application/json" };
    final body = json.encode(c.toMap());
    print("  > $body");

    final response = await http.post(url, headers: headers, body: body);
    final map = json.decode(response.body);
    print("  < $map");


    return true;
  }

  static Future<String> getLoremIpsim() async {
    final url = "https://loripsum.net/api";

    final response = await http.get(url);
    var body = response.body;

    body = body.replaceAll("<p>", "");
    body = body.replaceAll("</p>", "");

    return body;
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
