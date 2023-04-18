import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

class ShowMessage extends When1WithWorld<String, FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"the system should display a {string} message");

  @override
  Future<void> executeStep(String key) async {
    final noResults = find.text(key);
    var exists = await FlutterDriverUtils.isPresent(world.driver, noResults);
    expectMatch(exists, true);
  }
}