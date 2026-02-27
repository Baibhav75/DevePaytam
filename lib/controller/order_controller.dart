import 'package:get/get.dart';
import '../models/order_model.dart';
import '../service/order_service.dart';

class OrderController extends GetxController {

  var isLoading = false.obs;
  var orderData = Rxn<OrderModel>();

  Future<OrderModel?> placeOrder(Map<String, dynamic> body) async {

    try {
      isLoading.value = true;
      print("=========== ORDER DEBUG START ===========");
      print("SENT BODY => ${body}");
      print("==========================================");

      // 1️⃣ POST
      final orderNumber = await OrderService.createOrder(body);
      if (orderNumber != null) {

        // 2️⃣ GET
        final order = await OrderService.getOrderByNumber(orderNumber);
        // if (order != null) {
        //   orderData.value = order;
        //   Get.to(() => OrderSummary());
        // }
        if (order != null) {
          orderData.value = order;
          return order;   // ✅ return order
        }
      }
      return null;
    } catch (e) {
      print("❌ ORDER ERROR: $e");
    } finally {
      isLoading.value = false;
      print("=========== ORDER DEBUG END =============");
    }
  }

  void setTempOrder({
    required double total,
    required double discount,
    required double tax,
    required double shipping,
    required double finalAmount,
    required List<OrderItemModel> items,
  }) {
    orderData.value = OrderModel(
      orderNumber: "",                // TEMP
      totalAmount: total,
      discountAmount: discount,
      taxAmount: tax,
      shippingCharge: shipping,
      finalAmount: finalAmount,
      paymentStatus: "Pending",       // TEMP
      orderStatus: "Pending",         // TEMP
      shippingAddress: "",            // TEMP
      items: items,
    );
  }
}