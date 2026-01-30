import 'package:flutter/material.dart';

import '../models/product.dart';
import 'item_detail_page.dart';

class CategoriesListPage extends StatefulWidget {
  final String category;

  const CategoriesListPage({
    super.key,
    required this.category,
  });

  @override
  State<CategoriesListPage> createState() => _CategoriesListPageState();
}

class _CategoriesListPageState extends State<CategoriesListPage> {
  int selectedIndex = 0;

  final List<String> subCategories = [
    "All",
    "Men",
    "Women",
    "Kids",
    "Footwear",
    "Accessories",
  ];

  final List<Product> _cartItems = [];

  final List<Product> products = [
    Product(
      id: "1",
      title: "Men Casual Shirt",
      price: 799,
      imageUrl: "https://images.unsplash.com/photo-1521334884684-d80222895322",
      description: "A comfortable and stylish casual shirt for men.",
      rating: 4.2,
    ),
    Product(
      id: "2",
      title: "Women Summer Dress",
      price: 1299,
      imageUrl: "https://images.unsplash.com/photo-1520975916090-3105956dac38",
      description: "Light and breezy summer dress using premium fabric.",
      rating: 4.5,
    ),
    Product(
      id: "3",
      title: "Kids Hoodie",
      price: 599,
      imageUrl: "https://images.unsplash.com/photo-1519238263530-99bdd11df2ea",
      description: "Warm and cozy hoodie for kids.",
      rating: 4.8,
    ),
    Product(
      id: "4",
      title: "Running Shoes",
      price: 2199,
      imageUrl: "https://images.unsplash.com/photo-1520975916090-3105956dac38",
      description: "High performance running shoes.",
      rating: 4.1,
    ),
    Product(
      id: "5",
      title: "Running Shoes",
      price: 2199,
      imageUrl: "https://images.unsplash.com/photo-1520975916090-3105956dac38",
      description: "High performance running shoes.",
      rating: 4.1,
    ),
    Product(
      id: "6",
      title: "Running Shoes",
      price: 2199,
      imageUrl: "https://images.unsplash.com/photo-1520975916090-3105956dac38",
      description: "High performance running shoes.",
      rating: 4.1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),

      // ================= APP BAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          widget.category,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= SEARCH BAR =================
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search products",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ================= HORIZONTAL CATEGORY FILTER =================
          SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: subCategories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final isSelected = selectedIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedIndex = index);
                  },
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF6B46C1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF6B46C1)
                            : Colors.black12,
                      ),
                    ),
                    child: Text(
                      subCategories[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // ================= PRODUCT GRID =================
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return _ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ItemDetailPage(
                          product: product,
                          onAddToCart: () {
                            setState(() {
                              _cartItems.add(product);
                            });
                          },
                        ),
                      ),
                    );
                  },

                );
              },
            ),
          ),

        ],
      ),
    );
  }
}
class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _ProductCard({
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(18)),
              child: Image.network(
                product.imageUrl,
                height: 170,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "₹${product.price}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B46C1),
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
