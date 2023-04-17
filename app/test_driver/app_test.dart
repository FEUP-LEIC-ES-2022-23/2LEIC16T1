import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';

import 'steps/display_map_list.dart';
import 'steps/press_something.dart';
import 'steps/show_message.dart';
import 'steps/tap_button.dart';
import 'steps/type_text.dart';
import 'steps/user_go_to_page.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [Glob(r"test_driver/features/**.feature")]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      JsonReporter(path: './report.json')
    ] // you can include the "StdoutReporter()" without the message level parameter for verbose log information
  //..hooks = [HookExample()]
    ..stepDefinitions = [UserGoToPage(), ThenSeeButton(), TypeInTheSearchBar(), ShowMessage(), DisplayMapAndList(), WhenTapButton(), ThenTapButton()]
    ..customStepParameterDefinitions = []
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/app.dart";
  // ..tagExpression = "@smoke" // uncomment to see an example of running scenarios based on tag expressions
  return GherkinRunner().execute(config);
}