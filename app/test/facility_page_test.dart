import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sportspotter/models/facility.dart';
import 'package:sportspotter/facility_page.dart';

void main() {
  testWidgets('FacilityPage - Widget Test', (WidgetTester tester) async {
    final facility = Facility(
      id: '1',
      name: 'Test Facility',
      photo: 'https://example.com/image.jpg',
      address: '123 Main St',
      phoneNumber: '555-1234',
      tags: [],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: FacilityPage(facility: facility),
      ),
    );

    // Check if the facility name is displayed
    expect(find.text('Test Facility'), findsOneWidget);

    // Check if the facility photo is displayed
    expect(find.byType(Image), findsOneWidget);

    // Check if the facility address is displayed
    expect(find.text('123 Main St'), findsOneWidget);

    // Check if the facility phone number is displayed
    expect(find.text('555-1234'), findsOneWidget);

    // Check if the review text field is displayed
    expect(find.byType(TextField), findsOneWidget);

    // Check if the submit button is displayed
    expect(find.widgetWithText(TextButton, 'Submit'), findsOneWidget);
  });

  testWidgets('FacilityPage - Review Submission Test', (WidgetTester tester) async {
    final facility = Facility(
      id: '1',
      name: 'Test Facility',
      photo: 'https://example.com/image.jpg',
      address: '123 Main St',
      phoneNumber: '555-1234',
      tags: [],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: FacilityPage(facility: facility),
      ),
    );

    // Enter review text in the text field
    await tester.enterText(find.byType(TextField), 'This is a test review');

    // Tap the submit button
    await tester.tap(find.widgetWithText(TextButton, 'Submit'));

    // Wait for the review submission to complete
    await tester.pump();

    // Check if the review text field is cleared
    expect(tester.widget<TextField>(find.byType(TextField)).controller!.text, isEmpty);

    // Check if the review is displayed on the page
    expect(find.text('This is a test review'), findsOneWidget);
  });
}