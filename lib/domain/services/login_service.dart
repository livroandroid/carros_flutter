import 'dart:convert';

import 'package:carros/domain/response.dart';
import 'package:http/http.dart' as http;

class LoginService {
  static Future<Response> login(String login, String senha) async {
    var url = "http://livrowebservices.com.br/rest/login";

    final body = {"login": login, "senha": senha};

    final response =
        await http.post(url, body: body);

    final s = response.body;
    print(s);

    final r = Response.fromJson(json.decode(s));

    return r;
  }
}
