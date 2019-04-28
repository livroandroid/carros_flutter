
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TipoCarro {
  static const String classicos = "classicos";
  static const String esportivos = "esportivos";
  static const String luxo = "luxo";
}

class Carro {
  final int id;
  String tipo;
  String nome;
  String desc;
  String urlFoto;
  String urlVideo;
  String latitude;
  String longitude;

  latlng() {
   return LatLng(
       latitude == null || latitude.isEmpty ? 0.0 : double.parse(latitude),
       longitude == null || longitude.isEmpty ? 0.0 : double.parse(longitude)
   );
  }

  Carro(
      {this.id,
        this.nome,
        this.tipo,
        this.desc,
        this.urlFoto,
        this.urlVideo,
        this.latitude,
        this.longitude});

  factory Carro.fromJson(Map<String, dynamic> json) {
    return Carro(
      id: json['id'] as int,
      nome: json['nome'] as String,
      tipo: json['tipo'] as String,
      desc: json['desc'] as String,
      urlFoto: json['urlFoto'] as String,
      urlVideo: json['urlVideo'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
    );
  }

  Map toMap() {
    Map<String,dynamic> map = {
      "nome": nome,
      "tipo": tipo,
      "desc": desc,
      "urlFoto": urlFoto,
      "urlVideo": urlVideo,
      "latitude": latitude,
      "longitude": longitude,
    };
    if(id != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Carro[$id]: $nome - $tipo";
  }
}