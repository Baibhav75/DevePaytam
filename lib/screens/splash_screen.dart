// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../theme/app_colors.dart';
// import 'onboarding_screen.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   Timer? _timer;
//
//   @override
//   void initState() {
//     super.initState();
//     _timer = Timer(const Duration(seconds: 3), _goToOnboarding);
//   }
//
//   void _goToOnboarding() {
//     if (!mounted) return;
//
//     // ✅ Using GetX for navigation
//     Get.off(() => OnboardingScreen());
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kPrimaryTeal,
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Image.asset(
//               'assets/logo.png',
//               width: 200,
//               height: 200,
//               fit: BoxFit.contain,
//             ),
//             const SizedBox(height: 18),
//             const CircularProgressIndicator(
//               color: Colors.white,
//               strokeWidth: 2,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../controller/Auth_Controller.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }
  void _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));

    final box = GetStorage();
    final storedUserId = box.read("user_id") ?? 0;

    print("🔥 SPLASH STORAGE USER ID => $storedUserId");

    if (storedUserId != 0) {
      Get.offAllNamed('/home');
      } else {
        Get.offAllNamed('/login');
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryTeal,
      body: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}