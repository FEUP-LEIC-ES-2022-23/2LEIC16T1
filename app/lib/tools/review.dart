import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils.dart';

Future addReview(String facilityID, String userID, String review) async {

  int seconds = DateTime.now().second;
  int minutes = DateTime.now().minute;
  int hours = DateTime.now().hour;
  int day = DateTime.now().day;
  int month = DateTime.now().month;
  int year = DateTime.now().year;

  String date = '$year-$month-$day $hours:$minutes:$seconds';

  try {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(userID)
        .collection('reviews')
        .doc(facilityID)
        .set({
      'facilityID': facilityID,
      'review': review,
      'date': date,
    });
    await FirebaseFirestore.instance
        .collection('facility')
        .doc(facilityID)
        .collection('reviews')
        .doc(userID)
        .set({
      'userID': userID,
      'review': review,
      'date': date,
    });
  } on FirebaseAuthException catch (e) {
    Utils.showErrorBar(e.message);
  }
}

Future removeReview(String facilityID, String userID) async {
  try {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(userID)
        .collection('reviews')
        .doc(facilityID)
        .delete();
    await FirebaseFirestore.instance
        .collection('facilty')
        .doc(facilityID)
        .collection('reviews')
        .doc(userID)
        .delete();
  } on FirebaseAuthException catch (e) {
    Utils.showErrorBar(e.message);
  }
}

class ReviewData {
  String facilityID;
  String userID;
  String review;
  String date;

  ReviewData({ required this.facilityID, required this.userID, required this.review, required this.date});

  ReviewData.fromMap(Map<String, dynamic> data)
      : facilityID = data['facilityID'],
        userID = data['userID'],
        review = data['review'],
        date = data['date'];

  Map<String, dynamic> toMap() => {
        'facilityID': facilityID,
        'userID': userID,
        'review': review,
        'date': date,
      };
}

Future<List<QueryDocumentSnapshot>> getFacilityReviews(String facilityID) async {
  try {
    final reviews = await FirebaseFirestore.instance
        .collection('facility')
        .doc(facilityID)
        .collection('reviews')
        .get();
    return reviews.docs;
  } on FirebaseAuthException catch (e) {
    Utils.showErrorBar(e.message);
    return [];
  }
}