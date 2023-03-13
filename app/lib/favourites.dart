import 'package:flutter/material.dart';
import 'navigation.dart';


class FavouritesScreen extends StatelessWidget {
  final String customMapStyle =
      '[ { "featureType": "water", "elementType": "geometry.fill", "stylers": [ { "color": "#0099dd" } ] } ]';

  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Favourites Screen'),
        ),
        body: Stack(
          children: const [
            Positioned(
                bottom: 0,
                left: 0,
                child: NavigationWidget(selectedIndex: 2)
            )
          ],
        )
    );
  }
}