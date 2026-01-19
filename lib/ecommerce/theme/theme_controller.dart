import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  final Rx<ThemeMode> _themeMode = ThemeMode.light.obs; // ✅ DEFAULT LIGHT


  ThemeMode get themeMode => _themeMode.value;
  bool get isDark => _themeMode.value == ThemeMode.dark;

  void toggleTheme() {
    _themeMode.value =
    _themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    Get.changeThemeMode(_themeMode.value);
  }

  void setLight() {
    _themeMode.value = ThemeMode.light;
    Get.changeThemeMode(ThemeMode.light);
  }

  void setDark() {
    _themeMode.value = ThemeMode.dark;
    Get.changeThemeMode(ThemeMode.dark);
  }
}
