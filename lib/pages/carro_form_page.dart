import 'dart:io';

import 'package:carros/domain/carro.dart';
import 'package:carros/domain/services/carro_service.dart';
import 'package:carros/utils/alerts.dart';
import 'package:carros/utils/nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CarroFormPage extends StatefulWidget {
  final Carro carro;

  CarroFormPage({this.carro});

  @override
  State<StatefulWidget> createState() => new _CarroFormPageState();
}

class _CarroFormPageState extends State<CarroFormPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final tNome = TextEditingController();
  final tDesc = TextEditingController();
  final tTipo = TextEditingController();

  int _radioIndex = 0;

  var _showProgress = false;

  File fileCamera;

  get carro => widget.carro;

  // Add validate email function.
  String _validateNome(String value) {
    if (value.isEmpty) {
      return 'Informe o nome do carro.';
    }

    return null;
  }

  @override
  void initState() {
    super.initState();

    if (carro != null) {
      tNome.text = carro.nome;
      tDesc.text = carro.desc;
      _radioIndex = getTipoInt(carro);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          carro != null ? carro.nome : "Novo Carro",
        ),
      ),
      body: new Container(
        padding: new EdgeInsets.all(16),
        child: _form(),
      ),
    );
  }

  _form() {
    return new Form(
      key: this._formKey,
      child: new ListView(
        children: <Widget>[
          _headerFoto(),
          Text(
            "Clique na imagem para tirar uma foto",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Divider(),
          new Text(
            "Tipo",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
          ),
          _radioTipo(),
          Divider(),
          new TextFormField(
            controller: tNome,
            keyboardType: TextInputType.text,
            validator: _validateNome,
            style: TextStyle(color: Colors.blue, fontSize: 20),
            decoration: new InputDecoration(
              hintText: '',
              labelText: 'Nome',
            ),
          ),
          new TextFormField(
            controller: tDesc,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
            decoration: new InputDecoration(
              hintText: '',
              labelText: 'Descrição',
            ),
          ),
          new Container(
            height: 50,
            margin: new EdgeInsets.only(top: 20.0),
            child: RaisedButton(
              color: Colors.blue,
              child: _showProgress
                  ? CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : new Text(
                      "Salvar",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
              onPressed: () {
                _onClickSalvar(context);
              },
            ),
          )
        ],
      ),
    );
  }

  _headerFoto() {
    if(fileCamera != null) {
      return InkWell(
        child: Image.file(
          fileCamera,
          height: 150,
        ),onTap: _onClickFoto,
      );
    }

    return InkWell(
      child: carro != null && carro.urlFoto != null
          ? Image.network(carro.urlFoto)
          : Image.asset(
        "assets/images/camera.png",
        height: 150,
      ),onTap: _onClickFoto,
    );
  }

  _onClickFoto() async {
    fileCamera = await ImagePicker.
    pickImage(source: ImageSource.camera);

    setState(() {
    });

  }

  _radioTipo() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Radio(
            value: 0,
            groupValue: _radioIndex,
            onChanged: _onClickTipo,
          ),
          new Text(
            "Clássicos",
            style: TextStyle(color: Colors.blue, fontSize: 15),
          ),
          new Radio(
            value: 1,
            groupValue: _radioIndex,
            onChanged: _onClickTipo,
          ),
          new Text(
            "Esportivos",
            style: TextStyle(color: Colors.blue, fontSize: 15),
          ),
          new Radio(
            value: 2,
            groupValue: _radioIndex,
            onChanged: _onClickTipo,
          ),
          new Text(
            "Luxo",
            style: TextStyle(color: Colors.blue, fontSize: 15),
          ),
        ],
      ),
    );
  }

  void _onClickTipo(int value) {
    setState(() {
      _radioIndex = value;
    });
  }

  getTipoInt(Carro carro) {
    switch (carro.tipo) {
      case "classicos":
        return 0;
      case "esportivos":
        return 1;
      default:
        return 2;
    }
  }

  String _getTipo() {
    switch (_radioIndex) {
      case 0:
        return "classicos";
      case 1:
        return "esportivos";
      default:
        return "luxo";
    }
  }

  _onClickSalvar(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    // Cria o carro
    var c = carro ?? Carro();
    c.nome = tNome.text;
    c.desc = tDesc.text;
    c.tipo = _getTipo();

    setState(() {
      _showProgress = true;
    });

    final response = await CarroService.salvar(c);
    if (response.isOk()) {
      alert(context, "Carro salvo", response.msg, callback: () => pop(context));
    } else {
      alert(context, "Erro", response.msg);
    }

    setState(() {
      _showProgress = false;
    });
  }
}
