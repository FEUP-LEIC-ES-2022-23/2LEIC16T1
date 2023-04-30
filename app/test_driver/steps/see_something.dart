import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

class SeeButton extends Then1WithWorld<String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"I should see a {string}");

  @override
  Future<void> executeStep(String key) async {
    final locator = find.byValueKey(key);
    var exists = await FlutterDriverUtils.isPresent(world.driver, locator);
    expectMatch(exists, true);
  }
}
