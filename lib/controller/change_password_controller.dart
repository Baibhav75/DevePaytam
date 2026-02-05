import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/api.dart/api_service.dart';
import 'profile_controller.dart';

class ChangePasswordController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  // ✅ SAFE LOOKUP
  final ProfileController profileController =
  Get.isRegistered<ProfileController>()
      ? Get.find<ProfileController>()
      : Get.put(ProfileController());

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isLoading = false.obs;

  int? get userId => profileController.userId;

  Future<void> changePassword() async {
    // ================= USER CHECK =================
    if (userId == null) {
      _error("User not found. Please login again.");
      return;
    }

    final oldPwd = oldPasswordController.text.trim();
    final newPwd = newPasswordController.text.trim();
    final confirmPwd = confirmPasswordController.text.trim();

    // ================= VALIDATIONS =================
    if (oldPwd.isEmpty || newPwd.isEmpty || confirmPwd.isEmpty) {
      _error("All fields are required");
      return;
    }

    if (newPwd.length < 6) {
      _error("Password must be at least 6 characters");
      return;
    }

    if (newPwd != confirmPwd) {
      _error("New password and confirm password do not match");
      return;
    }

    // ================= API CALL =================
    isLoading.value = true;

    final response = await _apiService.changePassword(
      userId: userId!,
      oldPassword: oldPwd,
      newPassword: newPwd,
    );

    isLoading.value = false;

    // ================= RESPONSE =================
    if (response != null && response['Status'] == true) {
      _showSuccessDialog();
    } else {
      _error(response?['Message'] ?? "Password update failed");
    }
  }

  // ================= UI HELPERS =================
  void _error(String message) {
    Get.snackbar(
      "Error",
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showSuccessDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          "Success",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Your password has been changed successfully.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // close dialog
              Get.back(); // back to profile
            },
            child: const Text("OK"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
