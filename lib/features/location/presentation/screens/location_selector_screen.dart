import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:postergali/core/localization/localization_service.dart';
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
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: RepaintBoundary(
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
                    _currentLatLng = position.target;
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
                            Text(
                              context.tr('location'),
                              style: const TextStyle(
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
                    elevation: 8,
                    shadowColor: Colors.black26,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: AppColors.golden.withOpacity(0.5), width: 1.5),
                      ),
                      child: GooglePlaceAutoCompleteTextField(
                        textEditingController: _searchController,
                        focusNode: _searchFocus,
                        googleAPIKey: googleApiKey,
                        debounceTime: 300,
                        countries: const ["in"],
                        isLatLngRequired: true,
                        isCrossBtnShown: false,
                        containerHorizontalPadding: 0,
                        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                        inputDecoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search area, street or city",
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          prefixIcon: const Icon(Icons.search, color: AppColors.primaryRed, size: 24),
                        ),
                        itemClick: (prediction) async {
                          FocusScope.of(context).unfocus();
                          _searchController.text = prediction.description ?? "";
                        },
                        itemBuilder: (context, index, prediction) {
                          return Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on_rounded, color: AppColors.primaryRed, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    prediction.description ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        seperatedBuilder: const Divider(height: 1),
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
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _getCurrentLocation,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: AppColors.primaryRed, width: 1.6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.my_location_rounded, color: AppColors.primaryRed, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            context.tr('use_current_location'),
                            style: const TextStyle(
                              color: AppColors.primaryRed,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, -4)),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              context.tr('select_location'),
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: _getCurrentLocation,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryRed.withOpacity(.08),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.gps_fixed_rounded, size: 16, color: AppColors.primaryRed),
                                    const SizedBox(width: 4),
                                    Text(
                                      context.tr('current'),
                                      style: const TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.w700, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.lightCream,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: AppColors.primaryRed.withOpacity(.1)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(color: AppColors.primaryRed, shape: BoxShape.circle),
                                child: const Icon(Icons.location_on_rounded, color: Colors.white, size: 28),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_city, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                                    const SizedBox(height: 6),
                                    Text(
                                      _address,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        height: 1.4,
                                        color: Colors.black.withOpacity(.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: () async {
                              await _saveLocation();
                              if (!mounted) return;
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => HomeScreen(
                                    location: _address,
                                    latitude: _currentLatLng.latitude,
                                    longitude: _currentLatLng.longitude,
                                  ),
                                ),
                                (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryRed,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                            child: Text(
                              context.tr('confirm_location'),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
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
