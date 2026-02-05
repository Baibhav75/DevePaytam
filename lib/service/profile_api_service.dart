import 'package:dio/dio.dart';
import '../models/user_profile_model.dart';
import '/api.dart/api_constants.dart';

class ProfileApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  Future<UserProfileResponse?> getUserProfileByMobile(String mobile) async {
    try {
      final response = await _dio.get(
        ApiConstants.getUserProfileByMobile,
        queryParameters: {"mobileNumber": mobile},
      );

      if (response.statusCode == 200) {
        return UserProfileResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("❌ Profile API Error: $e");
      return null;
    }
  }
}
