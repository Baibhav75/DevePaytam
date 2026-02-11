import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/shop_controller.dart';
import '../models/product.dart';
import 'cart_page.dart';
import 'OderSummary.dart';

class ItemDetailPage extends StatefulWidget {
  final Product product;

  const ItemDetailPage({
    super.key,
    required this.product,
  });

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  int selectedSizeIndex = 0;
  final PageController _pageController = PageController();
  final ShopController shopController = Get.find<ShopController>();

  late final List<String> images;

  @override
  void initState() {
    super.initState();
    images = [
      widget.product.imageUrl,
      "https://images.unsplash.com/photo-1520975916090-3105956dac38", // Placeholder
      "https://images.unsplash.com/photo-1519238263530-99bdd11df2ea", // Placeholder
    ];
  }

  final List<String> sizes = ["S", "M", "L", "XL", "XXL"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),

      // ================= BODY =================
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= IMAGE CAROUSEL =================
                Stack(
                  children: [
                    SizedBox(
                      height: 340,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return Image.network(
                            images[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          );
                        },
                      ),
                    ),

                    // BACK BUTTON
                    Positioned(
                      top: 50,
                      left: 16,
                      child: _circleIcon(
                        icon: Icons.arrow_back,
                        onTap: () => Navigator.pop(context),
                      ),
                    ),

                    // WISHLIST
                    Positioned(
                      top: 50,
                      right: 16,
                      child: Obx(() {
                        final isFavorite = shopController.isFavorite(widget.product);
                        return GestureDetector(
                          onTap: () {
                            shopController.toggleFavorite(widget.product);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.black,
                              size: 22,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),

                // ================= PRODUCT INFO =================
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TITLE
                      Text(
                        widget.product.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // RATING
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              children: [
                                Text(
                                  "4.3",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 4),
                                Icon(Icons.star,
                                    color: Colors.white, size: 14),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "2,345 ratings",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // PRICE
                      Row(
                        children: [
                          Text(
                            "₹${widget.product.price}",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "₹1299",
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "38% OFF",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // ================= SIZE SELECTOR =================
                      const Text(
                        "Select Size",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        height: 44,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: sizes.length,
                          separatorBuilder: (_, __) =>
                          const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final isSelected =
                                selectedSizeIndex == index;
                            return GestureDetector(
                              onTap: () {
                                setState(() =>
                                selectedSizeIndex = index);
                              },
                              child: Container(
                                width: 48,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF2874F0)
                                        : Colors.grey.shade400,
                                  ),
                                  color: isSelected
                                      ? const Color(0xFF2874F0)
                                      .withOpacity(0.1)
                                      : Colors.white,
                                ),
                                child: Text(
                                  sizes[index],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? const Color(0xFF2874F0)
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ================= OFFERS =================
                      const Text(
                        "Available Offers",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      _offerTile("Bank Offer",
                          "5% Cashback on Axis Bank Cards"),
                      _offerTile("Special Price",
                          "Extra ₹100 off on prepaid orders"),
                      _offerTile("Free Delivery",
                          "On orders above ₹499"),

                      const SizedBox(height: 24),

                      // ================= DESCRIPTION =================
                      const Text(
                        "Product Description",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        widget.product.description.isNotEmpty
                            ? widget.product.description
                            : "Premium cotton shirt with slim fit design. "
                            "Perfect for casual & office wear. "
                            "Soft fabric, breathable and durable.",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ================= BOTTOM BAR =================
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        // Add to cart using GetX controller
                        shopController.addToCart(widget.product);

                        // Show confirmation
                        Get.snackbar(
                          'Added to Cart',
                          "${widget.product.title} added to cart",
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 1),
                        );

                        // Navigate to cart
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CartPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "ADD TO CART",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      color: const Color(0xFFFB641B),
                      child: TextButton(
                        onPressed: () {
                          Get.to(() => OrderSummary(buyNowProduct: widget.product));
                        },
                        child: const Text(
                          "BUY NOW",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= HELPER WIDGETS =================

  Widget _circleIcon({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 22),
        ),
      ),
    );
  }

  Widget _offerTile(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.local_offer,
              color: Colors.green, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: "$title: ",
                    style:
                    const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: subtitle),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
