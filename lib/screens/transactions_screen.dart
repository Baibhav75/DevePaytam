import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'scan_qr_screen.dart';
import 'wallet_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  int _selectedIndex = 1; // Transactions is selected

  static const List<_ServiceConfig> _rechargeServices = [
    _ServiceConfig(
      title: 'Mobile',
      icon: Icons.phone_android,
      color: kPrimaryYellow,
    ),
    _ServiceConfig(
      title: 'DTH',
      icon: Icons.tv,
      color: kPrimaryYellow,
    ),
    _ServiceConfig(
      title: 'Fast Tag',
      icon: Icons.local_gas_station,
      color: kPrimaryYellow,
    ),
  ];

  static const List<_ServiceConfig> _billPaymentRow1 = [
    _ServiceConfig(
      title: 'Electricity',
      icon: Icons.bolt,
      color: kPrimaryYellow,
    ),
    _ServiceConfig(
      title: 'Gas bill',
      icon: Icons.local_gas_station,
      color: Colors.red,
    ),
    _ServiceConfig(
      title: 'Water bill',
      icon: Icons.water_drop,
      color: Colors.blue,
    ),
  ];

  static const List<_ServiceConfig> _billPaymentRow2 = [
    _ServiceConfig(
      title: 'Credit card',
      icon: Icons.credit_card,
      color: Colors.blue,
    ),
    _ServiceConfig(
      title: 'Broadband',
      icon: Icons.wifi,
      color: kPrimaryYellow,
    ),
    _ServiceConfig(
      title: 'Education',
      icon: Icons.school,
      color: Colors.blue,
    ),
  ];

  static const List<_ServiceConfig> _financeServices = [
    _ServiceConfig(
      title: 'Home EMI',
      icon: Icons.home,
      color: kPrimaryYellow,
    ),
    _ServiceConfig(
      title: 'Govt. Taxes',
      icon: Icons.gavel,
      color: Colors.brown,
    ),
    _ServiceConfig(
      title: 'Insurance',
      icon: Icons.favorite,
      color: Colors.red,
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
      // Already on transactions, do nothing
      return;
    }
    if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ScanQrScreen()),
      );
      return;
    }
    if (index == 3) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WalletScreen()),
      );
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
              top: statusBarHeight + 15,
              bottom: 15,
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
                        'Recharge and pay bill',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // PNG Image lag gaya hai (wallet icon hata diya)
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/transcation.png', // Apna PNG yahan daalo
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.account_balance_wallet,
                          size: 50,
                          color: Colors.black87,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recharge Section
                  _buildSectionTitle('Recharge'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      for (final service in _rechargeServices) ...[
                        Expanded(
                          child: _buildServiceCard(
                            title: service.title,
                            icon: service.icon,
                            iconColor: service.color,
                          ),
                        ),
                        if (service != _rechargeServices.last) const SizedBox(width: 12),
                      ],
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Bill payment Section
                  _buildSectionTitle('Bill payment'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      for (final service in _billPaymentRow1) ...[
                        Expanded(
                          child: _buildServiceCard(
                            title: service.title,
                            icon: service.icon,
                            iconColor: service.color,
                          ),
                        ),
                        if (service != _billPaymentRow1.last) const SizedBox(width: 12),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      for (final service in _billPaymentRow2) ...[
                        Expanded(
                          child: _buildServiceCard(
                            title: service.title,
                            icon: service.icon,
                            iconColor: service.color,
                          ),
                        ),
                        if (service != _billPaymentRow2.last) const SizedBox(width: 12),
                      ],
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Finance & Taxes Section
                  _buildSectionTitle('Finance & Taxes'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      for (final service in _financeServices) ...[
                        Expanded(
                          child: _buildServiceCard(
                            title: service.title,
                            icon: service.icon,
                            iconColor: service.color,
                          ),
                        ),
                        if (service != _financeServices.last) const SizedBox(width: 12),
                      ],
                    ],
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildServiceCard({
    required String title,
    required IconData icon,
    required Color iconColor,
  }) {
    return InkWell(
      onTap: () {
        // Handle service card tap
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title clicked'),
            backgroundColor: kPrimaryYellow,
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceConfig {
  final String title;
  final IconData icon;
  final Color color;

  const _ServiceConfig({
    required this.title,
    required this.icon,
    required this.color,
  });
}
