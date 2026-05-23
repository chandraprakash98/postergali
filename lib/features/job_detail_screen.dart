import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../widgets/job_templates.dart';

class JobDetailScreen extends StatefulWidget {
  final int jobId;

  const JobDetailScreen({
    super.key,
    required this.jobId,
  });

  @override
  State<JobDetailScreen> createState() =>
      _JobDetailScreenState();
}

class _JobDetailScreenState
    extends State<JobDetailScreen> {

  bool isLoading = true;

  dynamic job;

  double? distanceKm;

  bool isDistanceLoading = true;

  @override
  void initState() {
    super.initState();
    fetchJob();
  }

  /// ======================================================
  /// EXPIRY TEXT
  /// ======================================================

  /// ======================================================
  /// EXPIRY TEXT
  /// ======================================================

  String getExpiryText() {

    try {

      final expiryRaw =
          job['expires_at']?.toString() ?? '';

      debugPrint("Expiry Raw: $expiryRaw");

      if (expiryRaw.isEmpty) {
        return "--";
      }

      /// MYSQL DATE FORMAT FIX
      /// 2026-05-27 12:12:23

      final expiryDate = DateTime.parse(
        expiryRaw.replaceAll(' ', 'T'),
      );

      final now = DateTime.now();

      final difference =
      expiryDate.difference(now);

      debugPrint(
        "Difference Hours: ${difference.inHours}",
      );

      /// EXPIRED

      if (difference.isNegative) {
        return "Expired";
      }

      /// DAYS

      if (difference.inDays >= 1) {

        return "${difference.inDays} "
            "Day${difference.inDays > 1 ? 's' : ''}";
      }

      /// HOURS

      if (difference.inHours >= 1) {

        return "${difference.inHours} "
            "Hr${difference.inHours > 1 ? 's' : ''}";
      }

      /// MINUTES

      if (difference.inMinutes >= 1) {

        return "${difference.inMinutes} Min";
      }

      return "Ending Soon";

    } catch (e) {

      debugPrint("Expiry Error: $e");

      return "--";
    }
  }

  /// ======================================================
  /// DISTANCE
  /// ======================================================

  Future<void> calculateDistance() async {

    try {

      setState(() {
        isDistanceLoading = true;
      });

      bool serviceEnabled =
      await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {

        setState(() {
          isDistanceLoading = false;
        });

        return;
      }

      LocationPermission permission =
      await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {

        permission =
        await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {

          setState(() {
            isDistanceLoading = false;
          });

          return;
        }
      }

      if (permission ==
          LocationPermission.deniedForever) {

        setState(() {
          isDistanceLoading = false;
        });

        return;
      }

      /// USER LOCATION

      Position position =
      await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      /// JOB LOCATION

      double jobLat =
          double.tryParse(
            job['latitude'].toString(),
          ) ??
              0;

      double jobLng =
          double.tryParse(
            job['longitude'].toString(),
          ) ??
              0;

      double distanceInMeters =
      Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        jobLat,
        jobLng,
      );

      distanceKm =
          distanceInMeters / 1000;

      setState(() {
        isDistanceLoading = false;
      });

    } catch (e) {

      setState(() {
        isDistanceLoading = false;
      });
    }
  }

  /// ======================================================
  /// FETCH JOB
  /// ======================================================

  Future<void> fetchJob() async {

    try {

      final response = await http.get(
        Uri.parse(
          'https://postergali.com/api/v1/jobs/${widget.jobId}',
        ),
      );

      if (response.statusCode == 200) {

        job = jsonDecode(response.body);

        setState(() {
          isLoading = false;
        });

        calculateDistance();

      } else {

        setState(() {
          isLoading = false;
        });
      }

    } catch (e) {

      setState(() {
        isLoading = false;
      });
    }
  }

  /// ======================================================
  /// OPEN MAP
  /// ======================================================

  Future<void> openMap() async {

    try {

      final lat =
      job['latitude'].toString();

      final lng =
      job['longitude'].toString();

      final Uri mapUrl = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving',
      );

      await launchUrl(
        mapUrl,
        mode: LaunchMode.externalApplication,
      );

    } catch (e) {}
  }

  /// ======================================================
  /// TEMPLATE SWITCH
  /// ======================================================

  Widget _buildPoster() {

    switch (job['temp_id']) {

      case 'T001':
        return JobTemplates.templateT001(job);

      case 'T002':
        return JobTemplates.templateT002(job);

      case 'T003':
        return JobTemplates.templateT003(job);

      case 'T004':
        return JobTemplates.templateT004(job);

      default:
        return JobTemplates.defaultTemplate(job);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xffF5F5F5),

      body: isLoading

          ? const Center(
        child:
        CircularProgressIndicator(),
      )

          : SafeArea(

        child: Column(

          children: [

            /// =========================================
            /// TOP BAR
            /// =========================================

            Padding(

              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),

              child: Row(

                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

                children: [

                  /// BACK

                  Material(

                    color: Colors.white,

                    borderRadius:
                    BorderRadius.circular(18),

                    elevation: 2,

                    child: InkWell(

                      borderRadius:
                      BorderRadius.circular(18),

                      onTap: () {
                        Navigator.pop(context);
                      },

                      child: Container(

                        height: 48,
                        width: 48,

                        decoration: BoxDecoration(

                          borderRadius:
                          BorderRadius.circular(18),

                          border: Border.all(
                            color: Colors.black12,
                          ),
                        ),

                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                  /// ACTIONS

                  Row(
                    children: [

                      _topActionButton(
                        icon:
                        Icons.favorite_border_rounded,
                      ),

                      const SizedBox(width: 10),

                      _topActionButton(
                        icon:
                        Icons.share_rounded,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// =========================================
            /// BODY
            /// =========================================

            Expanded(

              child: SingleChildScrollView(

                padding:
                const EdgeInsets.symmetric(
                  horizontal: 26,
                ),

                child: Column(

                  children: [

                    /// =====================================
                    /// POSTER
                    /// =====================================

                    AspectRatio(

                      aspectRatio: 0.72,

                      child: ClipRRect(

                        borderRadius:
                        BorderRadius.circular(8),

                        child: _buildPoster(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// =====================================
                    /// STATS
                    /// =====================================

                    Container(

                      width: double.infinity,

                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 10,
                      ),

                      decoration: BoxDecoration(

                        color: Colors.white,

                        borderRadius:
                        BorderRadius.circular(30),

                        border: Border.all(
                          color: Colors.black12,
                          width: 1.5,
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.04),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),

                      child: Row(

                        children: [

                          Expanded(
                            child: _modernStatItem(
                              icon:
                              Icons.remove_red_eye_outlined,
                              title: "Views",
                              value:
                              "${job['view_count']}",
                            ),
                          ),

                          _modernDivider(),

                          Expanded(
                            child: _modernStatItem(
                              icon:
                              Icons.near_me_rounded,
                              title: "Distance",

                              value: distanceKm == null
                                  ? "--"
                                  : "${distanceKm!.toStringAsFixed(1)} km",

                              isLoading:
                              isDistanceLoading,
                            ),
                          ),

                          _modernDivider(),

                          Expanded(
                            child: _modernStatItem(
                              icon: Icons.schedule_rounded,
                              title: "Expires",
                              value: getExpiryText(),
                              isLoading: false,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    /// =====================================
                    /// ACTION BUTTONS
                    /// =====================================

                    Row(
                      children: [

                        /// CALL BUTTON

                        Expanded(
                          child: GestureDetector(

                            onTap: () async {

                              final phone =
                                  job['mobile']
                                      ?.toString() ??
                                      '';

                              if (phone.isEmpty) return;

                              final Uri phoneUri =
                              Uri.parse(
                                'tel:$phone',
                              );

                              await launchUrl(
                                phoneUri,
                              );
                            },

                            child: Container(

                              height: 64,

                              decoration: BoxDecoration(

                                color: Colors.white,

                                borderRadius:
                                BorderRadius.circular(
                                  22,
                                ),

                                border: Border.all(
                                  color: Colors.black12,
                                ),

                                boxShadow: [
                                  BoxShadow(
                                    color:
                                    Colors.black.withOpacity(
                                      .05,
                                    ),
                                    blurRadius: 10,
                                    offset:
                                    const Offset(0, 4),
                                  ),
                                ],
                              ),

                              child: const Row(

                                mainAxisAlignment:
                                MainAxisAlignment.center,

                                children: [

                                  Icon(
                                    Icons.call_rounded,
                                    size: 22,
                                    color: Colors.black87,
                                  ),

                                  SizedBox(width: 8),

                                  Text(
                                    "Call",

                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                      FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        /// DIRECTION BUTTON

                        Expanded(
                          flex: 2,

                          child: GestureDetector(

                            onTap: openMap,

                            child: Container(

                              height: 64,

                              decoration: BoxDecoration(

                                color:
                                const Color(0xff448655),

                                borderRadius:
                                BorderRadius.circular(
                                  22,
                                ),

                                boxShadow: [
                                  BoxShadow(
                                    color:
                                    const Color(
                                      0xff448655,
                                    ).withOpacity(.30),

                                    blurRadius: 14,
                                    offset:
                                    const Offset(0, 6),
                                  ),
                                ],
                              ),

                              child: const Row(

                                mainAxisAlignment:
                                MainAxisAlignment.center,

                                children: [

                                  Icon(
                                    Icons.map_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),

                                  SizedBox(width: 10),

                                  Text(
                                    "Directions",

                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                      FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ======================================================
  /// STATS ITEM
  /// ======================================================

  Widget _modernStatItem({

    required IconData icon,

    required String title,

    required String value,

    bool isLoading = false,

  }) {

    return Padding(

      padding: const EdgeInsets.symmetric(
        horizontal: 6,
      ),

      child: Column(

        mainAxisSize: MainAxisSize.min,

        children: [

          Icon(
            icon,
            size: 22,
            color: Colors.black87,
          ),

          const SizedBox(height: 10),

          isLoading

              ? const SizedBox(
            height: 18,
            width: 18,

            child:
            CircularProgressIndicator(
              strokeWidth: 2,
            ),
          )

              : Text(
            value,

            maxLines: 1,

            overflow:
            TextOverflow.ellipsis,

            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              letterSpacing: -.3,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,

            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color:
              Colors.black.withOpacity(.55),
            ),
          ),
        ],
      ),
    );
  }

  Widget _modernDivider() {

    return Container(
      height: 54,
      width: 1,
      color: Colors.black12,
    );
  }

  /// ======================================================
  /// TOP ACTION BUTTON
  /// ======================================================

  Widget _topActionButton({
    required IconData icon,
  }) {

    return Material(

      color: Colors.white,

      borderRadius:
      BorderRadius.circular(18),

      elevation: 2,

      child: InkWell(

        borderRadius:
        BorderRadius.circular(18),

        onTap: openMap,

        child: Container(

          height: 48,
          width: 48,

          decoration: BoxDecoration(

            borderRadius:
            BorderRadius.circular(18),

            border: Border.all(
              color: Colors.black12,
            ),
          ),

          child: Icon(
            icon,
            size: 22,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}