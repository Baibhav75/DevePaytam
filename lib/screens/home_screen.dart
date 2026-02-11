import 'dart:ui';
import 'package:Dewa/screens/receiver_bank_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import '../ecommerce/screens/best_selling_section.dart';
import '../ecommerce/screens/shop_home_screen.dart';
import '../ecommerce/widgets/CategorySection.dart';
import '../ecommerce/widgets/big_summer_sale_list_page.dart';
import '../paytam/TapPaymentOfferSection.dart';
import '../theme/app_colors.dart';
import 'image_banner.dart';
import 'offers_screen.dart';
import 'search_screen.dart';
import 'notification_screen.dart';
import 'pay_contact_screen.dart';
import 'to_account_screen.dart';
import 'profile_screen.dart';
import 'scan_qr_screen.dart';
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

  // Pages for IndexedStack
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // Define all pages for the IndexedStack
    _pages = [
      _HomeContent(),  // index 0 - Home
      const ShopHomeScreen(),  // index 1 - Shop
      const SizedBox(),  // index 2 - Empty (for scan button)
      const WalletScreen(),  // index 3 - Card/Wallet
      const ProfileScreen(),  // index 4 - Profile
    ];
  }

  // Developer-only content
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

  /// Navigation tap handler - switches between pages using IndexedStack
  void _onNavTap(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5) , // Light background
      body: Stack(
          children: [
            // Main content using IndexedStack
            Positioned.fill(
              child: IndexedStack(
                index: _selectedIndex,
                children: _pages,
              ),
            ),

            // Custom Footer
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: _CustomFooter(
                selectedIndex: _selectedIndex,
                onNavTap: _onNavTap,
              ),
            ),
          ],
    ),
    );
  }
}

// ==================== HOME CONTENT WIDGET ====================
class _HomeContent extends StatefulWidget {
  @override
  State<_HomeContent> createState() => __HomeContentState();
}

class __HomeContentState extends State<_HomeContent> {
  final String bankName = "My Bank";


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 120),
      // Space for footer

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==================== FULL WIDTH BANNER HEADER ====================
          SizedBox(
            height: 280, // Taller header for full effect
            child: Stack(
              children: [
                // 1. Full Width Banner Carousel
                Positioned.fill(
                  child: PageView(
                    controller: PageController(viewportFraction: 1.0), // Full width
                    children: [
                      _BannerCard(
                        title: "Big Summer Sale",
                        subtitle: "Up to 50% Off\nOn Electronics",
                        buttonText: "Shop Now",
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor.withOpacity(0.75),
                          ],
                        ),
                        icon: Icons.shopping_bag,
                        fullWidth: true,
                        onTap: () {
                          Get.to(() => const BigSummerSaleListPage());
                        },
                      ),
                       const _BannerCard(//
                        title: "New Arrivals",
                        subtitle: "Trendy Fashion\nStarts @ ₹499",
                        buttonText: "Explore",
                         gradient: LinearGradient(
                           begin: Alignment.topLeft,
                           end: Alignment.bottomRight,
                           //colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                            colors: [Color(0xFFff9966), Color(0xFFff5e62)],
                         ),
                        icon: Icons.checkroom,
                        fullWidth: true,
                      ),
                       const _BannerCard(
                        title: "Special Offer",
                        subtitle: "Get Flat ₹100\nCashback",
                        buttonText: "Claim",
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                           end: Alignment.bottomRight,
                          colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
                        ),
                        icon: Icons.account_balance_wallet,
                        fullWidth: true,
                      ),
                    ],
                  ),
                ),

                // 2. Overlay Top Bar (Menu & Help)
                Positioned(
                  top: 50,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Drawer Icon
                      Builder(
                        builder: (context) => Material(
                          color: Colors.black26, // Semi-transparent backing
                          shape: const CircleBorder(
                            side: BorderSide(color: Colors.white30, width: 1.5),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfileScreen(),
                                ),
                              );
                            },
                            customBorder: const CircleBorder(),
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(Icons.menu, color: Colors.white, size: 24),
                            ),
                          ),
                        ),
                      ),
                      
                      // Help Icon
                      Material(
                        color: Colors.black26, 
                        shape: const CircleBorder(
                          side: BorderSide(color: Colors.white30, width: 1.5),
                        ),
                        child: InkWell(
                          onTap: () {},
                          customBorder: const CircleBorder(),
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(Icons.help_outline, color: Colors.white, size: 22),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ==================== BODY CONTENT ====================
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Money Transfers Title
                const Text(
                  "Money Transfers",
                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                
                // Money Transfer Icons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCircleMenuOption(Icons.phone_in_talk, "To Mobile\nNumber", context, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PayContactScreen()))),
                    _buildCircleMenuOption(Icons.account_balance, "To Bank &\nSelf A/c", context, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ToAccountScreen()))),
                    _buildCircleMenuOption(Icons.download, "Receive\nMoney", context,() => Navigator.push(context, MaterialPageRoute(builder: (_) => const DthRechargeScreen ()))),
                    _buildCircleMenuOption(Icons.account_balance_wallet, "Check\nBalance",context, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletScreen()))),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Promo Chips
                Row(
                  children: [
                    Expanded(child: _buildDarkPromoChip(Icons.currency_rupee, "Refer -> ₹200")),
                    const SizedBox(width: 12),
                    Expanded(child: _buildDarkPromoChip(Icons.savings, "Gold savings start @ ₹10")),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Recharge & Bills Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // ⭐ height control
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Recharge & Bills",
                            style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text("View All", style: TextStyle(color: Theme.of(context).primaryColor)),

                          )
                        ],
                      ),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 4,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 8,//ReceiverBankFormScreen
                        childAspectRatio: 0.9,
                        children: [
                          _buildGridOption(Icons.smartphone, "Mobile\nRecharge", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MobileRechargeScreen()))),
                          _buildGridOption(Icons.shopping_bag_outlined, "FASTag\nRecharge", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopHomeScreen()))),
                          _buildGridOption(Icons.lightbulb_outline, "Electricity\nBill", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ElectricityBillersScreen()))),
                          _buildGridOption(Icons.receipt, "DTH\nRecharge", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const  DthRechargeScreen()))),
                          _buildGridOption(Icons.notification_add, "Notification", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const   NotificationScreen()))),
                          _buildGridOption(Icons.wallet, "Wallets",() => Navigator.push(context, MaterialPageRoute(builder: (_) => const   WalletScreen()))),
                          _buildGridOption(Icons.local_offer, "Offer", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const   OffersScreen()))),
                          _buildGridOption(Icons.directions_car, "FASTag\nRecharge", () => Navigator.push(context, MaterialPageRoute(builder: (_)  => ReceiverBankFormScreen(bankName: bankName)))),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Other Sections (Loans, Insurance etc)
                const ShoppingBannerSlider(),

                const SizedBox(height: 12),

                const CategorySection(),

                const SizedBox(height: 12),

                const BestSellingSection(),

                const SizedBox(height: 12),

                const TapPaymentOfferSection(),

                const SizedBox(height: 12),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleMenuOption(IconData icon, String label, BuildContext context, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor, // ✅ theme color
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black87, fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildGridOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black12),
            ),
            child: Icon(icon, color: Colors.black87, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(color: Colors.black54, fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildDarkPromoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.black87, fontSize: 11, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

    Widget _buildDarkCard(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
         border: Border.all(color: Colors.black12),
         boxShadow: [
           BoxShadow(
             color: Colors.black.withOpacity(0.05),
             blurRadius: 8,
             offset: const Offset(0, 2),
           ),
         ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 10)),
          const SizedBox(height: 12),
          Align(alignment: Alignment.bottomRight, child: Icon(icon, color: Theme.of(context).primaryColor, size: 30)),
        ],
      ),
    );
  }
}

