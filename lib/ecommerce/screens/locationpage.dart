import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String _currentAddress = 'Fetching location...';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  // 🔐 Permission + Location handler
  Future<void> _fetchCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _currentAddress = 'Location service disabled';
          _loading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _currentAddress = 'Permission denied';
            _loading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _currentAddress = 'Enable permission from settings';
          _loading = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final place = placemarks.first;

      setState(() {
        _currentAddress =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}';
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _currentAddress = 'Unable to fetch location';
        _loading = false;
      });
    }
  }

  // 🧾 Dialog launcher
  Future<void> _openLocationDialog(String title) async {
    final result = await showDialog<String>(
      context: context,
      builder: (_) => LocationInputDialog(title: title),
    );

    if (result != null && result.trim().isNotEmpty) {
      Navigator.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔄 Use current location
            ListTile(
              leading: const Icon(Icons.my_location, color: Colors.blue),
              title: const Text('Use current location'),
              subtitle: Text(_loading ? 'Please wait...' : _currentAddress),
              trailing: const Icon(Icons.chevron_right),
              onTap: _loading
                  ? null
                  : () {
                Navigator.pop(context, _currentAddress);
              },
            ),

            const Divider(),

            /// ✏️ Edit location
            ListTile(
              leading:
              const Icon(Icons.edit_location_alt, color: Colors.orange),
              title: const Text('Edit location'),
              subtitle: const Text('Change house, area or landmark'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _openLocationDialog('Edit Location'),
            ),

            const Divider(),

            /// ➕ Add new location
            ListTile(
              leading:
              const Icon(Icons.add_location_alt, color: Colors.green),
              title: const Text('Add new location'),
              subtitle: const Text('Add address manually'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _openLocationDialog('Add Location'),
            ),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////

class LocationInputDialog extends StatefulWidget {
  final String title;

  const LocationInputDialog({super.key, required this.title});

  @override
  State<LocationInputDialog> createState() => _LocationInputDialogState();
}

class _LocationInputDialogState extends State<LocationInputDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Enter address',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, _controller.text.trim());
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
