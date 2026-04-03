class OrderItemModel {
  final String productId;   // 🔥 CHANGE HERE
  final String productName;
  final double price;
  final int quantity;
  final double subtotal;
  final String imageUrl;

  OrderItemModel({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.subtotal,
    required this.imageUrl,

  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json["ProductId"] ?? "",   // 🔥 string
      productName: json["product_name"] ?? "",
      price: (json["price"] ?? 0).toDouble(),
      quantity: json["quantity"] ?? 0,

      subtotal: (json["subtotal"] ?? 0).toDouble(),
      imageUrl: json["image_url"] ?? "", // ✅ ADD THIS
    );
  }
}

class OrderModel {
  final String orderNumber;
  final double totalAmount;
  final double discountAmount;
  final double taxAmount;
  final double shippingCharge;
  final double finalAmount;
  final String paymentStatus;
  final String orderStatus;
  final String shippingAddress;
  final List<OrderItemModel> items;

  OrderModel({
    required this.orderNumber,
    required this.totalAmount,
    required this.discountAmount,
    required this.taxAmount,
    required this.shippingCharge,
    required this.finalAmount,
    required this.paymentStatus,
    required this.orderStatus,
    required this.shippingAddress,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final order = json["order"];

    return OrderModel(
      orderNumber: order["order_number"] ?? "",
      totalAmount: (order["total_amount"] ?? 0).toDouble(),
      discountAmount: (order["discount_amount"] ?? 0).toDouble(),
      taxAmount: (order["tax_amount"] ?? 0).toDouble(),
      shippingCharge: (order["shipping_charge"] ?? 0).toDouble(),
      finalAmount: (order["final_amount"] ?? 0).toDouble(),
      paymentStatus: order["payment_status"] ?? "",
      orderStatus: order["order_status"] ?? "",
      shippingAddress: order["shipping_address"] ?? "",
      items: (order["Items"] as List? ?? [])
          .map((e) => OrderItemModel.fromJson(e))
          .toList(),
    );
  }
}


