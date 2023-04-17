
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sportspotter/google_maps/google_maps.dart';
import 'package:sportspotter/tools/geocoding.dart';

void main() {
  test('testing if getCoordinates returns a Pair of address and LatLng for a valid address', () async {
    final pair = await getCoordinates('1600 Amphitheatre Parkway, Mountain View, CA');
    expect(pair, isA<Pair<String, LatLng>>());
  });
}