import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sportspotter/navigation.dart';
import 'package:sportspotter/google_maps/google_maps.dart';
import 'package:sportspotter/tools/location.dart';
import 'package:sportspotter/tools/geocoding.dart';
import 'package:sportspotter/widgets/search_dropdown.dart';

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
          key: Key("search bar"),
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
  List<String> filters = List<String>.filled(5, '');
  double radius = 10;

  Future<void> getSelfCoordinates() async {
    LocationData? locationData = await getLocation(Location());
    if (locationData != null) {
      String? address = await getAddressFromCoordinates(locationData.latitude!, locationData.longitude!);
      if(address == null) {
        return;
      }
      query = address;
    }

  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
      IconButton(
        onPressed: () {
          editSearchSettings(context);
        },
        icon: const Icon(Icons.filter_alt)
      ),
      TextButton(
        onPressed: () {
          showResults(context);
        },
        child: IconButton(
            key: Key('search-icon'), // set the key property
            icon: const Icon(Icons.search),
            onPressed: () {
              showResults(context);
            }
        ),
      ),
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
      itemCount: matchQuery.length + 1, // Add one for the button
      itemBuilder: (context, index) {
        if (index == 0) { // The first item is the button
          return ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Get Location'),
            onTap: () async {
              await getSelfCoordinates();
            },
          );
        } else { // The rest of the items are the suggestions
          var result = matchQuery[index - 1];
          return ListTile(
            title: Text(result),
          );
        }
      },
    );
  }
  @override
  Widget buildResults(BuildContext context) {
    //List<Pair<Pair<"name","id">, LatLng>>
    final coordinates = getCoordinates(query).then((value){
      print("AAAAAAAAAAAAAAA");
      print(filters);
      final places = findPlaces(value, radius.round() * 1000, filters);
      return places.then((locations) {
        if (value.first == query) {
          return [Pair(Pair(value.first, ""), value.second)] + locations;
        } else {
          return locations;
        }
      });
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
                  key: Key("results-map"),
                  child: MapScreen(showMap: true, coordinates: snapshot.data, context: context),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Container();
                      }

                        var listTile = ListTile(
                          key: Key("results-list"),
                          title: Text(snapshot.data[index].first.first),
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return const Center(
                                  child: CircularProgressIndicator(color: Colors.white),
                                );
                              },
                            );

                            DataService.fetchFacility(snapshot.data[index].first.second).then((selectedFacility){
                              Navigator.of(context).pop();
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

  editSearchSettings(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, state) {
                return AlertDialog(
                    contentPadding: const EdgeInsets.only(top: 10.0),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                  content: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: 550,
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        const Center(
                            child: Text(
                              "Options",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(94, 97, 115, 1)
                              ),
                            )
                        ),
                        for (int i = 1; i <= 5; i++)
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 20, top: 30, bottom: 20),
                              child: Text(
                                  'Tag #$i',
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: Color.fromRGBO(94, 97, 115, 1)
                                  )
                              ),
                            ),
                            Expanded(
                                child: SearchDropdown(
                                  selectedItem: filters[i-1],
                                  items: DataService.availableTags,
                                  onChanged: (item) {
                                    filters[i-1] = item;
                                  },
                                )
                            ),
                          ],
                        ),
                        Row(
                            children: [
                              const Text("5"),
                              Expanded(
                                child: Slider(
                                  value: radius,
                                  divisions: 9,
                                  min: 5,
                                  max: 50,
                                  label: "${(radius.round())
                                      .toString()} km",
                                  onChanged: (value) {
                                    state(() {
                                      radius = value;
                                    });
                                  },
                                ),
                              ),
                              const Text("50")
                            ]
                        ),
                        const Center(
                          child: Text(
                            "Search radius (km)",
                            style: TextStyle(
                                fontSize: 17,
                                color: Color.fromRGBO(94, 97, 115, 1)
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            "Save",
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.white
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                );
              }
          );
        }
    );
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
      List<Pair<Pair<String, String>, LatLng>>? coordinates,
      required BuildContext context})
      : super(key: key) {
    if (showMap) {
      cameraPosition = coordinates![0].second;
      markers = buildMarkers(coordinates, context);
    }
  }

  Set<Marker> buildMarkers(List<Pair<Pair<String, String>, LatLng>> coordinates, BuildContext context) {
    Set<Marker> markers_ = {};
    BitmapDescriptor blueMarker =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    BitmapDescriptor redMarker =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    markers_.add(buildMarker(coordinates[0], blueMarker, 2, context));
    for (int i = 1; i < coordinates.length; i++) {
      markers_.add(buildMarker(coordinates[i], redMarker, 1, context));
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
