/* =======================================================
   HOME NAV MODULE: Home Screen
   ======================================================= */

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../widgets/discount_banner.dart';
import '../widgets/product_card.dart';
import 'products_list_screen.dart';
import 'search_screen.dart';

/* ============= Home Screen Widget ============= */
class HomeScreen extends StatefulWidget {
  final VoidCallback? onSearchTap;

  const HomeScreen({super.key, this.onSearchTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBannerIndex = 0;
  bool _isNotificationActive = true;

  /* ============= Get User Display Name ============= */
  String _getUserName() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.displayName != null && user.displayName!.isNotEmpty) {
        return user.displayName!;
      }
      if (user.email != null && user.email!.isNotEmpty) {
        final prefix = user.email!.split('@')[0];
        return prefix.isNotEmpty
            ? '${prefix[0].toUpperCase()}${prefix.substring(1)}'
            : 'User';
      }
    }
    return 'John William';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    // Partition sample products for Featured and Most Popular
    final featuredProducts = sampleProducts.take(4).toList();
    final popularProducts = sampleProducts.skip(3).take(4).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header (User Info + Notification Bell)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // User Avatar & Name
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFE5E7EB),
                          border: Border.all(
                            color: const Color(0xFF6055D8),
                            width: 1.5,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: user?.photoURL != null &&
                                  user!.photoURL!.isNotEmpty
                              ? Image.network(
                                  user.photoURL!,
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(
                                    child: Icon(
                                      Icons.person,
                                      color: Color(0xFF6055D8),
                                      size: 26,
                                    ),
                                  ),
                                )
                              : const Center(
                                  child: Icon(
                                    Icons.person,
                                    color: Color(0xFF6055D8),
                                    size: 26,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hello!',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9CA3AF),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _getUserName(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Notification Bell Interactive Toggle
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isNotificationActive = !_isNotificationActive;
                      });
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F4F6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isNotificationActive
                            ? Icons.notifications
                            : Icons.notifications_none_rounded,
                        color: _isNotificationActive
                            ? const Color(0xFF111827)
                            : const Color(0xFF9CA3AF),
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 2. Search Bar Redirect
              GestureDetector(
                onTap: () {
                  if (widget.onSearchTap != null) {
                    widget.onSearchTap!();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchScreen(),
                      ),
                    );
                  }
                },
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.search,
                        color: Color(0xFF9CA3AF),
                        size: 22,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Search here',
                        style: TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 3. Auto-Sliding Discount Banners + Page Indicator (CarouselSlider)
              CarouselSlider(
                options: CarouselOptions(
                  height: 140,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 500),
                  autoPlayCurve: Curves.easeInOut,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentBannerIndex = index;
                    });
                  },
                ),
                items: const [
                  DiscountBanner(
                    title: 'Get Winter Discount',
                    discount: '20% Off',
                    subtitle: 'For Childern',
                    imagePath: 'assets/images/discount.png',
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                  ),
                  DiscountBanner(
                    title: 'Summer Flash Sale',
                    discount: '30% Off',
                    subtitle: 'All Footwear',
                    imagePath: 'assets/images/footwear.png',
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                  ),
                  DiscountBanner(
                    title: 'Exclusive Weekend Offer',
                    discount: '15% Off',
                    subtitle: 'Electronics & Audio',
                    imagePath: 'assets/images/apple.png',
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                  ),
                  DiscountBanner(
                    title: 'New Season Arrival',
                    discount: '25% Off',
                    subtitle: 'Jackets & Hoodies',
                    imagePath: 'assets/images/hoodie&jacket.png',
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Smooth Animated Page Indicator
              Center(
                child: AnimatedSmoothIndicator(
                  activeIndex: _currentBannerIndex,
                  count: 4,
                  effect: const ExpandingDotsEffect(
                    dotHeight: 6,
                    dotWidth: 6,
                    expansionFactor: 3,
                    activeDotColor: Color(0xFF6055D8),
                    dotColor: Color(0xFFD1D5DB),
                    spacing: 4,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 4. Featured Section
              _buildSectionHeader(
                title: 'Featured',
                onSeeAllTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductsListScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),

              SizedBox(
                height: 168,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: featuredProducts.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: featuredProducts[index],
                      imageWidth: 126.0,
                      imageHeight: 99.0,
                      showAddButton: false,
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // 5. Most Popular Section
              _buildSectionHeader(
                title: 'Most Popular',
                onSeeAllTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductsListScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),

              SizedBox(
                height: 168,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: popularProducts.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: popularProducts[index],
                      imageWidth: 126.0,
                      imageHeight: 99.0,
                      showAddButton: false,
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /* ============= Section Header Helper Widget ============= */
  Widget _buildSectionHeader({
    required String title,
    required VoidCallback onSeeAllTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        GestureDetector(
          onTap: onSeeAllTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF6055D8).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6055D8),
                  ),
                ),
                SizedBox(width: 3),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 10,
                  color: Color(0xFF6055D8),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
