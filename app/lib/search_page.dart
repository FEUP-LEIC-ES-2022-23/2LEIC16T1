import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sportspotter/navigation.dart';
import 'package:sportspotter/google_maps.dart';

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
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            Pair<String, LatLng> sourceCoordinates = await getCoordinates(test);
            List<Pair<String, LatLng>> coordinates =
                await findPlaces(sourceCoordinates.second);
            coordinates.insert(0, sourceCoordinates);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MapScreen(showMap: true, coordinates: coordinates),
              ),
            );
          },
          child: const Text('Show Map'),
        ),
      ),
      bottomNavigationBar: const NavigationWidget(selectedIndex: 1),
    );
  }
}

class CustomSearch extends SearchDelegate {
  List<String> data = [
    'Ginásio de Paranhos',
    'Ginásio de Paranhos 2',
    'Ginásio de Paranhos 3'
  ];
  late Pair<String, LatLng> sourceCoordinates;
  late List<Pair<String, LatLng>> coordinates;
  bool isDone = false;
  List matchQuery = [];

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
    if(!isDone){
      getCoordinates(query).then((value) => {
        sourceCoordinates = value,
        findPlaces(sourceCoordinates.second).then((value) => {
          coordinates = value,
          for (var i = 0; i < coordinates.length; i++)
            matchQuery.add(coordinates[i].first),
          coordinates.insert(0, sourceCoordinates),
          isDone = true,
        })
      });
    }

      return StatefulBuilder(builder: (context, setState){
        return Column(children: [
          Expanded(child: MapScreen(showMap: true, coordinates: coordinates)),
          Expanded(
            child: ListView.builder(
                itemCount: coordinates.length,
                itemBuilder: (context, index) {
                  var result = matchQuery[index];
                  return ListTile(
                    title: Text(result),
                  );
                }),
          ),
          const NavigationWidget(selectedIndex: 1)
        ]);
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
