import '../api.dart/api_constants.dart';

class SubCategoryResponse {
  final bool status;
  final String message;
  final List<SubCategory> data;

  SubCategoryResponse({
    required this.status,
    required this.message,
    required this.data,
  });
  //
  // factory SubCategoryResponse.fromJson(Map<String, dynamic> json) {
  //   return SubCategoryResponse(
  //     status: json['Status'] ?? false,
  //     message: json['Message'] ?? '',
  //     data: (json['Data'] as List)
  //         .map((e) => SubCategory.fromJson(e))
  //         .toList(),
  //   );
  // }
  factory SubCategoryResponse.fromJson(Map<String, dynamic> json) {
    return SubCategoryResponse(
      status: json['Status'] ?? false,
      message: json['Message'] ?? '',
      data: json['Data'] != null
          ? List<SubCategory>.from(
        json['Data'].map((e) => SubCategory.fromJson(e)),
      )
          : [],
    );
  }
}

class SubCategory {
  final int subCategoryId;
  final int categoryId;
  final String subCategoryName;
  final String subCategoryImage;

  SubCategory({
    required this.subCategoryId,
    required this.categoryId,
    required this.subCategoryName,
    required this.subCategoryImage,
  });

  // factory SubCategory.fromJson(Map<String, dynamic> json) {
  //   return SubCategory(
  //     subCategoryId: json['SubCategoryId'],
  //     categoryId: json['CategoryId'],
  //     subCategoryName: json['SubCategoryName'],
  //     subCategoryImage: json['SubCategoryImage'] ?? '',
  //   );
  // }
  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      subCategoryId: json['SubCategoryId'] ?? 0,
      categoryId: json['CategoryId'] ?? 0,
      subCategoryName: json['SubCategoryName'] ?? '',
      subCategoryImage: json['SubCategoryImage'] ?? '',
    );
  }

  /// ✅ FIX IMAGE PATH
  // String get fullImageUrl {
  //   if (subCategoryImage.isEmpty) return '';
  //   String path = subCategoryImage.replaceAll('~', '');
  //   return 'https://dewa.co.in$path';
  // }
  String get fullImageUrl {
    if (subCategoryImage.isEmpty) return '';

    String path = subCategoryImage.replaceAll('~', '');

    return '${ApiConstants.baseUrl}$path';
  }
}
