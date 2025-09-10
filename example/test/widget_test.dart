// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:form_maker_example/main.dart';

void main() {
  testWidgets('Form maker example app test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the app title is present
    expect(find.text('Form Maker Example'), findsOneWidget);

    // Verify that the form heading is present
    expect(find.text('Restaurant Information'), findsOneWidget);

    // Verify that form fields are present
    expect(find.text('Restaurant Name'), findsOneWidget);
    expect(find.text('Contact Email'), findsOneWidget);
    expect(find.text('Restaurant Address'), findsOneWidget);
    expect(find.text('Primary Currency'), findsOneWidget);
    expect(find.text('Service Options'), findsOneWidget);

    // Test that text form fields are present
    expect(find.byType(TextFormField), findsWidgets);
  });
}
