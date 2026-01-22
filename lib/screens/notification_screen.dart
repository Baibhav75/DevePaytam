import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

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
          'Notification',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          // Today Section
          _buildSectionHeader('Today'),
          _buildNotificationItem(
            icon: Icons.account_balance_wallet,
            iconColor: kPrimaryTeal,
            title: 'Payment',
            description: 'You have successfully paid \$500',
            time: '5 min ago',
          ),
          _buildNotificationItem(
            icon: Icons.swap_horiz,
            iconColor: kCardTeal,
            title: 'Money transfer',
            description: 'You have successfully sent money to jacalin Patel',
            time: '10 min ago',
          ),
          _buildNotificationItem(
            icon: Icons.percent,
            iconColor: kPrimaryTeal,
            title: 'Cashback 25%',
            description: 'Your recharge is done you got 25 % cashback',
            time: '25 m ago',
          ),
          const SizedBox(height: 24),
          // This week Section
          _buildSectionHeader('This week'),
          _buildNotificationItem(
            icon: Icons.shield,
            iconColor: kSoftTeal,
            title: 'Reward',
            description: 'New user reward! explore',
            date: '20 mar',
          ),
          _buildNotificationItem(
            icon: Icons.account_balance_wallet,
            iconColor: kPrimaryTeal,
            title: 'Payment',
            description: 'You have successfully paid \$500',
            date: '21 mar',
          ),
          _buildNotificationItem(
            icon: Icons.swap_horiz,
            iconColor: kCardTeal,
            title: 'Money transfer',
            description: 'You have successfully sent money to jacalin Patel',
            date: '21 mar',
          ),
          _buildNotificationItem(
            icon: Icons.percent,
            iconColor: kPrimaryTeal,
            title: 'Cashback 25%',
            description: 'New user reward! explore',
            date: '23 mar',
          ),
          _buildNotificationItem(
            icon: Icons.smartphone,
            iconColor: Colors.blueAccent,
            title: 'Mobile recharge',
            description: 'You have successfully done mobile recharge \$59.00',
            date: '21 mar',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    String? time,
    String? date,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kPrimaryTeal.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: kPrimaryTeal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            time ?? date ?? '',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}


