import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sportspotter/firebase_options.dart';
import 'package:sportspotter/tools/rating.dart';
import 'package:sportspotter/utils.dart';
import 'dart:async';


void main() {
  group('Rating', ()
   {
    setUpAll(() {
      Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });
    const testFacilityID = 'testFacilityID';
    const testUserID = 'testUserID';
    const testRating = 5.0;

    test(
        'testing if addRating is working on user collection in database', () async {
      await addRating(testFacilityID, testUserID, testRating);
      try {
        final user = await FirebaseFirestore.instance
            .collection('user')
            .doc(testUserID)
            .collection('ratings')
            .doc(testFacilityID)
            .get();
        expect(user.exists, true);
        expect(user.data()!['facilityID'], testFacilityID);
        expect(user.data()!['rating'], testRating);
      } on FirebaseAuthException catch (e) {
        Utils.showErrorBar(e.message);
      }
    });

    test(
        'testing if addRating is working on facility collection in database', () async {
      await addRating(testFacilityID, testUserID, testRating);
      try {
        final facility = await FirebaseFirestore.instance
            .collection('facility')
            .doc(testFacilityID)
            .collection('ratings')
            .doc(testUserID)
            .get();
        expect(facility.exists, true);
        expect(facility.data()!['userID'], testUserID);
        expect(facility.data()!['rating'], testRating);
      } on FirebaseAuthException catch (e) {
        Utils.showErrorBar(e.message);
      }
    });

    test(
        'testing if remove is working on user collection in database', () async {
      await addRating(testFacilityID, testUserID, testRating);
      await removeRating(testFacilityID, testUserID, testRating);
      try {
        final user = await FirebaseFirestore.instance
            .collection('user')
            .doc(testUserID)
            .collection('ratings')
            .doc(testFacilityID)
            .get();
        expect(user.exists, false);
      } on FirebaseAuthException catch (e) {
        Utils.showErrorBar(e.message);
      }
    });

    test(
        'testing if remove is working on facilty collection in database', () async {
      await addRating(testFacilityID, testUserID, testRating);
      await removeRating(testFacilityID, testUserID, testRating);
      try {
        final facility = await FirebaseFirestore.instance
            .collection('facility')
            .doc(testFacilityID)
            .collection('ratings')
            .doc(testUserID)
            .get();
        expect(facility.exists, false);
      } on FirebaseAuthException catch (e) {
        Utils.showErrorBar(e.message);
      }
    });

    test(
        'testing if get is working for facility', () async {
      await addRating(testFacilityID, testUserID, testRating);
      try {
        final facility = await getFacilityRating(testFacilityID);
        expect(facility, testRating);
      } on FirebaseAuthException catch (e) {
        Utils.showErrorBar(e.message);
      }
    });

    test(
        'testing if get is returning the facility ratings mean', () async {
      await addRating(testFacilityID, testUserID, testRating);
      await addRating(testFacilityID, testUserID, testRating+1);
      await addRating(testFacilityID, testUserID, testRating-1);

      double expectedRating = (testRating + testRating + testRating + 1 - 1) / 3;
      try {
        final facility = await getFacilityRating(testFacilityID);
        expect(facility, expectedRating);
      } on FirebaseAuthException catch (e) {
        Utils.showErrorBar(e.message);
      }
    });

    test(
        'testing if get is working for user rating', () async {
      await addRating(testFacilityID, testUserID, testRating);
      try {
        final user = await getUserRating(testUserID, testFacilityID);
        expect(user, testRating);
      } on FirebaseAuthException catch (e) {
        Utils.showErrorBar(e.message);
      }
    });

   });
}
