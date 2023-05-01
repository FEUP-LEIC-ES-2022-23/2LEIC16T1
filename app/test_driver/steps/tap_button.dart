import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

class TapButton extends When1WithWorld<String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"I tap the {string}");

  @override
  Future<void> executeStep(String key) async {
    final locator = find.byValueKey(key);
    await FlutterDriverUtils.tap(world.driver, locator);
  }
}

class TapFacility extends And1WithWorld<String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"I choose the facility {string}");

  @override
  Future<void> executeStep(String key) async {
    final locator = find.text(key);
    await FlutterDriverUtils.tap(world.driver, locator);
    FlutterDriverUtils.waitForFlutter(world.driver);
  }
}