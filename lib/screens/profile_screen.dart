import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'profile_information_screen.dart';
import 'bank_accounts_screen.dart';
import 'home_screen.dart';
import 'transactions_screen.dart';
import 'wallet_screen.dart';
import 'scan_qr_screen.dart';
import 'help_support_screen.dart';
import 'privacy_policy_screen.dart';
import 'offers_screen.dart';
import 'voucher_screen.dart';
import 'referrals_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 4; // Profile is selected

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
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WalletScreen()),
      );
      return;
    }
    if (index == 4) {
      // Already on profile, do nothing
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Logout',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Do you want to logout?',
            style: TextStyle(
              color: Colors.black87,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text(
                'No',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                // Navigate to login screen and clear navigation stack
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryYellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Yes',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
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
            color: kPrimaryYellow,
            padding: EdgeInsets.only(
              top: statusBarHeight + 20,
              bottom: 20,
              left: 20,
              right: 20,
            ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/logo.png'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Brooklyn Simmons',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '+91 1234567890',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  _buildQrIcon(),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(height: 12),
                  ..._profileOptions.map((option) => _ProfileTile(option: option)),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: _showLogoutDialog,
                  ),
                ],
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

  static Widget _buildQrIcon() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Icon(Icons.qr_code, color: Colors.black87),
    );
  }
}

class _ProfileOption {
  const _ProfileOption({required this.icon, required this.title});

  final IconData icon;
  final String title;
}

const List<_ProfileOption> _profileOptions = [
  _ProfileOption(icon: Icons.person_outline, title: 'Profile information'),
  _ProfileOption(icon: Icons.group_outlined, title: 'Referrals'),
  _ProfileOption(icon: Icons.card_giftcard_outlined, title: 'Voucher'),
  _ProfileOption(icon: Icons.local_offer_outlined, title: 'Offers'),
  _ProfileOption(icon: Icons.account_balance_outlined, title: 'Bank account'),
  _ProfileOption(icon: Icons.language_outlined, title: 'Language'),
  _ProfileOption(icon: Icons.privacy_tip_outlined, title: 'Privacy policy'),
  _ProfileOption(icon: Icons.help_outline, title: 'Help and support'),
];

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({required this.option});

  final _ProfileOption option;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: kCardYellow.withOpacity(0.3),
        child: Icon(option.icon, color: kPrimaryYellow),
      ),
      title: Text(
        option.title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {
        if (option.title == 'Profile information') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ProfileInformationScreen()),
          );
        } else if (option.title == 'Bank account') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const BankAccountsScreen()),
          );
        } else if (option.title == 'Help and support') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
          );
        } else if (option.title == 'Privacy policy') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
          );
        } else if (option.title == 'Offers') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const OffersScreen()),
          );
        } else if (option.title == 'Voucher') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const VoucherScreen()),
          );
        } else if (option.title == 'Referrals') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ReferralsScreen()),
          );
        }
      },
    );
  }
}

