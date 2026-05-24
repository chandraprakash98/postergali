import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OfferFilterSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onApply;

  const OfferFilterSheet({
    super.key,
    required this.onApply,
  });

  @override
  State<OfferFilterSheet> createState() => _OfferFilterSheetState();
}

class _OfferFilterSheetState extends State<OfferFilterSheet> {
  bool categoryExpanded = true;
  bool discountExpanded = true;
  bool validityExpanded = true;

  String selectedDiscount = "50% Off";
  String selectedValidity = "Today";
  List<String> selectedCategories = ["Food"];

  final List<String> offerCategories = [
    "Food", "Fashion", "Salon", "Electronics", "Grocery", "Travel", "Cafe", "Gym",
  ];

  final List<String> discounts = [
    "10% Off", "25% Off", "50% Off", "Flat ₹100",
  ];

  final List<String> validityOptions = [
    "Today", "This Week", "This Month",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .92,
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
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(CupertinoIcons.back, size: 30, color: Colors.black),
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
                    _buildHeaderWidget("Offer Category", categoryExpanded, () {
                      setState(() => categoryExpanded = !categoryExpanded);
                    }),
                    if (categoryExpanded)
                      ...offerCategories.map((e) => _buildCategoryItem(e)),

                    _buildHeaderWidget("Discount", discountExpanded, () {
                      setState(() => discountExpanded = !discountExpanded);
                    }),
                    if (discountExpanded)
                      ...discounts.map((e) => _buildDiscountItem(e)),

                    _buildHeaderWidget("Offer Validity", validityExpanded, () {
                      setState(() => validityExpanded = !validityExpanded);
                    }),
                    if (validityExpanded) _buildValiditySelector(),

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
                          selectedDiscount = "";
                          selectedValidity = "";
                        });
                      },
                      child: Container(
                        height: 62,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        child: const Center(
                          child: Text(
                            "Clear",
                            style: TextStyle(
                              fontFamily: 'HelveticaNeue',
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
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
                        widget.onApply({
                          'categories': selectedCategories,
                          'discount': selectedDiscount,
                          'validity': selectedValidity,
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 62,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Center(
                          child: Text(
                            "Show Offers",
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

  Widget _buildDiscountItem(String e) {
    return InkWell(
      onTap: () => setState(() => selectedDiscount = e),
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
                    color: selectedDiscount == e ? Colors.grey : Colors.transparent,
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

  Widget _buildValiditySelector() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        height: 58,
        decoration: BoxDecoration(color: Colors.grey.shade300),
        child: Row(
          children: validityOptions.map((e) {
            final selected = selectedValidity == e;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => selectedValidity = e),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  color: selected ? Colors.black : Colors.transparent,
                  child: Center(
                    child: Text(
                      e,
                      style: TextStyle(
                        fontFamily: 'HelveticaNeue',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: selected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
