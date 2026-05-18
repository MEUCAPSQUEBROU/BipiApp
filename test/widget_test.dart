import 'package:bipi/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Bipi app boots and shows title', (WidgetTester tester) async {
    await tester.pumpWidget(const BipiApp());
    await tester.pumpAndSettle();

    expect(find.text('Bipi'), findsOneWidget);
  });
}
