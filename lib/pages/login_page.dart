import 'package:carros/domain/services/firebase_service.dart';
import 'package:carros/domain/services/login_service.dart';
import 'package:carros/domain/user.dart';
import 'package:carros/pages/home_page.dart';
import 'package:carros/utils/alerts.dart';
import 'package:carros/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _tLogin = TextEditingController(text: "rlecheta3@gmail.com");
  final _tSenha = TextEditingController(text: "ricardo");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _progress = false;

  @override
  void initState() {
    super.initState();

    RemoteConfig.instance.then((remoteConfig){
      try {
        remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
        remoteConfig.fetch(expiration: const Duration(minutes: 1));
        remoteConfig.activateFetched();
      } catch (error) {
        print("*** Error: $error");
      }

      var msg = remoteConfig.getString('welcome');
      print('>>> $msg');

      msg = remoteConfig.getString('fala');
      print('>>> $msg');
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carros"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: _body(context),
      ),
    );
  }

  String _validateLogin(String text) {
    if (text.isEmpty) {
      return "Informe o login";
    }

    return null;
  }

  String _validateSenha(String text) {
    if (text.isEmpty) {
      return "Informe a senha";
    }
    if (text.length <= 2) {
      return "Senha precisa ter mais de 2 números";
    }

    return null;
  }

  _body(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          TextFormField(
            controller: _tLogin,
            validator: _validateLogin,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 22,
            ),
            decoration: InputDecoration(
              labelText: "Login",
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 22,
              ),
              hintText: "Digite o seu login",
              hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          TextFormField(
            controller: _tSenha,
            validator: _validateSenha,
            obscureText: true,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 22,
            ),
            decoration: InputDecoration(
              labelText: "Senha",
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 22,
              ),
              hintText: "Digite a sua Senha",
              hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          Container(
            height: 46,
            margin: EdgeInsets.only(top: 20),
            child: RaisedButton(
              color: Colors.blue,
              child: _progress
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    )
                  : Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
              onPressed: () {
                _onClickLogin(context);
              },
            ),
          ),
          Container(
            height: 46,
            margin: EdgeInsets.only(top: 20),
            child: GoogleSignInButton(
              onPressed: () {
                _onClickLoginGoogle2(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onClickLoginGoogle(context) async {
    final login = _tLogin.text;
    final senha = _tSenha.text;

    final FirebaseAuth _fAuth = FirebaseAuth.instance;

    FirebaseUser fUser = await _fAuth.createUserWithEmailAndPassword(email: login, password: senha);
    print("FUser $fUser");

    final info = UserUpdateInfo();
    info.displayName = "Ricardo Lecheta Flutter";
    info.photoUrl = "https://s3-sa-east-1.amazonaws.com/livetouch-temp/livrows/foto.png";
    fUser.updateProfile(info);
  }

  void _onClickLoginGoogle2(context) async {
    final login = _tLogin.text;
    final senha = _tSenha.text;

    if (!_formKey.currentState.validate()) {
      return;
    }

    print("Login: $login, senha: $senha");

    setState(() {
      _progress = true;
    });

    final service = FirebaseService();
    final response = await service.loginGoogle();

    if (response.isOk()) {
      pushReplacement(context, HomePage());
    } else {
      alert(context, "Erro", response.msg);
    }

    setState(() {
      _progress = false;
    });
  }

  void _onClickLogin(context) async {
    final login = _tLogin.text;
    final senha = _tSenha.text;

    if (!_formKey.currentState.validate()) {
      return;
    }

    print("Login: $login, senha: $senha");

    setState(() {
      _progress = true;
    });

    final FirebaseAuth _fAuth = FirebaseAuth.instance;

    FirebaseUser fUser = await _fAuth.signInWithEmailAndPassword(email: login, password: senha);
    print("FUser ${fUser.displayName} ");

    if(fUser != null) {
      final user = User(fUser.displayName,login,fUser.email);
      user.save();
    }

//    final response = await LoginService.login(login, senha);
//
//    if (response.isOk()) {
      pushReplacement(context, HomePage());
//    } else {
//      alert(context, "Erro", response.msg);
//    }

    setState(() {
      _progress = false;
    });
  }
}
