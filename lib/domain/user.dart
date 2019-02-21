
import 'dart:convert';

import 'package:carros/utils/prefs.dart';

class User {
  final String nome;
  final String login;
  final String email;

  User(this.nome,this.login, this.email);

  User.fromJson(Map<String, dynamic> map)
      :
        this.nome = map["nome"],
        this.login = map["login"],
        this.email = map["email"];

  void save() {
    final map = {"nome": nome,"login": login, "email": email};
    Prefs.setString("user.prefs", json.encode(map));
  }

  static Future<User> get() async {
    String s = await Prefs.getString("user.prefs");
    if(s == null || s.isEmpty) {
      return null;
    }
    final user = User.fromJson(json.decode(s));
    return user;
  }

  static clear () {
    Prefs.setString("user.prefs", "");
  }
}