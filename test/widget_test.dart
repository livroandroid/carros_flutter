import 'package:carros/main.dart';
import 'package:carros/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Login Form Validation', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();

    // Clica no botão sem preencher nada
    await tester.tap(find.byType(RaisedButton).at(0));
    await tester.pump();

    // Vai dar erro
    expect(find.text("Informe o login"), findsOneWidget);
    expect(find.text("Informe a senha"), findsOneWidget);

    // Vou digitar uma senha errada
    await tester.enterText(find.byType(TextFormField).at(1), "12");

    // Clica no botão (vai dar erro)
    await tester.tap(find.byType(RaisedButton).at(0));
    await tester.pump();
    expect(find.text("Senha precisa ter mais de 2 números"), findsOneWidget);

    // Digitar Login e Senha corretamente
    // Vou digitar uma senha errada
    await tester.enterText(find.byType(TextFormField).at(0), "a@a.com");
    await tester.enterText(find.byType(TextFormField).at(1), "123");
    await tester.tap(find.byType(RaisedButton).at(0));
    await tester.pump();

    // Está Ok, não pode dar erro
    expect(find.text("Informe o login"), findsNothing);
    expect(find.text("Informe a senha"), findsNothing);
    expect(find.text("Senha precisa ter mais de 2 números"), findsNothing);
  });

  testWidgets('Login OK', (WidgetTester tester) async {

    await tester.pumpWidget(MyApp());

    // Simula que vai digitar algo...
    await tester.enterText(find.byType(TextFormField).at(0), "a@a.com");
    await tester.enterText(find.byType(TextFormField).at(1), "123");

    // Clica no botão
    await tester.tap(find.byType(RaisedButton).at(0));
//    await tester.pumpAndSettle();
    await tester.pump(Duration(seconds: 5));

    // Abriu a Home :-)
    expect(find.byType(HomePage), findsOneWidget);
//    expect(find.text("Carros!"), findsOneWidget);
  });
}
