import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'screens/splash_screen.dart';
import 'theme/app_colors.dart';
import '/api.dart/api_service.dart'; // ✅ ADD THIS IMPORT

void main() {
  // ✅ REGISTER API SERVICE FOR GETX (DEPENDENCY INJECTION)
  Get.put(ApiService());

  runApp(const PaymentApp());
}

class PaymentApp extends StatelessWidget {
  const PaymentApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: kPrimaryYellow,
      brightness: Brightness.light,
    );

    return GetMaterialApp( // ✅ REQUIRED FOR GETX
      debugShowCheckedModeBanner: false,
      title: 'DEWA',
      theme: ThemeData(
        colorScheme: colorScheme.copyWith(
          primary: kPrimaryYellow,
          secondary: kCardYellow,
          tertiary: kCardYellow,
        ),
        scaffoldBackgroundColor: kPrimaryYellow,
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withOpacity(0.12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(color: Colors.white70),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
