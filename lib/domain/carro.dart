class Carro {
  final String nome;
  final String urlFoto;

  Carro(this.nome, this.urlFoto);

  Carro.fromJson(Map<String,dynamic> map) :
        nome = map["nome"],
        urlFoto = map["urlFoto"];
}