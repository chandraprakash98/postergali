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
  
  class _HomeScreenState extends State<HomeScreen>
      with SingleTickerProviderStateMixin {

    bool isLoading = true;

    List<dynamic> jobs = [];
    List<dynamic> offers = [];

    bool noNearbyJobs = false;
    bool noNearbyOffers = false;

// Radius sequence
    final List<int> radiusList = [5, 10, 15];
    final ScrollController _scrollController = ScrollController();

    int currentRadiusIndex = 0;

    bool isLoadingMore = false;

    int selectedTab = 0;
    int selectedBottomIndex = 0;
  
    List<dynamic> allLikedPosters = [];
    bool isLikedMode = false;

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
  
    final List<String> salaryOptions = [
      "10000",
      "15000",
      "20000",
      "25000",
      "30000",
    ];
  
    final List<String> jobTypes = [
      "Full Time",
      "Part Time",
      "Temporary",
    ];

    final List<String> offerCategories = [
      "Food",
      "Fashion",
      "Salon",
      "Electronics",
      "Grocery",
      "Travel",
      "Cafe",
      "Gym",
    ];
  
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
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 400) {
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

      final uri = Uri.parse(
        "https://www.postergali.com/api/v1/$endpoint",
      ).replace(queryParameters: query);

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

    Future<void> fetchJobs() async {
      if (isLikedMode) {
        setState(() => selectedTab = 0);
        return;
      }

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
          debugPrint("Trying radius for Jobs: $radius km");
          
          final results = await _fetchByRadius(
            endpoint: "jobs",
            radius: radius,
            perPage: 50,
            extraQuery: query,
          );

          if (results.isNotEmpty) {
            jobs = results;
            currentRadiusIndex = i;
            // If we have at least 5 results, we are good. 
            // Otherwise, if there are more radii, keep looking.
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
      if (isLikedMode) {
        setState(() => selectedTab = 1);
        return;
      }

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
          debugPrint("Trying radius for Offers: $radius km");

          final results = await _fetchByRadius(
            endpoint: "offers",
            radius: radius,
            perPage: 50,
            extraQuery: query,
          );

          if (results.isNotEmpty) {
            offers = results;
            currentRadiusIndex = i;
            // If we have at least 5 results, we are good.
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

      debugPrint("Loading more at radius: $radius km");

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
      return Scaffold(backgroundColor: Colors.transparent,
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _buildFAB(),
        bottomNavigationBar: Container(
          color: Colors.transparent,
          child: HomeBottomBar(
            selectedIndex: selectedBottomIndex,
            onItemTapped: (index) {
              if (index == 0) {
                setState(() {
                  selectedBottomIndex = 0;
                  isLikedMode = false;
                });
                fetchJobs();
              } else if (index == 1) {
                // Location Selection
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LocationSelectorScreen(),
                  ),
                );
              } else if (index == 2) {
                setState(() {
                  selectedBottomIndex = 2;
                  isLikedMode = true;
                });
                _loadLikedPosters();
              } else {
                setState(() => selectedBottomIndex = index);
              }
            },
          ),
        ),
  
        body: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFFAE2BC),
                Color(0xFFFFF2CC),
                Color(0xFFEFDFAE),
              ],
            ),
            image: const DecorationImage(
              image: AssetImage('assets/images/img.png'),
              fit: BoxFit.cover,
              opacity: 0.10,
            ),
          ),
          child: SafeArea(
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isLikedMode) ...[
                          const SizedBox(height: 10),
                          Center(
                            child: Text(
                              context.tr('liked'),
                              style: const TextStyle(
                                fontFamily: 'ClashDisplay',
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff4A1F14),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                        ] else ...[
                          HomeHeader(
                            location: widget.location,
                            onLocationTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LocationSelectorScreen(),
                                ),
                              );
                            },
                            onLanguageTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LanguageSelectionScreen(),
                                ),
                              );
                            },
                            onBannerTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ReferralScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 28),
                        ],
                        HomeTabs(
                          selectedTab: selectedTab,
                          onJobsTap: fetchJobs,
                          onOffersTap: fetchOffers,
                        ),
                        if (!isLikedMode) ...[
                          const SizedBox(height: 24),
                          ResultHeader(
                            selectedTab: selectedTab,
                            isLikedMode: isLikedMode,
                            resultsCount: (selectedTab == 0 ? jobs.length : offers.length),
                            onFilterTap: () {
                              if (selectedTab == 0) {
                                _showFilterBottomSheet();
                              } else {
                                _showOfferFilterBottomSheet();
                              }
                            },
                          ),
                        ],
                        const SizedBox(height: 22),
                      ],
                    ),
                  ),
                ),
                if (isLoading)

                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryRed,
                      ),
                    ),
                  )

                else if (selectedTab == 0 && noNearbyJobs)

                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        context.tr('no_jobs'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )

                else if (selectedTab == 1 && noNearbyOffers)

                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          context.tr('no_offers'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )

                  else if (selectedTab == 0)

                      isLikedMode ? _buildLikedGrid() : _buildJobsGrid()

                    else
                      isLikedMode ? _buildLikedGrid() : _buildOffersGrid(),

                if (isLoadingMore)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryRed,
                        ),
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 120),
                ),
              ],
            ),
          ),
        ),
      );
    }
  
    Widget _buildFAB() {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BotSplashScreen(
                location: widget.location,
                latitude: widget.latitude,
                longitude: widget.longitude,
              ),
            ),
          );
        },
        child: Container(
          height: 78,
          width: 78,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [
                Color(0xffF2C96B),
                Color(0xffE8B84F),
              ],
            ),
            border: Border.all(
              color: Color(0xffB5402C),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            CupertinoIcons.add,
            size: 36,
            color: Color(0xffB5402C),
          ),
        ),
      );
    }
  
    Widget _buildJobsGrid() {
        return SliverPadding(
          padding: const EdgeInsets.only(left: 15, right: 10, top: 1, bottom: 30),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final job = jobs[index];
                return _buildGridItemWrapper(
                  index: index,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JobDetailScreen(
                          jobId: job['id'],
                          initialDistance: job['distance'],
                        ),
                      ),
                    );
                  },
                  child: HomeJobCard(job: job),
                  isJob: true,
                );
              },
              childCount: jobs.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 24,
              childAspectRatio: 0.62,
            ),
          ),
        );
    }
  
    Widget _buildLikedGrid() {
      final type = selectedTab == 0 ? 'job' : 'offer';
      final filtered = allLikedPosters.where((p) => p['type'] == type).toList();

      if (filtered.isEmpty) {
        return SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite_border_rounded, size: 80, color: Colors.black26),
                const SizedBox(height: 20),
                Text(
                  selectedTab == 0 ? context.tr('no_jobs') : context.tr('no_offers'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black54),
                ),
              ],
            ),
          ),
        );
      }

      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final poster = filtered[index];
              final bool isJob = poster['type'] == 'job';

              return _buildGridItemWrapper(
                index: index,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => isJob
                          ? JobDetailScreen(
                              jobId: poster['id'],
                              initialDistance: poster['distance'],
                            )
                          : OfferDetailScreen(
                              offerId: poster['id'],
                              initialDistance: poster['distance'],
                            ),
                    ),
                  );
                  _loadLikedPosters();
                },
                child: isJob ? HomeJobCard(job: poster) : HomeOfferCard(offer: poster),
                isJob: isJob,
              );
            },
            childCount: filtered.length,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 24,
            childAspectRatio: 0.62,
          ),
        ),
      );
    }

    Widget _buildOffersGrid() {
      return SliverPadding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 30),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final offer = offers[index];
              return _buildGridItemWrapper(
                index: index,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OfferDetailScreen(
                        offerId: offer['id'],
                        initialDistance: offer['distance'],
                      ),
                    ),
                  );
                },
                child: HomeOfferCard(offer: offer),
                isJob: false,
              );
            },
            childCount: offers.length,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 24,
            childAspectRatio: 0.62,
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
      // Alternate left/right tilt
      final angle = index.isEven ? -0.03 : 0.03;

      return GestureDetector(
        onTap: onTap,
        child: Transform.rotate(
          angle: angle, // radians
          child: child,
        ),
      );
    }


  }
