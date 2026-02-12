import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/category_product_controller.dart';
import '../../models/category_product_model.dart';

class OrderSummary extends StatelessWidget {
  final CategoryProduct? buyNowProduct;

  const OrderSummary({super.key, this.buyNowProduct});

  @override
  Widget build(BuildContext context) {
    final CategoryProductController productController = Get.find<CategoryProductController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      appBar: AppBar(
        title: const Text(
          "Order Summary",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
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
                _buildItemsSection(productController),
                const SizedBox(height: 8),
                _buildPriceDetailsSection(productController),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(productController),
    );
  }

  // ================= STEP INDICATOR =================

  Widget _buildStepIndicator() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _stepItem("Address", true),
          _stepDivider(true),
          _stepItem("Summary", true),
          _stepDivider(false),
          _stepItem("Payment", false),
        ],
      ),
    );
  }

  Widget _stepItem(String label, bool active) {
    return Column(
      children: [
        Icon(
          Icons.check_circle,
          size: 18,
          color: active ? const Color(0xFF2874F0) : Colors.grey,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            color: active ? Colors.black : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _stepDivider(bool active) {
    return Container(
      width: 40,
      height: 1,
      color: active ? const Color(0xFF2874F0) : Colors.grey.shade300,
    );
  }

  // ================= ADDRESS =================

  Widget _buildAddressSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Deliver to:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Text("Baibhav Kumar - 800001",
              style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 4),
          Text(
            "Flat No. 101, Dream Residency, Boring Road, Patna, Bihar",
            style: TextStyle(color: Colors.black54, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ================= ITEMS =================

  Widget _buildItemsSection(CategoryProductController productController) {
    if (buyNowProduct != null) {
      return _OrderItemTile(product: buyNowProduct!);
    }

    return Obx(() {
      final items = productController.cartItems;
      if (items.isEmpty) return const SizedBox();
      return Column(
        children: items.map((product) => _OrderItemTile(product: product)).toList(),
      );
    });
  }

  // ================= PRICE DETAILS =================

  Widget _buildPriceDetailsSection(CategoryProductController productController) {
    if (buyNowProduct != null) {
      return _buildPriceDetails(buyNowProduct!.afterDiscount, 1);
    }

    return Obx(() {
      final total = productController.cartItems.fold(0.0, (sum, item) => sum + item.afterDiscount);
      final count = productController.cartItems.length;
      return _buildPriceDetails(total, count);
    });
  }

  Widget _buildPriceDetails(double total, int count) {
    double discount = total * 0.1;
    double delivery = total > 499 ? 0 : 40;
    double finalPrice = total - discount + delivery;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Price Details",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.grey),
          ),
          const Divider(),
          _priceRow("Price ($count items)", "₹${total.toStringAsFixed(0)}"),
          _priceRow("Discount (10%)",
              "- ₹${discount.toStringAsFixed(0)}", color: Colors.green),
          _priceRow("Delivery Charges",
              delivery == 0 ? "FREE" : "₹${delivery.toStringAsFixed(0)}",
              color: delivery == 0 ? Colors.green : Colors.black),
          const Divider(),
          _priceRow("Total Amount", "₹${finalPrice.toStringAsFixed(0)}",
              isBold: true),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value,
      {Color? color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: color ?? Colors.black)),
        ],
      ),
    );
  }

  // ================= BOTTOM BAR =================

  Widget _buildBottomBar(CategoryProductController productController) {
    return Obx(() {
      // Accessing cartCount here ensures Obx always has an observable to watch,
      // preventing "improper use of GetX" error even when buyNowProduct is used.
      final _ = productController.cartItems.length;

      double total = buyNowProduct != null ? buyNowProduct!.afterDiscount : productController.cartItems.fold(0.0, (sum, item) => sum + item.afterDiscount);

      double discount = total * 0.1;
      double delivery = total > 499 ? 0 : 40;
      double finalPrice = total - discount + delivery;

      return Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, -2))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "₹${finalPrice.toStringAsFixed(0)}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFB641B),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              ),
              onPressed: () {
                Get.snackbar(
                  "Payment",
                  "Redirecting to Secure Payment Gateway...",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              },
              child: const Text(
                "CONTINUE",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ================= ORDER ITEM TILE =================

class _OrderItemTile extends StatelessWidget {
  final CategoryProduct product;

  const _OrderItemTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Image.network(
            product.fullImageUrl,
            height: 80,
            width: 70,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Container(
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
                Text(product.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 6),
                Text(
                  "₹${product.afterDiscount}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
