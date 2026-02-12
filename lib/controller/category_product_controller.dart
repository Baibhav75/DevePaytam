import 'package:get/get.dart';
import '../api.dart/api_service.dart';
import '../models/category_product_model.dart';

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

  int get cartCount => cartItems.length;

  void addToCart(CategoryProduct product) {

    // Prevent duplicate product
    if (!cartItems.any((item) => item.productId == product.productId)) {
      cartItems.add(product);
    } else {
      Get.snackbar(
        "Already Added",
        "${product.productName} already in cart",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeFromCart(CategoryProduct product) {
    cartItems.removeWhere((item) => item.productId == product.productId);
  }

  void clearCart() {
    cartItems.clear();
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

  // ================= REFRESH =================
  Future<void> refreshProducts() async {
    if (_currentCategoryId != null) {
      await fetchProducts(_currentCategoryId!,
          isPullToRefresh: true);
    }
  }

  // ================= CLEAR =================
  void clearProducts() {
    products.clear();
    errorMessage.value = '';
  }
}
