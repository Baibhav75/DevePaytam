import 'package:get/get.dart';
import '../api.dart/api_service.dart';
import '../models/product_detail_model.dart';

class ProductDetailController extends GetxController {

  final ApiService _apiService = Get.find<ApiService>();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var productDetail = Rxn<ProductDetail>();

  Future<void> fetchProductDetails(String productId) async {

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response =
      await _apiService.getProductDetails(productId: productId);

      if (response != null && response.status) {
        productDetail.value = response.data;
      } else {
        errorMessage.value =
            response?.message ?? "Product details not found";
      }

    } catch (e) {
      errorMessage.value = "Something went wrong";
      Get.log("❌ Product Detail Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
