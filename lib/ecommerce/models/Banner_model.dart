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
