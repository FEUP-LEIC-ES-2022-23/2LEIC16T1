import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sportspotter/models/local_storage.dart';
import 'package:sportspotter/navigation.dart';
import 'package:sportspotter/google_maps/google_maps.dart';
import 'package:sportspotter/tools/location.dart';
import 'package:sportspotter/tools/geocoding.dart';
import 'package:sportspotter/widgets/search_dropdown.dart';

import 'facility_page.dart';
import 'models/data_service.dart';

class SearchScreen extends StatefulWidget {
  final String customMapStyle =
      '[ { "featureType": "water", "elementType": "geometry.fill", "stylers": [ { "color": "#0099dd" } ] } ]';

  static const String test = 'R. Dr. Roberto Frias, 4200-465 Porto';
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

VisitedPlaces placesIDs = VisitedPlaces(facilities: List.generate(VisitedPlaces.MAX_PLACES, (index) => ""));

class _SearchScreenState extends State<SearchScreen>{
  bool _initState = true;

  @override
  void initState() {
    if (_initState) {
      _initState = false;
    }
  }

  Future<List<Pair<String, String>>> _fetchPlaces() async {
    placesIDs.fetchFacilities();
    List<Pair<String, String>> places = [];
    if (placesIDs.facilities.isNotEmpty) {
      for (String item in placesIDs.facilities) {
        if (item != "") {
          var facility = await DataService.fetchFacility(item);
          places.add(Pair(item, facility.name));
        }
      }
    }
    return places;
  }

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

      body: FutureBuilder<List<Pair<String, String>>>(
        future: _fetchPlaces(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Past Visited Places",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            title: Text(snapshot.data![index].second),
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                    ),
                                  );
                                },
                              );
                              DataService.fetchFacility(snapshot.data![index].first).then((selectedFacility){
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FacilityPage(facility: selectedFacility),
                                  ),
                                );
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container(
              color: Colors.white,
              child: Center(
                child: Text(
                  "You can see the facilities you have visited here",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            );
          }
        },
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
        key: Key('filter-icon'),
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
    final coordinates = getCoordinates(query).then((value){
      final places = findPlaces(value, radius.round() * 1000, filters);
      return places.then((locations) {
        if (value.first == query) {
          return [Pair(Pair(value.first, ""), value.second)] + locations;
        } else {
          if (locations.isEmpty) return [Pair(Pair(query, ""), value.second)];
          if (locations.first.first.second == value.first) return locations;
          return [Pair(Pair(query, ""), value.second)] + locations;
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
                  child: MapScreen(showMap: true, coordinates: snapshot.data, recentVisited: false, context: context),
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
                            placesIDs.updateFacilities(snapshot.data[index].first.second);
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
                                  key: Key('Edit options menu $i'),
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: Color.fromRGBO(94, 97, 115, 1)
                                  )
                              ),
                            ),
                            Expanded(
                                child: SearchDropdown(
                                  key: Key('dropdown $i'),
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
                          key: Key('save button'),
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
  bool recentVisited = false;

  MapScreen(
      {Key? key,
      required bool showMap,
      List<Pair<Pair<String, String>, LatLng>>? coordinates,
      required BuildContext context,
      required this.recentVisited})
      : super(key: key) {
    if (showMap) {
      cameraPosition = coordinates![0].second;
      markers = buildMarkers(coordinates, context);
    }
  }

  Set<Marker> buildMarkers(List<Pair<Pair<String, String>, LatLng>> coordinates, BuildContext context) {
    Set<Marker> markers_ = {};
    if (!recentVisited) {
      BitmapDescriptor blueMarker =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      BitmapDescriptor redMarker =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      markers_.add(buildMarker(coordinates[0], blueMarker, 2, context));
      for (int i = 1; i < coordinates.length; i++) {
        markers_.add(buildMarker(coordinates[i], redMarker, 1, context));
      }
    } else {
      BitmapDescriptor redMarker = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      for (int i = 0; i < coordinates.length; i++) {
        markers_.add(buildMarker(coordinates[i], redMarker, 1, context));
      }
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
