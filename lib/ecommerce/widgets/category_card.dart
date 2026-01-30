import 'package:flutter/material.dart';
import '/ecommerce/screens/shop_home_screen.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback? onAddToCart;

  const CategoryCard({
    super.key,
    required this.category,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // 👉 Navigate to category product list
        },
        child: Stack(
          children: [
            // ================= IMAGE =================
            Positioned.fill(
              child: Image.network(
                category.image,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                },
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),

            // ================= DARK GRADIENT =================
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.45),
                    ],
                  ),
                ),
              ),
            ),

            // ================= CATEGORY NAME =================
            Positioned(
              left: 10,
              right: 10,
              bottom: 48,
              child: Text(
                category.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // ================= ADD TO CART BUTTON =================
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: SizedBox(
                height: 34,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // 👉 Only add to cart (no navigation)
                    onAddToCart?.call();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${category.name} added to cart"),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: const Text(
                    "ADD TO CART",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
