import 'dart:ui';
import 'package:Dewa/screens/receiver_bank_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../ecommerce/screens/best_selling_section.dart';
import '../ecommerce/screens/shop_home_screen.dart';
import '../ecommerce/widgets/CategorySection.dart';
import '../ecommerce/widgets/animationbanner_section.dart';
import '../ecommerce/widgets/custom_footer.dart';
import '../ecommerce/widgets/suggestedForYouSession/suggested_for_you_section.dart';
import '../paytam/TapPaymentOfferSection.dart';
import 'image_banner.dart';
import 'offers_screen.dart';
import 'notification_screen.dart';
import 'pay_contact_screen.dart';
import 'to_account_screen.dart';
import 'profile_screen.dart';
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
            child:CustomFooter(

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
          // ====================  BANNER====================
          SizedBox(
            height: 280, // Taller header for full effect
            child: Stack(
              children: [
                // 1. Full Width Banner Carousel
                const BannerSection(),

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
                const SuggestedForYouSection(),

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
}

class Promo {
  final String title;
  final String subtitle;
  const Promo({required this.title, required this.subtitle});
}