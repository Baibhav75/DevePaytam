import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/add_address_controller.dart';
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                  separatorBuilder: (_, __) =>
                      const Divider(height: 30, thickness: 0.5),
                  itemBuilder: (context, index) {
                    final address = controller.addressList[index];

                    return  GestureDetector(
                    onTap: () {
                      controller.selectedAddress.value = address;  // 👈 SELECT
                      Get.back(); // 👈 WAPAS ORDER SUMMARY
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.home_outlined,
                          size: 26,
                          color: Colors.black54,
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// NAME
                              Text(
                                address.name,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 6),

                              /// ADDRESS
                              Text(
                                "${address.address}, "
                                "${address.city}, "
                                "${address.state}, "
                                "${address.pinCode}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  height: 1.4,
                                ),
                              ),

                              const SizedBox(height: 6),

                              /// MOBILE
                              Text(
                                address.mobileNo,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// THREE DOT MENU
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) {
                            if (value == "edit") {
                              // edit logic
                            } else if (value == "delete") {
                              // delete logic
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: "edit",
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 20),
                                  SizedBox(width: 8),
                                  Text("Edit"),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: "delete",
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    size: 20,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ));
                  },
                ),
              ),
          ],
        );
      }),
    );
  }
}
