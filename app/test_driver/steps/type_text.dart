import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

class TypeInTheSearchBar extends When1WithWorld<String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"I input a location {string} in the search bar");

  @override
  Future<void> executeStep(String key) async {
    final locator = find.byValueKey("search bar");
    await FlutterDriverUtils.enterText(world.driver, locator, "$key\n");
    final search = find.byValueKey("search-icon");
    await FlutterDriverUtils.tap(world.driver, search);
  }
}