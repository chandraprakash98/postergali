import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

class _OfferDetailScreenState extends State<OfferDetailScreen> {
  bool isLoading = true;
  dynamic offer;

  final PageController _pageController =
  PageController(viewportFraction: 0.92);

  int currentPage = 0;

  VideoPlayerController? _videoController;

  List<String> sliderItems = [];

  String? videoUrl;

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
          'https://postergali.com/api/v1/offers/${widget.offerId}',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        sliderItems.clear();

        /// 1st slide = template
        sliderItems.add("template");

        /// video
        final videoPath = data['media']?['video'];

        if (videoPath != null &&
            videoPath.toString().isNotEmpty) {
          videoUrl =
          "https://postergali.com/storage/$videoPath";

          sliderItems.add(videoUrl!);
        }

        /// images
        if (data['media']?['images'] != null) {
          for (var img in data['media']['images']) {
            sliderItems.add(
              "https://postergali.com/storage/$img",
            );
          }
        }

        setState(() {
          offer = data;
          isLoading = false;
        });

        /// IMPORTANT: init video AFTER UI build
        if (videoUrl != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
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

  Future<void> _initializeVideo(String url) async {
    try {
      await _videoController?.dispose();

      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(url),
      );

      await _videoController!.initialize();

      if (!mounted) return;

      setState(() {}); // show first frame

      await _videoController!
        ..setLooping(true)
        ..setVolume(1.0);

      await Future.delayed(const Duration(milliseconds: 200));

      await _videoController!.play();

      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("VIDEO ERROR => $e");
    }
  }

  Widget _buildPoster() {
    switch (offer['temp_id']) {
      case 'T001':
      case 'T01':
        return OfferTemplatesFull.templateT001(offer);
      case 'T002':
        return OfferTemplatesFull.templateT002(offer);
      case 'T003':
        return OfferTemplatesFull.templateT003(offer);
      case 'T004':
        return OfferTemplatesFull.templateT004(offer);
      default:
        return OfferTemplatesFull.defaultTemplate(offer);
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
              width: _videoController!.value.size.width,
              height: _videoController!.value.size.height,
              child: VideoPlayer(_videoController!),
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
        const Center(child: Icon(Icons.broken_image)),
      ),
    );
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
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _topButton(Icons.arrow_back_ios_new_rounded,
                          () => Navigator.pop(context)),
                  Row(
                    children: [
                      _topButton(Icons.favorite_border_rounded),
                      const SizedBox(width: 10),
                      _topButton(Icons.share_rounded),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.63,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: sliderItems.length,
                        onPageChanged: (index) {
                          setState(() => currentPage = index);
                        },
                        itemBuilder: (_, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: _buildSliderItem(
                              sliderItems[index],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(sliderItems.length, (i) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin:
                          const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: currentPage == i ? 24 : 8,
                          decoration: BoxDecoration(
                            color: currentPage == i
                                ? Colors.black
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 30),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _item("Business", offer['business_name']),
                          _item("Offer", offer['offer_details']),
                          _item("Phone", offer['mobile_number']),
                          _item("City", offer['city']),
                          _item("Views", "${offer['view_count']}"),
                          _item("Plan", "${offer['plan_id']}"),
                        ],
                      ),
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

  Widget _item(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value ?? '',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _topButton(IconData icon, [VoidCallback? onTap]) {
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
          child: Icon(icon, size: 22),
        ),
      ),
    );
  }
}