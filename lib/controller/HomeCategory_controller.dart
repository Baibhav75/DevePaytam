import 'package:get/get.dart';
import '../models/home_category_model.dart';
import '/api.dart/api_service.dart';

class HomecategoryControllerController extends GetxController {

  // ✅ Use Get.find instead of creating new instance
  final ApiService _apiService = Get.find<ApiService>();

  var isLoadingCategories = true.obs;
  var categories = <HomeCategory>[].obs;

  // ✅ Selected category (for sub-category / products)
  var selectedCategoryId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoadingCategories.value = true;

      final response = await _apiService.getCategories();

      if (response != null && response.status) {
        categories.assignAll(response.data);

        // ✅ Auto select first category (optional but useful)
        if (categories.isNotEmpty) {
          selectedCategoryId.value = categories.first.categoryId;
        }
      } else {
        categories.clear();
      }
    } catch (e) {
      Get.log("❌ Category fetch error: $e");
      categories.clear();
    } finally {
      isLoadingCategories.value = false;
    }
  }

  // ✅ Call this when user taps a category
  void selectCategory(int categoryId) {
    selectedCategoryId.value = categoryId;
  }
}
