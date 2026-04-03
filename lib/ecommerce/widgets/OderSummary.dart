import 'package:Dewa/ecommerce/widgets/payments_page.dart';
import 'package:Dewa/screens/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/Auth_Controller.dart';
import '../../controller/add_address_controller.dart';
import '../../controller/category_product_controller.dart';
import '../../controller/order_controller.dart';
import '../../models/category_product_model.dart';
import '../../screens/save_addesses_screen.dart';
import '../screens/locationpage.dart';

class OrderSummary extends StatelessWidget {
  final CategoryProduct? buyNowProduct;
  final CategoryProductController productController = Get.find<CategoryProductController>();
  final OrderController orderController =
  Get.isRegistered<OrderController>()
      ? Get.find<OrderController>()
      : Get.put(OrderController());
  final AddressController addressController =
  Get.isRegistered<AddressController>()
      ? Get.find<AddressController>()
      : Get.put(AddressController());
  OrderSummary({super.key, this.buyNowProduct});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      appBar: AppBar(
        title: const Text(
          "Order Summary",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF6200EA),
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
                _buildItemsSection(),
                const SizedBox(height: 8),
                _buildPriceDetailsSection(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
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


    return Obx(() {
      final address = addressController.selectedAddress.value;
      final pinAddress = addressController.currentPinAddress.value;

      return Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 TOP ROW (Title + Change)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Deliver to:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => SaveAddressesScreen(
                      mobile: Get.find<AuthController>().mobileNo.value,
                    ));
                  },
                  child: const Text(
                    "Change Address",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),

            const SizedBox(height: 10),

            // 📍 REFINE LOCATION SECTION
            InkWell(
              onTap: () async {
                final result = await Get.to(() => const SelectDeliveryLocationScreen());
                if (result != null && result is Map) {
                  addressController.currentPinAddress.value = result['address'] ?? "";
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.my_location, color: Colors.blue, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Refined Location (GPS)",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            pinAddress.isEmpty ? "Tap to refine on map" : pinAddress,
                            style: const TextStyle(fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                  ],
                ),
              ),
            ),

            if (address != null) ...[
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    address.addressType.toLowerCase() == 'home' 
                        ? Icons.home_work_outlined 
                        : Icons.business_outlined,
                    color: Colors.grey.shade600,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              address.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                address.addressType.toUpperCase(),
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${address.address}, ${address.city}, ${address.state} - ${address.pinCode}",
                          style: const TextStyle(color: Colors.black87, fontSize: 13, height: 1.4),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          address.mobileNo,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  "No saved address selected",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  // ================= ITEMS =================


  Widget _buildItemsSection() {
    return Obx(() {
      final order = orderController.orderData.value;

      if (order == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        children: order.items.map((item) {
          return Container(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 2),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // ✅ IMAGE
                Image.network(
                  item.imageUrl,
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

                const SizedBox(width: 12),

                // ✅ DETAILS
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "₹${item.price}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Qty: ${item.quantity}"),
                    ],
                  ),
                ),

                // ✅ TOTAL
                Text(
                  "₹${item.subtotal}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }).toList(),
      );
    });
  }

  // ================= PRICE DETAILS =================
  Widget _buildPriceDetailsSection() {
    return Obx(() {

      final order = orderController.orderData.value;

      if (order == null) {
        return const SizedBox();
      }

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

            _priceRow("Total Amount",
                "₹${order.totalAmount.toStringAsFixed(0)}"),

            _priceRow("Discount",
                "- ₹${order.discountAmount.toStringAsFixed(0)}",
                color: Colors.green),

            _priceRow("Tax",
                "₹${order.taxAmount.toStringAsFixed(0)}"),

            _priceRow("Shipping Charges",
                order.shippingCharge == 0
                    ? "FREE"
                    : "₹${order.shippingCharge.toStringAsFixed(0)}",
                color: order.shippingCharge == 0
                    ? Colors.green
                    : Colors.black),

            const Divider(),

            _priceRow("Final Amount",
                "₹${order.finalAmount.toStringAsFixed(0)}",
                isBold: true),
          ],
        ),
      );
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
  Widget _buildBottomBar() {
    return Obx(() {

      final order = orderController.orderData.value;

      if (order == null) {
        return const SizedBox();
      }

      return Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, -2))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "₹${order.finalAmount.toStringAsFixed(0)}",
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFB641B),
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 14),
              ),
              onPressed: () {
                // Get.snackbar(
                //   "Payment",
                //   "Redirecting to Secure Payment Gateway...",
                //   snackPosition: SnackPosition.BOTTOM,
                //   backgroundColor: Colors.green,
                //   colorText: Colors.white,
                // );
                Get.to(
                  PaymentPage(amount: order.finalAmount),
                );
              },
              child: const Text(
                "CONTINUE",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
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
