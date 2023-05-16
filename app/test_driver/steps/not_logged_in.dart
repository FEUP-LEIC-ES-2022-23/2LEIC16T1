import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

class NotLoggedIn extends AndWithWorld<FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"I am not logged in");

  @override
  Future<void> executeStep() async {
    final pageLocator = find.text("Profile");
    await FlutterDriverUtils.tap(world.driver, pageLocator);
    FlutterDriverUtils.waitForFlutter(world.driver);

    final signOutLocator = find.byValueKey("sign out button");
    var exists = await FlutterDriverUtils.isPresent(world.driver, signOutLocator);
    FlutterDriverUtils.waitForFlutter(world.driver);
    if (exists) {
      await FlutterDriverUtils.tap(world.driver, signOutLocator);
      FlutterDriverUtils.waitForFlutter(world.driver);
    }

    final signInLocator = find.byValueKey("sign in form");
    var form = await FlutterDriverUtils.isPresent(world.driver, signInLocator);
    expectMatch(form, true);
  }
}
