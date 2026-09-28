import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationHelper {
  /// Returns a map with city and country using GPS
  static Future<Map<String, String>> getCurrentCityAndCountry() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return {'city': 'Location Off', 'country': ''};
      }

      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return {'city': 'Unknown', 'country': ''};
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return {'city': 'Unknown', 'country': ''};
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Get placemark info
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return {
          'city': place.locality ?? 'Unknown',
          'country': place.country ?? ''
        };
      } else {
        return {'city': 'Unknown', 'country': ''};
      }
    } catch (e) {
      print("Error getting location: $e");
      return {'city': 'Error', 'country': ''};
    }
  }
}
