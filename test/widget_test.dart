import 'package:flutter_test/flutter_test.dart';

import 'package:stateless_labexam_lustre/main.dart';

void main() {
  testWidgets('app loads the dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const StudentDashboardApp());

    expect(find.text('Student Dashboard'), findsOneWidget);
    expect(find.text('Subjects'), findsOneWidget);
  });
}
