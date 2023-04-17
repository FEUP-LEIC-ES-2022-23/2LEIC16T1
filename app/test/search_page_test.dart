import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sportspotter/main.dart';


void main() {
  testWidgets('Display search bar when I click on the search page button', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    final searchButton = find.text('Search');
    expect(searchButton, findsOneWidget);
    await tester.tap(searchButton);
    await tester.pumpAndSettle();

    final searchBar = find.byIcon(Icons.search);
    expect(searchBar, findsOneWidget);
  });

  testWidgets('I can search information on the search bar', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    final searchButton = find.text('Search');
    expect(searchButton, findsOneWidget);
    await tester.tap(searchButton);
    await tester.pumpAndSettle();

    final Finder searchBarFinder = find.byIcon(Icons.search);
    expect(searchBarFinder, findsOneWidget);

    await tester.tap(searchBarFinder);
    await tester.pumpAndSettle();

    // Find the search field and enter a location
    final Finder searchFieldFinder = find.byType(TextField);
    expect(searchFieldFinder, findsOneWidget);

    await tester.enterText(searchFieldFinder, 'Porto');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    final Finder locationListFinder = find.byIcon(Icons.search);
    expect(locationListFinder, findsNothing); // this means we pressed enter
  });
}
