import 'package:Dewa/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'screens/splash_screen.dart';
import 'theme/app_colors.dart';
import '/ecommerce/theme/theme_controller.dart';
import '/ecommerce/theme/app_theme.dart';
import '/api.dart/api_service.dart';
import '';

void main() {
  // ✅ REGISTER SERVICES
  Get.put(ApiService());
  Get.put(ThemeController()); // 🔥 THEME CONTROLLER

  runApp(const PaymentApp());
}

class PaymentApp extends StatelessWidget {
  const PaymentApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(
          () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DEWA',

        // ✅ THEMES
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.themeMode,

        home: const SplashScreen(),
      ),
    );
  }
}
