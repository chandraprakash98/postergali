import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/job_templates.dart';

class JobDetailScreen extends StatefulWidget {

  final int jobId;

  const JobDetailScreen({
    super.key,
    required this.jobId,
  });

  @override
  State<JobDetailScreen> createState() =>
      _JobDetailScreenState();
}

class _JobDetailScreenState
    extends State<JobDetailScreen> {

  bool isLoading = true;

  dynamic job;

  @override
  void initState() {
    super.initState();
    fetchJob();
  }

  Future<void> fetchJob() async {

    try {

      final response = await http.get(
        Uri.parse(
          'https://postergali.com/api/v1/jobs/${widget.jobId}',
        ),
      );

      if (response.statusCode == 200) {

        setState(() {

          job = jsonDecode(response.body);

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

  /// ======================================================
  /// TEMPLATE SWITCH
  /// ======================================================

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

      backgroundColor:
      const Color(0xffF5F5F5),

      body: isLoading

          ? const Center(
        child:
        CircularProgressIndicator(),
      )

          : SafeArea(

        child: Column(

          children: [

            /// =========================================
            /// TOP BAR
            /// =========================================

            Padding(

              padding:
              const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 18,
              ),

              child: Row(

                mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

                children: [

                  /// BACK

                  InkWell(

                    onTap: () {
                      Navigator.pop(context);
                    },

                    child: Container(

                      height: 64,
                      width: 64,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),

                      child: const Icon(
                        Icons.arrow_back,
                        size: 34,
                      ),
                    ),
                  ),

                  /// ACTIONS

                  Row(
                    children: [

                      Container(

                        height: 64,
                        width: 64,

                        decoration:
                        const BoxDecoration(
                          shape:
                          BoxShape.circle,
                          color:
                          Color(0xffB5B5B5),
                        ),

                        child: const Icon(
                          Icons.favorite,
                          size: 34,
                        ),
                      ),

                      const SizedBox(width: 16),

                      Container(

                        height: 64,
                        width: 64,

                        decoration:
                        const BoxDecoration(
                          shape:
                          BoxShape.circle,
                          color:
                          Color(0xffB5B5B5),
                        ),

                        child: const Icon(
                          Icons.share,
                          size: 34,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(

              child: SingleChildScrollView(

                padding:
                const EdgeInsets.symmetric(
                  horizontal: 26,
                ),

                child: Column(

                  children: [

                    /// =====================================
                    /// POSTER TEMPLATE
                    /// =====================================

                    AspectRatio(

                      aspectRatio: 0.72,

                      child: ClipRRect(

                        borderRadius:
                        BorderRadius.circular(
                          8,
                        ),

                        child: _buildPoster(),
                      ),
                    ),

                    const SizedBox(height: 28),

                    /// =====================================
                    /// STATS CONTAINER
                    /// =====================================

                    Container(

                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),

                      decoration: BoxDecoration(

                        borderRadius:
                        BorderRadius.circular(
                          40,
                        ),

                        border: Border.all(
                          color:
                          Colors.black26,
                          width: 2,
                        ),
                      ),

                      child: Row(

                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,

                        children: [

                          _statItem(
                            icon:
                            Icons.remove_red_eye_outlined,
                            title: "Views",
                            value:
                            "${job['view_count']}",
                          ),

                          _divider(),

                          _statItem(
                            icon:
                            Icons.near_me_outlined,
                            title: "Distance",
                            value: "0-1km",
                          ),

                          _divider(),

                          _statItem(
                            icon:
                            Icons.warning_amber_rounded,
                            title:
                            "Expires in",
                            value: "3 days",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 70),

                    /// =====================================
                    /// BUTTONS
                    /// =====================================

                    Row(
                      children: [

                        /// CALL BUTTON

                        Expanded(

                          child: Container(

                            height: 82,

                            decoration:
                            BoxDecoration(

                              borderRadius:
                              BorderRadius.circular(
                                50,
                              ),

                              border: Border.all(
                                color:
                                Colors.black,
                                width: 2,
                              ),
                            ),

                            child: const Center(

                              child: Text(
                                "Call",

                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight:
                                  FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 18),

                        /// DIRECTION BUTTON

                        Expanded(

                          flex: 2,

                          child: Container(

                            height: 82,

                            decoration:
                            BoxDecoration(

                              borderRadius:
                              BorderRadius.circular(
                                50,
                              ),

                              color: const Color(
                                0xffB3B0B0,
                              ),
                            ),

                            child: const Center(

                              child: Text(
                                "Directions",

                                style: TextStyle(
                                  fontSize: 24,
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

  /// ======================================================
  /// STATS ITEM
  /// ======================================================

  Widget _statItem({

    required IconData icon,

    required String title,

    required String value,

  }) {

    return Column(

      children: [

        Text(
          title,

          style: const TextStyle(
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 8),

        Row(
          children: [

            Icon(
              icon,
              size: 32,
            ),

            const SizedBox(width: 8),

            Text(
              value,

              style: const TextStyle(
                fontSize: 24,
                fontWeight:
                FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _divider() {

    return Container(
      height: 54,
      width: 2,
      color: Colors.black,
    );
  }
}