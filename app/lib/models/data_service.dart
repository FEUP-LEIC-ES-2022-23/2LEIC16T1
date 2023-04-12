import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportspotter/models/facility.dart';

class DataService {
  static const apiKey = "AIzaSyAJTKPI8KJ_ulnXi-EuQN_5yrJbn5-cHP8";

  static Stream<List<Future<Facility>>> readFacilities() => FirebaseFirestore.instance
      .collection('facility')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Facility.fromJson(doc.id, doc.data())).toList().toList());

}