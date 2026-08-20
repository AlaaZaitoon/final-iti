/* =======================================================
   REUSABLE WIDGET: Product Card
   ======================================================= */

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../home_nav/product_details_screen.dart';

/* ============= Product Model ============= */
class Product {
  final String id;
  final String title;
  final double price;
  final String image;
  final String brand;
  final double rating;
  final int reviews;
  final String description;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    this.brand = 'Brand',
    this.rating = 4.5,
    this.reviews = 20,
    this.description =
        'Culpa aliquam consequuntur veritatis at consequuntur praesentium beatae temporibus nobis. Velit dolorem facilis neque autem. Itaque voluptatem expedita qui eveniet id veritatis eaque. Blanditiis quia placeat nemo. Nobis laudantium nesciunt perspiciatis sit eligendi.',
  });
}

/* ============= Global Sample Product Catalog ============= */
const List<Product> sampleProducts = [
  Product(
    id: 'watch',
    title: 'Watch',
    price: 40.0,
    image: 'assets/images/watch.png',
    brand: 'Rolex',
    rating: 4.8,
    reviews: 35,
    description:
        'A luxury analog timepiece crafted with premium materials, water resistance, and an elegant stainless steel finish for any occasion.',
  ),
  Product(
    id: 'nike',
    title: 'Nike Shoes',
    price: 430.0,
    image: 'assets/images/nike.png',
    brand: 'Nike',
    rating: 4.5,
    reviews: 20,
    description:
        'Culpa aliquam consequuntur veritatis at consequuntur praesentium beatae temporibus nobis. Velit dolorem facilis neque autem. Itaque voluptatem expedita qui eveniet id veritatis eaque. Blanditiis quia placeat nemo. Nobis laudantium nesciunt perspiciatis sit eligendi.',
  ),
  Product(
    id: 'airpods',
    title: 'Airpods',
    price: 333.0,
    image: 'assets/images/airpods.png',
    brand: 'Apple',
    rating: 4.9,
    reviews: 58,
    description:
        'Wireless Bluetooth earbuds delivering rich, immersive sound, active noise cancellation, and seamless connectivity with all your devices.',
  ),
  Product(
    id: 'tv',
    title: 'LG TV',
    price: 330.0,
    image: 'assets/images/tv.png',
    brand: 'LG',
    rating: 4.7,
    reviews: 42,
    description:
        'Ultra HD smart television featuring vibrant OLED display, ultra-low latency gaming mode, and cinematic audio experience.',
  ),
  Product(
    id: 'jacket',
    title: 'Jacket',
    price: 400.0,
    image: 'assets/images/jacket.png',
    brand: 'Zara',
    rating: 4.8,
    reviews: 27,
    description:
        'Premium winter insulated down jacket with waterproof outer shell, detachable hood, and fleece-lined pockets.',
  ),
  Product(
    id: 'hoodie',
    title: 'Hoodie',
    price: 50.0,
    image: 'assets/images/hoodie.png',
    brand: 'Puma',
    rating: 4.6,
    reviews: 19,
    description:
        'Casual soft-cotton fleece pullover hoodie offering comfort, warmth, and a stylish relaxed fit for daily streetwear.',
  ),
  Product(
    id: 'girl',
    title: 'Girl T-Shirt',
    price: 45.0,
    image: 'assets/images/girl.png',
    brand: 'H&M',
    rating: 4.4,
    reviews: 14,
    description:
        'Breathable pure cotton casual graphic t-shirt with modern print and lightweight relaxed fit.',
  ),
  Product(
    id: 't-shirt',
    title: 'Pink Sweater',
    price: 60.0,
    image: 'assets/images/t-shirt.png',
    brand: 'Urban',
    rating: 4.5,
    reviews: 22,
    description:
        'Soft knit crewneck pastel sweater designed for a chic, cozy layer during chilly mornings and evenings.',
  ),
];

/* ============= Product Card Widget ============= */
class ProductCard extends StatefulWidget {
  final Product product;
  final double? imageWidth;
  final double imageHeight;
  final bool showAddButton;

  const ProductCard({
    super.key,
    required this.product,
    this.imageWidth,
    this.imageHeight = 99.0,
    this.showAddButton = false,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  /* ============= Check Favorite Status in Firestore ============= */
  Future<void> _checkFavoriteStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(widget.product.id)
          .get();

      if (doc.exists && mounted) {
        setState(() {
          _isFavorite = true;
        });
      }
    } catch (_) {}
  }

  /* ============= Toggle Favorite Action ============= */
  Future<void> _toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      _isFavorite = !_isFavorite;
    });

    if (user != null) {
      final favDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(widget.product.id);

      if (_isFavorite) {
        await favDoc.set({
          'id': widget.product.id,
          'title': widget.product.title,
          'price': widget.product.price,
          'image': widget.product.image,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        await favDoc.delete();
      }
    }
  }

  /* ============= Add to Cart Action ============= */
  Future<void> _addToCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to add items to cart')),
      );
      return;
    }

    try {
      final cartDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(widget.product.id);

      final snapshot = await cartDoc.get();
      if (snapshot.exists) {
        final currentQty = snapshot.data()?['quantity'] ?? 1;
        await cartDoc.update({
          'quantity': currentQty + 1,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        await cartDoc.set({
          'id': widget.product.id,
          'title': widget.product.title,
          'price': widget.product.price,
          'image': widget.product.image,
          'brand': widget.product.brand,
          'size': '38',
          'quantity': 1,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.product.title} added to cart'),
            backgroundColor: const Color(0xFF6055D8),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add to cart: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProductDetailsScreen(product: widget.product),
          ),
        );
      },
      child: Container(
        width: widget.imageWidth,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F7F7),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Product Image Container
            Stack(
              children: [
                Container(
                  height: widget.imageHeight,
                  width: widget.imageWidth ?? double.infinity,
                  color: const Color(0xFFE5E7EB),
                  child: Image.asset(
                    widget.product.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image, color: Colors.grey),
                  ),
                ),

                // Heart Favorite Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: _toggleFavorite,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // 2. Product Details Row
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title & Price Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '\$${widget.product.price.toInt()}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6055D8),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Circular Plus Button
                  if (widget.showAddButton)
                    GestureDetector(
                      onTap: _addToCart,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF6055D8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
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
}
