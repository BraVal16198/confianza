import 'package:flutter_test/flutter_test.dart';
import 'package:microfinanza0/main.dart';

void main() {
  testWidgets('ConfianzaMicro arranca con MaterialApp.router', (tester) async {
    await tester.pumpWidget(const ConfianzaMicroApp());
    // Splash inicial: marca ConfianzaMicro visible en el árbol.
    expect(find.textContaining('Confianza'), findsWidgets);
  });
}
