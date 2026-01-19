import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../ecommerce/screens/shop_home_screen.dart';
import '../theme/app_colors.dart';
import 'search_screen.dart';
import 'notification_screen.dart';
import 'pay_contact_screen.dart';
import 'to_account_screen.dart';
import 'profile_screen.dart';
import 'scan_qr_screen.dart';
import 'transactions_screen.dart';
import 'wallet_screen.dart';
import 'mobile_recharge_screen.dart';
import 'electricity_billers_screen.dart';
import 'dth_recharge_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  int _currentPromoIndex = 0;

  // Hoisted promo configuration so it isn't recreated on every build
  static const List<_Promo> _promos = [
    _Promo(
      title: 'Up to 20 % cashback on bill payment every....',
      icon: Icons.account_balance_wallet,
    ),
    _Promo(
      title: 'Get 15% off on your first recharge!',
      icon: Icons.phone_android,
    ),
    _Promo(
      title: 'Special offer: 10% discount on gas bills',
      icon: Icons.local_gas_station,
    ),
  ];

  // Developer-only content explaining footer architecture (used in UI below).
  final List<Promo> developerFooterPromos = const [
    Promo(
      title: 'Footer Architecture Overview',
      subtitle:
          'The footer is built using layered widgets instead of BottomNavigationBar',
    ),
    Promo(
      title: 'Why Custom Footer',
      subtitle: 'Default BottomNavigationBar cannot create curved notch/center cut',
    ),
    Promo(
      title: 'Stack-Based Layout',
      subtitle: 'Stack layers footer bar, notch, and scan button',
    ),
    Promo(
      title: 'Base Footer Container',
      subtitle: 'A fixed-height container holds navigation icons and labels',
    ),
    Promo(
      title: 'Curved Notch Creation',
      subtitle: 'A curved path can be drawn using CustomPainter for a center cut',
    ),
    Promo(
      title: 'Floating Scan Button',
      subtitle: 'Scan button is positioned using Positioned inside Stack',
    ),
    Promo(
      title: 'Depth Illusion',
      subtitle: 'Shadows and circular layers create depth behind the scan button',
    ),
    Promo(
      title: 'Active Tab State',
      subtitle: 'Selected index controls icon state and navigation',
    ),
    Promo(
      title: 'Animated Icon Switching',
      subtitle: 'AnimatedSwitcher toggles active and inactive icons',
    ),
    Promo(
      title: 'Responsive & Safe Area',
      subtitle: 'Footer adapts across different screen sizes',
    ),
    Promo(
      title: 'Production-Ready Footer',
      subtitle: 'Custom, scalable, and fintech-ready design',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// ✅ NAV TAP HANDLER (FIXED)
  void _onNavTap(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
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
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  },
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: kPrimaryYellow),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome',
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                      Text(
                        'Brooklyn Simmons',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.black87),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SearchScreen()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.black87,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const NotificationScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: _QuickActionButton(
                          title: 'Pay contact',
                          icon: Icons.phone,
                          color: kPrimaryTeal,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const PayContactScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickActionButton(
                          title: 'Bank transfer',
                          icon: Icons.account_balance,
                          color: kCardTeal,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ToAccountScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickActionButton(
                          title: 'Self transfer',
                          icon: Icons.swap_horiz,
                          color: kSoftTeal,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Promotional Banner - Swipeable
                  SizedBox(
                    height: 160,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPromoIndex = index;
                        });
                      },
                      itemCount: _promos.length,
                      itemBuilder: (context, index) {
                        final promo = _promos[index];
                        return Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [kCardTeal, kPrimaryTeal],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      promo.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    OutlinedButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Promo details coming soon!',
                                            ),
                                          ),
                                        );
                                      },
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: Colors.white,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Know more',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                promo.icon,
                                size: 60,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Page Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _promos.length,
                      (index) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPromoIndex == index
                              ? kPrimaryTeal
                              : kPrimaryTeal.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Developer Notes (Footer architecture promos)
                  const Text(
                    'Developer notes',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 110,
                    child: PageView.builder(
                      itemCount: developerFooterPromos.length,
                      controller: PageController(viewportFraction: 0.92),
                      itemBuilder: (context, index) {
                        final p = developerFooterPromos[index];
                        return _DeveloperPromoCard(promo: p);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Recharge and pay bill Section
                  const Text(
                    'Recharge and pay bill',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: [
                      _BillOption(
                        title: 'Shop',
                        icon: Icons.shopping_bag_outlined,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ShopHomeScreen(),
                            ),
                          );
                        },
                      ),
                      _BillOption(
                        title: 'Recharge',
                        icon: Icons.phone_android,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const MobileRechargeScreen(),
                            ),
                          );
                        },
                      ),
                      _BillOption(
                        title: 'Electricity',
                        icon: Icons.bolt,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ElectricityBillersScreen(),
                            ),
                          );
                        },
                      ),
                      _BillOption(
                        title: 'Gas bill',
                        icon: Icons.local_gas_station,
                        onTap: () {},
                      ),
                      _BillOption(
                        title: 'Credit card',
                        icon: Icons.credit_card,
                        onTap: () {},
                      ),
                      _BillOption(
                        title: 'DTH',
                        icon: Icons.tv,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const DthRechargeScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Recent transaction Section
                  const Text(
                    'Recent transaction',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 80,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _RecentContact(
                          icon: Icons.person,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const MobileRechargeScreen(),
                              ),
                            );
                          },
                        ),
                        _RecentContact(
                          icon: Icons.person,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const MobileRechargeScreen(),
                              ),
                            );
                          },
                        ),
                        _RecentContact(
                          icon: Icons.person,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const MobileRechargeScreen(),
                              ),
                            );
                          },
                        ),
                        _RecentContact(
                          icon: Icons.person,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const MobileRechargeScreen(),
                              ),
                            );
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ScanQrScreen(),
                              ),
                            );
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: kPrimaryTeal,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: kPrimaryTeal.withOpacity(0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.qr_code_scanner,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 100,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            /// WHITE FOOTER BAR
            Container(
              height: 70,
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08), // soft shadow
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _AnimatedBottomItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: 'Home',
                    isActive: _selectedIndex == 0,
                    onTap: () => _onNavTap(0),
                    activeColor: Colors.black,
                    inactiveColor: Colors.black54,
                  ),
                  _AnimatedBottomItem(
                    icon: Icons.shopping_bag_outlined,
                    activeIcon: Icons.shopping_bag,
                    label: 'Shop',
                    isActive: _selectedIndex == 1,
                    onTap: () {
                      _onNavTap(1);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const ShopHomeScreen()),
                      );
                    },
                    activeColor: Colors.black,
                    inactiveColor: Colors.black54,
                  ),
                  const SizedBox(width: 48),
                  _AnimatedBottomItem(
                    icon: Icons.credit_card_outlined,
                    activeIcon: Icons.credit_card,
                    label: 'Card',
                    isActive: _selectedIndex == 3,
                    onTap: () {
                      _onNavTap(3);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const WalletScreen()),
                      );
                    },
                    activeColor: Colors.black,
                    inactiveColor: Colors.black54,
                  ),
                  _AnimatedBottomItem(
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    label: 'Profile',
                    isActive: _selectedIndex == 4,
                    onTap: () {
                      _onNavTap(4);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfileScreen()),
                      );
                    },
                    activeColor: Colors.black,
                    inactiveColor: Colors.black54,
                  ),
                ],
              ),
            ),

            /// CENTER SCAN BUTTON (WHITE & CLEAN)
            Positioned(
              bottom: 30,
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ScanQrScreen()),
                  );
                },
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.qr_code_scanner,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}

// ================= HELPERS =================
class _AnimatedBottomItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;

  const _AnimatedBottomItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? activeColor : inactiveColor;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              isActive ? activeIcon : icon,
              key: ValueKey(isActive),
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight:
              isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}



class _Promo {
  final String title;
  final IconData icon;
  const _Promo({required this.title, required this.icon});
}

class Promo {
  final String title;
  final String subtitle;
  const Promo({required this.title, required this.subtitle});
}

class _DeveloperPromoCard extends StatelessWidget {
  final Promo promo;
  const _DeveloperPromoCard({required this.promo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.layers, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  promo.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  promo.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.2,
                    color: Colors.black54,
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

class _QuickActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
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
}

class _BillOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _BillOption({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: kCardLight.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: kPrimaryTeal.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: kPrimaryTeal, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentContact extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _RecentContact({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: kCardLight.withOpacity(0.3),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: kPrimaryTeal.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: kPrimaryTeal),
      ),
    );
  }
}
