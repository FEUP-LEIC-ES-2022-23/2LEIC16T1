import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

class LoggedIn extends AndWithWorld<FlutterWorld> {
  @override
  RegExp get pattern => RegExp(r"I am logged in");

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

    final mail = find.byValueKey("sign in mail field");
    final pass = find.byValueKey("sign in password field");

    await FlutterDriverUtils.enterText(world.driver, mail, "esof@gmail.pt");
    await FlutterDriverUtils.enterText(world.driver, pass, "Es123456.?");

    final button = find.byValueKey("login button");
    await FlutterDriverUtils.tap(world.driver, button);
  }
}
