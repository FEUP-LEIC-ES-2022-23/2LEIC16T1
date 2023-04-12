import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sportspotter/models/facility.dart';
import 'package:sportspotter/navigation.dart';
import 'package:sportspotter/google_maps.dart';

import 'facility_page.dart';
import 'models/data_service.dart';

class SearchScreen extends StatelessWidget {
  final String customMapStyle =
      '[ { "featureType": "water", "elementType": "geometry.fill", "stylers": [ { "color": "#0099dd" } ] } ]';

  static const String test = 'R. Dr. Roberto Frias, 4200-465 Porto';
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: CustomSearch());
            }),
        title: GestureDetector(
          onTap: () {
            showSearch(
              context: context,
              delegate: CustomSearch(),
            );
          },
          child: const Text('Enter a location'),
        ),
      ),
      bottomNavigationBar: const NavigationWidget(selectedIndex: 1),
    );
  }
}

class CustomSearch extends SearchDelegate {
  List<String> data = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];

    for (var item in data) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(result),
          );
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    final coordinates = getCoordinates(query).then((value){
      final places = findPlaces(value.second);
      return places.then((locations) => [value] + locations);
    });

    return StatefulBuilder(builder: (context, setState) {
      return FutureBuilder(
        future: coordinates,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return Column(
              children: [
                Expanded(
                  child: MapScreen(showMap: true, coordinates: snapshot.data),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Container();
                      }

                      var facilityName = snapshot.data[index].first;
                        var listTile = ListTile(
                          title: Text(facilityName),
                          onTap: () {
                            Stream<List<Future<Facility>>> facilitiesStream = DataService.readFacilities();
                            Facility selectedFacility;
                            facilitiesStream.listen((facilities) async {
                              selectedFacility = await facilities.first;

                              Navigator.push(context, PageRouteBuilder(
                                  pageBuilder: (context, animation1, animation2) => FacilityPage(facility: selectedFacility),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero
                              ));
                            });
                          }
                        );
                        return listTile;
                    },
                  ),
                ),
                const NavigationWidget(selectedIndex: 1),
              ],
            );
          }
        },
      );
    });
  }

}

class MapScreen extends StatelessWidget {
  final String customMapStyle =
      '[ { "featureType": "water", "elementType": "geometry.fill", "stylers": [ { "color": "#0099dd" } ] } ]';

  Set<Marker> markers = {};
  late final LatLng cameraPosition;

  MapScreen(
      {Key? key,
      required bool showMap,
      List<Pair<String, LatLng>>? coordinates})
      : super(key: key) {
    if (showMap) {
      cameraPosition = coordinates![0].second;
      markers = buildMarkers(coordinates);
    }
  }

  Set<Marker> buildMarkers(List<Pair<String, LatLng>> coordinates) {
    Set<Marker> markers_ = {};
    BitmapDescriptor blueMarker =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    BitmapDescriptor redMarker =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    markers_.add(buildMarker(coordinates[0], blueMarker, 2));
    for (int i = 1; i < coordinates.length; i++) {
      markers_.add(buildMarker(coordinates[i], redMarker, 1));
    }
    return markers_;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: cameraPosition,
        zoom: 12,
      ),
      markers: markers,
      onMapCreated: (GoogleMapController controller) {
        // Set the custom map style here
        controller.setMapStyle(customMapStyle);
      },
    );
  }
}
