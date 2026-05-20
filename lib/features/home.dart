import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/job_templates.dart';
import '../widgets/offer_templates.dart';
import 'job_detail_screen.dart';
import 'language_selection_screen.dart';
import 'offer_detail_screen.dart';

class HomeScreen extends StatefulWidget {

  final String location;

  const HomeScreen({
    super.key,
    required this.location,
  });

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {

  int selectedTab = 0;

  bool isLoading = true;

  List<dynamic> jobs = [];
  List<dynamic> offers = [];

  /// FILTERS

  bool showSubCategory = false;
  bool showExpiry = false;
  bool showJobType = false;
  bool showSalary = false;

  List<String> selectedSubCategories = [];

  String selectedExpiry = '';

  String selectedJobType = 'Full-time';

  String selectedSalary = '';

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  /// =====================================================
  /// FETCH JOBS
  /// =====================================================

  Future<void> fetchJobs() async {

    setState(() {
      isLoading = true;
    });

    try {

      final response = await http.get(
        Uri.parse(
          'https://postergali.com/api/v1/jobs',
        ),
      );

      if (response.statusCode == 200) {

        jobs = jsonDecode(response.body);

        setState(() {
          selectedTab = 0;
          isLoading = false;
        });

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

  /// =====================================================
  /// FETCH OFFERS
  /// =====================================================

  Future<void> fetchOffers() async {

    setState(() {
      isLoading = true;
    });

    try {

      final response = await http.get(
        Uri.parse(
          'https://postergali.com/api/v1/offers',
        ),
      );

      if (response.statusCode == 200) {

        offers = jsonDecode(response.body);

        setState(() {
          selectedTab = 1;
          isLoading = false;
        });

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

  /// =====================================================
  /// UI
  /// =====================================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xffF6F7FB),

      bottomNavigationBar:
      _buildBottomBar(),

      floatingActionButtonLocation:
      FloatingActionButtonLocation
          .centerDocked,

      floatingActionButton:
      Container(
        height: 76,
        width: 76,

        decoration: BoxDecoration(
          shape: BoxShape.circle,

          gradient:
          const LinearGradient(
            colors: [
              Color(0xff6C63FF),
              Color(0xff8E7BFF),
            ],
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple
                  .withOpacity(.18),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: const Icon(
          Icons.add,
          size: 38,
          color: Colors.white,
        ),
      ),

      body: SafeArea(

        child: CustomScrollView(

          cacheExtent: 1000,

          physics:
          const BouncingScrollPhysics(),

          slivers: [

            /// HEADER

            SliverPadding(
              padding:
              const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 18,
              ),

              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    _buildHeader(),

                    const SizedBox(height: 20),

                    _buildReferCard(),

                    const SizedBox(height: 18),

                    _buildTabs(),

                    const SizedBox(height: 10),

                    _buildResultHeader(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            /// LOADING

            if (isLoading)
              const SliverFillRemaining(
                child: Center(
                  child:
                  CircularProgressIndicator(),
                ),
              ),

            /// JOB GRID

            if (!isLoading &&
                selectedTab == 0)

              SliverPadding(

                padding:
                const EdgeInsets.symmetric(
                  horizontal: 14,
                ),

                sliver: SliverGrid(

                  delegate:
                  SliverChildBuilderDelegate(

                        (context, index) {

                      final job = jobs[index];

                      return Transform.translate(

                        offset: Offset(
                          index.isEven ? -6 : 6,
                          index % 4 == 0
                              ? 0
                              : index % 4 == 1
                              ? 18
                              : index % 4 == 2
                              ? -10
                              : 12,
                        ),

                        child: Transform.rotate(

                          angle:
                          index.isEven
                              ? -0.05
                              : 0.05,

                          child: GestureDetector(

                            onTap: () {

                              Navigator.push(

                                context,

                                MaterialPageRoute(

                                  builder: (_) =>
                                      JobDetailScreen(
                                        jobId: job['id'],
                                      ),
                                ),
                              );
                            },

                            child: RepaintBoundary(
                              child:
                              _buildJobCard(job),
                            ),
                          ),
                        ),
                      );
                    },

                    childCount:
                    jobs.length,
                  ),

                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(

                    crossAxisCount: 2,

                    crossAxisSpacing: 10,

                    mainAxisSpacing: 14,

                    childAspectRatio: 0.62,
                  ),
                ),
              ),

            /// OFFER GRID

            if (!isLoading &&
                selectedTab == 1)

              SliverPadding(

                padding:
                const EdgeInsets.symmetric(
                  horizontal: 14,
                ),

                sliver: SliverGrid(

                  delegate:
                  SliverChildBuilderDelegate(

                        (context, index) {

                      final offer =
                      offers[index];

                      return Transform.translate(

                        offset: Offset(
                          index.isEven ? -6 : 6,
                          index % 4 == 0
                              ? 0
                              : index % 4 == 1
                              ? 18
                              : index % 4 == 2
                              ? -10
                              : 12,
                        ),

                        child: Transform.rotate(

                          angle:
                          index.isEven
                              ? -0.05
                              : 0.05,

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

                            child: RepaintBoundary(
                              child:
                              _buildOfferCard(
                                offer,
                              ),
                            ),
                          ),
                        ),
                      );
                    },

                    childCount:
                    offers.length,
                  ),

                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(

                    crossAxisCount: 2,

                    crossAxisSpacing: 10,

                    mainAxisSpacing: 14,

                    childAspectRatio: 0.62,
                  ),
                ),
              ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 120),
            ),
          ],
        ),
      ),
    );
  }

  /// =====================================================
  /// HEADER
  /// =====================================================

  Widget _buildHeader() {

    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        /// TOP ROW

        Row(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

          children: [

            Expanded(

              child: ShaderMask(

                shaderCallback: (bounds) {

                  return const LinearGradient(
                    colors: [
                      Color(0xff5B5FFF),
                      Color(0xff9B51E0),
                    ],
                  ).createShader(bounds);
                },

                child: const Text(
                  "PosterGali",

                  maxLines: 1,

                  overflow:
                  TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: 38,
                    fontWeight:
                    FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -1.5,
                    height: 1,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 14),

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

                height: 52,
                width: 52,

                alignment: Alignment.center,

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                  BorderRadius.circular(18),

                  boxShadow: [
                    BoxShadow(
                      color:
                      Colors.black.withOpacity(.05),
                      blurRadius: 8,
                      offset:
                      const Offset(0, 3),
                    ),
                  ],
                ),

                child: const Icon(
                  CupertinoIcons.globe,
                  color: Color(0xff5B5FFF),
                  size: 26,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        /// LOCATION

        Container(

          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),

          decoration: BoxDecoration(

            color: Colors.white,

            borderRadius:
            BorderRadius.circular(18),

            boxShadow: [
              BoxShadow(
                color:
                Colors.black.withOpacity(.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),

          child: Row(
            children: [

              const Icon(
                CupertinoIcons.location_solid,
                color: Color(0xffFF6B6B),
                size: 20,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  widget.location,

                  maxLines: 1,

                  overflow:
                  TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w700,
                    color:
                    Color(0xff374151),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// =====================================================
  /// REFER CARD
  /// =====================================================

  Widget _buildReferCard() {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(

        gradient:
        const LinearGradient(
          colors: [
            Color(0xffd87715),
            Color(0xff9B51E0),
          ],
        ),

        borderRadius:
        BorderRadius.circular(20),
      ),

      child: const Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Text(
            "Refer & Win",

            style: TextStyle(
              fontSize: 20,
              fontWeight:
              FontWeight.w900,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 5),

          Text(
            "Invite your friends and unlock exciting rewards on every successful referral.",

            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              fontWeight:
              FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// =====================================================
  /// TABS
  /// =====================================================

  Widget _buildTabs() {

    return Container(

      height: 64,

      padding: const EdgeInsets.all(6),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(26),

        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(.03),
            blurRadius: 6,
          ),
        ],
      ),

      child: Row(
        children: [

          Expanded(
            child: GestureDetector(

              onTap: fetchJobs,

              child: AnimatedContainer(

                duration:
                const Duration(
                  milliseconds: 220,
                ),

                decoration: BoxDecoration(

                  gradient:
                  selectedTab == 0
                      ? const LinearGradient(
                    colors: [
                      Color(0xff5B5FFF),
                      Color(0xff8E7BFF),
                    ],
                  )
                      : null,

                  borderRadius:
                  BorderRadius.circular(22),
                ),

                child: Center(

                  child: Text(
                    "Jobs",

                    style: TextStyle(
                      fontSize: 17,
                      fontWeight:
                      FontWeight.w700,

                      color:
                      selectedTab == 0
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: GestureDetector(

              onTap: fetchOffers,

              child: AnimatedContainer(

                duration:
                const Duration(
                  milliseconds: 220,
                ),

                decoration: BoxDecoration(

                  gradient:
                  selectedTab == 1
                      ? const LinearGradient(
                    colors: [
                      Color(0xffFF6B6B),
                      Color(0xffFF8E53),
                    ],
                  )
                      : null,

                  borderRadius:
                  BorderRadius.circular(22),
                ),

                child: Center(

                  child: Text(
                    "Offers",

                    style: TextStyle(
                      fontSize: 17,
                      fontWeight:
                      FontWeight.w700,

                      color:
                      selectedTab == 1
                          ? Colors.white
                          : Colors.black,
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

      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,

      children: [

        Text(
          selectedTab == 0
              ? "Jobs"
              : "Offers",

          style: const TextStyle(
            fontSize: 24,
            fontWeight:
            FontWeight.w800,
          ),
        ),

        GestureDetector(

          onTap: () {
            _showFilterBottomSheet();
          },

          child: Container(

            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
              BorderRadius.circular(16),
            ),

            child: const Icon(
              CupertinoIcons.slider_horizontal_3,
              color: Color(0xff5B5FFF),
            ),
          ),
        ),
      ],
    );
  }

  /// =====================================================
  /// FILTER BOTTOM SHEET
  /// =====================================================

  void _showFilterBottomSheet() {

    showModalBottomSheet(

      context: context,

      isScrollControlled: true,

      backgroundColor: Colors.transparent,

      builder: (context) {

        return StatefulBuilder(

          builder: (context, setModalState) {

            return Container(

              height:
              MediaQuery.of(context).size.height * .92,

              decoration: const BoxDecoration(

                color: Color(0xffF6F7FB),

                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),

              child: Column(

                children: [

                  const SizedBox(height: 18),

                  Container(
                    width: 70,
                    height: 5,

                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                  ),

                  Padding(

                    padding: const EdgeInsets.all(22),

                    child: Row(

                      children: [

                        GestureDetector(

                          onTap: () {
                            Navigator.pop(context);
                          },

                          child: const Icon(
                            CupertinoIcons.back,
                            size: 28,
                          ),
                        ),

                        const SizedBox(width: 14),

                        const Text(
                          "Filters",

                          style: TextStyle(
                            fontSize: 34,
                            fontWeight:
                            FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(

                    child: SingleChildScrollView(

                      child: Column(

                        children: [

                          _filterHeader(
                            title: "Sub Category",
                            expanded:
                            showSubCategory,

                            onTap: () {

                              setModalState(() {

                                showSubCategory =
                                !showSubCategory;
                              });
                            },
                          ),

                          if (showSubCategory)

                            Column(

                              children: [

                                _checkItem(
                                  "Retail and Shop Jobs",
                                  setModalState,
                                ),

                                _checkItem(
                                  "Food and Hospitality",
                                  setModalState,
                                ),

                                _checkItem(
                                  "Delivery and Logistics",
                                  setModalState,
                                ),

                                _checkItem(
                                  "Office and Admin",
                                  setModalState,
                                ),

                                _checkItem(
                                  "Skilled Workers",
                                  setModalState,
                                ),

                                _checkItem(
                                  "Creative and Digital",
                                  setModalState,
                                ),
                              ],
                            ),

                          _filterHeader(
                            title: "Expiry",
                            expanded: showExpiry,

                            onTap: () {

                              setModalState(() {

                                showExpiry =
                                !showExpiry;
                              });
                            },
                          ),

                          if (showExpiry)

                            Column(

                              children: [

                                _radioItem(
                                  title:
                                  "Within a day",

                                  value:
                                  "Within a day",

                                  groupValue:
                                  selectedExpiry,

                                  onChanged: (v) {

                                    setModalState(() {
                                      selectedExpiry =
                                      v!;
                                    });
                                  },
                                ),

                                _radioItem(
                                  title:
                                  "Within 3 days",

                                  value:
                                  "Within 3 days",

                                  groupValue:
                                  selectedExpiry,

                                  onChanged: (v) {

                                    setModalState(() {
                                      selectedExpiry =
                                      v!;
                                    });
                                  },
                                ),

                                _radioItem(
                                  title:
                                  "Within a week",

                                  value:
                                  "Within a week",

                                  groupValue:
                                  selectedExpiry,

                                  onChanged: (v) {

                                    setModalState(() {
                                      selectedExpiry =
                                      v!;
                                    });
                                  },
                                ),
                              ],
                            ),

                          _filterHeader(
                            title: "Job Type",
                            expanded:
                            showJobType,

                            onTap: () {

                              setModalState(() {

                                showJobType =
                                !showJobType;
                              });
                            },
                          ),

                          if (showJobType)

                            Padding(

                              padding:
                              const EdgeInsets.all(
                                20,
                              ),

                              child: Row(

                                children: [

                                  _jobTypeButton(
                                    "Full-time",
                                    setModalState,
                                  ),

                                  _jobTypeButton(
                                    "Part-time",
                                    setModalState,
                                  ),

                                  _jobTypeButton(
                                    "Temporary",
                                    setModalState,
                                  ),
                                ],
                              ),
                            ),

                          _filterHeader(
                            title: "Job Salary",
                            expanded:
                            showSalary,

                            onTap: () {

                              setModalState(() {

                                showSalary =
                                !showSalary;
                              });
                            },
                          ),

                          if (showSalary)

                            Column(

                              children: [

                                _radioItem(
                                  title: "0-10,000",

                                  value:
                                  "0-10,000",

                                  groupValue:
                                  selectedSalary,

                                  onChanged: (v) {

                                    setModalState(() {
                                      selectedSalary =
                                      v!;
                                    });
                                  },
                                ),

                                _radioItem(
                                  title:
                                  "10,001-20,000",

                                  value:
                                  "10,001-20,000",

                                  groupValue:
                                  selectedSalary,

                                  onChanged: (v) {

                                    setModalState(() {
                                      selectedSalary =
                                      v!;
                                    });
                                  },
                                ),

                                _radioItem(
                                  title:
                                  "20,000 and above",

                                  value:
                                  "20,000 and above",

                                  groupValue:
                                  selectedSalary,

                                  onChanged: (v) {

                                    setModalState(() {
                                      selectedSalary =
                                      v!;
                                    });
                                  },
                                ),
                              ],
                            ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),

                  Padding(

                    padding: const EdgeInsets.all(20),

                    child: Row(

                      children: [

                        Expanded(

                          child: OutlinedButton(

                            onPressed: () {

                              setModalState(() {

                                selectedSubCategories
                                    .clear();

                                selectedExpiry = '';

                                selectedSalary = '';

                                selectedJobType =
                                'Full-time';
                              });
                            },

                            style:
                            OutlinedButton.styleFrom(

                              minimumSize:
                              const Size(
                                double.infinity,
                                62,
                              ),

                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(
                                  40,
                                ),
                              ),
                            ),

                            child: const Text(
                              "Clear",

                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(

                          flex: 2,

                          child: ElevatedButton(

                            onPressed: () {
                              Navigator.pop(context);
                            },

                            style:
                            ElevatedButton.styleFrom(

                              backgroundColor:
                              const Color(
                                0xffB9B6C5,
                              ),

                              elevation: 0,

                              minimumSize:
                              const Size(
                                double.infinity,
                                62,
                              ),

                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(
                                  40,
                                ),
                              ),
                            ),

                            child: Text(

                              selectedTab == 0
                                  ? "Show ${jobs.length} Jobs"
                                  : "Show ${offers.length} Offers",

                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight:
                                FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _filterHeader({

    required String title,

    required bool expanded,

    required VoidCallback onTap,

  }) {

    return InkWell(

      onTap: onTap,

      child: Container(

        padding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 24,
        ),

        decoration: const BoxDecoration(

          border: Border(
            top: BorderSide(color: Colors.black12),
            bottom: BorderSide(color: Colors.black12),
          ),
        ),

        child: Row(

          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

          children: [

            Text(
              title,

              style: const TextStyle(
                fontSize: 22,
                fontWeight:
                FontWeight.w800,
              ),
            ),

            Icon(
              expanded
                  ? CupertinoIcons.chevron_up
                  : CupertinoIcons.chevron_down,
            ),
          ],
        ),
      ),
    );
  }

  Widget _checkItem(
      String title,
      StateSetter setModalState,
      ) {

    final isSelected =
    selectedSubCategories.contains(title);

    return CheckboxListTile(

      value: isSelected,

      activeColor: Colors.black,

      title: Text(
        title,

        style: const TextStyle(
          fontSize: 16,
          fontWeight:
          FontWeight.w500,
        ),
      ),

      onChanged: (value) {

        setModalState(() {

          if (value == true) {

            selectedSubCategories
                .add(title);

          } else {

            selectedSubCategories
                .remove(title);
          }
        });
      },
    );
  }

  Widget _radioItem({

    required String title,

    required String value,

    required String groupValue,

    required Function(String?) onChanged,

  }) {

    return RadioListTile<String>(

      value: value,

      groupValue: groupValue,

      activeColor: Colors.grey,

      title: Text(
        title,

        style: const TextStyle(
          fontSize: 16,
        ),
      ),

      onChanged: onChanged,
    );
  }

  Widget _jobTypeButton(
      String type,
      StateSetter setModalState,
      ) {

    final isSelected =
        selectedJobType == type;

    return Expanded(

      child: GestureDetector(

        onTap: () {

          setModalState(() {
            selectedJobType = type;
          });
        },

        child: Container(

          height: 56,

          alignment: Alignment.center,

          decoration: BoxDecoration(

            color:
            isSelected
                ? Colors.black
                : const Color(
              0xffE7E7E7,
            ),
          ),

          child: Text(
            type,

            style: TextStyle(
              color:
              isSelected
                  ? Colors.white
                  : Colors.black,

              fontWeight:
              FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  /// =====================================================
  /// JOB CARD
  /// =====================================================

  /// =====================================================
  /// JOB CARD
  /// =====================================================

  Widget _buildJobCard(dynamic job) {

    Widget card;

    switch (job['temp_id']) {

      case 'T001':
        card = JobTemplates.templateT001(job);
        break;

      case 'T002':
        card = JobTemplates.templateT002(job);
        break;

      case 'T003':
        card = JobTemplates.templateT003(job);
        break;

      case 'T004':
        card = JobTemplates.templateT004(job);
        break;

      default:
        card = JobTemplates.defaultTemplate(job);
    }

    return Stack(

      children: [

        /// POSTER
        Positioned.fill(
          child: card,
        ),

        /// VIEW COUNT
        Positioned(

          top: 10,
          right: 10,

          child: Container(

            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),

            decoration: BoxDecoration(

              color: Colors.black.withOpacity(.55),

              borderRadius:
              BorderRadius.circular(30),

              border: Border.all(
                color: Colors.white24,
              ),
            ),

            child: Row(

              mainAxisSize: MainAxisSize.min,

              children: [

                const Icon(
                  CupertinoIcons.eye_fill,
                  color: Colors.white,
                  size: 14,
                ),

                const SizedBox(width: 5),

                Text(
                  "${job['view_count'] ?? 0}",

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
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

        /// POSTER
        Positioned.fill(
          child: card,
        ),

        /// VIEW COUNT
        Positioned(

          top: 10,
          right: 10,

          child: Container(

            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),

            decoration: BoxDecoration(

              color: Colors.black.withOpacity(.55),

              borderRadius:
              BorderRadius.circular(30),

              border: Border.all(
                color: Colors.white24,
              ),
            ),

            child: Row(

              mainAxisSize: MainAxisSize.min,

              children: [

                const Icon(
                  CupertinoIcons.eye_fill,
                  color: Colors.white,
                  size: 14,
                ),

                const SizedBox(width: 5),

                Text(
                  "${offer['view_count'] ?? 0}",

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
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
  /// BOTTOM BAR
  /// =====================================================

  Widget _buildBottomBar() {

    return BottomAppBar(

      height: 88,

      color: const Color(0xff1E1E2D),

      shape:
      const CircularNotchedRectangle(),

      notchMargin: 10,

      child: Row(

        mainAxisAlignment:
        MainAxisAlignment.spaceAround,

        children: [

          Row(
            children: [

              _navItem(
                icon: CupertinoIcons.house_fill,
                title: "Home",
                active: true,
              ),

              const SizedBox(width: 30),

              _navItem(
                icon:
                CupertinoIcons.location_solid,
                title: "Location",
              ),
            ],
          ),

          const SizedBox(width: 50),

          Row(
            children: [

              _navItem(
                icon:
                CupertinoIcons.heart_fill,
                title: "Liked",
              ),

              const SizedBox(width: 30),

              _navItem(
                icon:
                CupertinoIcons.doc_text_fill,
                title: "MyPoster",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navItem({

    required IconData icon,

    required String title,

    bool active = false,

  }) {

    return GestureDetector(

      onTap: () {},

      child: Column(

        mainAxisSize: MainAxisSize.min,

        children: [

          Icon(
            icon,

            color:
            active
                ? const Color(0xff8E7BFF)
                : Colors.white,

            size: 26,
          ),

          const SizedBox(height: 4),

          Text(
            title,

            style: TextStyle(
              color:
              active
                  ? const Color(
                0xff8E7BFF,
              )
                  : Colors.white,

              fontSize: 12,

              fontWeight:
              FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}