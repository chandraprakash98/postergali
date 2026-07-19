import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postergali/core/localization/localization_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../posterman/bot_splash_screen.dart';
import '../../data/models/job_filter.dart';
import '../widgets/home_bottom_bar.dart';
import '../widgets/home_cards.dart';
import '../widgets/home_header.dart';
import '../widgets/home_tabs.dart';
import '../widgets/result_header.dart';
import 'job_filter_screen.dart';
import 'offer_filter_screen.dart';
import '../../data/models/offer_filter.dart';
import '../../../job_details/presentation/screens/job_detail_screen.dart';
import '../../../language/presentation/screens/language_selection_screen.dart';
import '../../../location/presentation/screens/location_selector_screen.dart';
import '../../../offer_details/presentation/screens/offer_detail_screen.dart';
import '../../../referral/presentation/screens/referral_screen.dart';

class HomeScreen extends StatefulWidget {
  final String location;
  final double latitude;
  final double longitude;

  const HomeScreen({
    super.key,
    required this.location,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool isLoading = true;
  List<dynamic> jobs = [];
  List<dynamic> offers = [];
  List<dynamic> allLikedPosters = [];
  List<dynamic> myPosters = [];

  bool noNearbyJobs = false;
  bool noNearbyOffers = false;

  final List<int> radiusList = [5, 10, 15];
  final ScrollController _scrollController = ScrollController();
  int currentRadiusIndex = 0;
  bool isLoadingMore = false;

  int selectedTab = 0;
  int selectedBottomIndex = 0;

  JobFilterModel jobFilter = JobFilterModel();
  OfferFilterModel offerFilter = OfferFilterModel();

  final List<String> jobCategories = [
    "Retail and Shop Jobs",
    "Food and Hospitality",
    "Delivery and Logistics",
    "Office and Admin",
    "Skilled Workers",
    "Housekeeping and Maintenance",
    "Creative and Digital",
    "HealthCare and Care",
    "Education and Training",
    "Construction and Labor",
  ];

  final List<String> expiryOptions = [
    "Within a day",
    "Within 3 days",
    "Within a week",
  ];

  final List<String> salaryOptions = ["10000", "15000", "20000", "25000", "30000"];

  final List<String> jobTypes = ["Full Time", "Part Time", "Temporary"];

  final List<String> offerCategories = ["Food", "Fashion", "Salon", "Electronics", "Grocery", "Travel", "Cafe", "Gym"];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    fetchJobs();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (selectedBottomIndex != 0) return;
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 400) {
      if (!isLoading && !isLoadingMore && currentRadiusIndex < radiusList.length - 1) {
        _loadMore();
      }
    }
  }

  Future<List<dynamic>> _fetchByRadius({
    required String endpoint,
    required int radius,
    required int perPage,
    Map<String, String>? extraQuery,
  }) async {
    final query = {
      "latitude": widget.latitude.toString(),
      "longitude": widget.longitude.toString(),
      "radius": radius.toString(),
      "per_page": perPage.toString(),
    };

    if (extraQuery != null) {
      extraQuery.remove("latitude");
      extraQuery.remove("longitude");
      extraQuery.remove("radius");
      extraQuery.remove("per_page");
      query.addAll(extraQuery);
    }

    query.removeWhere((key, value) => value.isEmpty);

    final uri = Uri.parse("https://www.postergali.com/api/v1/$endpoint").replace(queryParameters: query);

    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) return [];

