import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportspotter/tools/favourite.dart';
import 'package:sportspotter/widgets/facility_preview.dart';
import 'facility_page.dart';
import 'navigation.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final loggedIn = (user != null);

    return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            const Positioned(
              top: 45,
              left: 30,
              child: Text(
                'Favourite Places',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(124, 124, 124, 1),
                    fontFamily: 'Inter',
                    fontSize: 25,
                    letterSpacing: 0,
                    fontWeight: FontWeight.bold,
                    height: 1),
              ),
            ),
            if (loggedIn)
              Positioned(
                top: 70,
                bottom: 0,
                left: 0,
                right: 0,
                child: FutureBuilder(
                    key: const Key("favorites-list"),
                    future: getFavourites(user.uid),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                            child: Wrap(children: const [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "You don't have any favourite facilities yet",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          )
                        ]));
                      } else {
                        var favouriteFacilities = snapshot.data!;
                        return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: favouriteFacilities.length,
                            itemBuilder: (BuildContext context, int index) {
                              return FacilityPreview(
                                facility: favouriteFacilities[index],
                                onTap: () {
                                  Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                              pageBuilder: (context, animation1,
                                                      animation2) =>
                                                  FacilityPage(
                                                      facility:
                                                          favouriteFacilities[
                                                              index]),
                                              transitionDuration: Duration.zero,
                                              reverseTransitionDuration:
                                                  Duration.zero))
                                      .then((_) => setState(() {}));
                                },
                              );
                            });
                      }
                    }),
              )
            else
              Center(
                  child: Wrap(children: const [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Log in to check your favourite facilities",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                )
              ])),
          ],
        ),
        bottomNavigationBar: const NavigationWidget(selectedIndex: 2));
  }
}
