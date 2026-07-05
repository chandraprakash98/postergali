import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:postergali/core/localization/localization_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/widgets/offer_templates_full.dart';

class OfferDetailScreen extends StatefulWidget {
  final int offerId;

  const OfferDetailScreen({
    super.key,
    required this.offerId,
  });

  @override
  State<OfferDetailScreen> createState() =>
      _OfferDetailScreenState();
}

class _OfferDetailScreenState
    extends State<OfferDetailScreen> {
  bool isLoading = true;
  dynamic offer;

  final PageController _pageController =
  PageController(viewportFraction: 0.92);

  int currentPage = 0;

  VideoPlayerController? _videoController;

  List<String> sliderItems = [];

  String? videoUrl;

  double distanceInKm = 0;

  String expiryText = "N/A";

  @override
  void initState() {
    super.initState();
    fetchOffer();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> fetchOffer() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://www.postergali.com/api/v1/offers/${widget.offerId}',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        sliderItems.clear();

        /// FIRST SLIDE TEMPLATE
        sliderItems.add("template");

        /// VIDEO
        final videoPath = data['media']?['video'];

        if (videoPath != null &&
            videoPath.toString().isNotEmpty) {
          videoUrl =
          "https://www.postergali.com/storage/$videoPath";

          sliderItems.add(videoUrl!);
        }

        /// IMAGES
        if (data['media']?['images'] != null) {
          for (var img in data['media']['images']) {
            sliderItems.add(
              "https://www.postergali.com/storage/$img",
            );
          }
        }

        await _calculateDistance(data);

        _calculateExpiry(data);

        setState(() {
          offer = data;
          isLoading = false;
        });

        /// INIT VIDEO
        if (videoUrl != null) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) {
            _initializeVideo(videoUrl!);
          });
        }
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint(e.toString());
      setState(() => isLoading = false);
    }
  }

  Future<void> _calculateDistance(dynamic data) async {
    try {
      bool serviceEnabled =
      await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) return;

      LocationPermission permission =
      await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission =
        await Geolocator.requestPermission();
      }

      if (permission ==
          LocationPermission.denied ||
          permission ==
              LocationPermission.deniedForever) {
        return;
      }

      Position position =
      await Geolocator.getCurrentPosition();

      double userLat = position.latitude;
      double userLng = position.longitude;

      double offerLat = double.tryParse(
          data['latitude']?.toString() ?? "0") ??
          0;

      double offerLng = double.tryParse(
          data['longitude']?.toString() ?? "0") ??
          0;

      double distance = Geolocator.distanceBetween(
        userLat,
        userLng,
        offerLat,
        offerLng,
      );

      distanceInKm = distance / 1000;
    } catch (e) {
      debugPrint("DISTANCE ERROR => $e");
    }
  }

  void _calculateExpiry(dynamic data) {
    try {
      if (data['expires_at'] != null) {
        final expiryDate =
        DateTime.parse(data['expires_at']);

        final now = DateTime.now();

        final difference =
        expiryDate.difference(now);

        if (difference.inDays > 0) {
          expiryText =
          "${difference.inDays} days";
        } else if (difference.inHours > 0) {
          expiryText =
          "${difference.inHours} hrs";
        } else {
          expiryText = "Expiring Soon";
        }
      } else {
        /// fallback if expires_at null
        final created =
        DateTime.parse(data['created_at']);

        final expiry =
        created.add(const Duration(days: 7));

        final difference =
        expiry.difference(DateTime.now());

        if (difference.inDays > 0) {
          expiryText =
          "${difference.inDays} days";
        } else if (difference.inHours > 0) {
          expiryText =
          "${difference.inHours} hrs";
        } else {
          expiryText = "Expired";
        }
      }
    } catch (e) {
      expiryText = "N/A";
    }
  }

  Future<void> _initializeVideo(String url) async {
    try {
      await _videoController?.dispose();

      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(url),
      );

      await _videoController!.initialize();

      if (!mounted) return;

      await _videoController!
        ..setLooping(true)
        ..setVolume(1.0);

      await Future.delayed(
          const Duration(milliseconds: 200));

      await _videoController!.play();

      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("VIDEO ERROR => $e");
    }
  }

  Future<void> _makeCall() async {
    final phone = offer['mobile_number'];

    final Uri url = Uri.parse("tel:$phone");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _openMap() async {
    final lat = offer['latitude'];
    final lng = offer['longitude'];

    final Uri url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$lat,$lng",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Widget _buildPoster() {
    switch (offer['temp_id']) {
      case 'T001':
      case 'T01':
        return OfferTemplatesFull.templateT001(
            offer);

      case 'T002':
        return OfferTemplatesFull.templateT002(
            offer);

      case 'T003':
        return OfferTemplatesFull.templateT003(
            offer);

      case 'T004':
        return OfferTemplatesFull.templateT004(
            offer);

      default:
        return OfferTemplatesFull.defaultTemplate(
            offer);
    }
  }

  Widget _buildSliderItem(String item) {
    /// TEMPLATE
    if (item == "template") {
      return ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: _buildPoster(),
      );
    }

    /// VIDEO
    if (item == videoUrl) {
      if (_videoController == null ||
          !_videoController!.value.isInitialized) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      return ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _videoController!.value.isPlaying
                  ? _videoController!.pause()
                  : _videoController!.play();
            });
          },
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width:
              _videoController!.value.size.width,
              height:
              _videoController!.value.size.height,
              child:
              VideoPlayer(_videoController!),
            ),
          ),
        ),
      );
    }

    /// IMAGE
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Image.network(
        item,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) =>
        const Center(
          child: Icon(Icons.broken_image),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: isLoading
          ? const Center(
          child: CircularProgressIndicator())
          : SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
                children: [
                  _topButton(
                    Icons
                        .arrow_back_ios_new_rounded,
                        () => Navigator.pop(
                        context),
                  ),
                  Row(
                    children: [
                      _topButton(Icons
                          .favorite_border_rounded),
                      const SizedBox(
                          width: 10),
                      _topButton(Icons
                          .share_rounded),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding:
                const EdgeInsets.symmetric(
                    horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height:
                      MediaQuery.of(context)
                          .size
                          .height *
                          0.63,
                      child: PageView.builder(
                        controller:
                        _pageController,
                        itemCount:
                        sliderItems.length,
                        onPageChanged:
                            (index) {
                          setState(() =>
                          currentPage =
                              index);
                        },
                        itemBuilder:
                            (_, index) {
                          return Padding(
                            padding:
                            const EdgeInsets
                                .only(
                                right:
                                12),
                            child:
                            _buildSliderItem(
                              sliderItems[
                              index],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .center,
                      children: List.generate(
                        sliderItems.length,
                            (i) {
                          return AnimatedContainer(
                            duration:
                            const Duration(
                                milliseconds:
                                250),
                            margin:
                            const EdgeInsets
                                .symmetric(
                                horizontal:
                                4),
                            height: 8,
                            width:
                            currentPage ==
                                i
                                ? 24
                                : 8,
                            decoration:
                            BoxDecoration(
                              color:
                              currentPage ==
                                  i
                                  ? Colors
                                  .black
                                  : Colors
                                  .grey,
                              borderRadius:
                              BorderRadius
                                  .circular(
                                  30),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 26),

                    /// INFO BAR
                    Container(
                      width: double.infinity,
                      padding:
                      const EdgeInsets
                          .symmetric(
                        horizontal: 18,
                        vertical: 20,
                      ),
                      decoration:
                      BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius
                            .circular(
                            28),
                        border: Border.all(
                          color:
                          Colors.black12,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _infoItem(
                              Icons
                                  .remove_red_eye_outlined,
                              context.tr('views'),
                              "${offer['view_count']}",
                            ),
                          ),

                          Container(
                            width: 1,
                            height: 45,
                            color: Colors
                                .black12,
                          ),

                          Expanded(
                            child: _infoItem(
                              Icons
                                  .near_me_outlined,
                              context.tr('distance'),
                              "${distanceInKm.toStringAsFixed(1)} km",
                            ),
                          ),

                          Container(
                            width: 1,
                            height: 45,
                            color: Colors
                                .black12,
                          ),

                          Expanded(
                            child: _infoItem(
                              Icons
                                  .warning_amber_rounded,
                              context.tr('expires'),
                              expiryText,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 50),

                    /// BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 62,
                            child:
                            OutlinedButton(
                              onPressed:
                              _makeCall,
                              style:
                              OutlinedButton
                                  .styleFrom(
                                backgroundColor:
                                Colors
                                    .white,
                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      40),
                                ),
                                side:
                                const BorderSide(
                                  color: Colors
                                      .black,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                context.tr('call'),
                                style:
                                const TextStyle(
                                  color: Colors
                                      .black,
                                  fontSize:
                                  18,
                                  fontWeight:
                                  FontWeight
                                      .w600,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: SizedBox(
                            height: 62,
                            child:
                            ElevatedButton(
                              onPressed:
                              _openMap,
                              style:
                              ElevatedButton
                                  .styleFrom(
                                backgroundColor:
                                Colors
                                    .grey,
                                elevation: 0,
                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      40),
                                ),
                              ),
                              child: Text(
                                context.tr('directions'),
                                style:
                                const TextStyle(
                                  color: Colors
                                      .white,
                                  fontSize:
                                  18,
                                  fontWeight:
                                  FontWeight
                                      .w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(
      IconData icon,
      String title,
      String value,
      ) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _topButton(
      IconData icon, [
        VoidCallback? onTap,
      ]) {
    return Material(
      color: Colors.white,
      borderRadius:
      BorderRadius.circular(18),
      elevation: 2,
      child: InkWell(
        borderRadius:
        BorderRadius.circular(18),
        onTap: onTap,
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
          child: Icon(icon, size: 22),
        ),
      ),
    );
  }
}
