import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<String> getCurrentLocationText() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'Location services disabled';
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      return 'Location permission denied';
    }

    if (permission == LocationPermission.deniedForever) {
      return 'Location permission permanently denied';
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return 'Lat: ${position.latitude.toStringAsFixed(5)}, '
        'Lng: ${position.longitude.toStringAsFixed(5)}';
  }
}
