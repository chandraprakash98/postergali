import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postergali/core/localization/localization_service.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../posterman/bot_splash_screen.dart';
  import '../../data/models/job_filter.dart';
  import '../widgets/home_bottom_bar.dart';
  import '../widgets/home_cards.dart';
  import '../widgets/home_header.dart';
  import '../widgets/home_tabs.dart';
  import '../widgets/job_filter_sheet.dart';
  import '../widgets/offer_filter_sheet.dart';
  import '../widgets/result_header.dart';
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
  
    JobFilterModel jobFilter = JobFilterModel();
  
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
      "0-10,000",
      "10,001-20,000",
      "20,000 and above",
    ];
  
    final List<String> jobTypes = [
      "Full-time",
      "Part-time",
      "Temporary",
    ];
  
    String? _currentLocationName;
  double? _currentLatitude;
  double? _currentLongitude;

  @override
    void initState() {
      super.initState();
      _currentLocationName = widget.location;
      _currentLatitude = widget.latitude;
      _currentLongitude = widget.longitude;
      _scrollController.addListener(_scrollListener);
      fetchJobs();
    }

    void _showLocationSelector() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => LocationSelectorScreen(
            initialLat: _currentLatitude,
            initialLng: _currentLongitude,
          ),
        ),
      ).then((result) {
        if (result != null && result is Map<String, dynamic>) {
          setState(() {
            _currentLocationName = result['address'] ?? _currentLocationName;
            _currentLatitude = result['lat'] ?? _currentLatitude;
            _currentLongitude = result['lng'] ?? _currentLongitude;
          });
          if (selectedTab == 0) {
            fetchJobs();
          } else {
            fetchOffers();
          }
        }
      });
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
        "latitude": (_currentLatitude ?? widget.latitude).toString(),
        "longitude": (_currentLongitude ?? widget.longitude).toString(),
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
          latitude: _currentLatitude ?? widget.latitude,
          longitude: _currentLongitude ?? widget.longitude,
        );

        for (int i = 0; i < radiusList.length; i++) {
          final radius = radiusList[i];
          debugPrint("Trying initial radius: $radius km");
          
          final results = await _fetchByRadius(
            endpoint: "jobs",
            radius: radius,
            perPage: 50,
            extraQuery: query,
          );

          if (results.isNotEmpty) {
            jobs = results;
            currentRadiusIndex = i;
            break;
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
        for (int i = 0; i < radiusList.length; i++) {
          final radius = radiusList[i];
          debugPrint("Trying initial radius: $radius km");

          final results = await _fetchByRadius(
            endpoint: "offers",
            radius: radius,
            perPage: 50,
          );

          if (results.isNotEmpty) {
            offers = results;
            currentRadiusIndex = i;
            break;
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
          ? jobFilter.toQuery(
              latitude: _currentLatitude ?? widget.latitude,
              longitude: _currentLongitude ?? widget.longitude,
            )
          : null;

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

    void _showFilterBottomSheet() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return JobFilterSheet(
            initialFilter: jobFilter,
            jobCategories: jobCategories,
            expiryOptions: expiryOptions,
            salaryOptions: salaryOptions,
            jobTypes: jobTypes,
            onApply: (newFilter) {
              jobFilter = newFilter;
              fetchJobs();
            },
          );
        },
      );
    }
  
    void _showOfferFilterBottomSheet() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return OfferFilterSheet(
            onApply: (filters) {
              // Later call offer api with filters
              debugPrint("Offer filters applied: $filters");
            },
          );
        },
      );
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
              setState(() => selectedBottomIndex = index);
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
                        HomeHeader(
                          location: _currentLocationName ?? widget.location,
                          onLocationTap: _showLocationSelector,
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
                        HomeTabs(
                          selectedTab: selectedTab,
                          onJobsTap: fetchJobs,
                          onOffersTap: fetchOffers,
                        ),
                        const SizedBox(height: 24),
                        ResultHeader(
                          selectedTab: selectedTab,
                          resultsCount: selectedTab == 0 ? jobs.length : offers.length,
                          onFilterTap: () {
                            if (selectedTab == 0) {
                              _showFilterBottomSheet();
                            } else {
                              _showOfferFilterBottomSheet();
                            }
                          },
                        ),
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

                      _buildJobsGrid()

                    else
                      _buildOffersGrid(),

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
          padding: const EdgeInsets.only(left: 15, right: 10, top: 1),
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
                        builder: (_) => JobDetailScreen(jobId: job['id']),
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
              mainAxisSpacing: 1,
              childAspectRatio: 0.62,
            ),
          ),
        );
    }
  
    Widget _buildOffersGrid() {
      return SliverPadding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
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
                      builder: (_) => OfferDetailScreen(offerId: offer['id']),
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
            crossAxisSpacing: 26,
            mainAxisSpacing: 1,
              childAspectRatio: 0.50
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
