import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/controller/HomeCategory_controller.dart';
import '/models/home_category_model.dart';
import 'categories_list_page.dart';
import 'category_list_page.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final HomecategoryControllerController shopController = Get.find<HomecategoryControllerController>();

    return Obx(
          () {
        // ================= LOADING =================
        if (shopController.isLoadingCategories.value) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }

        // ================= EMPTY =================
        if (shopController.categories.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "No categories available",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        final categories = shopController.categories;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= TITLE ROW =================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Categories",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.to(() => const CategoryListPage());
                  },
                  child: const Text(
                    "View All",
                    style: TextStyle(
                      color: Color(0xFF2874F0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ================= CATEGORY GRID =================
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length > 8 ? 8 : categories.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                final HomeCategory category = categories[index];
                return _CategoryCard(
                  category: category,
                  onTap: () {
                    Get.to(
                          () => CategoriesListPage(
                        category: category.categoryName,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}

// ===================================================================

class _CategoryCard extends StatelessWidget {
  final HomeCategory category;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ================= IMAGE =================
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
                child: Image.network(
                  category.fullImageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.category,
                      size: 30,
                      color: Colors.grey,
                    );
                  },
                ),

              ),
            ),

            // ================= LABEL =================
            Container(
              padding:
              const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              decoration: const BoxDecoration(
                color: Color(0xFF6B46C1),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(14),
                ),
              ),
              child: Text(
                category.categoryName.toUpperCase(),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
