import 'package:flutter/material.dart';
import 'navigation.dart';


class FavouritesScreen extends StatelessWidget {

  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Favourites'),
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