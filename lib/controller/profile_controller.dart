import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile_model.dart';
import '../service/profile_api_service.dart';

class ProfileController extends GetxController {
  final ProfileApiService _apiService = ProfileApiService();

  var isLoading = true.obs;
  var profile = Rxn<UserProfile>();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;

    final prefs = await SharedPreferences.getInstance();
    final mobile = prefs.getString('mobile');

    if (mobile == null) {
      isLoading.value = false;
      return;
    }

    final response = await _apiService.getUserProfileByMobile(mobile);

    if (response != null && response.status) {
      profile.value = response.data;

      // ✅ OPTIONAL: cache userId if needed elsewhere
      await prefs.setInt('userId', response.data.userId);
    }

    isLoading.value = false;
  }

  // ==================================================
  // ✅ ADD THIS GETTER (THIS FIXES YOUR ERROR)
  // ==================================================
  int? get userId => profile.value?.userId;
}
