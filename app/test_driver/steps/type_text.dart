import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';


class Type extends When2WithWorld<String, String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"I input {string} in the {string}");

  @override
  Future<void> executeStep(String key, String button) async {
    final locator = find.byValueKey(button);
    await Future.delayed(const Duration(seconds: 1));
    await FlutterDriverUtils.enterText(world.driver, locator, "$key\n");
  }
}
