import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

class UserGoToPage extends Given1WithWorld<String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"I navigate to the {string} page");

  @override
  Future<void> executeStep(String page) async {
    final locator = find.text(page);
    await FlutterDriverUtils.tap(world.driver, locator);
    FlutterDriverUtils.waitForFlutter(world.driver);
  }
}
