import 'package:flutter/material.dart';

import 'navigation.dart';

class ProfileScreen extends StatelessWidget {
  final String customMapStyle =
      '[ { "featureType": "water", "elementType": "geometry.fill", "stylers": [ { "color": "#0099dd" } ] } ]';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Profile Screen'),
        ),
        body: Stack(
          children: const [
            Positioned(
                bottom: 0,
                left: 0,
                child: NavigationWidget(selectedIndex: 3)
            )
          ],
        )
    );
  }
}