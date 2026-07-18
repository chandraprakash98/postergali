import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:postergali/core/localization/localization_service.dart';
import '../../data/models/offer_filter.dart';

class OfferFilterScreen extends StatefulWidget {
  final OfferFilterModel initialFilter;
  final List<String> offerCategories;
  final List<String> expiryOptions;

  const OfferFilterScreen({
    super.key,
    required this.initialFilter,
    required this.offerCategories,
    required this.expiryOptions,
  });

  @override
  State<OfferFilterScreen> createState() => _OfferFilterScreenState();
}

class _OfferFilterScreenState extends State<OfferFilterScreen> {
  late List<String> selectedCategories;
  String? selectedExpiry;

  bool categoryExpanded = false;
  bool expiryExpanded = false;

  @override
  void initState() {
    super.initState();
    selectedCategories = List.from(widget.initialFilter.categories);
    selectedExpiry = widget.initialFilter.expiry;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        ),
        child: SafeArea(
          child: Column(
            children: [
              /// HEADER
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(CupertinoIcons.back, size: 30, color: Colors.black),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      context.tr('filter'),
                      style: const TextStyle(
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
                      _buildHeaderWidget("Offer Category", categoryExpanded, () {
                        setState(() => categoryExpanded = !categoryExpanded);
                      }),
                      if (categoryExpanded)
                        ...widget.offerCategories.map((e) => _buildCategoryItem(e)),

                      _buildHeaderWidget("Offer Validity", expiryExpanded, () {
                        setState(() => expiryExpanded = !expiryExpanded);
                      }),
                      if (expiryExpanded)
                        ...widget.expiryOptions.map((e) => _buildExpiryItem(e)),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              /// BOTTOM BUTTONS
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategories = [];
                            selectedExpiry = null;
                          });
                        },
                        child: Container(
                          height: 62,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: const Color(0xffB5402C), width: 1.5),
                          ),
                          child: const Center(
                            child: Text(
                              "Clear",
                              style: TextStyle(
                                fontFamily: 'HelveticaNeue',
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Color(0xffB5402C),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          final filter = OfferFilterModel(
                            categories: selectedCategories,
                            expiry: selectedExpiry,
                          );
                          Navigator.pop(context, filter);
                        },
                        child: Container(
                          height: 62,
                          decoration: BoxDecoration(
                            color: const Color(0xffB5402C),
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xffB5402C).withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              "Apply Filters",
                              style: TextStyle(
                                fontFamily: 'HelveticaNeue',
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
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
      ),
    );
  }

  Widget _buildHeaderWidget(String title, bool expanded, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 76,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.black12),
            bottom: BorderSide(color: Colors.black12),
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
              expanded ? CupertinoIcons.chevron_up : CupertinoIcons.chevron_down,
              color: Colors.black,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String e) {
    final selected = selectedCategories.contains(e);
    return InkWell(
      onTap: () {
        setState(() {
          if (selected) {
            selectedCategories.remove(e);
          } else {
            selectedCategories.add(e);
          }
        });
      },
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12)),
        ),
        child: Row(
          children: [
            Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                color: selected ? Colors.black : Colors.transparent,
                border: Border.all(color: Colors.black54, width: 1.5),
              ),
              child: selected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                e,
                style: const TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpiryItem(String e) {
    return InkWell(
      onTap: () => setState(() => selectedExpiry = e),
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12)),
        ),
        child: Row(
          children: [
            Container(
              height: 28,
              width: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black45),
              ),
              child: Center(
                child: Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selectedExpiry == e ? Colors.grey : Colors.transparent,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 18),
            Text(
              e,
              style: const TextStyle(
                fontFamily: 'HelveticaNeue',
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
