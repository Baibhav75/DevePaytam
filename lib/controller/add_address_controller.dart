import 'package:shared_preferences/shared_preferences.dart';

import '../models/add_address_model.dart';
import '../service/add_address_service.dart';
import 'package:get/get.dart';

class AddressController extends GetxController {

  final AddAddressService _apiService = AddAddressService();

  var isLoading = false.obs;
  var addressList = <AddAddressModel>[].obs;
  var selectedAddress = Rxn<AddAddressModel>();


  /// ================== GET ADDRESS ==================
  Future<void> fetchAddress({String? mobile}) async {
    try {
      isLoading(true);

      String mobileNumber = mobile ?? "";

      if (mobileNumber.isEmpty) {
        SharedPreferences prefs =
        await SharedPreferences.getInstance();
        mobileNumber =
            prefs.getString("mobile") ?? "";
      }

      if (mobileNumber.isEmpty) {
        print("❌ Mobile number not found");
        return;
      }

      final response =
      await _apiService.getAddress(mobileNumber);

      print("📦 Raw Response: $response");

      /// ✅ FIX HERE (small 'data')
      if (response != null && response['data'] != null) {

        addressList.value = (response['data'] as List)
            .map((e) =>
            AddAddressModel.fromJson(e))
            .toList();

        print("✅ Address Count: ${addressList.length}");
        // ✅ AUTO SELECT FIRST ADDRESS
        if (addressList.isNotEmpty && selectedAddress.value == null) {
          selectedAddress.value = addressList.first;
        }
      } else {
        addressList.clear();
        print("❌ No data found in response");
      }

    } catch (e) {
      print("🔴 GET Error: $e");
    } finally {
      isLoading(false);
    }
  }

  /// ================== ADD ADDRESS ==================
  Future<void> addAddress({
    required String name,
    required String mobile,
    required String addressType,
    required String address,
    required String city,
    required String state,
    required String pinCode,
  }) async {

    try {
      isLoading(true);

      final body = {
        "Name": name,
        "MobileNo": mobile,
        "AddressType": addressType,
        "Address": address,
        "City": city,
        "State": state,
        "PinCode": pinCode,
      };

      /// ✅ Direct service call
      final response = await _apiService.addAddress(body);

      print("✅ POST Response: $response");

      /// After success → refresh list
      await fetchAddress(mobile: mobile);

    } catch (e) {
      print("🔴 POST Error: $e");
    } finally {
      isLoading(false);
    }
  }
}