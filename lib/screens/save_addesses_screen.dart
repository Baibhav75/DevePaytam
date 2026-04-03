import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/add_address_controller.dart';
import '../ecommerce/screens/locationpage.dart';
import 'addAddress_screen.dart';

class SaveAddressesScreen extends StatefulWidget {
  final String mobile;

  const SaveAddressesScreen({super.key, required this.mobile});

  @override
  State<SaveAddressesScreen> createState() => _SaveAddressesScreenState();
}

class _SaveAddressesScreenState extends State<SaveAddressesScreen> {
  late final AddressController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(AddressController());
    controller.fetchAddress(mobile: widget.mobile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Saved Addresses",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            /// 🔥 BODY TOP RIGHT ADD NEW
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  // ✅ OPTION 1: CURRENT LOCATION (MAP)
                  InkWell(
                    onTap: () async {
                      // 👉 यहाँ map screen open करो
                      final result = await Get.to(() => SelectDeliveryLocationScreen());

                      if (result != null) {
                        controller.fetchAddress(mobile: widget.mobile);
                      }
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.my_location, color: Colors.green, size: 22),
                        SizedBox(width: 6),
                        Text(
                          "Use Current Location",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ✅ OPTION 2: ADD NEW ADDRESS
                  InkWell(
                    onTap: () async {
                      await Get.to(
                            () => AddAddressScreen(mobile: widget.mobile),
                      );

                      controller.fetchAddress(mobile: widget.mobile);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.add, color: Colors.blue, size: 22),
                        SizedBox(width: 6),
                        Text(
                          "Add New",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            /// EMPTY STATE
            if (controller.addressList.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    "No Address Found",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ),
              )
            else
              /// ADDRESS LIST
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.addressList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final address = controller.addressList[index];
                    final isSelected = controller.selectedAddress.value?.address == address.address;

                    return GestureDetector(
                      onTap: () {
                        controller.selectedAddress.value = address;
                        Get.back();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFF2F8FD) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF2874F0) : Colors.grey.shade300,
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Radio<String>(
                              value: address.address,
                              groupValue: controller.selectedAddress.value?.address,
                              activeColor: const Color(0xFF2874F0),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              onChanged: (val) {
                                controller.selectedAddress.value = address;
                                Get.back();
                              },
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        address.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          address.addressType.toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "${address.address}, ${address.city}, ${address.state} - ${address.pinCode}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    address.mobileNo,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert, color: Colors.black87),
                              onSelected: (value) {
                                // Add your logic
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(value: "edit", child: Text("Edit")),
                                PopupMenuItem(value: "delete", child: Text("Delete", style: TextStyle(color: Colors.red))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      }),
    );
  }
}
