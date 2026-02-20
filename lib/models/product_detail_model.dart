import '../ecommerce/models/product.dart';
import 'category_product_model.dart';

class ProductDetailResponse {
  final bool status;
  final String message;
  final ProductDetail? data;

  ProductDetailResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProductDetailResponse.fromJson(Map<String, dynamic> json) {
    return ProductDetailResponse(
      status: json['Status'] ?? false,
      message: json['Message'] ?? '',
      data: json['Data'] != null
          ? ProductDetail.fromJson(json['Data'])
          : null,
    );
  }
}

class ProductDetail {
  final int id;
  final String productId;
  final String productName;
  final String brandName;
  final String categoryName;
  final String subCategoryName;
  final String sizes;
  final String colors;
  final double mrp;
  final double discount;
  final double afterDiscount;
  final String description;
  final String stockStatus;
  final String sku;
  final String unit;
  final String productType;
  final String pageTitle;
  final String metaDescription;

  final String? image1;
  final String? image2;
  final String? image3;
  final String? image4;
  final String? image5;

  ProductDetail({
    required this.id,
    required this.productId,
    required this.productName,
    required this.brandName,
    required this.categoryName,
    required this.subCategoryName,
    required this.sizes,
    required this.colors,
    required this.mrp,
    required this.discount,
    required this.afterDiscount,
    required this.description,
    required this.stockStatus,
    required this.sku,
    required this.unit,
    required this.productType,
    required this.pageTitle,
    required this.metaDescription,
    this.image1,
    this.image2,
    this.image3,
    this.image4,
    this.image5,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      id: json['Id'] ?? 0,
      productId: json['ProductId'] ?? '',
      productName: json['ProductName'] ?? '',
      brandName: json['BrandName'] ?? '',
      categoryName: json['CategoryName'] ?? '',
      subCategoryName: json['SubCategoryName'] ?? '',
      sizes: json['Sizes'] ?? '',
      colors: json['Colors'] ?? '',
      mrp: (json['MRP'] ?? 0).toDouble(),
      discount: (json['Discount'] ?? 0).toDouble(),
      afterDiscount: (json['AfterDiscount'] ?? 0).toDouble(),
      description: json['Description'] ?? '',
      stockStatus: json['StockStatus'] ?? '',
      sku: json['SKU'] ?? '',
      unit: json['Unit'] ?? '',
      productType: json['ProductType'] ?? '',
      pageTitle: json['PageTitle'] ?? '',
      metaDescription: json['MetaDescription'] ?? '',
      image1: json['Image1'],
      image2: json['Image2'],
      image3: json['Image3'],
      image4: json['Image4'],
      image5: json['Image5'],
    );
  }

  // ================= IMAGE FORMATTER =================

  String _formatImage(String? img) {
    if (img == null || img.isEmpty) return '';
    String path = img.replaceAll('~', '');
    if (!path.startsWith('/')) path = '/$path';
    return "https://dewa.co.in$path";
  }

  String get fullImage1 => _formatImage(image1);
  String get fullImage2 => _formatImage(image2);
  String get fullImage3 => _formatImage(image3);
  String get fullImage4 => _formatImage(image4);
  String get fullImage5 => _formatImage(image5);

  // ================= IMAGE LIST =================

  List<String> get imageList {
    return [
      fullImage1,
      if (fullImage2.isNotEmpty) fullImage2,
      if (fullImage3.isNotEmpty) fullImage3,
      if (fullImage4.isNotEmpty) fullImage4,
      if (fullImage5.isNotEmpty) fullImage5,
    ];
  }

  // ================= CLEAN DESCRIPTION =================

  String get cleanDescription =>
      description.replaceAll(RegExp(r'<[^>]*>'), '').trim();

  // ================= SIZE LIST =================

  List<String> get sizeList =>
      sizes.isEmpty
          ? []
          : sizes.split(',').map((e) => e.trim()).toList();

  // ================= COLOR LIST =================

  List<String> get colorList =>
      colors.isEmpty
          ? []
          : colors.split(',').map((e) => e.trim()).toList();

  // ================= DISCOUNT PERCENTAGE =================

  int get discountPercentage =>
      discount.toInt();

  // ================= STOCK CHECK =================

  bool get isInStock =>
      stockStatus.toLowerCase() != "out of stock";

  // ================= CONVERT TO CATEGORY PRODUCT (FOR CART) =================

  CategoryProduct toCategoryProduct({int qty = 1, String? selectedSize}) {
    return CategoryProduct(
      id: id,
      productId: productId,
      productName: productName,
      categoryId: 0, // Default if not available
      categoryName: categoryName,
      subCategoryId: 0, // Default if not available
      subCategoryName: subCategoryName,
      brandName: brandName,
      sizes: sizes,
      colors: colors,
      mrp: mrp,
      discount: discount,
      afterDiscount: afterDiscount,
      description: description,
      image1: image1 ?? '',
      image2: image2,
      image3: image3,
      qty: qty,
      selectedSize: selectedSize,
    );
  }

  Product toProduct() {
    return Product(
      id: productId,
      title: productName,
      price: afterDiscount,
      imageUrl: fullImage1,
      description: cleanDescription,
      rating: 4.5,
      category: categoryName,
      type: "best",
    );
  }
}
