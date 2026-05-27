import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {

  Future<bool> _checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever;
  }

  Future<Map<String, dynamic>> getCurrentLocation() async {

    final allowed = await _checkPermission();
    if (!allowed) {
      throw Exception("Location permission denied");
    }

    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> place =
    await placemarkFromCoordinates(pos.latitude, pos.longitude);

    return {
      "lat": pos.latitude,
      "lng": pos.longitude,
      "city": place.first.locality ?? "Unknown",
    };
  }
}