import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ElectricityBillersScreen extends StatelessWidget {
  const ElectricityBillersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Section - Full coverage from top
          Container(
            padding: EdgeInsets.only(
              top: statusBarHeight + 16,
              bottom: 16,
              left: 20,
              right: 20,
            ),
            decoration: const BoxDecoration(
              color: kPrimaryYellow,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const Expanded(
                  child: Text(
                    'Electricity billers',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 48), // Balance the back button
              ],
            ),
          ),
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                hintText: 'Search by biller',
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          // Main Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const SizedBox(height: 16),
                // Biller in Gujarat Section
                const Text(
                  'Biller in Gujarat',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildBillerItem(
                  name: 'DGVCL Dakshin gujarat vij company',
                  iconColor: Colors.blue,
                  iconText: 'GVC',
                ),
                _buildBillerItem(
                  name: 'Gift power company ltd',
                  iconColor: Colors.brown,
                  iconText: '⚡',
                ),
                _buildBillerItem(
                  name: 'Madhya gujarat vij company limited',
                  iconColor: Colors.lightBlue,
                  iconText: 'GVC',
                ),
                _buildBillerItem(
                  name: 'Uttar gujart vij company ltd',
                  iconColor: Colors.lightGreen,
                  iconText: 'GVC',
                ),
                _buildBillerItem(
                  name: 'Paschim Gujarat Vij Company Ltd.',
                  iconColor: Colors.brown[300]!,
                  iconText: 'GVC',
                ),
                _buildBillerItem(
                  name: 'Torrent power',
                  iconColor: Colors.orange,
                  iconText: 'TP',
                ),
                const SizedBox(height: 24),
                // All biller Section
                const Text(
                  'All biller',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildBillerItem(
                  name: 'Ajmer vidyut vitrand nigam ltd',
                  iconColor: Colors.brown,
                  iconText: 'AV',
                ),
                _buildBillerItem(
                  name: 'APSPDCL AP south',
                  iconColor: Colors.blue,
                  iconText: 'S&D',
                ),
                _buildBillerItem(
                  name: 'Uttar gujart vij company ltd',
                  iconColor: Colors.lightGreen,
                  iconText: 'GVC',
                ),
                _buildBillerItem(
                  name: 'Adani electricity mumbai limited',
                  iconColor: Colors.green,
                  iconText: 'AE',
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillerItem({
    required String name,
    required Color iconColor,
    required String iconText,
  }) {
    return InkWell(
      onTap: () {
        // Handle biller selection
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: iconColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  iconText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}



