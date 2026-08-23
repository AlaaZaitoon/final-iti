/* =======================================================
   HOME NAV MODULE: Search Screen
   ======================================================= */

import 'package:flutter/material.dart';
import '../widgets/product_card.dart';

/* ============= Search Screen Widget ============= */
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = sampleProducts;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredProducts = sampleProducts;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /* ============= Search Filter Logic ============= */
  void _filterProducts(String query) {
    setState(() {
      _searchQuery = query.trim();
      if (_searchQuery.isEmpty) {
        _filteredProducts = sampleProducts;
      } else {
        _filteredProducts = sampleProducts.where((product) {
          final queryLower = _searchQuery.toLowerCase();
          return product.title.toLowerCase().contains(queryLower);
        }).toList();
      }
    });
  }

  /* ============= Clear Search Input ============= */
  void _clearSearch() {
    _searchController.clear();
    _filterProducts('');
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final bool canPop = Navigator.canPop(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // 1. Search Header Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  // Optional Back Arrow if navigated to
                  if (canPop) ...[
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
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
                    const SizedBox(width: 10),
                  ],

                  // Search Text Field Container
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: Color(0xFF9CA3AF),
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: _filterProducts,
                              autofocus: false,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF111827),
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Search here',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF9CA3AF),
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),

                          // Clear Icon Button
                          if (_searchController.text.isNotEmpty)
                            GestureDetector(
                              onTap: _clearSearch,
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.cancel,
                                  color: Color(0xFF9CA3AF),
                                  size: 18,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Cancel Action Button
                  if (_searchController.text.isNotEmpty || canPop) ...[
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        _clearSearch();
                        if (canPop) {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(0xFF6055D8),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 2. Results Count Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _searchQuery.isEmpty
                        ? 'All Products'
                        : 'Results for "$_searchQuery"',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                  ),
                  Text(
                    '${_filteredProducts.length} Results Found',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6055D8),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 3. Results Grid View
            Expanded(
              child: _filteredProducts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'No products found for "$_searchQuery"',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Try searching with different keywords',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      itemCount: _filteredProducts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 0.88,
                      ),
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        return ProductCard(
                          product: product,
                          imageHeight: 115.0,
                          showAddButton: true,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
