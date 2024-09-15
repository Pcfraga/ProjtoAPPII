import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/main.dart';
import 'package:myapp/database/database_helper.dart'; // Certifique-se de importar o DatabaseHelper

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Cria uma instância fictícia do DatabaseHelper para o teste.
    final databaseHelper = DatabaseHelper();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(databaseHelper: databaseHelper));

    // Verifique que o contador começa em 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Toque no ícone '+' e dispare um frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verifique que o contador foi incrementado.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
