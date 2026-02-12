import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/category_product_controller.dart';
import '../../models/category_product_model.dart';
import 'item_detail_page.dart';

class CitizenCardList extends StatefulWidget {
  final String category;
  final int categoryId; // 🔥 Important

  const CitizenCardList({
    super.key,
    required this.category,
    required this.categoryId,
  });

  @override
  State<CitizenCardList> createState() => _CitizenCardListState();
}

class _CitizenCardListState extends State<CitizenCardList> {

  final CategoryProductController controller =
  Get.put(CategoryProductController());

  @override
  void initState() {
    super.initState();
    controller.fetchProducts(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1090FF),

      appBar: AppBar(
        title: Text(widget.category),
        centerTitle: true,
      ),

      body: Obx(() {

        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.products.isEmpty) {
          return const Center(
            child: Text(
              "No products available",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.products.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 12,
            childAspectRatio: 0.68,
          ),
          itemBuilder: (context, index) {
            final CategoryProduct product =
            controller.products[index];

            return GestureDetector(
              onTap: () {
                // 🔥 Pass productId to detail page
                Get.to(() => ItemDetailPage(
                  productId: product.productId,
                ));
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
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                      const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.network(
                        product.fullImageUrl,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                        const Icon(Icons.image),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.productName,
                            maxLines: 2,
                            overflow:
                            TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "₹${product.afterDiscount}",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight:
                              FontWeight.bold,
                              color:
                              Color(0xFF6B46C1),
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
        );
      }),
    );
  }
}
