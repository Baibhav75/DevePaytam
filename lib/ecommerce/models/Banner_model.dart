class PromoBanner {
  final String image;
  final String title;
  final String subtitle;

  PromoBanner({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

class BannerModel {
  final int id;
  final String bannerType;
  final String image;
  final String createdDate;

  BannerModel({
    required this.id,
    required this.bannerType,
    required this.image,
    required this.createdDate,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['Id'] ?? 0,
      bannerType: json['BannerType'] ?? '',
      image: json['Image'] ?? '',
      createdDate: json['CreatedDate'] ?? '',
    );
  }
}

class BannerResponse {
  final bool status;
  final String message;
  final List<BannerModel> data;

  BannerResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BannerResponse.fromJson(Map<String, dynamic> json) {
    return BannerResponse(
      status: json['Status'] ?? false,
      message: json['Message'] ?? '',
      data: (json['Data'] as List?)
              ?.map((item) => BannerModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}


class CartItem {
  final String title;
  final String image;
  final double price;
  int qty;

  CartItem({
    required this.title,
    required this.image,
    required this.price,
    this.qty = 1,
  });
}
