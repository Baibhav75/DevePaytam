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
  final String productId; // ✅ ADD THIS
  final String productName;
  final int categoryId;
  final String categoryName;
  final int subCategoryId;
  final String subCategoryName;
  final String brandName;
  final String sizes;
  final String colors;
  final double mrp;
  final double discount;
  final double afterDiscount;
  final String description;
  final String image1;
  final String? image2;
  final String? image3;

  CategoryProduct({
    required this.id,
    required this.productId,
    required this.productName,
    required this.categoryId,
    required this.categoryName,
    required this.subCategoryId,
    required this.subCategoryName,
    required this.brandName,
    required this.sizes,
    required this.colors,
    required this.mrp,
    required this.discount,
    required this.afterDiscount,
    required this.description,
    required this.image1,
    this.image2,
    this.image3,
  });

  factory CategoryProduct.fromJson(Map<String, dynamic> json) {
    return CategoryProduct(
      id: json['Id'] ?? 0,
      productId: json['ProductId'] ?? '', // ✅ IMPORTANT
      productName: json['ProductName'] ?? '',
      categoryId: json['CategoryId'] ?? 0,
      categoryName: json['CategoryName'] ?? '',
      subCategoryId: json['SubCategoryId'] ?? 0,
      subCategoryName: json['SubCategoryName'] ?? '',
      brandName: json['BrandName'] ?? '',
      sizes: json['Sizes'] ?? '',
      colors: json['Colors'] ?? '',
      mrp: (json['MRP'] ?? 0).toDouble(),
      discount: (json['Discount'] ?? 0).toDouble(),
      afterDiscount: (json['AfterDiscount'] ?? 0).toDouble(),
      description: json['Description'] ?? '',
      image1: json['Image1'] ?? '',
      image2: json['Image2'],
      image3: json['Image3'],
    );
  }

  /// ✅ Convert "~" path to full URL
  String get fullImageUrl {
    if (image1.isEmpty) return '';
    String path = image1.replaceAll('~', '');
    if (!path.startsWith('/')) {
      path = '/$path';
    }
    return "https://dewa.co.in$path";
  }

  /// ✅ Clean HTML description
  String get cleanDescription {
    return description
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .trim();
  }

  /// ✅ Convert sizes string to List
  List<String> get sizeList {
    if (sizes.isEmpty) return [];
    return sizes.split(',');
  }

  /// ✅ Convert colors string to List
  List<String> get colorList {
    if (colors.isEmpty) return [];
    return colors.split(',');
  }
}
