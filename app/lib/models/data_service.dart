import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:sportspotter/models/facility.dart';

class DataService {
  static const apiKey = "AIzaSyAJTKPI8KJ_ulnXi-EuQN_5yrJbn5-cHP8";

  static Stream<List<Future<Facility>>> readFacilities() => FirebaseFirestore.instance
      .collection('facility')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Facility.fromJson(doc.id, doc.data())).toList().toList());

  static Future<Facility> fetchFacility(String id) => FirebaseFirestore.instance
      .collection('facility')
      .doc(id).get().then((doc){
        if (!doc.exists) {
          final json = {
            'tags' : []
          };

          doc.reference.set(json);

          return Facility.fromJson(id, json);
        } else {
          return Facility.fromJson(id, doc.data()!);
        }
      });
  
  static Future<List<String>> getTags() => FirebaseFirestore.instance
      .collection('tag').get()
      .then((snapshot) => snapshot.docs.map((doc) => doc.id).toList());

}