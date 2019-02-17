import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:carros/domain/carro.dart';
import 'package:carros/domain/response.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class CarroService {
  static Future<List<Carro>> getCarros(String tipo) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult);
    if (connectivityResult == ConnectivityResult.none) {
      throw SocketException("Internet indisponível.");
    }

    final url = "http://livrowebservices.com.br/rest/carros/tipo/$tipo";
    print("> get: $url");

    final response = await http.get(url);

    final mapCarros = json.decode(response.body).cast<Map<String, dynamic>>();

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
    final body = json.encode(c.toMap());
    print("   > $body");

    final response = await http.post(url, headers: headers, body: body);

    final s = response.body;
    print("   < $s");

    final r = Response.fromJson(json.decode(s));

    return r;
  }

  static Future<Response> upload(File file) async {
    final url = "http://livrowebservices.com.br/rest/carros/postFotoBase64";

    List<int> imageBytes = file.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    String fileName = path.basename(file.path);

    var body = {"fileName": fileName, "base64": base64Image};
    print("http.upload >> " + body.toString());

    final response = await http.post(url, body: body);

    print("http.upload << " + response.body);

    Map<String, dynamic> map = json.decode(response.body);

    var r = Response.fromJson(map);

    return r;
  }

  static Future<Response> deletar(id) async {
    final url = "http://livrowebservices.com.br/rest/carros/$id";
    print("> delete: $url");

    final response = await http.delete(url);

    final s = response.body;
    print("   < $s");

    final r = Response.fromJson(json.decode(s));

    return r;
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
