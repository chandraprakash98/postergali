import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:postergali/core/localization/localization_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../home/presentation/widgets/home_bottom_bar.dart';
import '../../../home/presentation/widgets/home_cards.dart';
import '../../../home/presentation/widgets/home_tabs.dart';
import '../../../job_details/presentation/screens/job_detail_screen.dart';
import '../../../location/presentation/screens/location_selector_screen.dart';
import '../../../offer_details/presentation/screens/offer_detail_screen.dart';
import '../../../posterman/bot_splash_screen.dart';

class LikedPostersScreen extends StatefulWidget {
  const LikedPostersScreen({super.key});

  @override
  State<LikedPostersScreen> createState() => _LikedPostersScreenState();
}

class _LikedPostersScreenState extends State<LikedPostersScreen> {
  List<dynamic> allLikedPosters = [];
  int selectedTab = 0; // 0 for Jobs, 1 for Offers
  int selectedBottomIndex = 2; // Liked is index 2
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLikedPosters();
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

  List<dynamic> get filteredPosters {
    final type = selectedTab == 0 ? 'job' : 'offer';
    return allLikedPosters.where((p) => p['type'] == type).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      bottomNavigationBar: HomeBottomBar(
        selectedIndex: selectedBottomIndex,
        onItemTapped: (index) {
          if (index == 0) {
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LocationSelectorScreen()),
            );
          } else if (index == 3) {
            // MyPoster logic if any, for now just update index
            setState(() => selectedBottomIndex = index);
          } else {
            setState(() => selectedBottomIndex = index);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GestureDetector(
        onTap: () {
          // You might need location data here or mock it for Liked Screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BotSplashScreen(
                location: "Current Location",
                latitude: 0,
                longitude: 0,
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
              colors: [Color(0xffF2C96B), Color(0xffE8B84F)],
            ),
            border: Border.all(color: const Color(0xffB5402C), width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(CupertinoIcons.add, size: 36, color: Color(0xffB5402C)),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFFAE2BC),
              Color(0xFFFFF2CC),
              Color(0xFFEFDFAE),
            ],
          ),
          image: DecorationImage(
            image: AssetImage('assets/images/img.png'),
            fit: BoxFit.cover,
            opacity: 0.10,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                child: Column(
                  children: [
                    Text(
                      context.tr('liked'),
                      style: const TextStyle(
                        fontFamily: 'ClashDisplay',
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff4A1F14),
                      ),
                    ),
                    const SizedBox(height: 20),
                    HomeTabs(
                      selectedTab: selectedTab,
                      onJobsTap: () => setState(() => selectedTab = 0),
                      onOffersTap: () => setState(() => selectedTab = 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredPosters.isEmpty
                        ? Center(
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
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 20,
                              childAspectRatio: 0.62,
                            ),
                            itemCount: filteredPosters.length,
                            itemBuilder: (context, index) {
                              final poster = filteredPosters[index];
                              final bool isJob = poster['type'] == 'job';

                              return GestureDetector(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => isJob
                                          ? JobDetailScreen(jobId: poster['id'])
                                          : OfferDetailScreen(offerId: poster['id']),
                                    ),
                                  );
                                  _loadLikedPosters(); // Refresh on return
                                },
                                child: Transform.rotate(
                                  angle: index.isEven ? -0.03 : 0.03,
                                  child: isJob
                                      ? HomeJobCard(job: poster)
                                      : HomeOfferCard(offer: poster),
                                ),
                              );
                            },
                          ),
              ),
              const SizedBox(height: 100), // Space for bottom bar
            ],
          ),
        ),
      ),
    );
  }
}
