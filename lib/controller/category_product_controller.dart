import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api.dart/api_service.dart';
import '../models/category_product_model.dart';
import '../models/add_to_cart_model.dart';
import 'profile_controller.dart';

class CategoryProductController extends GetxController {

  final ApiService _apiService = Get.find<ApiService>();

  // ================= STATE =================
  var isLoading = false.obs;
  var isRefreshing = false.obs;
  var errorMessage = ''.obs;

  // ================= PRODUCTS =================
  var products = <CategoryProduct>[].obs;
  int? _currentCategoryId;

  // ================= CART =================
  var cartItems = <CategoryProduct>[].obs;
  var cartCount = 0.obs; // ✅ now reactive

  // ================= ADD TO CART API =================
  Future<void> addToCartApi({
    required CategoryProduct product,
    required int userId,
    required int qty,
    required String size,
  }) async {

    final request = AddToCartRequest(
      productId: product.productId,
      userId: userId,
      qty: qty,
      afterDiscount: product.afterDiscount,
      size: size,
    );

    try {
      isLoading.value = true;

      final response = await _apiService.addToCart(request);

      isLoading.value = false;

      if (response != null && response.status) {

        // Update local cart UI
        var existingItemIndex = cartItems.indexWhere((item) => item.productId == product.productId && item.selectedSize == size);
        
        if (existingItemIndex != -1) {
          // If already in cart with same size, just update quantity
          cartItems[existingItemIndex].qty += qty;
          cartItems.refresh(); // Trigger UI update for Obx
        } else {
          // Add new item to cart
          product.qty = qty;
          product.selectedSize = size;
          cartItems.add(product);
        }
        
        cartCount.value = cartItems.length;

        Get.snackbar(
          "Success",
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );

      } else {
        Get.snackbar(
          "Error",
          response?.message ?? "Failed to add cart",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      }

    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "Something went wrong",
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      Get.log("❌ Add To Cart Error: $e");
    }
  }

  // ================= ADD TO CART (SIMPLIFIED) =================
  Future<void> addToCart(CategoryProduct product) async {
    final ProfileController profileController = Get.find<ProfileController>();
    final userId = profileController.userId;

    if (userId == null) {
      Get.snackbar("Error", "Please login to add items to cart");
      return;
    }

    // Use first size if available, else N/A
    String selectedSize = "N/A";
    if (product.sizes.isNotEmpty) {
      selectedSize = product.sizeList.first;
    }

    await addToCartApi(
      product: product,
      userId: userId,
      qty: 1,
      size: selectedSize,
    );
  }

  // ================= REMOVE =================
  void removeFromCart(CategoryProduct product) {
    cartItems.removeWhere((item) => 
      item.productId == product.productId && 
      item.selectedSize == product.selectedSize
    );
    cartCount.value = cartItems.length;
  }

  void clearCart() {
    cartItems.clear();
    cartCount.value = 0;
  }

  // ================= FETCH PRODUCTS =================
  Future<void> fetchProducts(int categoryId,
      {bool isPullToRefresh = false}) async {

    if (isLoading.value && !isPullToRefresh) return;

    try {
      if (isPullToRefresh) {
        isRefreshing.value = true;
      } else {
        isLoading.value = true;
      }

      errorMessage.value = '';
      _currentCategoryId = categoryId;

      final response =
      await _apiService.getProductsByCategoryId(categoryId: categoryId);

      if (response != null && response.status) {
        products.assignAll(response.data);
      } else {
        products.clear();
        errorMessage.value = response?.message ?? "No products found";
      }

    } catch (e) {
      products.clear();
      errorMessage.value = "Something went wrong";
      Get.log("❌ Product Fetch Error: $e");
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  Future<void> refreshProducts() async {
    if (_currentCategoryId != null) {
      await fetchProducts(_currentCategoryId!,
          isPullToRefresh: true);
    }
  }

  void clearProducts() {
    products.clear();
    errorMessage.value = '';
  }
  // ================= UPDATE QTY =================
  Future<void> increaseQty(CategoryProduct product) async {
    product.qty += 1;
    cartItems.refresh();   // UI update

    // 🔥 Agar API me qty update karna ho to yaha call karo
    // await updateCartQtyApi(product);
  }

  Future<void> decreaseQty(CategoryProduct product) async {
    if (product.qty > 1) {
      product.qty -= 1;
    } else {
      // qty 1 se kam ho to remove
      removeFromCart(product);
      return;
    }

    cartItems.refresh();

    // 🔥 API call yaha bhi kar sakte ho
  }

  bool isProductInCart(String productId) {
    return cartItems.any((item) => item.productId == productId);
  }

  int getProductQty(String productId) {
    final item = cartItems.firstWhereOrNull(
            (e) => e.productId == productId);
    return item?.qty ?? 0;
  }

}
