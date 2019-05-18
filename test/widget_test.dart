import 'package:carros/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Login Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
    await tester.pump();

    // Verify that our counter starts at 0.
    expect(find.byKey(Key('materialapp')), findsOneWidget);
    expect(find.byKey(Key('email')), findsOneWidget);
//    expect(find.text('rlecheta@gmail.com'), findsOneWidget);
//    expect(find.text('123456'), findsNothing);

    // Tap the '+' icon and trigger a frame.
//    await tester.tap(find.byIcon(Icons.add));
//    await tester.pump();
//
//    // Verify that our counter has incremented.
//    expect(find.text('0'), findsNothing);
//    expect(find.text('1'), findsOneWidget);
  });
}
