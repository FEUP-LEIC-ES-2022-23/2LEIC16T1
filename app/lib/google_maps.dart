import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Map<String, double>>> getCoordinates(List<String> addresses) async {
  const apiKey = 'AIzaSyAJTKPI8KJ_ulnXi-EuQN_5yrJbn5-cHP8';
  List<Map<String, double>> coordinates = [];

  for(String address in addresses){
    address = address.replaceAll(' ', '+');
  }
  //ask for the coordinates of the addresses
  for(String address in addresses){
    final apiUrl = 'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));
    final data = json.decode(response.body);
    if(data['results'].length == 0){
      print('No data found for address $address');
      continue;
    }
    final lat = data['results'][0]['geometry']['location']['lat'];
    final lng = data['results'][0]['geometry']['location']['lng'];

    coordinates.add({'lat': lat, 'lng': lng});

  }

  return coordinates;
}
