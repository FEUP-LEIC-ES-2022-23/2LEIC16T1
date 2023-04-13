import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_webservice_ex/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
    print('No data found for address $address');
    throw ('No data found for address $address');
  }
  final lat = data['results'][0]['geometry']['location']['lat'];
  final lng = data['results'][0]['geometry']['location']['lng'];
  final latLng = LatLng(lat, lng);
  return Pair(address, latLng);
}

Future<List<Pair<String, LatLng>>> buildCoordinates(List<String> addresses) async {

  List<Pair<String, LatLng>> coordinates = [];
  //ask for the coordinates of the addresses
  for(String address in addresses){
    try{
      coordinates.add(await getCoordinates(address));
    }catch(e){
      print(e);
    }
  }

  return coordinates;
}

Marker buildMarker(Pair<String, LatLng> coordinates, BitmapDescriptor icon, double zIndex){
    Marker marker = Marker(
      markerId: MarkerId(coordinates.first),
      position: coordinates.second,
      icon: icon,
      zIndex: zIndex,
      infoWindow: InfoWindow(
        title: coordinates.first,
      ),
    );

  return marker;
}

Future<List<Pair<String, LatLng>>> findPlaces(LatLng source) async {
  final places = GoogleMapsPlaces(apiKey: apiKey);
  final response = await places.searchNearbyWithRadius(
    Location(lat: source.latitude, lng: source.longitude),
    10000,
    type: 'gym',
  );
  List<Pair<String, LatLng>> facilities = [];
  for(PlacesSearchResult place in response.results){
    facilities.add(Pair(place.name, LatLng(place.geometry!.location.lat, place.geometry!.location.lng)));
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
