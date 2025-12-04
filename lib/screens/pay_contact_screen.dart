import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'payment_screen.dart';

class PayContactScreen extends StatelessWidget {
  const PayContactScreen({super.key});

  final List<Map<String, dynamic>> _recentContacts = const [
    {'name': 'Albert Flores', 'phone': '+91 1234567890', 'icon': Icons.person},
    {'name': 'Wade Warren', 'phone': '+91 1234567890', 'icon': Icons.person},
    {'name': 'Jenny Wilson', 'phone': '+91 1234567890', 'icon': Icons.person},
    {'name': 'Guy Hawkins', 'phone': '+91 1234567890', 'icon': Icons.person},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPrimaryTeal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Pay contact',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enter phone number Section
            const Text(
              'Enter phone number',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pay someone using a UPI verify phone number',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Enter mobile number',
                      hintStyle: TextStyle(color: kPrimaryTeal.withOpacity(0.6)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: kPrimaryTeal.withOpacity(0.3)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: kPrimaryTeal.withOpacity(0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: kPrimaryTeal, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: kPrimaryTeal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kPrimaryTeal.withOpacity(0.3)),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.person, color: kPrimaryTeal),
                    onPressed: () {
                      // Open contact picker
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Recent Section
            const Text(
              'Recent',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recentContacts.length,
              itemBuilder: (context, index) {
                final contact = _recentContacts[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: kCardLight.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        contact['icon'],
                        color: kPrimaryTeal,
                        size: 28,
                      ),
                    ),
                    title: Text(
                      contact['name'],
                      style: const TextStyle(
                        color: kPrimaryTeal,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      contact['phone'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PaymentScreen(
                            contactName: contact['name'] as String,
                            phoneNumber: contact['phone'] as String,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

