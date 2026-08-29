/* =======================================================
   HOME NAV MODULE: Favorites / Wishlist Screen
   ======================================================= */

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/product_card.dart';
import 'product_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  Future<void> _removeFavorite(String productId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(productId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFF111827),
                size: 20,
              ),
            ),
          ),
        ),
        title: const Text(
          'My Wishlist',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: user == null
          ? const Center(
              child: Text(
                'Please sign in to view your wishlist',
                style: TextStyle(color: Color(0xFF6B7280)),
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('favorites')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF6055D8),
                    ),
                  );
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF3F4F6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite_border_rounded,
                            size: 42,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Your Wishlist is Empty',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Save items you like by tapping the heart icon',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16.0,
                  ),
                  itemCount: docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14.0,
                    mainAxisSpacing: 14.0,
                    childAspectRatio: 0.78,
                  ),
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final String id = data['id'] ?? docs[index].id;
                    final String title = data['title'] ?? 'Product';
                    final double price =
                        (data['price'] as num?)?.toDouble() ?? 0.0;
                    final String image =
                        data['image'] ?? 'assets/images/discount.png';

                    // Find matching product from catalog or create a fallback
                    final matchedProduct = sampleProducts.firstWhere(
                      (p) => p.id == id,
                      orElse: () => Product(
                        id: id,
                        title: title,
                        price: price,
                        image: image,
                      ),
                    );

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(
                              product: matchedProduct,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F7F7),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Image + Remove Button
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    height: 110,
                                    width: double.infinity,
                                    color: const Color(0xFFE5E7EB),
                                    child: Image.asset(
                                      image,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.image,
                                                  color: Colors.grey),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: GestureDetector(
                                    onTap: () => _removeFavorite(id),
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.favorite_rounded,
                                        color: Color(0xFFFF4B4B),
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${price.toInt()}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6055D8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
