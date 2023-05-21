import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sportspotter/tools/favourite.dart';
import 'package:sportspotter/widgets/facility_preview.dart';
import 'models/facility.dart';
import 'navigation.dart';


class FavouritesScreen extends StatelessWidget {

  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final loggedIn = (user != null);
    List<Facility> favouriteFacilities = [];

    return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            const Positioned(
              top: 45,
              left: 30,
              child: Text('Favourite Places',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(124, 124, 124, 1),
                    fontFamily: 'Inter',
                    fontSize: 25,
                    letterSpacing: 0,
                    fontWeight: FontWeight.bold,
                    height: 1
                ),
              ),
            ),
            if (loggedIn)
              Positioned(
                top: 70,
                bottom: 0,
                left: 0,
                right: 0,
                child: FutureBuilder(
                  key: Key("favorites-list"),
                  future: getFavourites(user.uid),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: const CircularProgressIndicator()); // Show a loading indicator
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Wrap(children: const [Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "You don't have any favourite facilities yet",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      )]));
                    } else {
                      final favouriteFacilities = snapshot.data!;
                      return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: favouriteFacilities.length,
                          itemBuilder: (BuildContext context, int index) {
                            return FacilityPreview(
                                facility: favouriteFacilities[index]);
                          });
                    }
                  }
                ),
              )
            else Center(child: Wrap(children: const [Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Log in to check your favourite facilities",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            )])),
            const Positioned(
                bottom: 0,
                left: 0,
                child: NavigationWidget(selectedIndex: 2)
            )
          ],
        )
    );
  }
}