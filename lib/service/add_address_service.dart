import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../api.dart/api_constants.dart';

class AddAddressService {
  final String baseUrl = ApiConstants.baseUrl;

  /// ================== GET USER ADDRESS ==================
  Future<dynamic> getAddress(String mobile) async {
    final String url =
        "$baseUrl${ApiConstants.getAddress}?mobileNo=$mobile";

    try {
      if (kDebugMode) {
        print("🟢 GET URL: $url");
      }

      final response = await http.get(
        Uri.parse(url),
        headers: ApiConstants.jsonHeaders,
      );

      if (kDebugMode) {
        print("🟡 Status Code: ${response.statusCode}");
        print("🔵 Response Body: ${response.body}");
      }

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            "GET Address Failed → Status: ${response.statusCode}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("🔴 GET ERROR: $e");
      }
      rethrow;
    }
  }

  /// ================== ADD ADDRESS ==================
  Future<dynamic> addAddress(Map<String, dynamic> body) async {
    final String url =
        "$baseUrl${ApiConstants.addAddress}";

    try {
      if (kDebugMode) {
        print("🟢 POST URL: $url");
        print("🟣 Request Body: ${jsonEncode(body)}");
      }

      final response = await http.post(
        Uri.parse(url),
        headers: ApiConstants.jsonHeaders,
        body: jsonEncode(body),
      );

      if (kDebugMode) {
        print("🟡 Status Code: ${response.statusCode}");
        print("🔵 Response Body: ${response.body}");
      }

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            "POST Address Failed → Status: ${response.statusCode}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("🔴 POST ERROR: $e");
      }
      rethrow;
    }
  }
}