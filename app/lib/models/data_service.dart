import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportspotter/models/facility.dart';

class DataService {
  static Stream<List<Facility>> readFacilities() => FirebaseFirestore.instance
      .collection('facility')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Facility.fromJson(doc.data())).toList().toList());

}