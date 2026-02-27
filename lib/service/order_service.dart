import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api.dart/api_constants.dart';
import '../models/order_model.dart';

class OrderService {

  // 🔥 POST ORDER
  static Future<String?> createOrder(Map<String, dynamic> body) async {

    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.createOrder);
    print("url is $Uri");


    final response = await http.post(
      url,
      headers: ApiConstants.jsonHeaders,
      body: jsonEncode(body),
    );

    print("POST RESPONSE: ${response.body}");
    print("Response code:${response.statusCode}");


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["order_number"]; // 👈 ensure backend sends this
    }

    return null;
  }

  // 🔥 GET ORDER
  static Future<OrderModel?> getOrderByNumber(String orderNumber) async {

    final url = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.getOrderByNumber}?orderNumber=$orderNumber"
    );

    final response = await http.get(url);

    print("GET RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      return OrderModel.fromJson(jsonDecode(response.body));
    }

    return null;
  }
}