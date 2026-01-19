import 'package:get/get.dart';
import '/api.dart/api_service.dart';
import '../screens/login_screen.dart';
import 'package:flutter/material.dart';// Import if you want to navigate explicitly

class AuthController extends GetxController {
  // ✅ Use Get.put(ApiService()) in main or binding
  final ApiService api = Get.find<ApiService>();

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
