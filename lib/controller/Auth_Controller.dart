import 'package:Dewa/models/home_category_model.dart';
import 'package:Dewa/screens/home_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '/api.dart/api_service.dart';
import '../screens/login_screen.dart';
import 'package:flutter/material.dart';// Import if you want to navigate explicitly

class AuthController extends GetxController {
  // ✅ Use Get.put(ApiService()) in main or binding
  final ApiService api = Get.find<ApiService>();

  final box = GetStorage();
  var userId = 0.obs;
  var userName = "".obs;
  var mobileNo = "".obs;
  @override
  void onInit() {
    super.onInit();
    loadUserFromStorage();
    print("STORAGE USER ID => ${box.read("user_id")}");
    print("STORAGE NAME => ${box.read("name")}");
  }

  void loadUserFromStorage() {
    userId.value = box.read("user_id") ?? 0;
    userName.value = box.read("name") ?? "";
    mobileNo.value = box.read("mobile") ?? "";
  }

  Future<void> loginUser({
    required String mobile,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      final response = await api.loginUser(
        mobile: mobile,
        password: password,
      );

      isLoading.value = false;

      if (response != null && response['Status'] == true) {

        final userData = response['Data'];

        // ✅ Memory me save
        userId.value = userData['UserId'];
        userName.value = userData['FullName'];
        mobileNo.value = userData['MobileNumber'];

        box.write("user_id", userData['UserId']);
        box.write("name", userData['FullName']);
        box.write("mobile", userData['MobileNumber']);

        Get.snackbar(
          "Success",
          "Login Successful",
          backgroundColor: Color(0xFF4CAF50),
          colorText: Colors.white,
        );
        print("CURRENT USER ID => ${userId.value}");
        // Get.offAll(() => const HomeScreen());

      } else {
        Get.snackbar(
          "Error",
          response?['Message'] ?? "Login failed",
          backgroundColor: Color(0xFFF44336),
          colorText: Colors.white,
        );
      }

    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "Unexpected error: $e",
        backgroundColor: Color(0xFFF44336),
        colorText: Colors.white,
      );
    }
  }


  // Loading state
  var isLoading = false.obs;

  /// Register user
  Future<void> registerUser({
    required String fullName,
    required String mobile,
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      // Call API
      final response = await api.registerUser(
        fullName: fullName,
        mobile: mobile,
        email: email,
        password: password,
      );

      isLoading.value = false;

      if (response != null && response['Status'] == true) {
        final box = GetStorage();
        box.write("mobile", mobile);
        // ✅ Show success message
        Get.snackbar(
          "Success",
          "Registered Successfully",
          backgroundColor:  Color(0xFF4CAF50),
          colorText:  Color(0xFFFFFFFF),
          snackPosition: SnackPosition.BOTTOM,
        );

        // ✅ Navigate back to login screen
        Get.off(() => LoginScreen()); // Replaces current screen with login
      } else {
        // ❌ API returned error
        Get.snackbar(
          "Error",
          response?['Message'] ?? "Registration failed",
          backgroundColor:  Color(0xFFF44336),
          colorText: Color(0xFFFFFFFF),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      isLoading.value = false;

      // ❌ Unexpected error
      Get.snackbar(
        "Error",
        "Unexpected error: $e",
        backgroundColor:  Color(0xFFF44336),
        colorText: Color(0xFFFFFFFF),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}