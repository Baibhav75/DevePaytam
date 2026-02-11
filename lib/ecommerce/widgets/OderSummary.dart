import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/shop_controller.dart';
import '../models/product.dart';

class OrderSummary extends StatelessWidget {
  final Product? buyNowProduct;

  const OrderSummary({super.key, this.buyNowProduct});

  @override
  Widget build(BuildContext context) {
    final ShopController shopController = Get.find<ShopController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      appBar: AppBar(
        title: const Text(
          "Order Summary",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color(0xFF2874F0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: ListView(
              children: [
                _buildAddressSection(),
                const SizedBox(height: 8),
                _buildItemsSection(shopController),
                const SizedBox(height: 8),
                _buildPriceDetailsSection(shopController),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(shopController),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _stepItem("Address", Icons.location_on, true),
          _stepDivider(isActive: true),
          _stepItem("Summary", Icons.assignment, true),
          _stepDivider(isActive: false),
          _stepItem("Payment", Icons.payment, false),
        ],
      ),
    );
  }

  Widget _stepItem(String label, IconData icon, bool isActive) {
    return Column(
      children: [
        Icon(icon, size: 20, color: isActive ? const Color(0xFF2874F0) : Colors.grey),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? Colors.black : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _stepDivider({required bool isActive}) {
    return Container(
      width: 40,
      height: 1,
      color: isActive ? const Color(0xFF2874F0) : Colors.grey.shade300,
    );
  }

  Widget _buildAddressSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Deliver to:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Change",
                  style: TextStyle(color: Color(0xFF2874F0), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const Text(
            "Baibhav Kumar, 800001",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            "Flat No. 101, Dream Residency, Boring Road, Patna, Bihar",
            style: TextStyle(color: Colors.black54, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection(ShopController shopController) {
    if (buyNowProduct != null) {
      return _OrderItemTile(product: buyNowProduct!);
    }
    return Obx(() {
      final items = shopController.cartItems;
      if (items.isEmpty) return const SizedBox.shrink();
      return Column(
        children: items.map((product) => _OrderItemTile(product: product)).toList(),
      );
    });
  }

  Widget _buildPriceDetailsSection(ShopController shopController) {
    if (buyNowProduct != null) {
      return _buildPriceDetails(buyNowProduct!.price, 1);
    }
    return Obx(() {
      final total = shopController.getTotalAmount();
      final count = shopController.cartCount;
      return _buildPriceDetails(total, count);
    });
  }

  Widget _buildPriceDetails(double total, int count) {
    double discount = total * 0.1;
    double delivery = 40;
    double finalPrice = total - discount + delivery;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Price Details",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const Divider(),
          _priceRow("Price ($count items)", "₹${total.toStringAsFixed(0)}"),
          _priceRow("Discount", "- ₹${discount.toStringAsFixed(0)}", color: Colors.green),
          _priceRow("Delivery Charges", "₹${delivery.toStringAsFixed(0)}"),
          const Divider(),
          _priceRow("Total Amount", "₹${finalPrice.toStringAsFixed(0)}", isBold: true),
          const Divider(),
          Text(
            "You will save ₹${discount.toStringAsFixed(0)} on this order",
            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value, {Color? color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 15, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(ShopController shopController) {
    Widget bottomBarContent(double total) {
      double finalPrice = total - (total * 0.1) + 40;
      return Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, -2))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "₹${finalPrice.toStringAsFixed(0)}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "View price details",
                  style: TextStyle(color: Color(0xFF2874F0), fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFB641B),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: const RoundedRectangleBorder(),
              ),
              onPressed: () {
                Get.snackbar("Success", "Connecting to Secure Payment Gateway...",
                    snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
              },
              child: const Text(
                "CONTINUE",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      );
    }

    if (buyNowProduct != null) {
      return bottomBarContent(buyNowProduct!.price);
    }

    return Obx(() => bottomBarContent(shopController.getTotalAmount()));
  }
}

class _OrderItemTile extends StatelessWidget {
  final Product product;

  const _OrderItemTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            product.imageUrl,
            height: 80,
            width: 70,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 80,
              width: 70,
              color: Colors.grey.shade200,
              child: const Icon(Icons.image_not_supported),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 4),
                Text(
                  "₹${product.price}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Delivery by Tue, Feb 11 | Free",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
