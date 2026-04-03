import 'package:shared_preferences/shared_preferences.dart';

import '../models/add_address_model.dart';
import '../service/add_address_service.dart';
import 'package:get/get.dart';

import 'Auth_Controller.dart';

class AddressController extends GetxController {

  final AddAddressService _apiService = AddAddressService();

  var isLoading = false.obs;
  var addressList = <AddAddressModel>[].obs;
  var selectedAddress = Rxn<AddAddressModel>();
  var currentPinAddress = "".obs;


  /// ================== GET ADDRESS ==================
  Future<void> fetchAddress({String? mobile}) async {
    try {
      isLoading(true);

      String mobileNumber = mobile ?? "";

      // ✅ FALLBACK 1: Check AuthController
      if (mobileNumber.isEmpty && Get.isRegistered<AuthController>()) {
        mobileNumber = Get.find<AuthController>().mobileNo.value;
      }

      // ✅ FALLBACK 2: Check SharedPreferences
      if (mobileNumber.isEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        mobileNumber = prefs.getString("mobile") ?? "";
      }

      if (mobileNumber.isEmpty) {
        print("❌ Mobile number not found for fetching address");
        return;
      }

      final response = await _apiService.getAddress(mobileNumber);

      /// ✅ Robust parsing (Handles 'Data' and 'data')
      var dataList = response?['Data'] ?? response?['data'];

      if (dataList != null && dataList is List) {
        addressList.value = dataList
            .map((e) => AddAddressModel.fromJson(e))
            .toList();

        print("✅ Address Count: ${addressList.length}");
        
        // Auto-select first address if none selected
        if (addressList.isNotEmpty && selectedAddress.value == null) {
          selectedAddress.value = addressList.first;
        }
      } else {
        addressList.clear();
        print("❌ No address data found in response");
      }
    } catch (e) {
      print("🔴 Address Fetch Error: $e");
    } finally {
      isLoading(false);
    }
  }

  /// ================== ADD ADDRESS ==================
  Future<bool> addAddress({
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

      String mobileNumber = mobile;

      // ✅ FALLBACK 1: Check AuthController
      if (mobileNumber.isEmpty && Get.isRegistered<AuthController>()) {
        mobileNumber = Get.find<AuthController>().mobileNo.value;
      }

      // ✅ FALLBACK 2: Check SharedPreferences
      if (mobileNumber.isEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        mobileNumber = prefs.getString("mobile") ?? "";
      }

      if (mobileNumber.isEmpty) {
        print("❌ Mobile number not found for adding address");
        Get.snackbar("Error", "Mobile number is required to add address");
        return false;
      }

      final body = {
        "Name": name,
        "MobileNo": mobileNumber,
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
      await fetchAddress(mobile: mobileNumber);
      return true;

    } catch (e) {
      print("🔴 POST Error: $e");
      Get.snackbar("Error", "Failed to add address. Please try again.");
      return false;
    } finally {
      isLoading(false);
    }
  }
}