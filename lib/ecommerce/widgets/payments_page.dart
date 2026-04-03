import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/Auth_Controller.dart';
import '../../controller/add_address_controller.dart';
import '../../controller/order_controller.dart';
import '../../controller/profile_controller.dart';
import '../../theme/app_colors.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
// <-- your file

class PaymentPage extends StatefulWidget {

  final double amount;
  const PaymentPage({Key? key, required this.amount}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}


class _PaymentPageState extends State<PaymentPage> {
  final OrderController orderController = Get.find<OrderController>();

  late Razorpay _razorpay;   // ✅ YAHAN ADD
  bool showDetails = false;
  // ================= INIT =================
  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
  }

  // ================= PAYMENTSUCCESS / ERROR =================
  void handlePaymentSuccess(PaymentSuccessResponse response) async {
    _processOnlineOrder(response.paymentId ?? "");
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar("Payment Failed", response.message ?? "Error",
        backgroundColor: Colors.red, colorText: Colors.white);
  }

  // ================= ORDER PROCESSING =================

  Future<void> _processOnlineOrder(String paymentId) async {
    final profileController = Get.find<ProfileController>();
    final addressController = Get.find<AddressController>();

    final order = orderController.orderData.value;
    final address = addressController.selectedAddress.value;
    final userId = profileController.userId;

    if (userId == null || order == null || address == null) {
      Get.snackbar("Error", "Missing order or user data",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final body = {
      "UserId": userId,
      "AddressId": address.addressId, // ✅ Use addressId from model
      "PaymentMethod": "ONLINE",
      "PaymentId": paymentId,
      "Items": order.items.map((e) => {
        "ProductId": e.productId,
        "Quantity": e.quantity,
        "Price": e.price,
      }).toList()
    };

    final result = await orderController.placeOrder(body);
    if (result != null) {
      showOrderSuccess();
    }
  }

  void placeOrderCOD() async {
    final profileController = Get.find<ProfileController>();
    final addressController = Get.find<AddressController>();

    final order = orderController.orderData.value;
    final address = addressController.selectedAddress.value;
    final userId = profileController.userId;

    if (userId == null || order == null || address == null) {
      Get.snackbar("Error", "Missing order or user data",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final body = {
      "UserId": userId,
      "AddressId": address.addressId, // ✅ Use addressId from model
      "PaymentMethod": "COD",
      "Items": order.items.map((e) => {
        "ProductId": e.productId,
        "Quantity": e.quantity,
        "Price": e.price,
      }).toList()
    };

    final result = await orderController.placeOrder(body);
    if (result != null) {
      showOrderSuccess();
    }
  }


  void showOrderSuccess() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(25),
          height: 300,
          child: Column(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 15),
              const Text(
                "Order Placed Successfully!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Thank you for shopping with us.",
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryYellow,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Continue Shopping",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _priceRow(
    String label,
    String value, {
    Color? color,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget paymentTile({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: EdgeInsets.zero,
        iconColor: kMutedYellow,
        collapsedIconColor: kMutedYellow,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: kCardLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: kMutedYellow, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        subtitle: subtitle.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              )
            : null,
        children: [child],
      ),
    );
  }
  void openCheckout() {
    var options = {
      'key': 'rzp_test_SIQPaxFkbUV8mC', // 🔥 Replace with your actual live key
      'amount': (widget.amount * 100).toInt(),
      'name': 'DEWA Store',
      'description': 'Order Payment',
      'prefill': {
        'contact': Get.find<AuthController>().mobileNo.value,
        'email': 'test@email.com' // Optional: can be fetched from ProfileController
      }
    };

    _razorpay.open(options);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kInputBackground,
      appBar: AppBar(
        backgroundColor: Color(0xFF6200EA),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text("Payments", style: TextStyle(color: Colors.white)),
        actions: const [
          Padding(
            padding: EdgeInsets.all(10),
            child: Chip(
              label: Text("100% Secure"),
              avatar: Icon(Icons.lock, size: 16),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          // Total Amount Box
          Obx(() {
            final order = orderController.orderData.value;

            if (order == null) {
              return const SizedBox();
            }

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF6200EA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // 🔹 HEADER
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      setState(() {
                        showDetails = !showDetails;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // LEFT SIDE (Title + Arrow)
                          Row(
                            children: [
                              const Text(
                                "Total Amount",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              AnimatedRotation(
                                turns: showDetails ? 0.5 : 0,
                                duration: const Duration(milliseconds: 200),
                                child: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),

                          // RIGHT SIDE (Amount)
                          Text(
                            "₹${order.finalAmount.toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 🔹 DROPDOWN
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 250),
                    crossFadeState: showDetails
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        children: [
                          _priceRow(
                            "Total",
                            "₹${order.totalAmount.toStringAsFixed(0)}",
                          ),
                          _priceRow(
                            "Discount",
                            "- ₹${order.discountAmount.toStringAsFixed(0)}",
                            color: Colors.green,
                          ),
                          const Divider(),
                          _priceRow(
                            "Final Amount",
                            "₹${order.finalAmount.toStringAsFixed(0)}",
                            isBold: true,
                          ),
                        ],
                      ),
                    ),
                    secondChild: const SizedBox(),
                  ),
                ],
              ),
            );
          }),

          // UPI
          paymentTile(
            index: 0,
            title: "UPI",
            subtitle: "Pay by any UPI app",
            icon: Icons.account_balance_wallet,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryYellow,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: openCheckout,
                child: const Text("Pay with UPI",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),

          // Card
          paymentTile(
            index: 1,
            title: "Credit / Debit / ATM Card",
            subtitle: "Add and secure cards as per RBI guidelines",
            icon: Icons.credit_card,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryYellow,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: openCheckout,
                child: const Text("Pay with Card",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),

          // EMI
          paymentTile(
            index: 2,
            title: "EMI",
            subtitle: "Dewa EMI",
            icon: Icons.calendar_month,
            child: const Padding(
              padding: EdgeInsets.all(15),
              child: Text("Easy EMI options available (Coming Soon)"),
            ),
          ),

          // COD
          paymentTile(
            index: 3,
            title: "Cash on Delivery",
            subtitle: "",
            icon: Icons.currency_rupee,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    " Due to handling costs, a nominal fee of ₹10 will be\ncharged for order placed using this option.Avoid this\nfee by paying online now",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child:

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryYellow,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: placeOrderCOD,   // ✅ FIXED
                    child: const Text(
                      "Place Order",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
