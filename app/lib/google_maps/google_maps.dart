import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_webservice_ex/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sportspotter/search_page.dart';

import '../facility_page.dart';
import '../models/data_service.dart';

const apiKey = "AIzaSyAJTKPI8KJ_ulnXi-EuQN_5yrJbn5-cHP8";

class Pair<A, B> {
  final A first;
  final B second;

  Pair(this.first, this.second);

  @override
  String toString() => '($first, $second)';
}

Future<Pair<String, LatLng>> getCoordinates(String address) async {
  final apiUrl = 'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKey';

  final response = await http.get(Uri.parse(apiUrl));
  final data = json.decode(response.body);

  if(data['results'].length == 0){
    throw ('No data found for address $address');
  }
  final lat = data['results'][0]['geometry']['location']['lat'];
  final lng = data['results'][0]['geometry']['location']['lng'];
  final latLng = LatLng(lat, lng);

  if (data['results'][0]['geometry']['location_type'] == 'ROOFTOP'){
    address = data['results'][0]['place_id'];
  }

  return Pair(address, latLng);
}

Marker buildMarker(Pair<Pair<String, String>, LatLng> coordinates, BitmapDescriptor icon, double zIndex, BuildContext context){
    Marker marker = Marker(
      markerId: MarkerId(coordinates.first.second),
      position: coordinates.second,
      icon: icon,
      zIndex: zIndex,
      infoWindow: InfoWindow(
        title: coordinates.first.first,
        onTap: () {
          if (coordinates.first.second == "") return;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            },
          );

          DataService.fetchFacility(coordinates.first.second).then((selectedFacility){
            placesIDs.updateFacilities(selectedFacility.id);
            Navigator.of(context).pop();
            Navigator.push(context, PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => FacilityPage(facility: selectedFacility),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero
            ));
          });
        }
      ),
    );

  return marker;
}

Future<List<Pair<Pair<String, String>, LatLng>>> findPlaces(Pair<String,LatLng> source, int radius, List<String> filter) async {
  if (filter.every((element) => element == '')) return findPlacesWithoutFilters(source, radius);

  final places = GoogleMapsPlaces(apiKey: apiKey);
  final response = await places.searchNearbyWithRadius(
    Location(lat: source.second.latitude, lng: source.second.longitude),
    radius,
    type: 'gym',
  );

  List<Pair<Pair<Pair<String, String>, LatLng>, int>> facilitiesWithWeight = [];
  for(PlacesSearchResult place in response.results) {
    List<String> tags = await DataService().fetchFacilityTags(place.placeId);
    if (!tags.contains(filter[0])) continue; // this filter is mandatory
    int weight = 0;
    for (int i = 1; i < filter.length; i++) {
      if (tags.contains(filter[i])) weight++;
    }

    if (place.placeId == source.first) {
      facilitiesWithWeight.insert(0, Pair(Pair(Pair(place.name, place.placeId),
          LatLng(place.geometry!.location.lat, place.geometry!.location.lng)),
          weight));
    } else {
      facilitiesWithWeight.add(Pair(Pair(Pair(place.name, place.placeId),
          LatLng(place.geometry!.location.lat, place.geometry!.location.lng)),
          weight));
    }
  }

  facilitiesWithWeight.sort((a, b) => b.second.compareTo(a.second)); // sort according to the weight of the facility
  List<Pair<Pair<String, String>, LatLng>> facilities = [];
  for (Pair<Pair<Pair<String, String>, LatLng>, int> p in facilitiesWithWeight) {
    facilities.add(p.first);
  }

  return facilities;
}

Future<List<Pair<Pair<String, String>, LatLng>>> findPlacesWithoutFilters(Pair<String,LatLng> source, int radius) async {
  final places = GoogleMapsPlaces(apiKey: apiKey);
  final response = await places.searchNearbyWithRadius(
    Location(lat: source.second.latitude, lng: source.second.longitude),
    radius,
    type: 'gym',
  );
  List<Pair<Pair<String, String>, LatLng>> facilities = [];
  for(PlacesSearchResult place in response.results) {
    if (place.placeId == source.first){
      facilities.insert(0, Pair(Pair(place.name, place.placeId),
          LatLng(place.geometry!.location.lat, place.geometry!.location.lng)));
    } else {
      facilities.add(Pair(Pair(place.name, place.placeId),
          LatLng(place.geometry!.location.lat, place.geometry!.location.lng)));
    }
  }
  return facilities;
}

Future<bool> _handleLocationPermission(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Location services are disabled. Please enable the services')));
    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')));
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Location permissions are permanently denied, we cannot request permissions.')));
    return false;
  }
  return true;
}
