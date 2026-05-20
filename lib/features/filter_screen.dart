import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {

  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() =>
      _FilterScreenState();
}

class _FilterScreenState
    extends State<FilterScreen> {

  bool subCategoryExpanded = true;
  bool expiryExpanded = true;
  bool jobTypeExpanded = true;
  bool salaryExpanded = true;

  List<String> selectedCategories = [];

  String expiry = "Within a day";

  String selectedJobType = "Full-time";

  String salary = "0-10,000";

  final categories = [

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xffF5F5F5),

      body: SafeArea(

        child: Column(

          children: [

            /// ======================================
            /// HEADER
            /// ======================================

            Padding(

              padding:
              const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),

              child: Row(
                children: [

                  GestureDetector(

                    onTap: () {
                      Navigator.pop(context);
                    },

                    child: const Icon(
                      Icons.arrow_back,
                      size: 32,
                    ),
                  ),

                  const SizedBox(width: 16),

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

            const Divider(height: 1),

            Expanded(

              child: SingleChildScrollView(

                child: Column(

                  children: [

                    /// ======================================
                    /// SUB CATEGORY
                    /// ======================================

                    _sectionHeader(
                      title: "Sub Category",
                      expanded:
                      subCategoryExpanded,
                      onTap: () {

                        setState(() {
                          subCategoryExpanded =
                          !subCategoryExpanded;
                        });
                      },
                    ),

                    if (subCategoryExpanded)

                      Column(

                        children:
                        categories.map((e) {

                          final selected =
                          selectedCategories
                              .contains(e);

                          return InkWell(

                            onTap: () {

                              setState(() {

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
                              const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),

                              decoration:
                              const BoxDecoration(

                                border: Border(
                                  top: BorderSide(
                                    color:
                                    Colors.black,
                                  ),
                                ),
                              ),

                              child: Row(

                                children: [

                                  Checkbox(

                                    value: selected,

                                    activeColor:
                                    Colors.black,

                                    onChanged: (
                                        value,
                                        ) {},
                                  ),

                                  const SizedBox(
                                    width: 8,
                                  ),

                                  Expanded(
                                    child: Text(
                                      e,

                                      style:
                                      const TextStyle(
                                        fontSize:
                                        18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                    /// ======================================
                    /// EXPIRY
                    /// ======================================

                    _sectionHeader(
                      title: "Expiry",
                      expanded:
                      expiryExpanded,
                      onTap: () {

                        setState(() {
                          expiryExpanded =
                          !expiryExpanded;
                        });
                      },
                    ),

                    if (expiryExpanded)

                      Column(

                        children: [

                          _radioTile(
                            title:
                            "Within a day",
                            value:
                            "Within a day",
                            groupValue:
                            expiry,
                            onChanged:
                                (v) {

                              setState(() {
                                expiry = v!;
                              });
                            },
                          ),

                          _radioTile(
                            title:
                            "Within 3 days",
                            value:
                            "Within 3 days",
                            groupValue:
                            expiry,
                            onChanged:
                                (v) {

                              setState(() {
                                expiry = v!;
                              });
                            },
                          ),

                          _radioTile(
                            title:
                            "Within a week",
                            value:
                            "Within a week",
                            groupValue:
                            expiry,
                            onChanged:
                                (v) {

                              setState(() {
                                expiry = v!;
                              });
                            },
                          ),
                        ],
                      ),

                    /// ======================================
                    /// JOB TYPE
                    /// ======================================

                    _sectionHeader(
                      title: "Job Type",
                      expanded:
                      jobTypeExpanded,
                      onTap: () {

                        setState(() {
                          jobTypeExpanded =
                          !jobTypeExpanded;
                        });
                      },
                    ),

                    if (jobTypeExpanded)

                      Padding(

                        padding:
                        const EdgeInsets.all(20),

                        child: Row(
                          children: [

                            _jobTypeButton(
                              "Full-time",
                            ),

                            _jobTypeButton(
                              "Part-time",
                            ),

                            _jobTypeButton(
                              "Temporary",
                            ),
                          ],
                        ),
                      ),

                    /// ======================================
                    /// SALARY
                    /// ======================================

                    _sectionHeader(
                      title: "Job Salary",
                      expanded:
                      salaryExpanded,
                      onTap: () {

                        setState(() {
                          salaryExpanded =
                          !salaryExpanded;
                        });
                      },
                    ),

                    if (salaryExpanded)

                      Column(
                        children: [

                          _radioTile(
                            title:
                            "0-10,000",
                            value:
                            "0-10,000",
                            groupValue:
                            salary,
                            onChanged:
                                (v) {

                              setState(() {
                                salary = v!;
                              });
                            },
                          ),

                          _radioTile(
                            title:
                            "10,001-20,000",
                            value:
                            "10,001-20,000",
                            groupValue:
                            salary,
                            onChanged:
                                (v) {

                              setState(() {
                                salary = v!;
                              });
                            },
                          ),

                          _radioTile(
                            title:
                            "20,000 and above",
                            value:
                            "20,000 and above",
                            groupValue:
                            salary,
                            onChanged:
                                (v) {

                              setState(() {
                                salary = v!;
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

            /// ======================================
            /// BOTTOM BUTTONS
            /// ======================================

            Padding(

              padding:
              const EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: 30,
              ),

              child: Row(
                children: [

                  Expanded(

                    child: Container(

                      height: 76,

                      decoration: BoxDecoration(

                        borderRadius:
                        BorderRadius.circular(
                          50,
                        ),

                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),

                      child: const Center(

                        child: Text(
                          "Clear",

                          style: TextStyle(
                            fontSize: 20,
                            fontWeight:
                            FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 18),

                  Expanded(

                    flex: 2,

                    child: Container(

                      height: 76,

                      decoration: BoxDecoration(

                        borderRadius:
                        BorderRadius.circular(
                          50,
                        ),

                        color:
                        const Color(
                          0xffB3B0B0,
                        ),
                      ),

                      child: const Center(

                        child: Text(
                          "Show 21 Jobs",

                          style: TextStyle(
                            fontSize: 20,
                            color:
                            Colors.white,
                            fontWeight:
                            FontWeight.w500,
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
  }

  /// ======================================
  /// SECTION HEADER
  /// ======================================

  Widget _sectionHeader({

    required String title,

    required bool expanded,

    required VoidCallback onTap,

  }) {

    return InkWell(

      onTap: onTap,

      child: Container(

        height: 78,

        padding:
        const EdgeInsets.symmetric(
          horizontal: 24,
        ),

        decoration:
        const BoxDecoration(

          border: Border(
            top: BorderSide(
              color: Colors.black,
            ),
          ),
        ),

        child: Row(

          mainAxisAlignment:
          MainAxisAlignment
              .spaceBetween,

          children: [

            Text(
              title,

              style: const TextStyle(
                fontSize: 20,
                fontWeight:
                FontWeight.w700,
              ),
            ),

            Icon(
              expanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              size: 34,
            ),
          ],
        ),
      ),
    );
  }

  /// ======================================
  /// RADIO TILE
  /// ======================================

  Widget _radioTile({

    required String title,

    required String value,

    required String groupValue,

    required Function(String?)
    onChanged,

  }) {

    return Container(

      height: 84,

      padding:
      const EdgeInsets.symmetric(
        horizontal: 24,
      ),

      decoration:
      const BoxDecoration(

        border: Border(
          top: BorderSide(
            color: Colors.black,
          ),
        ),
      ),

      child: Row(

        children: [

          Radio<String>(

            value: value,

            groupValue:
            groupValue,

            activeColor:
            Colors.grey,

            onChanged:
            onChanged,
          ),

          Text(
            title,

            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  /// ======================================
  /// JOB TYPE BUTTON
  /// ======================================

  Widget _jobTypeButton(
      String title,
      ) {

    final selected =
        selectedJobType == title;

    return Expanded(

      child: GestureDetector(

        onTap: () {

          setState(() {
            selectedJobType =
                title;
          });
        },

        child: Container(

          height: 58,

          color:
          selected
              ? Colors.black
              : const Color(
            0xffD9D9D9,
          ),

          child: Center(

            child: Text(
              title,

              style: TextStyle(
                fontSize: 18,

                fontWeight:
                FontWeight.w700,

                color:
                selected
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}