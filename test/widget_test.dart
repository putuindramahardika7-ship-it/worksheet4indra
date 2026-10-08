import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_fundamentals/main.dart';

void main() {
  testWidgets('CourseExplorerApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CourseExplorerApp());
    expect(find.text('Course Explorer'), findsOneWidget);
  });
}
