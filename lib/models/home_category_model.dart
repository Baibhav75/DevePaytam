class HomeCategoryResponse {
  final bool status;
  final String message;
  final List<HomeCategory> data;

  HomeCategoryResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory HomeCategoryResponse.fromJson(Map<String, dynamic> json) {
    return HomeCategoryResponse(
      status: json['Status'] ?? false,
      message: json['Message'] ?? '',
      data: (json['Data'] as List)
          .map((e) => HomeCategory.fromJson(e))
          .toList(),
    );
  }
}

class HomeCategory {
  final int categoryId;
  final String categoryName;
  final String? categoryImage;

  HomeCategory({
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
  });

  factory HomeCategory.fromJson(Map<String, dynamic> json) {
    return HomeCategory(
      categoryId: json['CategoryId'] ?? 0,
      categoryName: json['CategoryName'] ?? '',
      categoryImage: json['CategoryImage'], // can be null
    );
  }



//   String get fullImageUrl {
//     if (categoryImage.isEmpty) return '';
//
//     // remove "~"
//     String path = categoryImage.replaceAll('~', '');
//
//     // remove wrong folder
//     path = path.replaceAll('/Uploads/Category/', '');
//
//     // ensure correct base
//     return 'https://dewa.co.in$path';
//   }
// }
  String get fullImageUrl {
    if (categoryImage == null || categoryImage!.isEmpty) {
      return '';
    }

    // remove "~"
    String path = categoryImage!.replaceFirst('~', '');

    return 'https://dewa.co.in$path';
  }
}