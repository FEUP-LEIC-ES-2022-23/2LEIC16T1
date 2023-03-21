import 'package:sportspotter/models/review.dart';
import 'package:sportspotter/models/tag.dart';

class Facility {
  final String name;
  final String image;
  final String phoneNumber;
  final String email;
  final String address;

  final List<Tag> tags;

  final List<Review> reviews;
  final List<double> ratings;

  Facility({
    required this.name,
    required this.image,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.tags,
    required this.reviews,
    required this.ratings,
  });


  Map<String, dynamic> toJson() => {
    'name': name,
    'image': image,
    'phoneNumber': phoneNumber,
    'email': email,
    'address': address,
    'tags': tags,
    'reviews': reviews,
    'ratings': ratings
  };

  static Facility fromJson(Map<String, dynamic> json) => Facility(
      name: json['name'],
      image: json['image'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      address: json['address'],
      tags: json['tags'],
      reviews: json['reviews'],
      ratings: json['ratings']
  );
}