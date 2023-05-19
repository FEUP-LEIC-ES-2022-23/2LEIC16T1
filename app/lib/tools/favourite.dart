
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/facility.dart';
import '../utils.dart';

Future addFavourite(String facilityID, String userID) async {
  try {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(userID)
        .update({
      'favourites': FieldValue.arrayUnion([FirebaseFirestore.instance.collection('facility').doc(facilityID)])
    });
  } on FirebaseAuthException catch (e) {
    Utils.showErrorBar(e.message);
  }
}

Future removeFavourite(String facilityID, String userID) async {
  try {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(userID)
        .update({
      'favourites': FieldValue.arrayRemove([FirebaseFirestore.instance.collection('facility').doc(facilityID)])
    });
  } on FirebaseAuthException catch (e) {
    Utils.showErrorBar(e.message);
  }
}

Future<bool> isFavourite(String facilityID, String userID) async {
  bool isFavourite = false;
  try {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(userID)
        .get().then((docSnapshot) {
      final data = docSnapshot.data();
      if (data == null || !data.containsKey('favourites')) return false;

      final favourites = data['favourites'] as List<dynamic>;
      final facility = FirebaseFirestore.instance.collection('facility').doc(facilityID);

      isFavourite = favourites.contains(facility);
    });
  } on FirebaseAuthException catch (e) {
    Utils.showErrorBar(e.message);
  }

  return isFavourite;
}

Future<List<Facility>> getFavourites(String userID) async {
  List<Facility> favouriteFacilities = [];
  try {
    await FirebaseFirestore.instance.collection('user').doc(userID).get().then((docSnapshot) async {
      final data = docSnapshot.data();
      if (data == null || !data.containsKey('favourites')) return [];

      final favourites = data['favourites'] as List<dynamic>;
      for (var facility in favourites) {
        final facilityDoc = await facility.get();
        final Facility fac = await Facility.fromJson(facilityDoc.id, facilityDoc.data()!);
        favouriteFacilities.add(fac);
      }
    });
  } on FirebaseAuthException catch (e) {
    Utils.showErrorBar(e.message);
  }

  return favouriteFacilities;
}