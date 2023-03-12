import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sportspotter/navigation.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SportSpotter',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Stack(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MapScreen(showMap: true),
                  ),
                );
              },
              child: const Text('Show Map'),
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              child: NavigationWidget()
          )
        ],
      )
    );
  }
}

class MapScreen extends StatelessWidget {
  final String customMapStyle =
      '[ { "featureType": "water", "elementType": "geometry.fill", "stylers": [ { "color": "#0099dd" } ] } ]';

  const MapScreen({Key? key, required bool showMap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Screen'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: const CameraPosition(
          target: LatLng(41.179722, -8.616389),
          zoom: 12,
        ),
        markers: <Marker>{
          const Marker(
            markerId: MarkerId('marker_1'),
            position: LatLng(41.179722, -8.616389),
            infoWindow: InfoWindow(
              title: 'Paranhos',
              snippet: 'Welcome to Paranhos',
            ),
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          // Set the custom map style here
          controller.setMapStyle(customMapStyle);
        },
      ),
    );
  }
}
