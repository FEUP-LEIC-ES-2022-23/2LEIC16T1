import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils.dart';

Future addRating(String facilityID, String userID, double rating) async {
  try {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(userID)
        .collection('ratings')
        .doc(facilityID)
        .set({
      'facilityID': facilityID,
      'rating': rating,
    });
    await FirebaseFirestore.instance
        .collection('facilty')
        .doc(facilityID)
        .collection('ratings')
        .doc(userID)
        .set({
      'userID': userID,
      'rating': rating,
    });
  } on FirebaseAuthException catch (e) {
    Utils.showErrorBar(e.message);
  }
}


Future removeRating(String facilityID, String userID, double rating) async {
  try {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(userID)
        .collection('ratings')
        .doc(facilityID)
        .delete();
    await FirebaseFirestore.instance
        .collection('facilty')
        .doc(facilityID)
        .collection('ratings')
        .doc(userID)
        .delete();
  } on FirebaseAuthException catch (e) {
    Utils.showErrorBar(e.message);
  }
}

Future<double?> getFacilityRating(String facilityID) async {
  try {
    final ratings = await FirebaseFirestore.instance
        .collection('facilityID')
        .doc(facilityID)
        .collection('ratings')
        .get();
    double rating = 0;
    double total = 0;
    double count = 0;
    for (var rating in ratings.docs) {
      total += rating.data()['rating'];
      count++;
    }
    rating = total / count;
  } on FirebaseAuthException catch (e) {
    Utils.showErrorBar(e.message);
  }
  return null;
}

Future<double?> getUserRating(String userID, String facilityID) async {
  try {
    final ratings = await FirebaseFirestore.instance
        .collection('user')
        .doc(userID)
        .collection('ratings')
        .where('facilityID', isEqualTo: facilityID)
        .get();
    double rating = 0;
    rating = ratings.docs[0].data()['rating'];
    return rating;
  } on FirebaseAuthException catch (e) {
    Utils.showErrorBar(e.message);
  }
  return null;
}
