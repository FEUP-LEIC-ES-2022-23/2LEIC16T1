import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

class DisplayMapAndList extends ThenWithWorld<FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"the system should display a map and a list of the sports facilities near that location");

  @override
  Future<void> executeStep() async {
    final map = find.byValueKey("results-map");
    final list = find.byValueKey("results-list");
    var existsMap = await FlutterDriverUtils.isPresent(world.driver, map);
    var existsList = await FlutterDriverUtils.isPresent(world.driver, list);
    expectMatch(existsMap, true);
    expectMatch(existsList, true);
  }
}