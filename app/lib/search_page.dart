import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sportspotter/navigation.dart';
import 'package:sportspotter/google_maps.dart';


class SearchScreen extends StatelessWidget {
  final String customMapStyle =
      '[ { "featureType": "water", "elementType": "geometry.fill", "stylers": [ { "color": "#0099dd" } ] } ]';

  static const List<String> test = ['R. Dr. Roberto Frias, 4200-465 Porto', 'Rua do Paço, 4425-158 Maia', 'ahhhhhhh'];
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: CustomSearch()
                );
              }
          ),
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

        body: Stack(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  List<Map<String, double>> coordinates = await getCoordinates(test);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapScreen(showMap: true, coordinates: coordinates),
                    ),
                  );
                },
                child: const Text('Show Map'),
              ),
            ),
            const Positioned(
                bottom: 0,
                left: 0,
                child: NavigationWidget(selectedIndex: 1)
            )
          ],
        )
    );
  }
}

class CustomSearch extends SearchDelegate {
  List<String> data = [
    'Ginásio de Paranhos', 'Ginásio de Paranhos 2', 'Ginásio de Paranhos 3'
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear)
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back)
    );
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
      }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
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
        }
    );
  }
}

class MapScreen extends StatelessWidget {
  final String customMapStyle =
      '[ { "featureType": "water", "elementType": "geometry.fill", "stylers": [ { "color": "#0099dd" } ] } ]';

  final Set<Marker> markers = {};


  MapScreen({Key? key, required bool showMap, List<Map<String, double>>? coordinates})  :super(key: key) {
    if (showMap) {
      for (var item in coordinates!) {
        markers.add(Marker(
          markerId: MarkerId(item.toString()),
          position: LatLng(item['lat']!, item['lng']!),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Screen'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: const CameraPosition(
          target: LatLng(41.179722, -8.616389),
          zoom: 12,
        ),
        markers: markers,
        onMapCreated: (GoogleMapController controller) {
          // Set the custom map style here
          controller.setMapStyle(customMapStyle);
        },
      ),
    );
  }
}