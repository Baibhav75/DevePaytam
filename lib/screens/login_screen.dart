import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import '/controller/Auth_Controller.dart';
import 'register_screen.dart';
import 'otp_verification_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  // ✅ GetX Controller
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // ✅ Mobile validation
  String? _validateMobile(String value) {
    if (value.isEmpty) return 'Please enter your mobile number';
    if (!RegExp(r'^\d{10}$').hasMatch(value)) return 'Mobile number must be 10 digits';
    return null;
  }

  // ✅ Input decoration helper
  InputDecoration _buildFieldDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black54),
      prefixIcon: Icon(icon, color: Colors.black54),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black26),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black87),
      ),
      hintStyle: const TextStyle(color: Colors.black38),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryTeal,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              Image.asset('assets/logo.png', width: 160, height: 170),
              const SizedBox(height: 180),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                decoration: BoxDecoration(
                  color: kCardLight,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Login',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Please login to your account',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: Colors.black87),
                      decoration: _buildFieldDecoration('Enter your mobile number', Icons.smartphone),
                      maxLength: 10,
                      validator: (value) => _validateMobile(value ?? ''),
                    ),
                    const SizedBox(height: 35),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: Obx(
                            () => ElevatedButton(
                          onPressed: authController.isLoading.value
                              ? null
                              : () async {
                            final phoneNumber = _phoneController.text.trim();
                            final validation = _validateMobile(phoneNumber);

                            if (validation != null) {
                              Get.snackbar(
                                "Error",
                                validation,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              return;
                            }

                            authController.isLoading.value = true;

                            final response = await authController.api.sendOtp(phoneNumber);

                            authController.isLoading.value = false;

                            if (response != null && response['Status'] == true) {
                              final otp = response['Data']['OTP'];
                              Get.to(() => OtpVerificationScreen(
                                phoneNumber: '+91 $phoneNumber',
                                otp: otp,
                              ));
                            } else {
                              Get.snackbar(
                                "Error",
                                response?['Message'] ?? "Failed to send OTP",
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: authController.isLoading.value
                              ? const CircularProgressIndicator(color: kPrimaryTeal)
                              : const Text(
                            'Login',
                            style: TextStyle(
                              color: kPrimaryYellow,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              TextButton(
                onPressed: () {
                  Get.to(() => RegisterScreen());
                },
                child: const Text(
                  'Register',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
