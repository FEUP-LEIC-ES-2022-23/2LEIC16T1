import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sportspotter/main.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


void main() {
  group('Search Page', () {
  testWidgets('Display search bar when I click on the search page button', (
      WidgetTester tester) async {
    databaseFactory = databaseFactoryFfi;
    await tester.pumpWidget(MyApp());
    final searchButton = find.text('Search');
    expect(searchButton, findsOneWidget);
    await tester.tap(searchButton);
    await tester.pumpAndSettle();

    final searchBar = find.byIcon(Icons.search);
    expect(searchBar, findsOneWidget);
  });
});
}
