import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

import 'home.dart';

// TODO: Move this key to an external .env file to prevent API theft!
const String googleApiKey = "AIzaSyAHAA9CKUyB0P1WebEUrBPQj-ExwpIgz7k";

class LocationSelectorScreen extends StatefulWidget {
  const LocationSelectorScreen({super.key});

  @override
  State<LocationSelectorScreen> createState() => _LocationSelectorScreenState();
}

class _LocationSelectorScreenState extends State<LocationSelectorScreen> {
  final Completer<GoogleMapController> _mapControllerCompleter = Completer<GoogleMapController>();
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<bool> _isSearchNotEmpty = ValueNotifier<bool>(false);

  LatLng _currentLatLng = const LatLng(28.6139, 77.2090); // Default: New Delhi
  String _city = "New Delhi";
  String _address = "L-72, Block H, Sarojini Nagar, New Delhi";
  bool _isCameraMovingByProgram = false;

  // Design Constants
  static const Color _backgroundColor = Color(0xffF5F5F5);
  static const Color _textGrey = Color(0xff6B7280);

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _isSearchNotEmpty.value = _searchController.text.isNotEmpty;
    });
    _initiateLocationDiscovery();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _isSearchNotEmpty.dispose();
    super.dispose();
  }

  Future<void> _initiateLocationDiscovery() async {
    try {
      final position = await _determinePosition();
      _updateCameraAndAddress(LatLng(position.latitude, position.longitude));
    } catch (e) {
      _showSnackBar("Location error: ${e.toString()}");
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> _updateCameraAndAddress(LatLng targetLocation) async {
    _isCameraMovingByProgram = true;
    _currentLatLng = targetLocation;

    final GoogleMapController controller = await _mapControllerCompleter.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentLatLng, zoom: 16.5),
      ),
    );

    await _fetchGeocodedAddress(_currentLatLng.latitude, _currentLatLng.longitude);
    _isCameraMovingByProgram = false;
  }

  Future<void> _fetchGeocodedAddress(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        setState(() {
          _city = place.locality ?? "Unknown";
          _address = [
            if (place.street != null && place.street!.isNotEmpty) place.street,
            if (place.subLocality != null && place.subLocality!.isNotEmpty) place.subLocality,
            if (place.locality != null && place.locality!.isNotEmpty) place.locality,
          ].join(', ');
        });
      }
    } catch (e) {
      debugPrint("Geocoding failed: $e");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Stack(
        children: [
          /// MAP LAYER
          Positioned.fill(
            child: GoogleMap(
              mapToolbarEnabled: false,
              initialCameraPosition: CameraPosition(target: _currentLatLng, zoom: 15),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              compassEnabled: false,
              buildingsEnabled: true,
              onMapCreated: (controller) {
                if (!_mapControllerCompleter.isCompleted) {
                  _mapControllerCompleter.complete(controller);
                }
              },
              onCameraMove: (position) {
                if (!_isCameraMovingByProgram) {
                  _currentLatLng = position.target;
                }
              },
              onCameraIdle: () {
                if (!_isCameraMovingByProgram) {
                  _fetchGeocodedAddress(_currentLatLng.latitude, _currentLatLng.longitude);
                }
              },
            ),
          ),

          /// MAP DARK OVERLAY
          Positioned.fill(
            child: IgnorePointer(
              child: Container(color: Colors.black.withOpacity(0.40)),
            ),
          ),

          /// AUTOCOMPLETE SEARCH BAR
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Container(
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.06),
                      blurRadius: 18,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: GooglePlaceAutoCompleteTextField(
                  textEditingController: _searchController,
                  googleAPIKey: googleApiKey,
                  debounceTime: 400,
                  countries: const ["in"],
                  isLatLngRequired: true,
                  boxDecoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -.2,
                    color: Colors.black,
                  ),
                  inputDecoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search your street",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade500,
                      letterSpacing: -.2,
                    ),
                    prefixIcon: const Icon(Icons.search_rounded, size: 22, color: Colors.black87),
                    suffixIcon: ValueListenableBuilder<bool>(
                      valueListenable: _isSearchNotEmpty,
                      builder: (context, isNotEmpty, _) {
                        return isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.close_rounded, size: 20, color: Colors.black54),
                          onPressed: () => _searchController.clear(),
                        )
                            : const SizedBox.shrink();
                      },
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  getPlaceDetailWithLatLng: (prediction) {
                    if (prediction.lat != null && prediction.lng != null) {
                      _updateCameraAndAddress(
                        LatLng(double.parse(prediction.lat!), double.parse(prediction.lng!)),
                      );
                    }
                  },
                  itemClick: (prediction) {
                    _searchController.text = prediction.description ?? "";
                    _searchController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _searchController.text.length),
                    );
                    FocusScope.of(context).unfocus();
                  },
                  itemBuilder: (context, index, prediction) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Container(
                            height: 34,
                            width: 34,
                            decoration: BoxDecoration(
                              color: _backgroundColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.location_on_outlined, size: 18, color: Colors.black87),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              prediction.description ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: -.2),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  seperatedBuilder: Divider(height: 1, color: Colors.grey.shade200),
                  containerHorizontalPadding: 0,
                  isCrossBtnShown: false,
                ),
              ),
            ),
          ),

          /// PIN DROP CENTER MARKER
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    "You are here",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: -.2),
                  ),
                ),
                CustomPaint(
                  size: const Size(18, 10),
                  painter: TrianglePainter(),
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                      child: Center(
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                        ),
                      ),
                    ),
                    Container(width: 4, height: 55, color: Colors.black),
                    Container(
                      width: 42,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// TARGET GPS BUTTON
          Positioned(
            bottom: 290,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton.extended(
                onPressed: _initiateLocationDiscovery,
                backgroundColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                label: Row(
                  children: const [
                    Icon(Icons.my_location, size: 20, color: Colors.black),
                    SizedBox(width: 12),
                    Text(
                      "Use my current location",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -.2,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// METRICS & INFORMATION BOTTOM SHEET
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              decoration: const BoxDecoration(
                color: _backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(34),
                  topRight: Radius.circular(34),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Select your location",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: -.2),
                        ),
                        Text(
                          "Change",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: -.2),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.black.withOpacity(0.08)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: const BoxDecoration(
                              color: Color(0xffF1F1F1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.location_on, size: 22, color: Colors.black),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _city,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: -.2),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _address,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w400,
                                    color: _textGrey,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    ElevatedButton(
                      onPressed: () {

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HomeScreen(
                              location: _address,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff222222), // Active color alternative to static grey
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 62),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Confirm Location",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: -.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}