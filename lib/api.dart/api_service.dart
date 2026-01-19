import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'api_constants.dart';

class ApiService extends GetxService {
  late dio.Dio dioClient;

  // ✅ CONSTRUCTOR INITIALIZATION (NO onInit)
  ApiService() {
    dioClient = dio.Dio(
      dio.BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: {"Content-Type": "application/json"},
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

  /// ✅ REGISTER USER
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
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print("❌ Register Error: $e");
      return null;
    }
  }

  /// ✅ LOGIN USER
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
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print("❌ Login Error: $e");
      return null;
    }
  }

  /// ✅ SEND OTP
  Future<Map<String, dynamic>?> sendOtp(String mobile) async {
    try {
      final dio.Response response = await dioClient.post(
        ApiConstants.sendOtp,
        data: {"MobileNumber": mobile},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print("❌ OTP Error: $e");
      return null;
    }
  }

  /// ✅ VERIFY OTP
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
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print("❌ Verify OTP Error: $e");
      return null;
    }
  }

  /// ✅ GET USER PROFILE
  Future<Map<String, dynamic>?> getUserProfile({
    required String userId,
  }) async {
    try {
      final dio.Response response = await dioClient.get(
        ApiConstants.getUserProfile,
        queryParameters: {"UserId": userId},
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print("❌ Profile Error: $e");
      return null;
    }
  }
}
