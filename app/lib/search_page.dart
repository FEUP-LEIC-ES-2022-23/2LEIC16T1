import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sportspotter/models/facility.dart';
import 'package:sportspotter/models/local_storage.dart';
import 'package:sportspotter/navigation.dart';
import 'package:sportspotter/google_maps/google_maps.dart';
import 'package:sportspotter/tools/location.dart';
import 'package:sportspotter/tools/geocoding.dart';
import 'package:sportspotter/widgets/facility_preview.dart';
import 'package:sportspotter/widgets/search_dropdown.dart';

import 'facility_page.dart';
import 'models/data_service.dart';

class SearchScreen extends StatefulWidget {
  final String customMapStyle =
      '[ { "featureType": "water", "elementType": "geometry.fill", "stylers": [ { "color": "#0099dd" } ] } ]';

  static const String test = 'R. Dr. Roberto Frias, 4200-465 Porto';
  final String sportTag;
  const SearchScreen({Key? key, required this.sportTag}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

VisitedPlaces placesIDs = VisitedPlaces(
    facilities: List.generate(VisitedPlaces.MAX_PLACES, (index) => ""));

class _SearchScreenState extends State<SearchScreen> {
  bool _initState = true;

  @override
  void initState() {
    super.initState();
    if (_initState) {
      _initState = false;
      final sportTag = widget.sportTag;
      final searchDelegate = CustomSearch(widget.sportTag);
      if (sportTag.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showSearch(
            context: context,
            delegate: searchDelegate,
          );
          searchDelegate.query = 'Porto';
          searchDelegate.showResults(context);
        });
      }
    }
  }

  Future<List<Facility>> _fetchPlaces() async {
    await placesIDs.fetchFacilities();
    List<Facility> places = [];
    if (placesIDs.facilities.isNotEmpty) {
      for (String item in placesIDs.facilities) {
        if (item != "") {
          var facility = await DataService.fetchFacility(item);
          places.add(facility);
        }
      }
    }
    return places;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
          shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30))),
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: const Icon(Icons.search),
              color: const Color.fromRGBO(94, 97, 115, 1),
              onPressed: () {
                showSearch(context: context, delegate: CustomSearch(''))
                    .then((_) => setState(() {}));
              }),
          title: GestureDetector(
            key: const Key("search bar"),
            onTap: () {
              showSearch(
                context: context,
                delegate: CustomSearch(''),
              ).then((_) => setState(() {}));
            },
            child: const Text('Enter a location',
                style: TextStyle(color: Color.fromRGBO(94, 97, 115, 1))),
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            const Positioned(
              top: 30,
              left: 30,
              child: Text(
                'Past Visited Places',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(124, 124, 124, 1),
                    fontFamily: 'Inter',
                    fontSize: 25,
                    letterSpacing: 0,
                    fontWeight: FontWeight.bold,
                    height: 1),
              ),
            ),
            Positioned(
              top: 80,
              bottom: 0,
              left: 0,
              right: 0,
              child: FutureBuilder(
                  future: _fetchPlaces(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: Wrap(children: const [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "You can see the facilities you have visited here",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        )
                      ]));
                    } else {
                      var pastPlaces = snapshot.data!;
                      return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: pastPlaces.length,
                          itemBuilder: (BuildContext context, int index) {
                            return FacilityPreview(
                              facility: pastPlaces[index],
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        pageBuilder: (context, animation1,
                                                animation2) =>
                                            FacilityPage(
                                                facility: pastPlaces[index]),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration:
                                            Duration.zero));
                              },
                            );
                          });
                    }
                  }),
            ),
          ],
        ),
        bottomNavigationBar: const NavigationWidget(selectedIndex: 1));
  }
}

class CustomSearch extends SearchDelegate {
  String sportTag;
  CustomSearch(this.sportTag);

  List<String> data = [];
  List<String> filters = List<String>.filled(5, '');
  double radius = 10;

  Future<void> getSelfCoordinates() async {
    LocationData? locationData = await getLocation(Location());
    if (locationData != null) {
      String? address = await getAddressFromCoordinates(
          locationData.latitude!, locationData.longitude!);
      if (address == null) {
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
          key: const Key('filter-icon'),
          onPressed: () {
            editSearchSettings(context);
          },
          icon: const Icon(Icons.filter_alt)),
      TextButton(
        onPressed: () {
          showResults(context);
        },
        child: IconButton(
            key: const Key('search-icon'), // set the key property
            icon: const Icon(Icons.search),
            onPressed: () {
              showResults(context);
            }),
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
        if (index == 0) {
          // The first item is the button
          return ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Get Location'),
            onTap: () async {
              await getSelfCoordinates();
            },
          );
        } else {
          // The rest of the items are the suggestions
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
    final coordinates = getCoordinates(query).then((value) {
      if (filters[0] == '' && sportTag != '') {
        filters[0] = sportTag;
        radius = 50;
        sportTag = '';
      }
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
                  key: const Key("results-map"),
                  child: MapScreen(
                      showMap: true,
                      coordinates: snapshot.data,
                      recentVisited: false,
                      context: context),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Container();
                      }

                      var listTile = ListTile(
                          key: const Key("results-list"),
                          title: Text(snapshot.data[index].first.first),
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.white),
                                );
                              },
                            );
                            placesIDs.updateFacilities(
                                snapshot.data[index].first.second);
                            DataService.fetchFacility(
                                    snapshot.data[index].first.second)
                                .then((selectedFacility) {
                              Navigator.of(context).pop();
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      pageBuilder:
                                          (context, animation1, animation2) =>
                                              FacilityPage(
                                                  facility: selectedFacility),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration:
                                          Duration.zero));
                            });
                          });
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
          return StatefulBuilder(builder: (context, state) {
            return AlertDialog(
                contentPadding: const EdgeInsets.only(top: 10.0),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
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
                            color: Color.fromRGBO(94, 97, 115, 1)),
                      )),
                      for (int i = 1; i <= 5; i++)
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 20, top: 30, bottom: 20),
                              child: Text('Tag #$i',
                                  key: Key('Edit options menu $i'),
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: Color.fromRGBO(94, 97, 115, 1))),
                            ),
                            Expanded(
                                child: SearchDropdown(
                              key: Key('dropdown $i'),
                              selectedItem: filters[i - 1],
                              items: DataService.availableTags,
                              onChanged: (item) {
                                filters[i - 1] = item;
                              },
                            )),
                          ],
                        ),
                      Row(children: [
                        const Text("5"),
                        Expanded(
                          child: Slider(
                            value: radius,
                            divisions: 9,
                            min: 5,
                            max: 50,
                            label: "${(radius.round()).toString()} km",
                            onChanged: (value) {
                              state(() {
                                radius = value;
                              });
                            },
                          ),
                        ),
                        const Text("50")
                      ]),
                      const Center(
                        child: Text(
                          "Search radius (km)",
                          style: TextStyle(
                              fontSize: 17,
                              color: Color.fromRGBO(94, 97, 115, 1)),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        key: const Key('save button'),
                        child: const Text(
                          "Save",
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ));
          });
        });
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

  Set<Marker> buildMarkers(List<Pair<Pair<String, String>, LatLng>> coordinates,
      BuildContext context) {
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
      BitmapDescriptor redMarker =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
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
