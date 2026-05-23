import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/jobfilter.dart';
import '../widgets/job_templates.dart';
import '../widgets/job_templates_small.dart';
import '../widgets/offer_templates.dart';
import 'job_detail_screen.dart';
import 'language_selection_screen.dart';
import 'offer_detail_screen.dart';

/// =======================================================
/// COLORS
/// =======================================================

const Color kPrimaryRed = Color(0xffCF5C4C);
const Color kDarkRed = Color(0xffA6473A);
const Color kGolden = Color(0xffF2AD36);
const Color kCream = Color(0xffFFF9F2);
const Color kLightCream = Color(0xffF8E5D2);
const Color kGreen = Color(0xff448655);
const Color kTextDark = Color(0xff2E211D);

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

  /// =====================================================
  /// FILTERS
  /// =====================================================

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

  /// =====================================================
  /// FETCH JOBS
  /// =====================================================
  /// =====================================================
  /// FETCH JOBS
  /// =====================================================

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

      query.removeWhere(
            (key, value) => value.isEmpty,
      );

      final uri = Uri.parse(
        'https://postergali.com/api/v1/jobs',
      ).replace(
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


  /// =====================================================
  /// FETCH OFFERS
  /// =====================================================

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

  /// =====================================================
  /// UI
  /// =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCream,

      extendBody: true,

      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,

      floatingActionButton: GestureDetector(
        onTap: () {},
        child: Container(
          height: 78,
          width: 78,

          decoration: BoxDecoration(
            shape: BoxShape.circle,

            gradient: const LinearGradient(
              colors: [
                kGolden,
                Color(0xffF7C767),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),

            border: Border.all(
              color: kCream,
              width: 7,
            ),

            boxShadow: [
              BoxShadow(
                color: kGolden.withOpacity(.45),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              ),
            ],
          ),

          child: const Icon(
            CupertinoIcons.add,
            size: 36,
            color: kPrimaryRed,
          ),
        ),
      ),

      bottomNavigationBar: _buildBottomBar(),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffFFF9F2),
              Color(0xffFCEEDF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
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
                      _buildHeader(),

                      const SizedBox(height: 28),

                      _buildTabs(),

                      const SizedBox(height: 24),

                      _buildResultHeader(),

                      const SizedBox(height: 22),
                    ],
                  ),
                ),
              ),

              /// LOADING
              if (isLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: kPrimaryRed,
                    ),
                  ),
                ),

              /// JOBS

              /// JOBS
              if (!isLoading && selectedTab == 0)
                SliverPadding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 8,
                  ),

                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final job = jobs[index];


                        return Container(
                          margin: EdgeInsets.only(
                            bottom: index < 2
                                ? 25
                                : index < 4
                                ? 10
                                : 0,
                          ),

                          child: Transform.translate(
                            offset: Offset(
                              index.isEven ? -4 : 4,

                              index % 6 == 0
                                  ? 0
                                  : index % 6 == 1
                                  ? 16
                                  : index % 6 == 2
                                  ? -10
                                  : index % 6 == 3
                                  ? 18
                                  : index % 6 == 4
                                  ? -12
                                  : 8,
                            ),

                            child: Transform.rotate(
                              angle: index.isEven
                                  ? -0.045
                                  : 0.045,

                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => JobDetailScreen(
                                        jobId: job['id'],
                                      ),
                                    ),
                                  );
                                },

                                child: _buildJobCard(job),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: jobs.length,
                    ),

                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,

                      crossAxisSpacing: 5,
                      mainAxisSpacing: 8,

                      childAspectRatio: 0.62,
                    ),
                  ),
                ),
              /// OFFERS
              /// OFFERS
              if (!isLoading && selectedTab == 1)
                SliverPadding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 8,
                  ),

                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final offer = offers[index];

                        return Transform.translate(
                          offset: Offset(
                            index.isEven ? -4 : 4,

                            index % 6 == 0
                                ? 0
                                : index % 6 == 1
                                ? 16
                                : index % 6 == 2
                                ? -10
                                : index % 6 == 3
                                ? 18
                                : index % 6 == 4
                                ? -12
                                : 8,
                          ),

                          child: Transform.rotate(
                            angle: index.isEven
                                ? -0.045
                                : 0.045,

                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        OfferDetailScreen(
                                          offerId: offer['id'],
                                        ),
                                  ),
                                );
                              },

                              child: _buildOfferCard(offer),
                            ),
                          ),
                        );
                      },
                      childCount: offers.length,
                    ),

                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,

                      crossAxisSpacing: 5,
                      mainAxisSpacing: 8,

                      childAspectRatio: 0.62,
                    ),
                  ),
                ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 130),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// =====================================================
  /// HEADER
  /// =====================================================

  Widget _buildHeader() {

    final borderRadius = BorderRadius.circular(34);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        /// TOP HEADER
        Row(
          children: [

            /// LEFT SIDE
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  /// APP NAME
                  Text(
                    "PosterGali",

                    style: TextStyle(
                      fontFamily: 'ClashDisplay',
                      fontSize: 40,
                      height: 1,
                      letterSpacing: -1.5,
                      fontWeight: FontWeight.w700,
                      color: kPrimaryRed,

                      shadows: [
                        Shadow(
                          color:
                          Colors.black.withOpacity(.08),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// LOCATION
                  Row(
                    children: [

                      /// LOCATION ICON
                      Container(
                        height: 30,
                        width: 30,

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,

                          gradient: LinearGradient(
                            colors: [
                              kGolden.withOpacity(.22),
                              kGolden.withOpacity(.08),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),

                          border: Border.all(
                            color:
                            kGolden.withOpacity(.18),
                          ),
                        ),

                        child: const Icon(
                          CupertinoIcons.location_solid,
                          size: 14,
                          color: kPrimaryRed,
                        ),
                      ),

                      const SizedBox(width: 10),

                      /// LOCATION TEXT
                      Expanded(
                        child: Text(
                          widget.location,

                          maxLines: 1,
                          overflow:
                          TextOverflow.ellipsis,

                          style: TextStyle(
                            fontFamily:
                            'HelveticaNeue',
                            fontSize: 14,
                            fontWeight:
                            FontWeight.w700,
                            color: kTextDark
                                .withOpacity(.72),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// LANGUAGE BUTTON
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const LanguageSelectionScreen(),
                  ),
                );
              },

              child: Container(
                height: 58,
                width: 58,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  gradient: const LinearGradient(
                    colors: [
                      kPrimaryRed,
                      kDarkRed,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color:
                      kPrimaryRed.withOpacity(.35),
                      blurRadius: 18,
                      spreadRadius: 1,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),

                child: const Icon(
                  CupertinoIcons.globe,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        /// 3D MATERIAL BANNER
        Container(
          height: 189,
          width: double.infinity,

          decoration: BoxDecoration(
            borderRadius: borderRadius,

            /// IMAGE
            image: const DecorationImage(
              image: AssetImage(
                'assets/images/img_5.png',
              ),
              fit: BoxFit.cover,
            ),


          ),

          child: ClipRRect(
            borderRadius: borderRadius,

            child: Stack(
              children: [


                /// LIGHT REFLECTION
                Positioned(
                  top: -40,
                  right: -20,

                  child: Container(
                    height: 140,
                    width: 140,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                      Colors.white.withOpacity(.10),
                    ),
                  ),
                ),



              ],
            ),
          ),
        ),
      ],
    );
  }
  /// =====================================================
  /// TABS
  /// =====================================================

  Widget _buildTabs() {
    return Container(
      height: 68,

      padding: const EdgeInsets.all(5),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: fetchJobs,

              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),

                  gradient: selectedTab == 0
                      ? const LinearGradient(
                    colors: [
                      kPrimaryRed,
                      kDarkRed,
                    ],
                  )
                      : null,
                ),

                child: Center(
                  child: Text(
                    "Jobs",

                    style: TextStyle(
                      fontFamily: 'ClashDisplay',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: selectedTab == 0
                          ? Colors.white
                          : kTextDark,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: GestureDetector(
              onTap: fetchOffers,

              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),

                  gradient: selectedTab == 1
                      ? const LinearGradient(
                    colors: [
                      kPrimaryRed,
                      kDarkRed,
                    ],
                  )
                      : null,
                ),

                child: Center(
                  child: Text(
                    "Offers",

                    style: TextStyle(
                      fontFamily: 'ClashDisplay',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: selectedTab == 1
                          ? Colors.white
                          : kTextDark,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// =====================================================
  /// RESULT HEADER
  /// =====================================================

  Widget _buildResultHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              selectedTab == 0
                  ? "Trending Jobs"
                  : "Latest Offers",

              style: const TextStyle(
                fontFamily: 'ClashDisplay',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: kTextDark,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              "${selectedTab == 0 ? jobs.length : offers.length} results available",

              style: TextStyle(
                fontFamily: 'HelveticaNeue',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: kTextDark.withOpacity(.55),
              ),
            ),
          ],
        ),

        GestureDetector(
          onTap: () {
            if (selectedTab == 0) {
              _showFilterBottomSheet();
            } else {
              _showOfferFilterBottomSheet();
            }
          },

          child: Container(
            height: 52,
            width: 52,

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),

            child: const Icon(
              CupertinoIcons.slider_horizontal_3,
              color: kPrimaryRed,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  /// =====================================================
  /// FILTER SHEET
  /// =====================================================

  /// =====================================================
  /// FILTER SHEET
  /// =====================================================

  void _showFilterBottomSheet() {
    List<String> selectedCategories =
    List.from(jobFilter.categories);

    String? selectedExpiry = jobFilter.expiry;
    String? selectedJobType = jobFilter.jobType;
    String? selectedSalary = jobFilter.salary;

    bool subCategoryExpanded = true;
    bool expiryExpanded = true;
    bool jobTypeExpanded = true;
    bool salaryExpanded = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              height:
              MediaQuery.of(context).size.height * .92,

              decoration: const BoxDecoration(
                color: Color(0xffF5F5F5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),

              child: SafeArea(
                top: false,

                child: Column(
                  children: [

                    /// HEADER
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        22,
                        20,
                        22,
                        18,
                      ),

                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },

                            child: const Icon(
                              CupertinoIcons.back,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),

                          const SizedBox(width: 14),

                          const Text(
                            "Filters",
                            style: TextStyle(
                              fontFamily: 'ClashDisplay',
                              fontSize: 34,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [

                            /// =====================================
                            /// SUB CATEGORY
                            /// =====================================

                            _buildFilterHeader(
                              title: "Sub Category",
                              expanded: subCategoryExpanded,
                              onTap: () {
                                setSheetState(() {
                                  subCategoryExpanded =
                                  !subCategoryExpanded;
                                });
                              },
                            ),

                            if (subCategoryExpanded)
                              Column(
                                children:
                                jobCategories.map((e) {
                                  final selected =
                                  selectedCategories
                                      .contains(e);

                                  return InkWell(
                                    onTap: () {
                                      setSheetState(() {
                                        if (selected) {
                                          selectedCategories
                                              .remove(e);
                                        } else {
                                          selectedCategories
                                              .add(e);
                                        }
                                      });
                                    },

                                    child: Container(
                                      height: 70,
                                      padding:
                                      const EdgeInsets
                                          .symmetric(
                                        horizontal: 22,
                                      ),

                                      decoration:
                                      const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color:
                                            Colors.black12,
                                          ),
                                        ),
                                      ),

                                      child: Row(
                                        children: [

                                          /// CHECKBOX
                                          Container(
                                            height: 24,
                                            width: 24,

                                            decoration:
                                            BoxDecoration(
                                              color: selected
                                                  ? Colors.black
                                                  : Colors
                                                  .transparent,

                                              border:
                                              Border.all(
                                                color:
                                                Colors.black54,
                                                width: 1.5,
                                              ),
                                            ),

                                            child: selected
                                                ? const Icon(
                                              Icons.check,
                                              size: 16,
                                              color: Colors
                                                  .white,
                                            )
                                                : null,
                                          ),

                                          const SizedBox(
                                              width: 18),

                                          Expanded(
                                            child: Text(
                                              e,

                                              style:
                                              const TextStyle(
                                                fontFamily:
                                                'HelveticaNeue',
                                                fontSize: 17,
                                                fontWeight:
                                                FontWeight
                                                    .w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),

                            /// =====================================
                            /// EXPIRY
                            /// =====================================

                            _buildFilterHeader(
                              title: "Expiry",
                              expanded: expiryExpanded,
                              onTap: () {
                                setSheetState(() {
                                  expiryExpanded =
                                  !expiryExpanded;
                                });
                              },
                            ),

                            if (expiryExpanded)
                              Column(
                                children:
                                expiryOptions.map((e) {
                                  return InkWell(
                                    onTap: () {
                                      setSheetState(() {
                                        selectedExpiry = e;
                                      });
                                    },

                                    child: Container(
                                      height: 80,
                                      padding:
                                      const EdgeInsets
                                          .symmetric(
                                        horizontal: 22,
                                      ),

                                      decoration:
                                      const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color:
                                            Colors.black12,
                                          ),
                                        ),
                                      ),

                                      child: Row(
                                        children: [

                                          /// RADIO
                                          Container(
                                            height: 28,
                                            width: 28,

                                            decoration:
                                            BoxDecoration(
                                              shape:
                                              BoxShape.circle,

                                              border:
                                              Border.all(
                                                color:
                                                Colors.black45,
                                              ),
                                            ),

                                            child: Center(
                                              child: Container(
                                                height: 16,
                                                width: 16,

                                                decoration:
                                                BoxDecoration(
                                                  shape: BoxShape
                                                      .circle,

                                                  color:
                                                  selectedExpiry ==
                                                      e
                                                      ? Colors
                                                      .grey
                                                      : Colors
                                                      .transparent,
                                                ),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(
                                              width: 18),

                                          Text(
                                            e,

                                            style:
                                            const TextStyle(
                                              fontFamily:
                                              'HelveticaNeue',
                                              fontSize: 17,
                                              fontWeight:
                                              FontWeight
                                                  .w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),

                            /// =====================================
                            /// JOB TYPE
                            /// =====================================

                            _buildFilterHeader(
                              title: "Job Type",
                              expanded: jobTypeExpanded,
                              onTap: () {
                                setSheetState(() {
                                  jobTypeExpanded =
                                  !jobTypeExpanded;
                                });
                              },
                            ),

                            if (jobTypeExpanded)
                              Padding(
                                padding:
                                const EdgeInsets.all(20),

                                child: Container(
                                  height: 58,

                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                  ),

                                  child: Row(
                                    children: jobTypes.map((e) {
                                      final selected =
                                          selectedJobType ==
                                              e;

                                      return Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            setSheetState(() {
                                              selectedJobType =
                                                  e;
                                            });
                                          },

                                          child:
                                          AnimatedContainer(
                                            duration:
                                            const Duration(
                                              milliseconds:
                                              250,
                                            ),

                                            color: selected
                                                ? Colors.black
                                                : Colors
                                                .transparent,

                                            child: Center(
                                              child: Text(
                                                e,

                                                style:
                                                TextStyle(
                                                  fontFamily:
                                                  'HelveticaNeue',
                                                  fontSize: 16,
                                                  fontWeight:
                                                  FontWeight
                                                      .w700,

                                                  color: selected
                                                      ? Colors
                                                      .white
                                                      : Colors
                                                      .black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),

                            /// =====================================
                            /// SALARY
                            /// =====================================

                            _buildFilterHeader(
                              title: "Job Salary",
                              expanded: salaryExpanded,
                              onTap: () {
                                setSheetState(() {
                                  salaryExpanded =
                                  !salaryExpanded;
                                });
                              },
                            ),

                            if (salaryExpanded)
                              Column(
                                children:
                                salaryOptions.map((e) {
                                  return InkWell(
                                    onTap: () {
                                      setSheetState(() {
                                        selectedSalary = e;
                                      });
                                    },

                                    child: Container(
                                      height: 80,
                                      padding:
                                      const EdgeInsets
                                          .symmetric(
                                        horizontal: 22,
                                      ),

                                      decoration:
                                      const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color:
                                            Colors.black12,
                                          ),
                                        ),
                                      ),

                                      child: Row(
                                        children: [

                                          /// RADIO
                                          Container(
                                            height: 28,
                                            width: 28,

                                            decoration:
                                            BoxDecoration(
                                              shape:
                                              BoxShape.circle,

                                              border:
                                              Border.all(
                                                color:
                                                Colors.black45,
                                              ),
                                            ),

                                            child: Center(
                                              child: Container(
                                                height: 16,
                                                width: 16,

                                                decoration:
                                                BoxDecoration(
                                                  shape: BoxShape
                                                      .circle,

                                                  color:
                                                  selectedSalary ==
                                                      e
                                                      ? Colors
                                                      .grey
                                                      : Colors
                                                      .transparent,
                                                ),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(
                                              width: 18),

                                          Text(
                                            e,

                                            style:
                                            const TextStyle(
                                              fontFamily:
                                              'HelveticaNeue',
                                              fontSize: 17,
                                              fontWeight:
                                              FontWeight
                                                  .w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),

                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),

                    /// BOTTOM BUTTONS
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        12,
                        20,
                        24,
                      ),

                      child: Row(
                        children: [

                          /// CLEAR
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setSheetState(() {
                                  selectedCategories = [];
                                  selectedExpiry = null;
                                  selectedJobType = null;
                                  selectedSalary = null;
                                });
                              },

                              child: Container(
                                height: 62,

                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(
                                      100),

                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.5,
                                  ),
                                ),

                                child: const Center(
                                  child: Text(
                                    "Clear",

                                    style: TextStyle(
                                      fontFamily:
                                      'HelveticaNeue',
                                      fontSize: 17,
                                      fontWeight:
                                      FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 18),

                          /// APPLY
                          Expanded(
                            flex: 2,

                            child: GestureDetector(
                              onTap: () async {

                                jobFilter =
                                    JobFilterModel(
                                      categories:
                                      selectedCategories,
                                      expiry:
                                      selectedExpiry,
                                      jobType:
                                      selectedJobType,
                                      salary:
                                      selectedSalary,
                                    );

                                Navigator.pop(context);

                                await fetchJobs();
                              },

                              child: Container(
                                height: 62,

                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius:
                                  BorderRadius.circular(
                                      100),
                                ),

                                child: Center(
                                  child: Text(
                                    "Show Jobs",

                                    style: const TextStyle(
                                      fontFamily:
                                      'HelveticaNeue',
                                      fontSize: 17,
                                      fontWeight:
                                      FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// =====================================================
  /// FILTER HEADER
  /// =====================================================

  Widget _buildFilterHeader({
    required String title,
    required bool expanded,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      child: Container(
        height: 76,

        padding: const EdgeInsets.symmetric(
          horizontal: 22,
        ),

        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.black12,
            ),
            bottom: BorderSide(
              color: Colors.black12,
            ),
          ),
        ),

        child: Row(
          children: [
            Expanded(
              child: Text(
                title,

                style: const TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),

            Icon(
              expanded
                  ? CupertinoIcons.chevron_up
                  : CupertinoIcons.chevron_down,

              color: Colors.black,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  /// =====================================================
  /// JOB CARD
  /// =====================================================

  Widget _buildJobCard(dynamic job) {
    Widget card;

    switch (job['temp_id']) {
      case 'T001':
        card = JobTemplatesSmall.templateT001(job);
        break;

      case 'T002':
        card = JobTemplatesSmall.templateT002(job);
        break;

      case 'T003':
        card = JobTemplatesSmall.templateT003(job);
        break;

      case 'T004':
        card = JobTemplates.templateT004(job);
        break;

      default:
        card = JobTemplates.defaultTemplate(job);
    }

    return Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(1),
            child: card,
          ),
        ),

        Positioned(
          top: 7,
          right: 7,

          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 7,
              vertical: 3,
            ),

            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.50),
              borderRadius: BorderRadius.circular(20),
            ),

            child: Row(
              mainAxisSize: MainAxisSize.min,

              children: [
                const Icon(
                  CupertinoIcons.eye_fill,
                  size: 10,
                  color: Colors.white,
                ),

                const SizedBox(width: 3),

                Text(
                  "${job['view_count'] ?? 0}",

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  /// =====================================================
  /// OFFER CARD
  /// =====================================================

  Widget _buildOfferCard(dynamic offer) {
    Widget card;

    switch (offer['temp_id']) {
      case 'T001':
        card = OfferTemplates.templateT001(offer);
        break;

      case 'T002':
        card = OfferTemplates.templateT002(offer);
        break;

      case 'T003':
        card = OfferTemplates.templateT003(offer);
        break;

      case 'T004':
        card = OfferTemplates.templateT004(offer);
        break;

      default:
        card = OfferTemplates.defaultTemplate(offer);
    }

    return Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(1),
            child: card,
          ),
        ),

        Positioned(
          top: 7,
          right: 7,

          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 7,
              vertical: 3,
            ),

            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.50),
              borderRadius: BorderRadius.circular(20),
            ),

            child: Row(
              mainAxisSize: MainAxisSize.min,

              children: [
                const Icon(
                  CupertinoIcons.eye_fill,
                  size: 10,
                  color: Colors.white,
                ),

                const SizedBox(width: 3),

                Text(
                  "${offer['view_count'] ?? 0}",

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// =====================================================
  /// BOTTOM NAVIGATION
  /// =====================================================

  Widget _buildBottomBar() {
    return Container(
      height: 82,



      decoration: BoxDecoration(
        color: kPrimaryRed,
        borderRadius: BorderRadius.circular(2),

        boxShadow: [
          BoxShadow(
            color: kPrimaryRed.withOpacity(.25),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Stack(
        clipBehavior: Clip.none,

        alignment: Alignment.topCenter,

        children: [
          Positioned(
            top: -38,

            child: Container(
              width: 103,
              height: 85,

              decoration: BoxDecoration(
                color: kCream,
                shape: BoxShape.circle,
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: [
              _navItem(
                index: 0,
                icon: CupertinoIcons.house_fill,
                title: "Home",
              ),

              _navItem(
                index: 1,
                icon: CupertinoIcons.location_fill,
                title: "Location",
              ),

              const SizedBox(width: 70),


              _navItem(
                index: 2,
                icon: CupertinoIcons.heart_fill,
                title: "Liked",
              ),

              _navItem(
                index: 3,
                icon: CupertinoIcons.doc_text_fill,
                title: "MyPoster",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required int index,
    required IconData icon,
    required String title,
  }) {
    final isSelected = selectedBottomIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedBottomIndex = index;
        });
      },

      child: SizedBox(
        width: 72,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),

              height: 4,
              width: isSelected ? 28 : 0,

              decoration: BoxDecoration(
                color: kGolden,
                borderRadius: BorderRadius.circular(100),
              ),
            ),

            const SizedBox(height: 10),

            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : Colors.white.withOpacity(.7),
              size: 25,
            ),

            const SizedBox(height: 4),

            Text(
              title,

              style: TextStyle(
                fontFamily: 'HelveticaNeue',
                color: isSelected
                    ? Colors.white
                    : Colors.white.withOpacity(.7),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// =====================================================
  /// OFFER FILTER SHEET
  /// =====================================================

  void _showOfferFilterBottomSheet() {

    bool categoryExpanded = true;
    bool discountExpanded = true;
    bool validityExpanded = true;

    String selectedDiscount = "50% Off";
    String selectedValidity = "Today";

    List<String> selectedCategories = [
      "Food",
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

    final List<String> discounts = [
      "10% Off",
      "25% Off",
      "50% Off",
      "Flat ₹100",
    ];

    final List<String> validity = [
      "Today",
      "This Week",
      "This Month",
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,

      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {

            return Container(
              height:
              MediaQuery.of(context).size.height * .92,

              decoration: const BoxDecoration(
                color: Color(0xffF5F5F5),

                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),

              child: SafeArea(
                top: false,

                child: Column(
                  children: [

                    /// HEADER
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        22,
                        20,
                        22,
                        18,
                      ),

                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },

                            child: const Icon(
                              CupertinoIcons.back,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),

                          const SizedBox(width: 14),

                          const Text(
                            "Offer Filters",

                            style: TextStyle(
                              fontFamily: 'ClashDisplay',
                              fontSize: 34,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [

                            /// =====================================
                            /// CATEGORY
                            /// =====================================

                            _buildFilterHeader(
                              title: "Offer Category",
                              expanded: categoryExpanded,

                              onTap: () {
                                setSheetState(() {
                                  categoryExpanded =
                                  !categoryExpanded;
                                });
                              },
                            ),

                            if (categoryExpanded)
                              Column(
                                children:
                                offerCategories.map((e) {

                                  final selected =
                                  selectedCategories
                                      .contains(e);

                                  return InkWell(
                                    onTap: () {

                                      setSheetState(() {

                                        if (selected) {
                                          selectedCategories
                                              .remove(e);
                                        } else {
                                          selectedCategories
                                              .add(e);
                                        }
                                      });
                                    },

                                    child: Container(
                                      height: 70,

                                      padding:
                                      const EdgeInsets
                                          .symmetric(
                                        horizontal: 22,
                                      ),

                                      decoration:
                                      const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color:
                                            Colors.black12,
                                          ),
                                        ),
                                      ),

                                      child: Row(
                                        children: [

                                          /// CHECKBOX
                                          Container(
                                            height: 24,
                                            width: 24,

                                            decoration:
                                            BoxDecoration(
                                              color: selected
                                                  ? Colors.black
                                                  : Colors
                                                  .transparent,

                                              border:
                                              Border.all(
                                                color:
                                                Colors.black54,
                                                width: 1.5,
                                              ),
                                            ),

                                            child: selected
                                                ? const Icon(
                                              Icons.check,
                                              size: 16,
                                              color: Colors
                                                  .white,
                                            )
                                                : null,
                                          ),

                                          const SizedBox(
                                              width: 18),

                                          Expanded(
                                            child: Text(
                                              e,

                                              style:
                                              const TextStyle(
                                                fontFamily:
                                                'HelveticaNeue',
                                                fontSize: 17,
                                                fontWeight:
                                                FontWeight
                                                    .w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),

                            /// =====================================
                            /// DISCOUNT
                            /// =====================================

                            _buildFilterHeader(
                              title: "Discount",
                              expanded: discountExpanded,

                              onTap: () {
                                setSheetState(() {
                                  discountExpanded =
                                  !discountExpanded;
                                });
                              },
                            ),

                            if (discountExpanded)
                              Column(
                                children:
                                discounts.map((e) {

                                  return InkWell(
                                    onTap: () {

                                      setSheetState(() {
                                        selectedDiscount = e;
                                      });
                                    },

                                    child: Container(
                                      height: 80,

                                      padding:
                                      const EdgeInsets
                                          .symmetric(
                                        horizontal: 22,
                                      ),

                                      decoration:
                                      const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color:
                                            Colors.black12,
                                          ),
                                        ),
                                      ),

                                      child: Row(
                                        children: [

                                          /// RADIO
                                          Container(
                                            height: 28,
                                            width: 28,

                                            decoration:
                                            BoxDecoration(
                                              shape:
                                              BoxShape.circle,

                                              border:
                                              Border.all(
                                                color:
                                                Colors.black45,
                                              ),
                                            ),

                                            child: Center(
                                              child: Container(
                                                height: 16,
                                                width: 16,

                                                decoration:
                                                BoxDecoration(
                                                  shape: BoxShape
                                                      .circle,

                                                  color:
                                                  selectedDiscount ==
                                                      e
                                                      ? Colors
                                                      .grey
                                                      : Colors
                                                      .transparent,
                                                ),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(
                                              width: 18),

                                          Text(
                                            e,

                                            style:
                                            const TextStyle(
                                              fontFamily:
                                              'HelveticaNeue',
                                              fontSize: 17,
                                              fontWeight:
                                              FontWeight
                                                  .w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),

                            /// =====================================
                            /// VALIDITY
                            /// =====================================

                            _buildFilterHeader(
                              title: "Offer Validity",
                              expanded: validityExpanded,

                              onTap: () {
                                setSheetState(() {
                                  validityExpanded =
                                  !validityExpanded;
                                });
                              },
                            ),

                            if (validityExpanded)
                              Padding(
                                padding:
                                const EdgeInsets.all(20),

                                child: Container(
                                  height: 58,

                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                  ),

                                  child: Row(
                                    children:
                                    validity.map((e) {

                                      final selected =
                                          selectedValidity ==
                                              e;

                                      return Expanded(
                                        child: GestureDetector(
                                          onTap: () {

                                            setSheetState(() {
                                              selectedValidity =
                                                  e;
                                            });
                                          },

                                          child:
                                          AnimatedContainer(
                                            duration:
                                            const Duration(
                                              milliseconds:
                                              250,
                                            ),

                                            color: selected
                                                ? Colors.black
                                                : Colors
                                                .transparent,

                                            child: Center(
                                              child: Text(
                                                e,

                                                style:
                                                TextStyle(
                                                  fontFamily:
                                                  'HelveticaNeue',
                                                  fontSize: 15,
                                                  fontWeight:
                                                  FontWeight
                                                      .w700,

                                                  color: selected
                                                      ? Colors
                                                      .white
                                                      : Colors
                                                      .black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),

                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),

                    /// BOTTOM BUTTONS
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        12,
                        20,
                        24,
                      ),

                      child: Row(
                        children: [

                          /// CLEAR
                          Expanded(
                            child: GestureDetector(
                              onTap: () {

                                setSheetState(() {
                                  selectedCategories = [];
                                  selectedDiscount = "";
                                  selectedValidity = "";
                                });
                              },

                              child: Container(
                                height: 62,

                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(
                                      100),

                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.5,
                                  ),
                                ),

                                child: const Center(
                                  child: Text(
                                    "Clear",

                                    style: TextStyle(
                                      fontFamily:
                                      'HelveticaNeue',
                                      fontSize: 17,
                                      fontWeight:
                                      FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 18),

                          /// APPLY
                          Expanded(
                            flex: 2,

                            child: GestureDetector(
                              onTap: () {

                                Navigator.pop(context);

                                /// later call offer api
                              },

                              child: Container(
                                height: 62,

                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius:
                                  BorderRadius.circular(
                                      100),
                                ),

                                child: const Center(
                                  child: Text(
                                    "Show Offers",

                                    style: TextStyle(
                                      fontFamily:
                                      'HelveticaNeue',
                                      fontSize: 17,
                                      fontWeight:
                                      FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}