// ==================== CUSTOM FOOTER ====================
class _CustomFooter extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onNavTap;

  const _CustomFooter({
    required this.selectedIndex,
    required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [

          Container(
            height: 80,
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 30),
            decoration: BoxDecoration(
              color: Colors.white, // Light Card Color
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
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
                  isActive: selectedIndex == 0,
                  onTap: () => onNavTap(0),
                  activeColor: Theme.of(context).primaryColor,
                  inactiveColor: Colors.grey,
                ),
                _AnimatedBottomItem(
                  icon: Icons.shopping_bag_outlined,
                  activeIcon: Icons.shopping_bag,
                  label: 'Shop',
                  isActive: selectedIndex == 1,
                  onTap: () => onNavTap(1),
                  activeColor: Theme.of(context).primaryColor,
                  inactiveColor: Colors.grey,
                ),
                const SizedBox(width: 48), // Space for scan button
                _AnimatedBottomItem(
                  icon: Icons.credit_card_outlined,
                  activeIcon: Icons.credit_card,
                  label: 'Card',
                  isActive: selectedIndex == 3,
                  onTap: () => onNavTap(3),
                  activeColor: Theme.of(context).primaryColor,
                  inactiveColor: Colors.grey,
                ),
                _AnimatedBottomItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Profile',
                  isActive: selectedIndex == 4,
                  onTap: () => onNavTap(4),
                  activeColor: Theme.of(context).primaryColor,
                  inactiveColor: Colors.grey,
                ),
              ],
            ),
          ),

          /// CENTER SCAN BUTTON
          Positioned(
            bottom: 30,
            child:  _AdvancedScaleScanButton(
              onTap: () {
                HapticFeedback.mediumImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ScanQrScreen()),
                );
              },
            ),
          ),

                 ],
      ),
    );
  }
}
/// ADVANCED DUAL COLOR PULSE ANIMATION
class _AdvancedScaleScanButton extends StatefulWidget {
  final VoidCallback onTap;

  const _AdvancedScaleScanButton({required this.onTap});

  @override
  State<_AdvancedScaleScanButton> createState() =>
      _AdvancedScaleScanButtonState();
}

class _AdvancedScaleScanButtonState extends State<_AdvancedScaleScanButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    var bankName = "My Bank"; // or from API

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.85, // 👈 small
      end: 1.1,   // 👈 big
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            );
          },
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.qr_code_scanner,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// Helper class for color tween sequence
class ColorTweenSequence extends Animatable<Color?> {
  final List<Color> colors;

  ColorTweenSequence({required this.colors});

  @override
  Color? transform(double t) {
    if (colors.isEmpty) return Colors.white;
    if (colors.length == 1) return colors.first;

    final segment = 1.0 / (colors.length - 1);
    final index = (t / segment).floor();

    if (index >= colors.length - 1) return colors.last;

    final localT = (t - (index * segment)) / segment;
    return Color.lerp(colors[index], colors[index + 1], localT);
  }
}

// ==================== HELPER WIDGETS ====================
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
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
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

/*class _BillOption extends StatelessWidget {
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
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
            Icon(icon, color: kPrimaryTeal, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}*/

/*class _RecentContact extends StatelessWidget {
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
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: kPrimaryTeal),
      ),
    );
  }
}*/

class _BannerCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final Gradient gradient;
  final IconData icon;
  final bool fullWidth;
  final VoidCallback? onTap;

  const _BannerCard({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.gradient,
    required this.icon,
    this.fullWidth = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: fullWidth ? EdgeInsets.zero : const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: fullWidth
              ? const BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          )
              : BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      title.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Icon(
                    icon,
                    size: 80,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
