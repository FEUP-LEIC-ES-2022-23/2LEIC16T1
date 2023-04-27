import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sportspotter/widgets/search_dropdown.dart';

void main() {
  group('Search Dropdown', () {
    String selectedItem = "badminton";
    List<String> items = ["badminton", "outdoor"];
    Widget testWidget = MediaQuery(
        data: const MediaQueryData(),
        child: MaterialApp(
          home: Scaffold(
              body: SearchDropdown(selectedItem: selectedItem, items: items)
          )
        )
    );

    testWidgets('Box size before clicking', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);

      final tagList = find.byKey(Key('dropdown list tags'));
      expect(tagList, findsOneWidget);

      Size size = tester.getSize(tagList);
      expect(size.height, equals(0));
    });

    testWidgets('Box size after clicking', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);

      final tagInput = find.text(' what are you looking for');
      expect(tagInput, findsOneWidget);

      await tester.tapAt(tester.getTopLeft(tagInput));
      await tester.pumpAndSettle();

      final tagList = find.byKey(Key('dropdown list tags'));
      expect(tagList, findsOneWidget);

      Size size = tester.getSize(tagList);
      expect(size.height, equals(200));
    });
  });
}