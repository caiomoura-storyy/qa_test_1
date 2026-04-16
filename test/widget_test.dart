import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qatest1/app_root.dart';

void main() {
  testWidgets('Login screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const AppRoot());
    await tester.pumpAndSettle();

    expect(find.widgetWithText(FilledButton, 'Login'), findsOneWidget);
    expect(find.text('Forgot password?'), findsOneWidget);
  });
}
