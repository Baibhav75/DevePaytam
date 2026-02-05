import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../controllers/shop_controller.dart';
import 'item_detail_page.dart';

class CitizenCardList extends StatelessWidget {
  final String category;

  CitizenCardList ({
    super.key,
    required this.category,
  });

  final ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    // 🔥 Filter products by category
    final List<Product> categoryProducts = shopController.products
        .where((p) => p.category == category)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF1090FF),

      // ================= APP BAR =================
      appBar: AppBar(
        title: Text(category),
        centerTitle: true,
      ),

      // ================= BODY =================
      body: categoryProducts.isEmpty
          ? const Center(
        child: Text(
          "No products available",
          style: TextStyle(fontSize: 16),
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categoryProducts.length,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 12,
          childAspectRatio: 0.68,
        ),
        itemBuilder: (context, index) {
          final product = categoryProducts[index];

          return GestureDetector(
            onTap: () {
              // 👉 SAME ITEM DETAIL PAGE
              Get.to(() => ItemDetailPage(product: product));
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      product.imageUrl,
                      height: 150,
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
        },
      ),
    );
  }
}