      final json = jsonDecode(response.body);
      if (json is Map<String, dynamic>) {
        return json["data"] ?? [];
      }
    } catch (e) {
      debugPrint("Error fetching radius $radius: $e");
    }
    return [];
  }

  Future<void> fetchJobs() async {
    setState(() {
      isLoading = true;
      selectedTab = 0;
      noNearbyJobs = false;
      jobs = [];
      currentRadiusIndex = 0;
    });

    try {
      final query = jobFilter.toQuery(
        latitude: widget.latitude,
        longitude: widget.longitude,
      );

      for (int i = 0; i < radiusList.length; i++) {
        final radius = radiusList[i];
        final results = await _fetchByRadius(
          endpoint: "jobs",
          radius: radius,
          perPage: 50,
          extraQuery: query,
        );

        if (results.isNotEmpty) {
          jobs = results;
          currentRadiusIndex = i;
          if (jobs.length >= 5 || i == radiusList.length - 1) {
            break;
          }
        }
        currentRadiusIndex = i;
      }

      noNearbyJobs = jobs.isEmpty;
    } catch (e) {
      debugPrint(e.toString());
      noNearbyJobs = true;
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchOffers() async {
    setState(() {
      isLoading = true;
      selectedTab = 1;
      noNearbyOffers = false;
      offers = [];
      currentRadiusIndex = 0;
    });

    try {
      final query = offerFilter.toQuery(
        latitude: widget.latitude,
        longitude: widget.longitude,
      );

      for (int i = 0; i < radiusList.length; i++) {
        final radius = radiusList[i];
        final results = await _fetchByRadius(
          endpoint: "offers",
          radius: radius,
          perPage: 50,
          extraQuery: query,
        );

        if (results.isNotEmpty) {
          offers = results;
          currentRadiusIndex = i;
          if (offers.length >= 5 || i == radiusList.length - 1) {
            break;
          }
        }
        currentRadiusIndex = i;
      }

      noNearbyOffers = offers.isEmpty;
    } catch (e) {
      debugPrint(e.toString());
      noNearbyOffers = true;
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadMore() async {
    if (currentRadiusIndex >= radiusList.length - 1) return;

    setState(() {
      isLoadingMore = true;
    });

    final nextRadiusIndex = currentRadiusIndex + 1;
    final radius = radiusList[nextRadiusIndex];
    final endpoint = selectedTab == 0 ? "jobs" : "offers";

    final query = selectedTab == 0
        ? jobFilter.toQuery(latitude: widget.latitude, longitude: widget.longitude)
        : offerFilter.toQuery(latitude: widget.latitude, longitude: widget.longitude);

    final results = await _fetchByRadius(
      endpoint: endpoint,
      radius: radius,
      perPage: 50,
      extraQuery: query,
    );

    if (results.isNotEmpty) {
      setState(() {
        if (selectedTab == 0) {
          final existingIds = jobs.map((j) => j['id']).toSet();
          final newItems = results.where((j) => !existingIds.contains(j['id'])).toList();
          jobs.addAll(newItems);
        } else {
          final existingIds = offers.map((o) => o['id']).toSet();
          final newItems = results.where((o) => !existingIds.contains(o['id'])).toList();
          offers.addAll(newItems);
        }
      });
    }

    setState(() {
      currentRadiusIndex = nextRadiusIndex;
      isLoadingMore = false;
    });
  }

  Future<void> _loadLikedPosters() async {
    setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final liked = prefs.getStringList('liked_posters') ?? [];
      setState(() {
        allLikedPosters = liked.map((e) => jsonDecode(e)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _showFilterBottomSheet() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobFilterScreen(
          initialFilter: jobFilter,
          jobCategories: jobCategories,
          expiryOptions: expiryOptions,
          salaryOptions: salaryOptions,
          jobTypes: jobTypes,
        ),
      ),
    );

    if (result != null && result is JobFilterModel) {
      setState(() {
        jobFilter = result;
      });
      fetchJobs();
    }
  }

  Future<void> _showOfferFilterBottomSheet() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OfferFilterScreen(
          initialFilter: offerFilter,
          offerCategories: offerCategories,
          expiryOptions: expiryOptions,
        ),
      ),
    );

    if (result != null && result is OfferFilterModel) {
      setState(() {
        offerFilter = result;
      });
      fetchOffers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFAB(),
      bottomNavigationBar: HomeBottomBar(
        selectedIndex: selectedBottomIndex,
        onItemTapped: (index) {
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const LocationSelectorScreen()));
            return;
          }
          setState(() {
            selectedBottomIndex = index;
            if (index == 0) fetchJobs();
            if (index == 2) _loadLikedPosters();
            if (index == 3) {
              /* Mock or fetch my posters */
            }
          });
        },
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xECFFDAB5), Color(0xECFFDAB5), Color(0xFFFFDCB9)],
          ),
          image: const DecorationImage(
            image: AssetImage('assets/images/img.png'),
            fit: BoxFit.cover,
            opacity: 0.01,
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            controller: selectedBottomIndex == 0 ? _scrollController : null,
            slivers: [
              SliverToBoxAdapter(child: _buildHeaderForIndex()),
              const SliverToBoxAdapter(child: SizedBox(height: 10)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: HomeTabs(
                    selectedTab: selectedTab,
                    onJobsTap: () => setState(() {
                      selectedTab = 0;
                      if (selectedBottomIndex == 0) fetchJobs();
                    }),
                    onOffersTap: () => setState(() {
                      selectedTab = 1;
                      if (selectedBottomIndex == 0) fetchOffers();
                    }),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverToBoxAdapter(child: _buildResultHeaderForIndex()),
              const SliverToBoxAdapter(child: SizedBox(height: 10)),
              if (isLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(color: AppColors.primaryRed)),
                )
              else
                ..._buildSliverFragmentBody(),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderForIndex() {
    if (selectedBottomIndex == 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: HomeHeader(
          location: widget.location,
          walletBalance: 1000,
          onLocationTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LocationSelectorScreen())),
          onLanguageTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LanguageSelectionScreen())),
          onBannerTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReferralScreen())),
        ),
      );
    }
    String title = selectedBottomIndex == 2 ? context.tr('liked_posters') : context.tr('my_poster');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => setState(() => selectedBottomIndex = 0),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xffB5402C), width: 1.5)),
              child: const Icon(Icons.arrow_back, color: Color(0xffB5402C), size: 24),
            ),
          ),
          const SizedBox(width: 15),
          Text(
            title,
            style: const TextStyle(fontFamily: 'ClashDisplay', fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xff4A1F14)),
          ),
        ],
      ),
    );
  }

  Widget _buildResultHeaderForIndex() {
    int count = 0;
    if (selectedBottomIndex == 0) {
      count = selectedTab == 0 ? jobs.length : offers.length;
    } else if (selectedBottomIndex == 2) {
      count = allLikedPosters.where((p) => p['type'] == (selectedTab == 0 ? 'job' : 'offer')).length;
    } else {
      count = myPosters.where((p) => p['type'] == (selectedTab == 0 ? 'job' : 'offer')).length;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total results (${count.toString().padLeft(2, '0')})",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xff4A1F14)),
          ),
          GestureDetector(
            onTap: () {
              if (selectedTab == 0) _showFilterBottomSheet();
              else _showOfferFilterBottomSheet();
            },
            child: const Icon(CupertinoIcons.slider_horizontal_3, color: Color(0xffB5402C), size: 24),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSliverFragmentBody() {
    if (selectedBottomIndex == 0) {
      if (selectedTab == 0 && noNearbyJobs) return [SliverToBoxAdapter(child: _emptyState(context.tr('no_jobs')))];
      if (selectedTab == 1 && noNearbyOffers) return [SliverToBoxAdapter(child: _emptyState(context.tr('no_offers')))];
      return [_buildSliverGrid(selectedTab == 0 ? jobs : offers)];
    } else if (selectedBottomIndex == 2) {
      final filtered = allLikedPosters.where((p) => p['type'] == (selectedTab == 0 ? 'job' : 'offer')).toList();
      if (filtered.isEmpty) return [SliverToBoxAdapter(child: _emptyState(selectedTab == 0 ? context.tr('no_jobs') : context.tr('no_offers')))];
      return [_buildSliverGrid(filtered)];
    } else {
      final filtered = myPosters.where((p) => p['type'] == (selectedTab == 0 ? 'job' : 'offer')).toList();
      if (filtered.isEmpty) return [SliverToBoxAdapter(child: _emptyState("You haven't posted anything yet."))];
      return [_buildSliverGrid(filtered)];
    }
  }

  Widget _buildSliverGrid(List<dynamic> data) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 20,
          childAspectRatio: 0.62,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = data[index];
            final bool isJob = item['type'] == 'job' || item['job_role'] != null;
            return _buildGridItemWrapper(
              index: index,
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => isJob
                        ? JobDetailScreen(jobId: item['id'], initialDistance: item['distance'])
                        : OfferDetailScreen(offerId: item['id'], initialDistance: item['distance']),
                  ),
                );
                if (selectedBottomIndex == 2) _loadLikedPosters();
              },
              child: isJob ? HomeJobCard(job: item) : HomeOfferCard(offer: item),
              isJob: isJob,
            );
          },
          childCount: data.length,
        ),
      ),
    );
  }

  Widget _buildGridItemWrapper({
    required int index,
    required VoidCallback onTap,
    required Widget child,
    required bool isJob,
  }) {
    final angle = index.isEven ? -0.03 : 0.03;
    return GestureDetector(
      onTap: onTap,
      child: Transform.rotate(angle: angle, child: child),
    );
  }

  Widget _emptyState(String msg) {
    return Container(
      height: 300,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(CupertinoIcons.doc_text, size: 80, color: Colors.black26),
          const SizedBox(height: 20),
          Text(msg, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BotSplashScreen(location: widget.location, latitude: widget.latitude, longitude: widget.longitude),
        ),
      ),
      child: Container(
        height: 78,
        width: 78,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(colors: [Color(0xffF2C96B), Color(0xffE8B84F)]),
          border: Border.all(color: const Color(0xffB5402C), width: 3),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4))],
        ),
        child: const Icon(CupertinoIcons.add, size: 36, color: Color(0xffB5402C)),
      ),
    );
  }
}
