import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sportspotter/models/review.dart';
import 'package:sportspotter/models/tag.dart';

class Facility {
  final String name;
  final Future<String> photo;
  final String phoneNumber;
  final String email;
  final String address;

  //final List<Tag> tags;

  //final List<Review> reviews;
  //final List<double> ratings;

  Facility({
    required this.name,
    required this.photo,
    required this.phoneNumber,
    required this.email,
    required this.address,
    //required this.tags,
    //required this.reviews,
    //required this.ratings,
  });

  static Facility fromJson(Map<String, dynamic> json){
    //do this or just store in firebase as reference 'facility/facility_name.jpg'
    //and use .ref() instead of .refFromURL()
    final photoRef = FirebaseStorage.instance.refFromURL('gs:/' + json['photo'].path.substring('gs:'.length));
    return Facility(
        name: json['name'],
        photo: photoRef.getDownloadURL().then((url) => url),
        phoneNumber: json['phoneNumber'],
        email: json['email'],
        address: json['address'],
        //tags: jsonDecode(json['tags']),
        //reviews: json['reviews'],
        //ratings: json['ratings']
    );
  }
}