import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

class WhenTapButton extends When1WithWorld<String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"I tap the {string}");

  @override
  Future<void> executeStep(String key) async {
    final locator = find.byValueKey(key);
    await FlutterDriverUtils.tap(world.driver, locator);
  }
}

class ThenTapButton extends Then1WithWorld<String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"I tap the {string}");

  @override
  Future<void> executeStep(String key) async {
    final locator = find.byValueKey(key);
    await FlutterDriverUtils.tap(world.driver, locator);
    FlutterDriverUtils.waitForFlutter(world.driver);
  }
}