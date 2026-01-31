import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/shop_controller.dart';
import '../models/product.dart';
import '../widgets/cart_page.dart';

class BestSellingDetailsPage extends StatefulWidget {
  final Product product;

  const BestSellingDetailsPage({
    super.key,
    required this.product,
  });

  @override
  State<BestSellingDetailsPage> createState() => _BestSellingDetailsPageState();
}

class _BestSellingDetailsPageState extends State<BestSellingDetailsPage> {
  int selectedSizeIndex = 0;
  final PageController _pageController = PageController();
  final List<String> sizes = ["S", "M", "L", "XL", "XXL"];
  
  // Carousel images (using product image + placeholders for demo)
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

  @override
  Widget build(BuildContext context) {
    final ShopController shopController = Get.find<ShopController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Get.to(() => const CartPage()),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Carousel
                Stack(
                  children: [
                    SizedBox(
                      height: 400,
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
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          images.length,
                          (index) => Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Obx(() {
                        final isFavorite = shopController.isFavorite(widget.product);
                        return GestureDetector(
                          onTap: () => shopController.toggleFavorite(widget.product),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                              size: 24,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),

                // Product Details
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.category,
                        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.product.title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  widget.product.rating.toString(),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.star, color: Colors.white, size: 14),
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
                      Row(
                        children: [
                          Text(
                            "₹${widget.product.price.toInt()}",
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "₹${(widget.product.price * 1.5).toInt()}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "33% off",
                            style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Size Selection
                      const Text(
                        "Select Size",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: sizes.length,
                          itemBuilder: (context, index) {
                            final isSelected = selectedSizeIndex == index;
                            return GestureDetector(
                              onTap: () => setState(() => selectedSizeIndex = index),
                              child: Container(
                                width: 50,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isSelected ? Colors.blue : Colors.grey.shade300,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  color: isSelected ? Colors.blue.withOpacity(0.05) : Colors.white,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  sizes[index],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? Colors.blue : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Description
                      const Text(
                        "Product Details",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.product.description,
                        style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Offers
                      const Text(
                        "Available Offers",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      _buildOfferItem("Bank Offer", "10% off on SBI Credit Cards, up to ₹1500."),
                      _buildOfferItem("Special Price", "Get extra ₹200 off (price inclusive of cash discount)"),
                      _buildOfferItem("Free Delivery", "On orders above ₹499"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        shopController.addToCart(widget.product);
                        Get.snackbar(
                          "Added to Cart",
                          "${widget.product.title} has been added to your cart",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.black87,
                          colorText: Colors.white,
                        );
                        Get.to(() => const CartPage());
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          "ADD TO CART",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        // Buy now logic
                      },
                      child: Container(
                        alignment: Alignment.center,
                        color: const Color(0xFFFF9F00), // Flipkart Orange
                        child: const Text(
                          "BUY NOW",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
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

  Widget _buildOfferItem(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.local_offer, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 13),
                children: [
                  TextSpan(text: "$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: desc),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
