import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/change_password_controller.dart';
import '../theme/app_colors.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  // ✅ Controller
  final ChangePasswordController controller =
  Get.put(ChangePasswordController());

  // 👁 Show / Hide states
  final RxBool showOld = false.obs;
  final RxBool showNew = false.obs;
  final RxBool showConfirm = false.obs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        title: const Text("Change Password"),
      ),
      body: Obx(
            () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _passwordField(
                  label: "Current Password",
                  controller:
                  controller.oldPasswordController,
                  show: showOld,
                ),
                const SizedBox(height: 20),
                _passwordField(
                  label: "New Password",
                  controller:
                  controller.newPasswordController,
                  show: showNew,
                ),
                const SizedBox(height: 20),
                _passwordField(
                  label: "Confirm New Password",
                  controller:
                  controller.confirmPasswordController,
                  show: showConfirm,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!
                          .validate()) {
                        controller.changePassword();
                      }
                    },
                    child: const Text(
                      "Update Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= PASSWORD FIELD =================
  Widget _passwordField({
    required String label,
    required TextEditingController controller,
    required RxBool show,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Obx(
              () => TextFormField(
            controller: controller,
            obscureText: !show.value,
            validator: (v) =>
            v == null || v.isEmpty ? "Required" : null,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: kPrimaryTeal,
                  width: 2,
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  show.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () => show.toggle(),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
