import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/HomeCategory_controller.dart';
import '../../controller/sub_category_controller.dart';

import '../../models/category_product_model.dart';
import 'badge_icon.dart';
import 'cart_page.dart';
import 'item_detail_page.dart';
import '../../controller/category_product_controller.dart';

class CategoriesListPage extends StatefulWidget {
  final String category;
  final int categoryId;


  const CategoriesListPage({super.key, required this.category,  required this.categoryId,});

  @override
  State<CategoriesListPage> createState() => _CategoriesListPageState();
}

class _CategoriesListPageState extends State<CategoriesListPage> {
  final CategoryProductController productController =
  Get.put(CategoryProductController());

  // ✅ ADD THIS LINE
  final HomecategoryControllerController homeCategoryController =
  Get.find<HomecategoryControllerController>();


  final SubCategoryController subCategoryController =
  Get.find<SubCategoryController>();


  @override
  void initState() {
    super.initState();

    // Fetch subcategories
    subCategoryController.fetchSubCategories(widget.categoryId);

    // Fetch products by category
    productController.fetchProducts(widget.categoryId);
  }

  @override
  void dispose() {
    productController.clearProducts();
    super.dispose();
  }

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

        // Cart icon with badge
        actions: [
          Obx(
                () => BadgeIcon(
              icon: Icons.shopping_cart,
              count: productController.cartCount.value,
              iconColor: Colors.black,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CartPage()),
                );
              },
            ),
          ),
        ],



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
            child: Obx(() {
              if (subCategoryController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: subCategoryController.subCategories.length + 1, // +1 for "All"
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final bool isAll = index == 0;
                  final sub = isAll ? null : subCategoryController.subCategories[index - 1];
                  final subId = isAll ? 0 : sub!.subCategoryId;
                  final subName = isAll ? "All" : sub!.subCategoryName;
                  
                  final isSelected = subCategoryController.selectedSubCategoryId.value == subId;

                  return GestureDetector(
                    onTap: () {
                      subCategoryController.selectSubCategory(subId);
                      // productController.fetchProducts(widget.categoryId); // Already reactive via Obx in GridView
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
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
                        subName,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          const SizedBox(height: 16),

          // ================= PRODUCT GRID =================
          Expanded(
            child: Obx(() {

              if (productController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (productController.errorMessage.isNotEmpty) {
                return Center(
                  child: Text(productController.errorMessage.value),
                );
              }

              if (productController.products.isEmpty) {
                return const Center(
                  child: Text("No products found"),
                );
              }

              return RefreshIndicator(
                onRefresh: productController.refreshProducts,
                child: Obx(() {
                  final selectedSubId = subCategoryController.selectedSubCategoryId.value;
                  final filteredProducts = selectedSubId == 0
                      ? productController.products
                      : productController.products.where((p) => p.subCategoryId == selectedSubId).toList();

                  if (filteredProducts.isEmpty) {
                    return const Center(child: Text("No products found for this sub-category"));
                  }

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final screenWidth = constraints.maxWidth;

                      // 2 column ke hisaab se item width calculate
                      final itemWidth = (screenWidth - 16 * 2 - 12) / 2;

                      // Approximate item height (adjust if needed)
                      final itemHeight = itemWidth * 1.45;

                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredProducts.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 12,
                          childAspectRatio: itemWidth / itemHeight,
                        ),
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return _ProductCard(product: product);
                        },
                      );
                    },
                  );
                }),
              );
            }),
          ),

        ],
      ),
    );
  }
}
class _ProductCard extends StatelessWidget {
  final CategoryProduct product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<CategoryProductController>();

    return GestureDetector(
      onTap: () {
        Get.to(() => ItemDetailPage(
          productId: product.productId,
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          children: [

            SizedBox(
              height: 160, // 👈 controlled image height
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: Container(
                  width: double.infinity,
                  color: Colors.grey.shade50,
                  padding: const EdgeInsets.all(10),
                  child: Image.network(
                    product.fullImageUrl,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
            ),

            /// CONTENT
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// NAME
                    Text(
                      product.productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// PRICE
                    Text(
                      "₹${product.afterDiscount}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            "₹${product.mrp}",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "-${product.discount.toStringAsFixed(0)}%",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                          ),
                        ),
                        const Spacer(),

                        /// ADD BUTTON
                        InkWell(
                          onTap: () {
                            controller.addToCart(product);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
