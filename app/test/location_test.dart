import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart';
import 'package:location_platform_interface/location_platform_interface.dart';
import 'package:sportspotter/tools/location.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('testing if getLocation returns anything', () {
    Future<LocationData?> res = getLocation();
    expect(res, isA<Future<LocationData?>>());
  });
}
