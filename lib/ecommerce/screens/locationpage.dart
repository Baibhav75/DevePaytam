import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class SelectDeliveryLocationScreen extends StatefulWidget {
  const SelectDeliveryLocationScreen({super.key});

  @override
  State<SelectDeliveryLocationScreen> createState() =>
      _SelectDeliveryLocationScreenState();
}

class _SelectDeliveryLocationScreenState
    extends State<SelectDeliveryLocationScreen> {
  GoogleMapController? mapController;

  LatLng? selectedLatLng;
  String address = "Fetching address...";
  Placemark? currentPlace;

  // ================= GET CURRENT LOCATION =================
  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    selectedLatLng = LatLng(position.latitude, position.longitude);

    mapController?.animateCamera(
      CameraUpdate.newLatLng(selectedLatLng!),
    );

    getAddressFromLatLng(selectedLatLng!);
  }

  // ================= GET ADDRESS =================
  Future<void> getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

      final place = placemarks.first;

      setState(() {
        currentPlace = place;
        address =
        "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}";
      });
    } catch (e) {
      setState(() {
        address = "Unable to fetch address";
      });
    }
  }

  // ================= INIT =================
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Delivery Location")),

      body: Stack(
        children: [
          // 🗺️ MAP
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(28.6139, 77.2090),
              zoom: 14,
            ),
            onMapCreated: (controller) {
              mapController = controller;
            },

            // 👉 User tap
            onTap: (latLng) {
              setState(() {
                selectedLatLng = latLng;
              });
              getAddressFromLatLng(latLng);
            },

            // 👉 Marker
            markers: selectedLatLng == null
                ? {}
                : {
              Marker(
                markerId: const MarkerId("selected"),
                position: selectedLatLng!,
                draggable: true,

                // 👉 Drag support
                onDragEnd: (newLatLng) {
                  setState(() {
                    selectedLatLng = newLatLng;
                  });
                  getAddressFromLatLng(newLatLng);
                },
              ),
            },
          ),

          // 📍 ADDRESS CARD
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Selected Address",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(address),

                  const SizedBox(height: 12),

                  // ✅ CONFIRM BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back(result: {
                          "address": address,
                          "city": currentPlace?.locality ?? "",
                          "state": currentPlace?.administrativeArea ?? "",
                          "pinCode": currentPlace?.postalCode ?? "",
                          "lat": selectedLatLng?.latitude,
                          "lng": selectedLatLng?.longitude,
                        });
                      },
                      child: const Text("Confirm Location"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}