/* =======================================================
   HOME NAV MODULE: Products List Screen
   ======================================================= */

import 'package:flutter/material.dart';
import '../widgets/product_card.dart';

/* ============= Products List Screen Widget ============= */
class ProductsListScreen extends StatelessWidget {
  const ProductsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Products',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          itemCount: sampleProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1.08,
          ),
          itemBuilder: (context, index) {
            final product = sampleProducts[index];
            return ProductCard(
              product: product,
              imageHeight: 115.0,
              showAddButton: true,
            );
          },
        ),
      ),
    );
  }
}
