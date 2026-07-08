import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:postergali/core/localization/localization_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/widgets/job_templates_full.dart';
import '../../../../core/constants/app_colors.dart';

class JobDetailScreen extends StatefulWidget {
  final int jobId;

  const JobDetailScreen({
    super.key,
    required this.jobId,
  });

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  bool isLoading = true;
  dynamic job;
  double? distanceKm;
  bool isDistanceLoading = true;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    fetchJob();
    _checkLikedStatus();
  }

  Future<void> _checkLikedStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final liked = prefs.getStringList('liked_posters') ?? [];
      setState(() {
        isLiked = liked.any((item) {
          final data = jsonDecode(item);
          return data['id'] == widget.jobId && data['type'] == 'job';
        });
      });
    } catch (e) {
      debugPrint("Check Liked Error: $e");
    }
  }

  Future<void> _toggleLike() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> liked = prefs.getStringList('liked_posters') ?? [];

      if (isLiked) {
        liked.removeWhere((item) {
          final data = jsonDecode(item);
          return data['id'] == widget.jobId && data['type'] == 'job';
        });
      } else {
        if (job != null) {
          final posterData = Map<String, dynamic>.from(job);
          posterData['type'] = 'job'; // Tag as job
          liked.add(jsonEncode(posterData));
        }
      }

      await prefs.setStringList('liked_posters', liked);
      setState(() => isLiked = !isLiked);
    } catch (e) {
      debugPrint("Toggle Like Error: $e");
    }
  }

  String getExpiryText() {
    try {
      final expiryRaw = job['expires_at']?.toString() ?? '';
      if (expiryRaw.isEmpty) return "--";

      final expiryDate = DateTime.parse(expiryRaw.replaceAll(' ', 'T'));
      final now = DateTime.now();
      final difference = expiryDate.difference(now);

      if (difference.isNegative) return "Expired";
      if (difference.inDays >= 1) {
        return "${difference.inDays} Day${difference.inDays > 1 ? 's' : ''}";
      }
      if (difference.inHours >= 1) {
        return "${difference.inHours} Hr${difference.inHours > 1 ? 's' : ''}";
      }
      if (difference.inMinutes >= 1) {
        return "${difference.inMinutes} Min";
      }
      return "Ending Soon";
    } catch (e) {
      debugPrint("Expiry Error: $e");
      return "--";
    }
  }

  Future<void> calculateDistance() async {
    try {
      setState(() => isDistanceLoading = true);
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => isDistanceLoading = false);
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => isDistanceLoading = false);
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() => isDistanceLoading = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double jobLat = double.tryParse(job['latitude'].toString()) ?? 0;
      double jobLng = double.tryParse(job['longitude'].toString()) ?? 0;

      double distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        jobLat,
        jobLng,
      );

      distanceKm = distanceInMeters / 1000;
      setState(() => isDistanceLoading = false);
    } catch (e) {
      setState(() => isDistanceLoading = false);
    }
  }

  Future<void> fetchJob() async {
    try {
      final response = await http.get(
        Uri.parse('https://postergali.com/api/v1/jobs/${widget.jobId}'),
      );

      if (response.statusCode == 200) {
        job = jsonDecode(response.body);
        setState(() => isLoading = false);
        calculateDistance();
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> openMap() async {
    try {
      final lat = job['latitude'].toString();
      final lng = job['longitude'].toString();
      final Uri mapUrl = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving',
      );
      await launchUrl(mapUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

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
      backgroundColor: const Color(0xffF5F5F5),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _topActionButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onTap: () => Navigator.pop(context),
                        ),
                        Row(
                          children: [
                            _topActionButton(
                              icon: isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              onTap: _toggleLike,
                              color: isLiked ? Colors.red : Colors.black87,
                            ),
                            const SizedBox(width: 10),
                            _topActionButton(icon: Icons.share_rounded),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 0.72,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: _buildPoster(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.black12, width: 1.5),
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
                                    icon: Icons.remove_red_eye_outlined,
                                    title: context.tr('views'),
                                    value: "${job['view_count']}",
                                  ),
                                ),
                                _modernDivider(),
                                Expanded(
                                  child: _modernStatItem(
                                    icon: Icons.near_me_rounded,
                                    title: context.tr('distance'),
                                    value: distanceKm == null
                                        ? "--"
                                        : "${distanceKm!.toStringAsFixed(1)} km",
                                    isLoading: isDistanceLoading,
                                  ),
                                ),
                                _modernDivider(),
                                Expanded(
                                  child: _modernStatItem(
                                    icon: Icons.schedule_rounded,
                                    title: context.tr('expires'),
                                    value: getExpiryText(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    final phone = job['mobile']?.toString() ?? '';
                                    if (phone.isEmpty) return;
                                    await launchUrl(Uri.parse('tel:$phone'));
                                  },
                                  child: Container(
                                    height: 64,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(22),
                                      border: Border.all(color: Colors.black12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(.05),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.call_rounded, size: 22, color: Colors.black87),
                                        const SizedBox(width: 8),
                                        Text(
                                          context.tr('call'),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: openMap,
                                  child: Container(
                                    height: 64,
                                    decoration: BoxDecoration(
                                      color: AppColors.green,
                                      borderRadius: BorderRadius.circular(22),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.green.withOpacity(.30),
                                          blurRadius: 14,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.map_rounded, color: Colors.white, size: 24),
                                        const SizedBox(width: 10),
                                        Text(
                                          context.tr('directions'),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
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

  Widget _modernStatItem({
    required IconData icon,
    required String title,
    required String value,
    bool isLoading = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: Colors.black87),
          const SizedBox(height: 10),
          isLoading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, letterSpacing: -.3),
                ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black.withOpacity(.55)),
          ),
        ],
      ),
    );
  }

  Widget _modernDivider() => Container(height: 54, width: 1, color: Colors.black12);

  Widget _topActionButton({required IconData icon, VoidCallback? onTap, Color? color}) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.black12),
          ),
          child: Icon(icon, size: 22, color: color ?? Colors.black87),
        ),
      ),
    );
  }
}
