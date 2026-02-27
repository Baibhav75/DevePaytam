import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controller/Auth_Controller.dart';
import 'controller/HomeCategory_controller.dart';
import 'controller/add_address_controller.dart';
import 'controller/profile_controller.dart';
import 'controller/sub_category_controller.dart';
import 'ecommerce/controllers/shop_controller.dart';
import 'ecommerce/theme/theme_controller.dart';
import 'ecommerce/theme/app_theme.dart';
import 'api.dart/api_service.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  // 🔥 Dependency Injection
  Get.put(ApiService(), permanent: true);
  Get.put(AuthController(), permanent: true);
  Get.put(HomecategoryControllerController(), permanent: true);
  Get.put(SubCategoryController(), permanent: true);
  Get.put(AddressController(), permanent: true);
  Get.put(ShopController(), permanent: true);
  Get.put(ProfileController(), permanent: true); // ✅ add permanent
  Get.put(ThemeController(), permanent: true);

  runApp(const PaymentApp());
}

class PaymentApp extends StatelessWidget {
  const PaymentApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "DEWA",

        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.themeMode,

        // 🔥 PURE STATE BASED ROUTING
        home: const HomeScreen(),
      );
    });
  }
}