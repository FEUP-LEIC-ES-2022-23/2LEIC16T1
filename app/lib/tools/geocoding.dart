import 'package:geocoding/geocoding.dart';

Future<String?> getAddressFromCoordinates(double latitude, double longitude) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks[0];
      String address = '${placemark.street}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}';
      return address;
    }
  } catch (e) {
    print('Error: $e');
  }
}