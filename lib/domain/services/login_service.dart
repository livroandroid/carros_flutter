import 'dart:convert';
import 'dart:io';

import 'package:carros/domain/response.dart';
import 'package:carros/domain/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

class LoginService {
  static Future<Response> login(String login, String senha) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    FirebaseUser fuser = await _firebaseAuth.signInWithEmailAndPassword(email: login, password: senha);
    if(fuser != null) {
      print("Firebase login $fuser");

      final user = User(fuser.displayName,login,fuser.email);
      user.save();

      Response r = Response(true, "Login efetuado com sucesso");
      return r;
    }


    var connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult);
    if (connectivityResult == ConnectivityResult.none) {
      return Response(false, "Internet indisponível.");
    }

    try {
      var url = "http://livrowebservices.com.br/rest/login";

      final body = {"login": login, "senha": senha};

      final response = await http.post(url, body: body);

      final s = response.body;
      print(s);

      final r = Response.fromJson(json.decode(s));

      final user = User("Ricardo Flutter",login,"rlecheta@flutter.com");
      user.save();

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
