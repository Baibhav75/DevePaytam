class AddToCartRequest {
  final String productId;
  final int userId;
  final int qty;
  final double afterDiscount;
  final String size;

  AddToCartRequest({
    required this.productId,
    required this.userId,
    required this.qty,
    required this.afterDiscount,
    required this.size,
  });

  Map<String, dynamic> toJson() {
    return {
      "ProductId": productId,
      "UserId": userId,
      "QTY": qty,
      "AfterDiscount": afterDiscount, // ✅ updated key
      "Size": size,
    };
  }
}

class AddToCartResponse {
  final bool status;
  final String message;

  AddToCartResponse({
    required this.status,
    required this.message,
  });

  factory AddToCartResponse.fromJson(Map<String, dynamic> json) {
    return AddToCartResponse(
      status: json['Status'] ?? false,
      message: json['Message'] ?? '',
    );
  }
}
