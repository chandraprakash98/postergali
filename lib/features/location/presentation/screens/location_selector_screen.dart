import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../home/presentation/screens/home_screen.dart';

const String googleApiKey = "AIzaSyAHAA9CKUyB0P1WebEUrBPQj-ExwpIgz7k";

class LocationSelectorScreen extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;
  const LocationSelectorScreen({super.key, this.initialLat, this.initialLng});

  @override
  State<LocationSelectorScreen> createState() => _LocationSelectorScreenState();
}

class _LocationSelectorScreenState extends State<LocationSelectorScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  final Completer<GoogleMapController> _mapController = Completer();
  Timer? _debounce;

  late LatLng _currentLatLng;
  String _city = "Loading...";
  String _address = "Fetching address...";
  bool _isLoadingLocation = false;
  bool _isMovingBySearch = false;
  List<Map<String, dynamic>> _savedLocations = [];

  static const String _mapStyle = '''
[
  {
    "featureType": "poi",
    "stylers": [
      { "visibility": "off" }
    ]
  }
]
''';

  @override
  void initState() {
    super.initState();
    _currentLatLng = LatLng(
      widget.initialLat ?? 28.6139,
      widget.initialLng ?? 77.2090,
    );
    _loadSavedLocations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialLat != null && widget.initialLng != null) {
        _moveToLocation(lat: widget.initialLat!, lng: widget.initialLng!);
      } else {
        _getCurrentLocation();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadSavedLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList("saved_locations") ?? [];
    setState(() {
      _savedLocations = data
          .map((e) => Map<String, dynamic>.from(jsonDecode(e)))
          .toList();
    });
  }

  Future<void> _saveLocation() async {
    final prefs = await SharedPreferences.getInstance();
    _savedLocations.removeWhere((e) => e["address"] == _address);
    _savedLocations.insert(0, {
      "city": _city,
      "address": _address,
      "lat": _currentLatLng.latitude,
      "lng": _currentLatLng.longitude,
    });
    if (_savedLocations.length > 6) {
      _savedLocations = _savedLocations.take(6).toList();
    }
    await prefs.setStringList(
      "saved_locations",
      _savedLocations.map((e) => jsonEncode(e)).toList(),
    );
    setState(() {});
  }

  Future<void> _getCurrentLocation() async {
    if (_isLoadingLocation) return;
    _isLoadingLocation = true;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnackBar("Please enable location");
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showSnackBar("Location permission denied");
        return;
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      await _moveToLocation(lat: position.latitude, lng: position.longitude);
    } catch (e) {
      _showSnackBar("Unable to fetch location");
    }
    _isLoadingLocation = false;
  }

  Future<void> _fetchAddress(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _city = place.locality ?? place.subAdministrativeArea ?? "Unknown";
          _address = [place.street, place.subLocality, place.locality]
              .where((e) => e != null && e.isNotEmpty)
              .join(", ");
        });
      }
    } catch (_) {}
  }

  Future<void> _moveToLocation({required double lat, required double lng}) async {
    _isMovingBySearch = true;
    setState(() {
      _currentLatLng = LatLng(lat, lng);
    });
    final controller = await _mapController.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 17.5),
      ),
    );
    await _fetchAddress(lat, lng);
    await _saveLocation();
    _isMovingBySearch = false;
    setState(() {});
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: _currentLatLng, zoom: 15),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
              rotateGesturesEnabled: false,
              tiltGesturesEnabled: false,
              onMapCreated: (controller) async {
                controller.setMapStyle(_mapStyle);
                if (!_mapController.isCompleted) {
                  _mapController.complete(controller);
                }
              },
              onCameraMove: (position) {
                if (!_isMovingBySearch) {
                  setState(() {
                    _currentLatLng = position.target;
                  });
                }
              },
              onCameraIdle: () async {
                if (!_isMovingBySearch) {
                  _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 300), () async {
                    await _fetchAddress(_currentLatLng.latitude, _currentLatLng.longitude);
                  });
                }
              },
            ),
          ),
          IgnorePointer(
            child: Center(
              child: Transform.translate(
                offset: const Offset(0, -40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.green,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.18),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 220),
                        child: Column(
                          children: [
                            const Text(
                              "Selected Location",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _city,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    CustomPaint(
                      size: const Size(28, 14),
                      painter: MarkerTrianglePainter(color: AppColors.green),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColors.primaryRed.withOpacity(.25),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const Icon(
                          Icons.location_on_rounded,
                          size: 72,
                          color: AppColors.primaryRed,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Material(
                    elevation: 12,
                    shadowColor: Colors.black.withOpacity(.12),
                    borderRadius: BorderRadius.circular(34),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(34),
                        border: Border.all(color: AppColors.golden, width: 2),
                      ),
                      child: GooglePlaceAutoCompleteTextField(
                        textEditingController: _searchController,
                        focusNode: _searchFocus,
                        googleAPIKey: googleApiKey,
                        debounceTime: 250,
                        countries: const ["in"],
                        isLatLngRequired: true,
                        isCrossBtnShown: false,
                        containerHorizontalPadding: 0,
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        inputDecoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search area, street or city",
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          contentPadding: const EdgeInsets.symmetric(vertical: 24),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 14, right: 10),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.primaryRed, width: 2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.search, color: AppColors.primaryRed, size: 30),
                            ),
                          ),
                        ),
                        itemClick: (prediction) async {
                          FocusScope.of(context).unfocus();
                          _searchController.text = prediction.description ?? "";
                        },
                        itemBuilder: (context, index, prediction) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryRed.withOpacity(.1),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(Icons.location_on_rounded, color: AppColors.primaryRed),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    prediction.description ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        seperatedBuilder: Divider(height: 1, thickness: 1, color: Colors.grey.shade100),
                        getPlaceDetailWithLatLng: (prediction) async {
                          if (prediction.lat != null && prediction.lng != null) {
                            await _moveToLocation(
                              lat: double.parse(prediction.lat!),
                              lng: double.parse(prediction.lng!),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _getCurrentLocation,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: AppColors.primaryRed, width: 1.6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.08),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.my_location_rounded, color: AppColors.primaryRed),
                          SizedBox(width: 12),
                          Text(
                            "Use my current location",
                            style: TextStyle(
                              color: AppColors.primaryRed,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(22, 22, 22, 30),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(34),
                        topRight: Radius.circular(34),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 56,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Text(
                              "Select your location",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: _getCurrentLocation,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryRed.withOpacity(.08),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.gps_fixed_rounded, size: 18, color: AppColors.primaryRed),
                                    SizedBox(width: 6),
                                    Text(
                                      "Current",
                                      style: TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.lightCream,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(color: AppColors.primaryRed.withOpacity(.12)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(color: AppColors.primaryRed, shape: BoxShape.circle),
                                child: const Icon(Icons.location_on_rounded, color: Colors.white, size: 32),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_city, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                                    const SizedBox(height: 8),
                                    Text(
                                      _address,
                                      style: TextStyle(
                                        fontSize: 14,
                                        height: 1.5,
                                        color: Colors.black.withOpacity(.68),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: ElevatedButton(
                            onPressed: () async {
                              await _saveLocation();
                              if (!mounted) return;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => HomeScreen(
                                    location: _address,
                                    latitude: _currentLatLng.latitude,
                                    longitude: _currentLatLng.longitude,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryRed,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                            ),
                            child: const Text(
                              "Confirm Location",
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MarkerTrianglePainter extends CustomPainter {
  final Color color;
  MarkerTrianglePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
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
