import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:postergali/core/localization/localization_service.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../home/presentation/widgets/home_bottom_bar.dart';
import '../../../home/presentation/widgets/home_cards.dart';
import '../../../home/presentation/widgets/home_tabs.dart';
import '../../../job_details/presentation/screens/job_detail_screen.dart';
import '../../../liked/presentation/screens/liked_posters_screen.dart';
import '../../../location/presentation/screens/location_selector_screen.dart';
import '../../../offer_details/presentation/screens/offer_detail_screen.dart';
import '../../../posterman/bot_splash_screen.dart';


class MyPostersScreen extends StatefulWidget {
  const MyPostersScreen({super.key});

  @override
  State<MyPostersScreen> createState() => _MyPostersScreenState();
}

class _MyPostersScreenState extends State<MyPostersScreen> {
  List<dynamic> myPosters = []; // This will be fetched via API later
  int selectedTab = 0; // 0 for Jobs, 1 for Offers
  int selectedBottomIndex = 3; // MyPoster is index 3
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Fetch user posters from API later
  }

  List<dynamic> get filteredPosters {
    final type = selectedTab == 0 ? 'job' : 'offer';
    return myPosters.where((p) => p['type'] == type).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      bottomNavigationBar: HomeBottomBar(
        selectedIndex: selectedBottomIndex,
        onItemTapped: (index) {
          if (index == selectedBottomIndex) return;
          if (index == 0) {
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LocationSelectorScreen()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LikedPostersScreen()),
            );
          } else if (index == 3) {
             // Already here
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFAB(),
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
          bottom: false,
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: HomeTabs(
                  selectedTab: selectedTab,
                  onJobsTap: () => setState(() => selectedTab = 0),
                  onOffersTap: () => setState(() => selectedTab = 1),
                ),
              ),
              const SizedBox(height: 20),
              _buildResultHeader(),
              const SizedBox(height: 10),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primaryRed))
                    : _buildGrid(),
              ),
              const SizedBox(height: 100), // Space for bottom bar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xffB5402C), width: 1.5),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xffB5402C),
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Text(
            context.tr('my_poster'),
            style: const TextStyle(
              fontFamily: 'ClashDisplay',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xff4A1F14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultHeader() {
    final count = filteredPosters.length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total results (${count.toString().padLeft(2, '0')})",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff4A1F14),
            ),
          ),
          const Icon(
            CupertinoIcons.slider_horizontal_3,
            color: Color(0xffB5402C),
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    if (filteredPosters.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(CupertinoIcons.doc_text, size: 80, color: Colors.black26),
            const SizedBox(height: 20),
            Text(
              "You haven't posted any ${selectedTab == 0 ? 'jobs' : 'offers'} yet.",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black54),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => isJob
                    ? JobDetailScreen(jobId: poster['id'])
                    : OfferDetailScreen(offerId: poster['id']),
              ),
            );
          },
          child: Transform.rotate(
            angle: index.isEven ? -0.03 : 0.03,
            child: isJob
                ? HomeJobCard(job: poster)
                : HomeOfferCard(offer: poster),
          ),
        );
      },
    );
  }

  Widget _buildFAB() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const BotSplashScreen(
              location: "New Delhi",
              latitude: 28.6139,
              longitude: 77.2090,
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
    );
  }
}
