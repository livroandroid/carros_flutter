import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';

import 'package:carros/domain/carro.dart';
import 'package:carros/domain/response.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class CarroService {

  static bool FAKE = false;

  static Future<List<Carro>> getCarrosByTipo(String tipo) async {
    String json;

    if(FAKE) {
      json = await rootBundle.loadString("assets/fake/$tipo.json");
    } else {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw SocketException("Internet indisponível.");
      }

      final url = "http://livrowebservices.com.br/rest/carros/tipo/$tipo";
      print("> get: $url");

      final response = await http.get(url)
          .timeout(Duration(seconds: 10),onTimeout: _onTimeOut);

      json = response.body;
    }

    final mapCarros = convert.json.decode(json).cast<Map<String, dynamic>>();

    final carros = mapCarros.map<Carro>((json) => Carro.fromJson(json)).toList();

    return carros;
  }

  static Future<List<Carro>> getCarros() async {
    final url = "http://livrowebservices.com.br/rest/carros";
    print("> get: $url");

    final response = await http.get(url)
        .timeout(Duration(seconds: 10),onTimeout: _onTimeOut);

    final mapCarros = convert.json.decode(response.body).cast<Map<String, dynamic>>();

    final carros = mapCarros.map<Carro>((json) => Carro.fromJson(json)).toList();

    return carros;
  }

  static Future<Response> salvar(Carro c, File file) async {
    if(file != null) {
      final fotoResponse = await upload(file);
      c.urlFoto = fotoResponse.url;
    }

    final url = "http://livrowebservices.com.br/rest/carros";
    print("> post: $url");

    final headers = {"Content-Type":"application/json"};
    final body = convert.json.encode(c.toMap());
    print("   > $body");

    final response = await http.post(url, headers: headers, body: body)
        .timeout(Duration(seconds: 10),onTimeout: _onTimeOut);

    final s = response.body;
    print("   < $s");

    final r = Response.fromJson(convert.json.decode(s));

    return r;
  }

  static Future<Response> upload(File file) async {
    final url = "http://livrowebservices.com.br/rest/carros/postFotoBase64";

    List<int> imageBytes = file.readAsBytesSync();
    String base64Image = convert.base64Encode(imageBytes);

    String fileName = path.basename(file.path);

    var body = {"fileName": fileName, "base64": base64Image};
    print("http.upload >> " + body.toString());

    final response = await http.post(url, body: body)
        .timeout(Duration(seconds: 10),onTimeout: _onTimeOut);

    print("http.upload << " + response.body);

    Map<String, dynamic> map = convert.json.decode(response.body);

    var r = Response.fromJson(map);

    return r;
  }

  static Future<Response> deletar(id) async {
    final url = "http://livrowebservices.com.br/rest/carros/$id";
    print("> delete: $url");

    final response = await http.delete(url)
        .timeout(Duration(seconds: 10),onTimeout: _onTimeOut);

    final s = response.body;
    print("   < $s");

    final r = Response.fromJson(convert.json.decode(s));

    return r;
  }

  static Future<String> getLoremIpsim() async {
    final url = "https://loripsum.net/api";

    final response = await http.get(url)
        .timeout(Duration(seconds: 10),onTimeout: _onTimeOut);

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


  static FutureOr<http.Response> _onTimeOut() {
    print("timeout!");
    throw SocketException("Não foi possível se comunicar com o servidor.");
  }

  static search(String query) async {
    List<Carro> carros = await getCarros();

    List<Carro> list = [];

    for(Carro c in carros) {
      if(c.nome.toUpperCase().contains(query.toUpperCase())) {
        list.add(c);
      }
    }

    return list;
  }
}
