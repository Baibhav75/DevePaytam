import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/api.dart/api_service.dart';

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
  int _selectedIndex = 4; // Profile tab
  final ApiService _apiService = ApiService();

  String _name = '';
  String _phone = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      // No user logged in, redirect to login
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
            (route) => false,
      );
      return;
    }

    final response = await _apiService.getUserProfile(userId: userId);

    if (response != null && response['Status'] == true && response['Data'] != null) {
      setState(() {
        _name = response['Data']['FullName'] ?? 'User';
        _phone = response['Data']['MobileNumber'] ?? '';
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load profile'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onNavItemTapped(int index) {
    if (index == _selectedIndex) return;

    Widget? destination;
    switch (index) {
      case 0:
        destination = const HomeScreen();
        break;
      case 1:
        destination = const TransactionsScreen();
        break;
      case 2:
        destination = const ScanQrScreen();
        break;
      case 3:
        destination = const WalletScreen();
        break;
      case 4:
        return; // Already on Profile
    }

    if (destination != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => destination!),
      );
    }
    setState(() => _selectedIndex = index);
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Logout',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Do you want to logout?',
            style: TextStyle(color: Colors.black87),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'No',
                style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear(); // Clear all saved data
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) =>  LoginScreen()),
                      (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryYellow,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
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
          Container(
            color: kPrimaryYellow,
            padding: EdgeInsets.only(top: statusBarHeight + 20, bottom: 20, left: 20, right: 20),
            child: _isLoading
                ? const SizedBox(
              height: 80,
              child: Center(child: CircularProgressIndicator()),
            )
                : Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/logo.png'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _name,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(_phone, style: const TextStyle(color: Colors.black54)),
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
            )
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
                decoration: BoxDecoration(color: kPrimaryYellow, shape: BoxShape.circle),
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
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
      child: const Icon(Icons.qr_code, color: Colors.black87),
    );
  }
}

// Profile options model
class _ProfileOption {
  const _ProfileOption({required this.icon, required this.title});
  final IconData icon;
  final String title;
}

// List of options
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

// Profile tile widget
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
      title: Text(option.title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {
        switch (option.title) {
          case 'Profile information':
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileInformationScreen()));
            break;
          case 'Bank account':
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BankAccountsScreen()));
            break;
          case 'Help and support':
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HelpSupportScreen()));
            break;
          case 'Privacy policy':
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()));
            break;
          case 'Offers':
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OffersScreen()));
            break;
          case 'Voucher':
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const VoucherScreen()));
            break;
          case 'Referrals':
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ReferralsScreen()));
            break;
        }
      },
    );
  }
}
