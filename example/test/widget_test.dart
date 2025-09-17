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

    // Verify that tabs are present
    expect(find.text('Restaurant'), findsOneWidget);
    expect(find.text('School'), findsOneWidget);
    expect(find.text('User'), findsOneWidget);
    expect(find.text('Hospital'), findsOneWidget);

    // Verify that the default restaurant form is shown
    expect(find.text('Restaurant Name'), findsOneWidget);
    expect(find.text('Restaurant Logo'), findsOneWidget);
    expect(find.text('Cuisine Type'), findsOneWidget);
    expect(find.text('Service Options'), findsOneWidget);

    // Test that text form fields are present
    expect(find.byType(TextFormField), findsWidgets);

    // Test tab switching to school
    await tester.tap(find.text('School'));
    await tester.pumpAndSettle();

    // Verify school form is shown
    expect(find.text('Institution Name'), findsOneWidget);
    expect(find.text('School Logo'), findsOneWidget);

    // Test tab switching to user
    await tester.tap(find.text('User'));
    await tester.pumpAndSettle();

    // Verify user form is shown
    expect(find.text('First Name'), findsOneWidget);
    expect(find.text('Profile Photo'), findsOneWidget);

    // Test tab switching to hospital
    await tester.tap(find.text('Hospital'));
    await tester.pumpAndSettle();

    // Verify hospital form is shown
    expect(find.text('Medical Center Name'), findsOneWidget);
    expect(find.text('Hospital Main Building'), findsOneWidget);

    // Test that Show Form Data button is present in all forms
    expect(find.text('Show Form Data'), findsOneWidget);

    // Test tab switching back to restaurant to verify button there too
    await tester.tap(find.text('Restaurant'));
    await tester.pumpAndSettle();
    expect(find.text('Show Form Data'), findsOneWidget);

    // Verify new fields are present in restaurant form
    expect(find.text('Restaurant Phone'), findsOneWidget);
    expect(find.text('Postal Code'), findsOneWidget);
  });
}
