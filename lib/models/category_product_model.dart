class CategoryProductResponse {
  final bool status;
  final String message;
  final List<CategoryProduct> data;

  CategoryProductResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CategoryProductResponse.fromJson(Map<String, dynamic> json) {
    return CategoryProductResponse(
      status: json['Status'] ?? false,
      message: json['Message'] ?? '',
      data: (json['Data'] as List<dynamic>? ?? [])
          .map((e) => CategoryProduct.fromJson(e))
          .toList(),
    );
  }
}

class CategoryProduct {
  final int id;
  final String productName;
  final int categoryId;
  final double mrp;
  final double discount;
  final double afterDiscount;
  final String image1;

  CategoryProduct({
    required this.id,
    required this.productName,
    required this.categoryId,
    required this.mrp,
    required this.discount,
    required this.afterDiscount,
    required this.image1,
  });

  factory CategoryProduct.fromJson(Map<String, dynamic> json) {
    return CategoryProduct(
      id: json['Id'] ?? 0,
      productName: json['ProductName'] ?? '',
      categoryId: json['CategoryId'] ?? 0,
      mrp: (json['MRP'] ?? 0).toDouble(),
      discount: (json['Discount'] ?? 0).toDouble(),
      afterDiscount: (json['AfterDiscount'] ?? 0).toDouble(),
      image1: json['Image1'] ?? '',
    );
  }

  String get fullImageUrl {
    if (image1.isEmpty) return '';

    String path = image1.replaceAll('~', '');

    if (!path.startsWith('/')) {
      path = '/$path';
    }

    return "https://dewa.co.in$path";
  }
}
