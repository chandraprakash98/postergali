  import 'dart:convert';
  
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
  import 'package:http/http.dart' as http;
  
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
    int selectedTab = 0;
    int selectedBottomIndex = 0;
    bool isLoading = true;
  
    List<dynamic> jobs = [];
    List<dynamic> offers = [];
  
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
  
    @override
    void initState() {
      super.initState();
      fetchJobs();
    }
  
    Future<void> fetchJobs() async {
      setState(() {
        isLoading = true;
        selectedTab = 0;
      });
  
      try {
        final query = jobFilter.toQuery(
          latitude: widget.latitude,
          longitude: widget.longitude,
        );
  
        query.removeWhere((key, value) => value.isEmpty);
  
        final uri = Uri.parse('https://postergali.com/api/v1/jobs').replace(
          queryParameters: query,
        );
  
        debugPrint(uri.toString());
  
        final response = await http.get(uri);
  
        if (response.statusCode == 200) {
          jobs = jsonDecode(response.body);
        }
      } catch (e) {
        debugPrint(e.toString());
      }
  
      setState(() {
        isLoading = false;
      });
    }
  
    Future<void> fetchOffers() async {
      setState(() {
        isLoading = true;
        selectedTab = 1;
      });
  
      try {
        final response = await http.get(
          Uri.parse('https://postergali.com/api/v1/offers'),
        );
  
        if (response.statusCode == 200) {
          offers = jsonDecode(response.body);
        }
      } catch (e) {
        debugPrint(e.toString());
      }
  
      setState(() {
        isLoading = false;
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
          decoration: const BoxDecoration(
            color: Color(0xfffff3d5),
          ),
          child: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HomeHeader(
                          location: widget.location,
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
                      child: CircularProgressIndicator(color: AppColors.primaryRed),
                    ),
                  )
                else if (selectedTab == 0)
                  _buildJobsGrid()
                else
                  _buildOffersGrid(),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 130),
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
