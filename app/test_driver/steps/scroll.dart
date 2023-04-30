import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

class Scroll extends And1WithWorld<String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"I scroll in {string}");

  @override
  Future<void> executeStep(String key) async {
    final menu = find.byValueKey(key);
    await world.driver?.scroll(menu, 0, -300, const Duration(milliseconds: 500));
    FlutterDriverUtils.waitForFlutter(world.driver);
  }
}
