import 'package:flutter_test/flutter_test.dart';
import 'package:sportspotter/google_maps/google_maps.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  int radius = 10 * 1000;
  group('Google maps', () {
    test('testing if getCoordinates returns a Pair of address and LatLng for a valid address', () async {
      final pair = await getCoordinates('1600 Amphitheatre Parkway, Mountain View, CA');
      expect(pair, isA<Pair<String, LatLng>>());
    });

    test('testing if getCoordinates returns the correct id address for a valid address', () async {
      final pair = await getCoordinates('1600 Amphitheatre Parkway, Mountain View, CA');
      String expected = 'ChIJj38IfwK6j4ARNcyPDnEGa9g';
      expect(pair.first, expected);
    });

    test('testing if getCoordinates returns the correct coordinates for a valid address', () async {
      final pair = await getCoordinates('1600 Amphitheatre Parkway, Mountain View, CA');
      LatLng expected = const LatLng(37.4224764, -122.0842499);
      expect(pair.second.latitude, closeTo(expected.latitude, 0.001));
      expect(pair.second.longitude, closeTo(expected.longitude, 0.001));
    });

    test('testing if getCoordinates returns a Pair of address and LatLng for a valid address', () async {
      final pair = await getCoordinates('1600 Amphitheatre Parkway, Mountain View, CA');
      expect(pair, isA<Pair<String, LatLng>>());
    });

    test('testing if findPlacesWithoutFilters returns a non-empty list for a valid source', () async {
      final source = Pair('ChIJj38IfwK6j4ARNcyPDnEGa9g', const LatLng(37.4224764, -122.0842499));
      final places = await findPlacesWithoutFilters(source, radius);
      expect(places, isNotEmpty);
    });

    test('testing if findPlacesWithoutFilters returns a list of Pairs', () async {
      final source = Pair('ChIJj38IfwK6j4ARNcyPDnEGa9g', const LatLng(37.4224764, -122.0842499));
      final places = await findPlacesWithoutFilters(source, radius);
      expect(places, isA<List<Pair<Pair<String, String>, LatLng>>>());
    });

    test('testing if findPlacesWithoutFilters returns a list of Pairs containing the correct id and LatLng for each place', () async {
      final source = Pair('ChIJYXxhoeW6j4ARis9VjjDkDVo', const LatLng(37.4224764, -122.0842499));
      final places = await findPlacesWithoutFilters(source, radius);
      final expected = Pair('Blossom Birth & Family', 'ChIJYXxhoeW6j4ARis9VjjDkDVo');
      final expectedLatLng = const LatLng(37.424212507724185, -122.10286875396935);
      for (var place in places) {
        if(place.first.first == expected.first){
          expect(place.first.second, expected.second);
          expect(place.second.latitude, closeTo(expectedLatLng.latitude, 0.001));
          expect(place.second.longitude, closeTo(expectedLatLng.longitude, 0.001));
        }
      }
    });
  });
}