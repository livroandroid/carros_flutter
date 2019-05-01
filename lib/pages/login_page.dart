import 'dart:io';

import 'package:carros/firebase/firebase_service.dart';
import 'package:carros/pages/cadastro_page.dart';
import 'package:carros/pages/home_page.dart';
import 'package:carros/utils/alerts.dart';
import 'package:carros/utils/finger_print.dart';
import 'package:carros/utils/nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _tLogin = TextEditingController(text: "rlecheta@gmail.com");
  final _tSenha = TextEditingController(text: "123456");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _progress = false;

  FirebaseUser fUser;
  final FirebaseMessaging _firebaseMessaging
    = FirebaseMessaging();
  var showForm = false;

  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((fUser) {
      setState(() {
        this.fUser = fUser;
        if (fUser != null) {
          //pushReplacement(context, HomePage());
          showForm = true;
        } else {
          showForm = true;
        }
      });
    });

    _initRemoteConfig();
    _initFcm();
  }

  void _initFcm() {
    _firebaseMessaging.getToken().then((token) {
      print("Firebase Token [$token]");
    });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('\n\n\n*** on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );

    if (Platform.isIOS) {
      _firebaseMessaging.requestNotificationPermissions(
          IosNotificationSettings(sound: true, badge: true, alert: true));
      _firebaseMessaging.onIosSettingsRegistered
          .listen((IosNotificationSettings settings) {
        print("iOS Push Settings: [$settings]");
      });
    }
  }


  _initRemoteConfig() {
    RemoteConfig.instance.then((remoteConfig) {
      remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));

      try {
        remoteConfig.fetch(expiration: const Duration(minutes: 1));
        remoteConfig.activateFetched();
      } catch (error) {
        print("Remote Config: $error");
      }

      final mensagem = remoteConfig.getString("mensagem");

      print('Mensagem: $mensagem');
    });
  }

  @override
  Widget build(BuildContext context) {
    _firebaseMessaging.getToken().then((token) {
      print("Firebase Token [$token]");
    });

    return Scaffold(
      appBar: AppBar(
        title: fUser != null
            ? Text("Carros ${fUser.displayName}")
            : Text("Carros"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: _body(context),
      ),
    );
  }

  _body(BuildContext context) {
    if (!showForm) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
              labelText: "Email",
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 22,
              ),
              hintText: "Digite o seu email",
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
            keyboardType: TextInputType.number,
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
                _onClickLoginGoogle(context);
              },
            ),
          ),
          Container(
            height: 46,
            margin: EdgeInsets.only(top: 20),
            child: InkWell(
              onTap: () {
                _onClickCadastrar(context);
              },
              child: Text(
                "Cadastre-se!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          Opacity(
            opacity: fUser != null ? 1 : 0,
            child: Container(
              height: 46,
              child: InkWell(
                onTap: () {
                  _onClickFingerprint(context);
                },
                child: Image.asset(
                  "assets/images/fingerprint.png",
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ],
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

  _onClickFingerprint(context) async {
      final ok = await FingerPrint.verify();
      if(ok) {
        pushReplacement(context, HomePage());
      }
  }

  _onClickCadastrar(context) {
    pushReplacement(context, CadastroPage());
  }

  void _onClickLoginGoogle(context) async {
    print("Google");

    final service = FirebaseService();
    final response = await service.loginGoogle();

    if (response.isOk()) {
      pushReplacement(context, HomePage());
    } else {
      alert(context, "Erro", response.msg);
    }
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

    final service = FirebaseService();
    final response = await service.login(login, senha);

    if (response.isOk()) {
      pushReplacement(context, HomePage());
    } else {
      alert(context, "Erro", response.msg);
    }

    setState(() {
      _progress = false;
    });
  }
}
