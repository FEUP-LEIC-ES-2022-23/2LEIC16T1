import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sportspotter/widgets/search_dropdown.dart';

void main() {
  late Widget testWidget;

  group('Search Dropdown', () {
    setUp(() {
      String selectedItem = 'badminton';
      List<String> items = ["badminton", "outdoor"];
      testWidget = MediaQuery(
          data: const MediaQueryData(),
          child: MaterialApp(
              home: Scaffold(
                  body: SearchDropdown(selectedItem: selectedItem, items: items)
              )
          )
      );
    });

    testWidgets('Box size before clicking', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);

      final tagList = find.byKey(Key('dropdown list tags'));
      expect(tagList, findsOneWidget);

      Size size = tester.getSize(tagList);
      expect(size.height, equals(0));
    });

    testWidgets('Box open and tap outside', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);

      final tagInput = find.ancestor(
          of: find.text('badminton'),
          matching: find.byType(TextField)
      );
      expect(tagInput, findsOneWidget);

      await tester.tap(tagInput);
      await tester.pumpAndSettle();

      final tagList = find.byKey(Key('dropdown list tags'));
      expect(tagList, findsOneWidget);

      Size size = tester.getSize(tagList);
      expect(size.height, equals(200));

      await tester.tapAt(Offset(0, tester.getCenter(tagInput).dy + 250));
      await tester.pumpAndSettle();

      size = tester.getSize(tagList);
      expect(size.height, equals(0));
    });

    testWidgets('Box open and tap option', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);

      var tagInput = find.ancestor(
          of: find.text('badminton'),
          matching: find.byType(TextField)
      );
      expect(tagInput, findsOneWidget);

      await tester.tap(tagInput);
      await tester.pumpAndSettle();

      final tagList = find.byKey(Key('dropdown list tags'));
      expect(tagList, findsOneWidget);

      Size size = tester.getSize(tagList);
      expect(size.height, equals(200));

      final outdoor = find.text('outdoor');
      await tester.tap(outdoor);
      await tester.pumpAndSettle();

      expect(tagInput, findsNothing);

      size = tester.getSize(tagList);
      expect(size.height, equals(0));

      tagInput = find.ancestor(
          of: find.text('outdoor'),
          matching: find.byType(TextField)
      );

      expect(tagInput, findsOneWidget);
    });
    
    testWidgets('Input invalid tag and submit', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);

      var tagInput = find.ancestor(
          of: find.text('badminton'),
          matching: find.byType(TextField)
      );
      expect(tagInput, findsOneWidget);

      await tester.tap(tagInput);
      await tester.pumpAndSettle();

      final tagList = find.byKey(Key('dropdown list tags'));
      expect(tagList, findsOneWidget);

      Size size = tester.getSize(tagList);
      expect(size.height, equals(200));

      await tester.enterText(tagInput, 'a');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(tagInput, findsOneWidget);
      expect(find.text('a'), findsNothing);
    });

    testWidgets('Input valid tag and submit', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);

      var tagInput = find.ancestor(
          of: find.text('badminton'),
          matching: find.byType(TextField)
      );
      expect(tagInput, findsOneWidget);

      await tester.tap(tagInput);
      await tester.pumpAndSettle();

      final tagList = find.byKey(Key('dropdown list tags'));
      expect(tagList, findsOneWidget);

      Size size = tester.getSize(tagList);
      expect(size.height, equals(200));

      await tester.enterText(tagInput, 'outdoor');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(tagInput, findsNothing);

      tagInput = find.ancestor(
          of: find.text('outdoor'),
          matching: find.byType(TextField)
      );
      expect(tagInput, findsOneWidget);
    });

    testWidgets('Input invalid tag and tap outside', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);

      var tagInput = find.ancestor(
          of: find.text('badminton'),
          matching: find.byType(TextField)
      );
      expect(tagInput, findsOneWidget);

      await tester.tap(tagInput);
      await tester.pumpAndSettle();

      final tagList = find.byKey(Key('dropdown list tags'));
      expect(tagList, findsOneWidget);

      Size size = tester.getSize(tagList);
      expect(size.height, equals(200));

      await tester.enterText(tagInput, 'a');
      await tester.tapAt(const Offset(0, 250));
      await tester.pumpAndSettle();

      expect(tagInput, findsOneWidget);
      expect(find.text('a'), findsNothing);
    });

    testWidgets('Input valid tag and tap outside', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);

      var tagInput = find.ancestor(
          of: find.text('badminton'),
          matching: find.byType(TextField)
      );
      expect(tagInput, findsOneWidget);

      await tester.tap(tagInput);
      await tester.pumpAndSettle();

      final tagList = find.byKey(Key('dropdown list tags'));
      expect(tagList, findsOneWidget);

      Size size = tester.getSize(tagList);
      expect(size.height, equals(200));

      await tester.enterText(tagInput, 'outdoor');
      await tester.tapAt(const Offset(0, 250));
      await tester.pumpAndSettle();

      expect(tagInput, findsNothing);

      tagInput = find.ancestor(
          of: find.text('outdoor'),
          matching: find.byType(TextField)
      );
      expect(tagInput, findsOneWidget);
    });

    testWidgets('Clear input and tap outside', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);

      var tagInput = find.ancestor(
          of: find.text('badminton'),
          matching: find.byType(TextField)
      );
      expect(tagInput, findsOneWidget);

      await tester.tap(tagInput);
      await tester.pumpAndSettle();

      final tagList = find.byKey(Key('dropdown list tags'));
      expect(tagList, findsOneWidget);

      Size size = tester.getSize(tagList);
      expect(size.height, equals(200));

      await tester.enterText(tagInput, '');
      await tester.tapAt(const Offset(0, 250));
      await tester.pumpAndSettle();

      expect(tagInput, findsNothing);
      expect(find.text(''), findsOneWidget);
    });

    testWidgets('Clear input and submit', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);

      var tagInput = find.ancestor(
          of: find.text('badminton'),
          matching: find.byType(TextField)
      );
      expect(tagInput, findsOneWidget);

      await tester.tap(tagInput);
      await tester.pumpAndSettle();

      final tagList = find.byKey(Key('dropdown list tags'));
      expect(tagList, findsOneWidget);

      Size size = tester.getSize(tagList);
      expect(size.height, equals(200));

      await tester.enterText(tagInput, '');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(tagInput, findsNothing);

      expect(tagInput, findsNothing);
      expect(find.text(''), findsOneWidget);
    });
  });
}