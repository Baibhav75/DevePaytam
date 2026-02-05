import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/change_password_controller.dart';
import '../controller/profile_controller.dart';
import '../profile/ChangePasswordScreen.dart';
import '/api.dart/api_service.dart';

import '../theme/app_colors.dart';
import 'profile_information_screen.dart';
import 'bank_accounts_screen.dart';
import 'home_screen.dart';
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
  final ApiService _apiService = ApiService();

  String _name = '';
  String _phone = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // ================= LOAD PROFILE =================
  Future<void> _loadUserProfile() async {
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();

    // 🔥 STEP 1: SHOW LOCAL DATA FIRST (FAST UI)
    setState(() {
      _name = prefs.getString('fullName') ?? 'User';
      _phone = prefs.getString('mobile') ?? '';
      _isLoading = false;
    });

    final userId = prefs.getString('userId');

    // ❌ Not logged in
    if (userId == null) {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) =>  LoginScreen()),
            (route) => false,
      );
      return;
    }

    // 🔄 STEP 2: FETCH FROM API (BACKGROUND REFRESH)
    final response = await _apiService.getUserProfile(userId: userId);

    if (!mounted) return;

    if (response != null &&
        response['Status'] == true &&
        response['Data'] != null) {
      final data = response['Data'];

      // 🔥 SAVE UPDATED DATA
      await prefs.setString('fullName', data['FullName'] ?? '');
      await prefs.setString('mobile', data['MobileNumber'] ?? '');
      await prefs.setString('email', data['Email'] ?? '');

      // 🔄 UPDATE UI
      setState(() {
        _name = data['FullName'] ?? _name;
        _phone = data['MobileNumber'] ?? _phone;
      });
    }
  }

  // ================= LOGOUT =================
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Do you want to logout?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (!mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => LoginScreen()),
                    (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryYellow,
            ),
            child: const Text('Yes', style: TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ================= HEADER =================
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
                InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, size: 18),
                  ),
                ),
                const SizedBox(width: 12),
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _phone,
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ================= BODY =================
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
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _showLogoutDialog,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const List<_ProfileOption> _profileOptions = [
  _ProfileOption(icon: Icons.person_outline, title: 'Profile information'),
  _ProfileOption(icon: Icons.group_outlined, title: 'Referrals'),
  _ProfileOption(icon: Icons.card_giftcard_outlined, title: 'Voucher'),
  _ProfileOption(icon: Icons.local_offer_outlined, title: 'Offers'),
  _ProfileOption(icon: Icons.account_balance_outlined, title: 'Bank account'),
  _ProfileOption(icon: Icons.privacy_tip_outlined, title: 'Privacy policy'),
  _ProfileOption(icon: Icons.help_outline, title: 'Help and support'),
  _ProfileOption(icon: Icons.published_with_changes, title: 'Change password'),
];


// ================= MODELS =================
class _ProfileOption {
  const _ProfileOption({required this.icon, required this.title});
  final IconData icon;
  final String title;
}

// ================= TILE =================
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
      title: Text(option.title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        switch (option.title) {

          case 'Profile information':
          // ✅ Ensure ProfileController exists
            if (!Get.isRegistered<ProfileController>()) {
              Get.put(ProfileController());
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UserProfileScreen(),
              ),
            );
            break;

          case 'Bank account':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const BankAccountsScreen(),
              ),
            );
            break;

          case 'Help and support':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const HelpSupportScreen(),
              ),
            );
            break;

          case 'Privacy policy':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PrivacyPolicyScreen(),
              ),
            );
            break;

          case 'Offers':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const OffersScreen(),
              ),
            );
            break;

          case 'Voucher':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const VoucherScreen(),
              ),
            );
            break;

          case 'Referrals':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ReferralsScreen(),
              ),
            );
            break;

          case 'Change password':
          // ✅ CRITICAL FIX
            if (!Get.isRegistered<ProfileController>()) {
              Get.put(ProfileController());
            }

            if (!Get.isRegistered<ChangePasswordController>()) {
              Get.put(ChangePasswordController());
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChangePasswordScreen(),
              ),
            );
            break;
        }
      },
    );
  }
}

