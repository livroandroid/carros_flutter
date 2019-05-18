
import 'package:carros/domain/carro.dart';
import 'package:carros/domain/services/carro_service.dart';
import 'package:flutter/services.dart';
import 'package:test/test.dart';


void main() {
  test('Carros All Test', () async {
    List<Carro> carros = await CarroService.getCarros();
    expect(carros.length > 0, true);

    expect(carros.length, 36);
  });

  test('Carro Ferrari', () async {
    Carro c = await CarroService.getCarro(11);
    expect(c.nome, "Ferrari FF");
  });

}