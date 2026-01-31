import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../models/category.dart';

class ShopController extends GetxController {
  // ================= CATEGORIES =================
  final List<Category> categories = [
    Category(name: "Men", image: "", icon: Icons.man),
    Category(name: "Women", image: "", icon: Icons.woman),
    Category(name: "Kids", image: "", icon: Icons.child_care),
    Category(name: "Footwear", image: "", icon: Icons.shopping_bag),
    Category(name: "Accessories", image: "", icon: Icons.watch),
    Category(name: "Beauty", image: "", icon: Icons.brush),
    Category(name: "Winter Wear", image: "", icon: Icons.ac_unit),
    Category(name: "Electronics", image: "", icon: Icons.devices),
    Category(name: "Home", image: "", icon: Icons.home),
    Category(name: "Sports", image: "", icon: Icons.sports_basketball),
  ];
  // ================= FAVORITES & CART =================
  final RxSet<Product> _favorites = <Product>{}.obs;
  final RxList<Product> _cartItems = <Product>[].obs;

  Set<Product> get favorites => _favorites;
  List<Product> get cartItems => _cartItems;
  int get favoritesCount => _favorites.length;
  int get cartCount => _cartItems.length;

  // ================= PRODUCTS =================
  final RxList<Product> _products = <Product>[
    Product(
      id: "1",
      title: "Men Casual Shirt",
      price: 799,
      category: "Men",
      type: "best",
      imageUrl:
      "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400",
      description: "A comfortable and stylish casual shirt for men.",
      rating: 4.2,
    ),
    Product(
      id: "2",
      title: "Women Summer Dress",
      price: 1299,
      category: "Women",
      type: "best",
      imageUrl:
      "https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400",
      description: "Light and breezy summer dress using premium fabric.",
      rating: 4.5,
    ),
    Product(
      id: "3",
      title: "Kids Hoodie",
      price: 599,
      category: "Kids",
      type: "citizen",
      imageUrl:
      "https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=400",
      description: "Warm and cozy hoodie for kids.",
      rating: 4.8,
    ),
    Product(
      id: "4",
      title: "Running Shoes",
      price: 2199,
      category: "Footwear",
      type: "citizen",
      imageUrl:
      "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400",
      description: "High performance running shoes.",
      rating: 4.1,
    ),
    Product(
      id: "5",
      title: "Leather Wallet",
      price: 899,
      category: "Accessories",
      type: "best",
      imageUrl:
      "https://images.unsplash.com/photo-1627123424574-724758594e93?w=400",
      description: "Premium leather wallet with multiple card slots.",
      rating: 4.6,
    ),
    Product(
      id: "6",
      title: "Denim Jeans",
      price: 1499,
      category: "Men",
      type: "category",
      imageUrl:
      "https://images.unsplash.com/photo-1542272604-787c3835535d?w=400",
      description: "Classic blue denim jeans with perfect fit.",
      rating: 4.3,
    ),
  ].obs;

  // Public getter
  List<Product> get products => _products;

  // ================= FILTER HELPERS =================
  List<Product> getProductsByCategory(String category) {
    return _products.where((p) => p.category == category).toList();
  }

  List<Product> get bestSelling {
    return _products.where((p) => p.type == "best").toList();
  }

  List<Product> get citizenCards {
    return _products.where((p) => p.type == "citizen").toList();
  }

  // ================= FAVORITES =================
  bool isFavorite(Product product) {
    return _favorites.any((p) => p.id == product.id);
  }

  void toggleFavorite(Product product) {
    isFavorite(product)
        ? _favorites.removeWhere((p) => p.id == product.id)
        : _favorites.add(product);
  }

  void removeFromFavorites(Product product) {
    _favorites.removeWhere((p) => p.id == product.id);
  }

  // ================= CART =================
  void addToCart(Product product) {
    _cartItems.add(product);
  }

  void removeFromCart(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
    }
  }

  void removeProductFromCart(Product product) {
    _cartItems.removeWhere((p) => p.id == product.id);
  }

  double getTotalAmount() {
    return _cartItems.fold(0, (sum, item) => sum + item.price);
  }

  int getProductQuantityInCart(Product product) {
    return _cartItems.where((p) => p.id == product.id).length;
  }

  void clearCart() {
    _cartItems.clear();
  }
}
