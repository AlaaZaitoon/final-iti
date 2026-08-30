/* =======================================================
   HOME NAV MODULE: Search Screen (with Category Filter Chips)
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
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Clothing',
    'Electronics',
    'Shoes',
    'Watches',
  ];

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

  /* ============= Combined Search & Category Filter Logic ============= */
  void _applyFilter({String? query, String? category}) {
    setState(() {
      if (query != null) _searchQuery = query.trim();
      if (category != null) _selectedCategory = category;

      _filteredProducts = sampleProducts.where((product) {
        // 1. Text Search Filter
        final queryLower = _searchQuery.toLowerCase();
        final matchesQuery = _searchQuery.isEmpty ||
            product.title.toLowerCase().contains(queryLower) ||
            product.brand.toLowerCase().contains(queryLower);

        // 2. Category Filter
        bool matchesCategory = true;
        if (_selectedCategory == 'Clothing') {
          matchesCategory = ['jacket', 'hoodie', 'girl', 't-shirt']
              .contains(product.id.toLowerCase());
        } else if (_selectedCategory == 'Electronics') {
          matchesCategory =
              ['airpods', 'tv'].contains(product.id.toLowerCase());
        } else if (_selectedCategory == 'Shoes') {
          matchesCategory = product.id.toLowerCase().contains('nike');
        } else if (_selectedCategory == 'Watches') {
          matchesCategory = product.id.toLowerCase().contains('watch');
        }

        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  /* ============= Clear Search Input ============= */
  void _clearSearch() {
    _searchController.clear();
    _applyFilter(query: '');
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
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
                              onChanged: (q) => _applyFilter(query: q),
                              autofocus: false,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF111827),
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Search products or brands...',
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
                  if (_searchController.text.isNotEmpty) ...[
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _clearSearch,
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

            const SizedBox(height: 14),

            // 2. Category Filter Chips (Horizontal Scroll)
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: _categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;

                  return GestureDetector(
                    onTap: () => _applyFilter(category: category),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF6055D8)
                            : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF6055D8)
                                      .withOpacity(0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 14),

            // 3. Results Count Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedCategory == 'All'
                        ? (_searchQuery.isEmpty
                            ? 'All Products'
                            : 'Results for "$_searchQuery"')
                        : '$_selectedCategory (${_filteredProducts.length})',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                  ),
                  Text(
                    '${_filteredProducts.length} items',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6055D8),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 4. Results Grid View
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
                            'No products found in $_selectedCategory',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Try selecting another category or keyword',
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
                        childAspectRatio: 1.08,
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
