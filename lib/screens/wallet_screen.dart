import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'scan_qr_screen.dart';
import 'transactions_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int _selectedIndex = 3; // Wallet is selected

  static const List<_WalletQuickAction> _quickActions = [
    _WalletQuickAction(
      title: 'Add money',
      icon: Icons.add_circle_outline,
      color: Color(0xFFFFE0E6), // approximate for Colors.pink[100]
      iconColor: Colors.pink,
    ),
    _WalletQuickAction(
      title: 'Bank transfer',
      icon: Icons.account_balance,
      color: Color(0xFFBBDEFB), // approximate for Colors.blue[100]
      iconColor: Colors.blue,
    ),
    _WalletQuickAction(
      title: 'Transaction history',
      icon: Icons.history,
      color: Color(0xFFFFE0B2), // approximate for Colors.orange[100]
      iconColor: Colors.orange,
    ),
  ];

  void _onNavItemTapped(int index) {
    if (index == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
      return;
    }
    if (index == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const TransactionsScreen()),
      );
      return;
    }
    if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ScanQrScreen()),
      );
      return;
    }
    if (index == 3) {
      // Already on wallet, do nothing
      return;
    }
    if (index == 4) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

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
              top: statusBarHeight + 17,
              bottom: 17,
              left: 20,
              right: 20,
            ),
            decoration: const BoxDecoration(
              color: kPrimaryYellow,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'My wallet',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Balance : \$150.00',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Custom PNG Illustration (Replaced Icon)
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset(
                        'assets/wallet2.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Quick Action Buttons
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                for (final action in _quickActions) ...[
                  Expanded(
                    child: _buildQuickActionButton(
                      title: action.title,
                      icon: action.icon,
                      color: action.color,
                      iconColor: action.iconColor,
                    ),
                  ),
                  if (action != _quickActions.last) const SizedBox(width: 12),
                ],
              ],
            ),
          ),
          // Recent Transactions Section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recent transaction',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTransactionItem(
                    name: 'Albert Flore',
                    date: '20 Jan, 2019',
                    amount: '\$27.50',
                    isCredit: true,
                  ),
                  _buildTransactionItem(
                    name: 'Wade Warren',
                    date: '20 Jan, 2019',
                    amount: '\$27.50',
                    isCredit: false,
                  ),
                  _buildTransactionItem(
                    name: 'Floyd Miles',
                    date: '19 Jan, 2019',
                    amount: '\$50.00',
                    isCredit: true,
                  ),
                  _buildTransactionItem(
                    name: 'Bessie Cooper',
                    date: '18 Jan, 2019',
                    amount: '\$45.00',
                    isCredit: true,
                  ),
                  _buildTransactionItem(
                    name: 'Leslie Alexander',
                    date: '15 Jan, 2019',
                    amount: '\$20.50',
                    isCredit: true,
                  ),
                  _buildTransactionItem(
                    name: 'Theresa Webb',
                    date: '15 Jan, 2019',
                    amount: '\$30.45',
                    isCredit: true,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: kCardLight,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onNavItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black87,
          unselectedItemColor: Colors.black54,
          backgroundColor: kCardLight,
          items: [
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 0 ? Icons.home : Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 1 ? Icons.receipt_long : Icons.receipt_long_outlined),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: kPrimaryYellow,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 24),
              ),
              label: 'Scan',
            ),
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 3 ? Icons.account_balance_wallet : Icons.account_balance_wallet_outlined),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 4 ? Icons.person : Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required String title,
    required IconData icon,
    required Color color,
    required Color iconColor,
  }) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title clicked'),
            backgroundColor: kPrimaryYellow,
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: iconColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem({
    required String name,
    required String date,
    required String amount,
    required bool isCredit,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Profile Picture
          CircleAvatar(
            radius: 24,
            backgroundColor: kPrimaryYellow.withOpacity(0.2),
            child: Text(
              name[0].toUpperCase(),
              style: TextStyle(
                color: kPrimaryYellow,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Name and Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: kPrimaryYellow,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Amount
          Text(
            amount,
            style: TextStyle(
              color: isCredit ? Colors.green : Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletQuickAction {
  final String title;
  final IconData icon;
  final Color color;
  final Color iconColor;

  const _WalletQuickAction({
    required this.title,
    required this.icon,
    required this.color,
    required this.iconColor,
  });
}
