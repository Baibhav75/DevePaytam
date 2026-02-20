import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../screens/scan_qr_screen.dart';

class CustomFooter extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onNavTap;

  const CustomFooter({
    super.key,
    required this.selectedIndex,
    required this.onNavTap,
  });

  @override
  State<CustomFooter> createState() => _CustomFooterState();
}

class _CustomFooterState extends State<CustomFooter> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _scanController;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    // 🔹 PULSE ANIMATION (FOR GLOW)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 8.0, end: 18.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );

    // 🔹 SCANNER LINE ANIMATION (RED LINE UP TO DOWN)
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    const double barHeight = 70.0;
    const double fabSize = 72.0;
    final Color primaryColor = Theme.of(context).primaryColor;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 🔹 FOOTER BACKGROUND WITH CONCAVE CURVE & THEME STROKE
        CustomPaint(
          size: Size(size.width, barHeight + 20),
          painter: BNBCustomPainter(strokeColor: primaryColor),
        ),

        // 🔹 NAVIGATION ITEMS
        Positioned(
          bottom: 12,
          left: 0,
          right: 0,
          child: Container(
            height: barHeight,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavBarItem(
                  icon: Icons.home_rounded,
                  activeIcon: Icons.home_rounded,
                  label: 'Home',
                  isSelected: widget.selectedIndex == 0,
                  onTap: () => widget.onNavTap(0),
                  primaryColor: primaryColor,
                ),
                _NavBarItem(
                  icon: Icons.shopping_bag_outlined,
                  activeIcon: Icons.shopping_bag_rounded,
                  label: 'Shop',
                  isSelected: widget.selectedIndex == 1,
                  onTap: () => widget.onNavTap(1),
                  primaryColor: primaryColor,
                ),
                SizedBox(width: size.width * 0.18), // Space for FAB
                _NavBarItem(
                  icon: Icons.credit_card_outlined,
                  activeIcon: Icons.credit_card_rounded,
                  label: 'Card',
                  isSelected: widget.selectedIndex == 3,
                  onTap: () => widget.onNavTap(3),
                  primaryColor: primaryColor,
                ),
                _NavBarItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person_rounded,
                  label: 'Profile',
                  isSelected: widget.selectedIndex == 4,
                  onTap: () => widget.onNavTap(4),
                  primaryColor: primaryColor,
                ),
              ],
            ),
          ),
        ),

        // 🔹 CENTER QR SCAN BUTTON (FAB)
        Positioned(
          top: -32,
          left: (size.width - fabSize) / 2,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ScanQrScreen(),
                    ),
                  );
                },
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Container(
                      width: fabSize,
                      height: fabSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            primaryColor.withOpacity(0.8),
                            primaryColor,
                            primaryColor.withOpacity(0.9),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            blurRadius: _pulseAnimation.value,
                            spreadRadius: 1,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Stack(
                          children: [
                            child!,
                            // 🔹 THE MOVING RED SCANNER LINE
                            AnimatedBuilder(
                              animation: _scanAnimation,
                              builder: (context, _) {
                                return Positioned(
                                  top: _scanAnimation.value * fabSize,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 2,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.red.withOpacity(0.8),
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.red.withOpacity(0.1),
                                          Colors.red,
                                          Colors.red.withOpacity(0.1),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.12),
                      ),
                      child: const Icon(
                        Icons.qr_code_scanner_rounded,
                        size: 36,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Scan & Pay',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                  color: Colors.blueGrey.shade900,
                ),
              ),
              const SizedBox(height: 5),
              // Theme Blue indicator below Scan & Pay
              Container(
                width: 16,
                height: 3,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color primaryColor;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color inactiveColor = Colors.blueGrey.shade400;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 250),
        tween: Tween(begin: 1.0, end: isSelected ? 1.1 : 1.0),
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: SizedBox(
              width: 60,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSelected ? activeIcon : icon,
                    color: isSelected ? primaryColor : inactiveColor,
                    size: 24,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected ? primaryColor : inactiveColor,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      letterSpacing: 0.1,
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(top: 6),
                    width: isSelected ? 18 : 0,
                    height: 2.5,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  final Color strokeColor;

  BNBCustomPainter({required this.strokeColor});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Paint strokePaint = Paint()
      ..color = strokeColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // Path for the background fill
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.32, 0);

    // Concave dip
    path.quadraticBezierTo(size.width * 0.38, 0, size.width * 0.40, 18);
    path.arcToPoint(Offset(size.width * 0.60, 18),
        radius: const Radius.circular(30.0), clockwise: false);

    path.quadraticBezierTo(size.width * 0.62, 0, size.width * 0.68, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Clean Subtle Shadow
    canvas.drawShadow(path, Colors.black.withOpacity(0.2), 12.0, true);
    canvas.drawPath(path, paint);

    // Path for the theme stroke on the top edge including the dip
    Path strokePath = Path();
    strokePath.moveTo(size.width * 0.32, 0);
    strokePath.quadraticBezierTo(size.width * 0.38, 0, size.width * 0.40, 18);
    strokePath.arcToPoint(Offset(size.width * 0.60, 18),
        radius: const Radius.circular(30.0), clockwise: false);
    strokePath.quadraticBezierTo(size.width * 0.62, 0, size.width * 0.68, 0);

    canvas.drawPath(strokePath, strokePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}