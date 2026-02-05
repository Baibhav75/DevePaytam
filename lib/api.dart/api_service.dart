import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

import '../models/home_category_model.dart';
import '../models/sub_category_model.dart';
import 'api_constants.dart';

class ApiService extends GetxService {
  late dio.Dio dioClient;

  ApiService() {
    dioClient = dio.Dio(
      dio.BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: ApiConstants.jsonHeaders,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    )..interceptors.add(
      dio.LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  // ================= REGISTER =================
  Future<Map<String, dynamic>?> registerUser({
    required String fullName,
    required String mobile,
    required String email,
    required String password,
  }) async {
    try {
      final dio.Response response = await dioClient.post(
        ApiConstants.registerUser,
        data: {
          "FullName": fullName,
          "MobileNumber": mobile,
          "Email": email,
          "Password": password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
    } catch (e) {
      Get.log("❌ Register Error: $e");
    }
    return null;
  }

  // ================= LOGIN =================
  Future<Map<String, dynamic>?> loginUser({
    required String mobile,
    required String password,
  }) async {
    try {
      final dio.Response response = await dioClient.post(
        ApiConstants.loginUser,
        data: {
          "MobileNumber": mobile,
          "Password": password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
    } catch (e) {
      Get.log("❌ Login Error: $e");
    }
    return null;
  }

  // ================= SEND OTP =================
  Future<Map<String, dynamic>?> sendOtp(String mobile) async {
    try {
      final dio.Response response = await dioClient.post(
        ApiConstants.sendOtp,
        data: {"MobileNumber": mobile},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
    } catch (e) {
      Get.log("❌ OTP Error: $e");
    }
    return null;
  }

  // ================= VERIFY OTP =================
  Future<Map<String, dynamic>?> verifyOtp({
    required String mobile,
    required String userOtp,
  }) async {
    try {
      final dio.Response response = await dioClient.post(
        ApiConstants.verifyOtp,
        data: {
          "MobileNumber": mobile,
          "UserOtp": userOtp,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
    } catch (e) {
      Get.log("❌ Verify OTP Error: $e");
    }
    return null;
  }

  // ================= GET PROFILE =================
  Future<Map<String, dynamic>?> getUserProfile({
    required String userId,
  }) async {
    try {
      final dio.Response response = await dioClient.get(
        ApiConstants.getUserProfile,
        queryParameters: {"UserId": userId},
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      Get.log("❌ Profile Error: $e");
    }
    return null;
  }

  // ================= CHANGE PASSWORD =================
  Future<Map<String, dynamic>?> changePassword({
    required int userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final dio.Response response = await dioClient.post(
        ApiConstants.changePassword,
        data: {
          "UserId": userId,
          "OldPassword": oldPassword,
          "NewPassword": newPassword,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      Get.log("❌ Change Password Error: $e");
    }
    return null;
  }

  // homecategory service
  Future<HomeCategoryResponse?> getCategories() async {
    try {
      final response = await dioClient.get(
        ApiConstants.getCategories,
      );

      if (response.statusCode == 200) {
        return HomeCategoryResponse.fromJson(response.data);
      }
    } catch (e) {
      Get.log("❌ Category Error: $e");
    }
    return null;
  }

  // ================= SUB CATEGORIES =================
  Future<SubCategoryResponse?> getSubCategoriesByCategory({
    required int categoryId,
  }) async {
    try {
      final dio.Response response = await dioClient.get(
        ApiConstants.getSubCategoriesByCategory,
        queryParameters: {
          "categoryId": categoryId,
        },
      );

      if (response.statusCode == 200) {
        return SubCategoryResponse.fromJson(response.data);
      }
    } catch (e) {
      Get.log("❌ SubCategory Error: $e");
    }
    return null;
  }



}

