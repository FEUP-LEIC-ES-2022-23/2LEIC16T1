import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportspotter/models/facility.dart';
import 'package:sportspotter/models/tag.dart';

class DataService {
  static const apiKey = "AIzaSyAJTKPI8KJ_ulnXi-EuQN_5yrJbn5-cHP8";

  static late final List<String> availableTags;

  static Stream<List<Future<Facility>>> readFacilities() =>
      FirebaseFirestore.instance.collection('facility').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Facility.fromJson(doc.id, doc.data()))
              .toList()
              .toList());

  static Future<Facility> fetchFacility(String id) => FirebaseFirestore.instance
          .collection('facility')
          .doc(id)
          .get()
          .then((doc) {
        if (!doc.exists) {
          final json = {'tags': []};

          doc.reference.set(json);

          return Facility.fromJson(id, json);
        } else {
          return Facility.fromJson(id, doc.data()!);
        }
      });

  Future<List<String>> fetchFacilityTags(String id) => FirebaseFirestore.instance
      .collection('facility')
      .doc(id).get().then((doc) async {
    if (!doc.exists) {
      return [];
    } else {
      List<String> tags = [];
      for (var reference in doc.data()!['tags']){
        final snapshot = await reference.get();
        tags.add(snapshot.id);
      }
      return tags;
    }
  });
  
  static getTags() async => availableTags = await FirebaseFirestore.instance
      .collection('tag')
      .get()
      .then((snapshot) => snapshot.docs.map((doc) => doc.id).toList());

  static Future<bool> isDuplicateUsername(String? username) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('user')
        .where('username', isEqualTo: username)
        .get();
    return query.docs.isNotEmpty;
  }
}
