/* =======================================================
   REUSABLE WIDGET: Discount Banner
   ======================================================= */

import 'package:flutter/material.dart';

/* ============= Discount Banner Widget ============= */
class DiscountBanner extends StatelessWidget {
  final String title;
  final String discount;
  final String subtitle;
  final String imagePath;
  final EdgeInsetsGeometry? margin;

  const DiscountBanner({
    super.key,
    this.title = 'Get Winter Discount',
    this.discount = '20% Off',
    this.subtitle = 'For Childern',
    this.imagePath = 'assets/images/discount.png',
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 140,
      margin: margin,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF6055D8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Left Text Column
          Positioned(
            left: 20,
            top: 0,
            bottom: 0,
            right: 130,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  discount,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Right Image reaching top and bottom edges
          Positioned(
            right: 12,
            top: 2,
            bottom: -6,
            child: Image.asset(
              imagePath,
              fit: BoxFit.fitHeight,
              alignment: Alignment.topCenter,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  width: 80,
                  child: Center(
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
