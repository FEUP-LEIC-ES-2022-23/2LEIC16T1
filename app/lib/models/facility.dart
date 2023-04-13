import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportspotter/models/data_service.dart';
import 'package:sportspotter/models/tag.dart';
import 'package:http/http.dart' as http;

class Facility {
  final String name;
  final String photo;
  final String phoneNumber;
  final String address;

  final List<Tag> tags;

  //final List<Review> reviews;
  //final List<double> ratings;

  Facility({
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

    List<Tag> tags = [];
    for (var reference in json['tags']){
      reference.get().then(
          (DocumentSnapshot snapshot) =>
              tags.add(Tag.fromJson(snapshot.data() as Map<String, dynamic>))
      );
    }

    return Facility(
        name: data['result']['name'],
        photo: "https://maps.googleapis.com/maps/api/place/photo?maxheight=200&photo_reference=${data['result']['photos'][0]['photo_reference']}&key=${DataService.apiKey}",
        phoneNumber: data['result']['international_phone_number'],
        address: data['result']['vicinity'],
        tags: tags
        //reviews: json['reviews'],
        //ratings: json['ratings']
    );
  }
}