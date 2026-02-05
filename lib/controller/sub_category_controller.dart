import 'package:get/get.dart';
import '../api.dart/api_service.dart';
import '../models/sub_category_model.dart';

class SubCategoryController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  var isLoading = false.obs;
  var subCategories = <SubCategory>[].obs;
  var selectedSubCategoryId = 0.obs; // 0 = All

  Future<void> fetchSubCategories(int categoryId) async {
    isLoading.value = true;

    final response =
    await _apiService.getSubCategoriesByCategory(categoryId: categoryId);

    if (response != null && response.status) {
      subCategories.assignAll(response.data);
    }

    isLoading.value = false;
  }

  void selectSubCategory(int id) {
    selectedSubCategoryId.value = id;
  }
}
