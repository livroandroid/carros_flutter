import 'dart:convert';
import 'dart:io';

import 'package:carros/domain/response.dart';
import 'package:http/http.dart' as http;

class LoginService {
  static Future<Response> login(String login, String senha) async {
    try {
      var url = "http://livrowebservices.com.br/rest/login";

      final body = {"login": login, "senha": senha};

      final response = await http.post(url, body: body);

      final s = response.body;
      print(s);

      final r = Response.fromJson(json.decode(s));

      return r;
    } catch (error) {
      return Response(false, handleError(error));
    }
  }

  static String handleError(error) {
    print(error);
    return error is SocketException
        ? "Internet indisponível. Por favor, verifique a sua conexão"
        : "Ocorreu um erro no login";
  }
}
