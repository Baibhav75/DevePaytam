import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/add_address_controller.dart';

class AddAddressScreen extends StatefulWidget {
  final String mobile;

  const AddAddressScreen({super.key, required this.mobile});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {

  final AddressController controller = Get.find<AddressController>();

  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final pinCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      appBar: AppBar(
        title: const Text("Add New Address"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              _buildField("Full Name", nameCtrl, Icons.person),
              const SizedBox(height: 16),

              _buildField("Complete Address", addressCtrl,
                  Icons.location_on_outlined,
                  maxLines: 3),
              const SizedBox(height: 16),

              _buildField("City", cityCtrl, Icons.location_city),
              const SizedBox(height: 16),

              _buildField("State", stateCtrl, Icons.map),
              const SizedBox(height: 16),

              _buildField("Pin Code", pinCtrl,
                  Icons.pin_drop,
                  keyboardType: TextInputType.number),

              const SizedBox(height: 30),

              Obx(() => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {

                    if (_formKey.currentState!.validate()) {

                      await controller.addAddress(
                        name: nameCtrl.text.trim(),
                        mobile: widget.mobile,
                        addressType: "Home",
                        address: addressCtrl.text.trim(),
                        city: cityCtrl.text.trim(),
                        state: stateCtrl.text.trim(),
                        pinCode: pinCtrl.text.trim(),
                      );

                      Get.back();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0288D1),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(12)),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(
                      color: Colors.white)
                      : const Text(
                    "Save Address",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                    color: Colors.white
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildField(
      String label,
      TextEditingController controller,
      IconData icon, {
        int maxLines = 1,
        TextInputType keyboardType = TextInputType.text,
      }) {

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) =>
      value == null || value.isEmpty
          ? "Required"
          : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(
            vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(12),
          borderSide:
          const BorderSide(
              color: Colors.black,
              width: 1.5),
        ),
      ),
    );
  }
}