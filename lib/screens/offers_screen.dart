import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

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
                    'Offers',
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
          // Main Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildOfferCard(
                  title: 'Flipkart offer',
                  code: 'afg45sd',
                  description: 'Get up to 10% off on payment via smart pay.',
                  icon: Icons.shopping_bag,
                ),
                const SizedBox(height: 16),
                _buildOfferCard(
                  title: 'DTH recharge offer',
                  code: 'afg45sd',
                  description: 'Get 10% cashback on first DTH recharge via smart pay',
                  icon: Icons.tv,
                ),
                const SizedBox(height: 16),
                _buildOfferCard(
                  title: 'Mobile recharge offer',
                  code: 'afg45sd',
                  description: 'Get 20% cashback on first mobile recharge via smart pay',
                  icon: Icons.phone_android,
                ),
                const SizedBox(height: 16),
                _buildOfferCard(
                  title: 'Mobile recharge offer',
                  code: 'afg45sd',
                  description: 'Get 20% cashback on first mobile recharge via smart pay',
                  icon: Icons.phone_android,
                ),
                const SizedBox(height: 16),
                _buildOfferCard(
                  title: 'Money transfer offer',
                  code: 'afg45sd',
                  description: 'Get 10% cashback on first DTH recharge via smart pay',
                  icon: Icons.send,
                ),
                const SizedBox(height: 16),
                _buildOfferCard(
                  title: 'Amazon offer',
                  code: 'afg45sd',
                  description: 'Get up to 10% off on payment via smart pay.',
                  icon: Icons.shopping_cart,
                ),
                const SizedBox(height: 16),
                _buildOfferCard(
                  title: 'DTH recharge offer',
                  code: 'afg45sd',
                  description: 'Get 10% cashback on first DTH recharge via smart pay',
                  icon: Icons.tv,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard({
    required String title,
    required String code,
    required String description,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon/Image placeholder
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: kCardYellow.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 40,
              color: kPrimaryYellow,
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: kPrimaryYellow,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Use code : $code',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

