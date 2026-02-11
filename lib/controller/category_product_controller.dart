import 'package:get/get.dart';
import '../api.dart/api_service.dart';
import '../models/category_product_model.dart';

class CategoryProductController extends GetxController {

  final ApiService _apiService = Get.find<ApiService>();

  // ================= STATE =================
  var isLoading = false.obs;
  var isRefreshing = false.obs;
  var errorMessage = ''.obs;
  var cartCount = 0.obs;

  var products = <CategoryProduct>[].obs;
  void addToCart() {
    cartCount.value++;
  }
  int? _currentCategoryId;

  // ================= FETCH PRODUCTS =================
  Future<void> fetchProducts(int categoryId,
      {bool isPullToRefresh = false}) async {

    // Prevent duplicate API call
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
