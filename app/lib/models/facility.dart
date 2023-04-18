import 'dart:convert';

import 'package:sportspotter/models/data_service.dart';
import 'package:sportspotter/models/tag.dart';
import 'package:http/http.dart' as http;

class Facility {
  final String id;
  final String name;
  final String photo;
  final String phoneNumber;
  final String address;

  final List<Tag> tags;

  //final List<Review> reviews;
  //final List<double> ratings;

  Facility({
    required this.id,
    required this.name,
    required this.photo,
    required this.phoneNumber,
    required this.address,
    required this.tags,
    //required this.reviews,
    //required this.ratings,
  });

  static Future<Facility> fromJson(String id, Map<String, dynamic> json) async {
    final apiUrl = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$id&key=${DataService.apiKey}';

    final response = await http.get(Uri.parse(apiUrl));
    final data = jsonDecode(response.body);

    String name;
    try {
      name = data['result']['name'];
    } catch(e) {
      name = id;
    }

    String photo;
    try {
      photo = "https://maps.googleapis.com/maps/api/place/photo?maxheight=200&photo_reference=${data['result']['photos'][0]['photo_reference']}&key=${DataService.apiKey}";
    } catch(e) {
      photo = "";
    }

    String phoneNumber;
    try {
      phoneNumber = data['result']['international_phone_number'];
    } catch(e){
      try {
        phoneNumber = data['result']['formatted_phone_number'];
      } catch(e){
        phoneNumber = "";
      }
    }

    String address;
    try {
      address = data['result']['vicinity'];
    } catch(e) {
      try {
        address = data['result']['formatted_address'];
      } catch(e){
        address = "";
      }
    }

    List<Tag> tags = [];
    for (var reference in json['tags']){
      final snapshot = await reference.get();
      tags.add(Tag.fromJson(snapshot.id, snapshot.data() as Map<String, dynamic>));
    }

    return Facility(
        id: id,
        name: name,
        photo: photo,
        phoneNumber: phoneNumber,
        address: address,
        tags: tags
        //reviews: json['reviews'],
        //ratings: json['ratings']
    );
  }
}