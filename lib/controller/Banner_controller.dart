import 'package:get/get.dart';
import '../api.dart/api_service.dart';
import '../api.dart/api_constants.dart';
import '../ecommerce/models/Banner_model.dart';

class BannerController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  var isLoading = true.obs;
  var banners = <BannerModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBanners();
  }

  Future<void> fetchBanners() async {
    try {
      isLoading.value = true;
      final response = await _apiService.getBanners();

      if  (response != null && response.status) {
        // Replace ~/ with base url
        banners.assignAll(response.data.map((banner) {
          String imageUrl = banner.image;
          if (imageUrl.startsWith("~/")) {
            imageUrl = imageUrl.replaceFirst("~/", "${ApiConstants.baseUrl}/");
          }
          return BannerModel(
            id: banner.id,
            bannerType: banner.bannerType,
            image: imageUrl,
            createdDate: banner.createdDate,
          );
        }).toList());
      }
    } catch (e) {
      Get.log("❌ Banner Controller Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
